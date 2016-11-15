---
title: Disaster recovery for small business
tags: dr, backup
---

Not everyone can afford redundant servers and sites. If you are a small
business here are some off site disaster recovery options to think about.

---

Where and how do you backup your files now? Do you take these backups off site?
One option I use is to send backups to a hosted virtual private server or VPS.
Many companies provide both Linux and Windows VPS options for as little at $10
per month. Another option is to use services like Dropbox. Either option allows
you to upload backup files to a safe remote location. Before you do this there
is one extra step that you must consider.

Once your data resides on the remote host, who has access to it? The buzz word
of the day is the cloud. You cannot control who at the provider can gain access
to your backups. The solution to this is encryption. Encrypt the backup files
before you send them to the VPS. For example, suppose I have one Linux host. I
perform my backups with Tar. I want to use GnuPG to encrypt them. Consult with
the GnuPG documentation on how to generate a key pair. Once you have done so
you can encrypt your backups like this.

%= highlight Bash => begin
    gpg -r "Neil Watson" -o - -e mybackup.tar.gz | \
       ssh vpn.example.com "cat > backups/mybackup.tar.gz.en"
% end

This instructs GnuGP to encrypt my backup tar file. The encrypted file is sent
to standard output. This is piped to SSH where it is redirected to a target
file at my remote VPS.

When you need this backup how will you recover it? You’ll need to download the
encrypted file. Then you’ll need to decrypt the file. Suppose, during the
disaster you’ve also lost your GnuPG private key? The trick is record this
information and back it up separately. Record your VPS credentials and the
method you need to access it. This might include the IP address or URL. Record
the GnuGP private key to ascii using the armor option. This will allow you
import the key anew if lost.

This data must be stored in a safe place. Multiple copies and locations are
encouraged. Storage methods could include both paper and CDROM or USB key.
Store this data off site. A safety deposit box is ideal.

If this article has you thinking you’ll realize that there are other ways to do
this. By all means use them. Just remember to be sure that your data is
protected and that your recovery method is stored in a safe place.

If you want my help with your disaster recovery plans please contact me.

