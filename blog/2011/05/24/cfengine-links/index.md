---
title: Creating links using Cfengine
tags: cfengine, cfengine cookbook, configuration management
---

Problem

You Cfengine binaries are in /var/cfengine/bin but you want them in the PATH.

---

Solution

Symbolic linking the binaries is a good approach. The most simple method follows. Please note that you should look at the introduction entry to this series to better understand the setup.

bundle agent recipe {

    files:
        "/usr/bin/cf-agent"
            handle => "cf_agent_link",
            comment => "Link cf-engine binaries",
            link_from => ln_s("/var/cfengine/bin/cf-agent");

        "/usr/bin/cf-serverd"
            handle => "cf_serverd_link",
            comment => "Link cf-engine binaries",
            link_from => ln_s("/var/cfengine/bin/cf-serverd");

        "/usr/bin/cf-execd"
            handle => "cf_execd_link",
            comment => "Link cf-engine binaries",
            link_from => ln_s("/var/cfengine/bin/cf-execd");
}

The promises are clear but somewhat repetitive. A more efficient approach involves using a list.

bundle agent recipe {

    vars:
        "cfbins" slist => {
            "agent", "serverd", "execd"
        },
        comment => "Cfengine binary files";

    files:
        "/usr/bin/cf-${cfbins}"
            handle => "cf_bin_links",
            comment => "Link cf-engine binaries",
            link_from => ln_s("/var/cfengine/bin/cf-${cfbins}");
}

This bundle repeats the same link promise for each string in list “cfbins”.

cf3     Promise handle: cf_bin_links
cf3     Promise made by: /usr/bin/cf-agent
cf3 
cf3     Comment:  Link cf-engine binaries
cf3     .........................................................
cf3 
cf3  -> Using literal pathtype for /usr/bin/cf-agent
cf3  -> Handling file existence constraints on /usr/bin/cf-agent
cf3  -> Link /usr/bin/cf-agent points to /vars:/cfengine/bin/cf-agent -
promise kept
cf3 
cf3     .........................................................
cf3     Promise handle: cf_bin_links
cf3     Promise made by: /usr/bin/cf-serverd
cf3 
cf3     Comment:  Link cf-engine binaries
cf3     .........................................................
cf3 
cf3  -> Using literal pathtype for /usr/bin/cf-serverd
cf3  -> Handling file existence constraints on /usr/bin/cf-serverd
cf3  -> Link /usr/bin/cf-serverd points to
/vars:/cfengine/bin/cf-serverd - promise kept
cf3 
cf3     .........................................................
cf3     Promise handle: cf_bin_links
cf3     Promise made by: /usr/bin/cf-execd
cf3 
cf3     Comment:  Link cf-engine binaries
cf3     .........................................................
cf3 
cf3  -> Using literal pathtype for /usr/bin/cf-execd
cf3  -> Handling file existence constraints on /usr/bin/cf-execd
cf3  -> Link /usr/bin/cf-execd points to /vars:/cfengine/bin/cf-execd -
promise kept

Gravy

I keep a personal source repository of profile rc files (e.g. .profile, .muttrc) and custom scripts for my \$HOME/bin path. I typically have a checked out working copy of these files. I have Cfengine make links from the proper location to my the checked out repository.

