---
title: Backups using Cfengine
tags: cfengine, cfengine cookbook, backup, dr
---

Problem

You want to use Cfengine for scheduling backups instead of crond.

---

Solution

Cfengine is flexible enough to allow for advanced time scheduling (see Cfengine as an atlernative to crond). Its file copying functions allow Cfengine to copy files directly as a backup program including advanced rsync behaviour. Cfengine shell commands allow you to use your own backup tools.

Earlier I discussed methods promises. I will make use of this again here.
The humble tar ball

First a method call.

bundle agent main {

   vars:
      "backupdir" string => "/srv/aux/backup",
         handle => "main_vars_backupdir",
         comment => "Location for backups";

      "backups" slist => {
            "/home/neil/.kde/share/apps/amarok",
            "/home/neil/.ssh",
            "/home/neil/.gnupg",
            "/home/neil/.gnucash",
            "/home/neil/Mail",
            "/srv/music/playlists",
            "/etc",
            "/var/www",
            "/srv/svn/"
         },
         handle => "vars_home_backups",
         comment => "Dirs to backup";

   methods:

      Hr01::

         "backup" usebundle => backup( 
               ${backupdir}, 
               @{main.backups} ),
            action => if_elapsed("60"),
            depends_on => { "svn_checkin" },
            handle => "main_methods_home_backups";

}

Here we set some variables for a backup directory and a list of things to backup. Doing this allows us to change the variables by class from host to host. Next we call the bundle via a method passing the variables. Note that list variables must be fully scoped by listing their bundle name.

The bundle is called at 0100 hours. If_elapsed ensures that the backup in only promised once during that hour. Depends_on shows what other bundles might need to be done first. In this case I need a Subversion promise ahead of time.

The magic here is that not only will the bundle go off at 0100 but like all Cfengine promises it will continually try, for every run during that hour, to ensure that that promise is kept. Now let’s look at the called bundle.

bundle agent backup(dir, backups) {

vars:

   "dirs" string => join(" ", "backups"),
      handle => "backup_vars_dirs",
      comment => "Make list of string for tar";

files:

   "${dir}/."
      handle => "backup_files_srv_backups",
      create => "true";

commands:

   "/bin/tar -czf ${dir}/cfbackup-${g.day}.tgz ${dirs}"
      handle => "backup_commands_tar",
      contain => silent,
      classes => if_else("backup_go_encrypt","backup_tar_failed");

reports:

   backup_tar_failed::
      "Backup tar command failed."; 
}

The bundle is quite simple. A tar command is run using the passed variables as a target for the tar file and a list of things to tar up. The variable ‘g.day’ is a global variable that always contains a three letter abbreviation of today (e.g. sun, mon, tue). This is not built in. I set this in a common bundle. The files promise ensure that the location for the tar file is always there. The reports promise reports if the tar command throws and error. This would not be necessary in Nova since it keeps track of promise compliance automatically.

A peek inside this backup directory shows:

# ls /srv/aux/backup/cfbackup*
/srv/aux/backup/cfbackup-fri.tgz
/srv/aux/backup/cfbackup-sun.tgz
/srv/aux/backup/cfbackup-wed.tgz
/srv/aux/backup/cfbackup-mon.tgz
/srv/aux/backup/cfbackup-thu.tgz
/srv/aux/backup/cfbackup-sat.tgz
/srv/aux/backup/cfbackup-tue.tgz

A simple copy

I have a directory of images from my camera work. I like to back this up to another hard drive on my workstation. First the method.

methods:

   Hr01::

      "backup_pictures" usebundle => local_sync(
            "/home/neil/Pictures",
            "/srv/aux/backup-pictures"
         ),
         action => if_elapsed("10080"),
         handle => "main_methods_local_sync_pictures";

This method passes two strings, both directories, to a bundle. The if_elapsed body sets the frequency of this backup to once per week. Now the bundle.

bundle agent local_sync(src, dest){

files:

   "${dest}/."
      handle => "local_sync_files_dest_create",
      create => "true",
      perms => mog("644","root","root");

   "${dest}"
      handle => "local_sync_files_dest_copy",
      depth_search => recurse("inf"),
      copy_from => local_cp("${src}");
}

Two files promises are found here. The first ensure that the destination directory is available. The second copies files from the source, provided by the method above to the destination, also provided by the method. The copy_from body is found in the standard Cfengine library. This is just a straight copy. I could have used a purge in the copy_from body to perform a sync function instead.
Encryption and off-site backups

Some of my backups are sent to an off-site host. I don't fully trust the off-site location so I encrypt the backup files first. Again from my main bundle.

methods:

   "backup_encrypt_neil" usebundle => backup_encrypt_neil("cfbackup-${g.day}.tgz"),
      action => if_elapsed("60"),
      handle => "main_methods__backup_encrypt_neil_cfbackup";

   oort.(Saturday|Wednesday).(Hr10|Hr11)::

      "remote_backup" usebundle => remote_backup_vps,
         handle => "main_methods_oort_remote_backup_vps",
         comment => "CEST time zone",
         action => if_elapsed("120");

The first method calls a bundle make encrypted copies of my backup tar balls. The second method is invoked on a remote host called ‘oort’. It is invoked on Saturday or Wednesday during the hours of 1000 or 1100 local time. The if_elapsed sets the span of two hours to ensure the promise is kept. Now the bundles.

bundle agent backup_encrypt_neil(file) {

vars:

  "backup_dir" string => "/srv/aux/backup",
      handle => "backup_encrype_neil_backup_dir";

  "encrypted_dir" string => "/srv/aux/backup/encrypted",
      handle => "backup_encrype_neil_encrypted_dir";

files:

  "${encrypted_dir}/."
      handle => "backup_encrypt_neil_files_encrypted",
      create => "true";

commands:

  "/usr/bin/gpg -r 'Neil Watson' -o  ${encrypted_dir}/${file}.en -e ${backup_dir}/${file}",
      contain => silent,
      handle => "backup_encrypt_neil_commands_encrypt";
}

This bundle calls GNUpg via a commands promise to encrypt the given tar file. A files promise ensures that the directory for the encrypted file to reside exists.

A peek inside the encrypted directory shows:

# ls /srv/aux/backup/encrypted/cfbackup*
/srv/aux/backup/encrypted/cfbackup-fri.tgz.en
/srv/aux/backup/encrypted/cfbackup-thu.tgz.en
/srv/aux/backup/encrypted/cfbackup-mon.tgz.en
/srv/aux/backup/encrypted/cfbackup-tue.tgz.en
/srv/aux/backup/encrypted/cfbackup-sat.tgz.en
/srv/aux/backup/encrypted/cfbackup-wed.tgz.en
/srv/aux/backup/encrypted/cfbackup-sun.tgz.en

Now the remote backup bundle.

bundle agent remote_backup_vps {

files:

   "/home/neil/backups"
      handle => "remote_backup_vps_files_backups",
      depth_search => recurse("inf"),
      file_select => by_name(".*?${g.day}.*?\.en"),
      copy_from => remote_dcp(
         "/srv/aux/backup/encrypted",
         "${sys.policy_hub}"
      );
}

This last bundle is another files promise that performs a copy. The file_select body ensure that only the tar file that matches today’s tar file is copied. The thing to remember with this type of operation is that the server listed in the copy_from body is whatever host houses the backups. In this case it is my policy hub. However it could be any host running Cfengine so long as the proper access rules are applied.

Should you be using Nova you can use something called remote classes. Remote classes are classes that are set on one client so that other clients can query it. In this example I could have the host that encrypts the files set a class called ‘encrypted_files_ready’. The remote host could query for this class. If it is set then kickoff of the remote backup bundle.

