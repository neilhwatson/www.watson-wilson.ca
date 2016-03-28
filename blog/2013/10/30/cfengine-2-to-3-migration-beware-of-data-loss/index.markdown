---
author: nwatson
data:
  categories:
    - content: Cfengine
      domain: category
      nicename: cfengine
  post_type: post
  wp_menu_order: 0
  wp_post_id: 701
  wp_post_name: cfengine-2-to-3-migration-beware-of-data-loss
  wp_post_parent: 0
  wp_post_path: http://watson-wilson.ca/cfengine-2-to-3-migration-beware-of-data-loss/
date: 2013-10-30 12:00:03
status: published
tags:
  - cfengine
title: 'CFEngine 2 to 3 migration? Beware of data loss'
---


CFEengine 3 bootstrapping can result in the loss of CFEngine 2 inputs.
A common strategy to migrate from CFEngine 2 to 3 is to run both in
parallel. --- Both versions share the same default inputs directory of
/var/cfengine/inputs. A CF3 bootstrap deletes all files in the inputs
directory:

``

    [root@atlrhel5is cfengine]# cf-agent -IB hub.example.com 
    2013-10-29T12:37:43-0400     info: Removing all files in '/var/cfengine/inputs/'

*Now your working CF2 inputs are gone.* I've reported a [bug](https://cfengine.com/dev/issues/3605)
about this, but I do not know when or if it will be addressed. As a
work around I suggest a wrapper script to your bootstrap procedure.
Something like this snippet:

``

    TS=$(date +%s)
    
    mkdir /var/cfengine/inputs-${TS}
    cp -r /var/cfengine/inputs/* /var/cfengine/inputs-${TS}
    
    if [ $? -eq 0 ]
       then
          cf-agent -B hub.example.com
          cp -nr /var/cfengine/inputs-${TS}/* /var/cfengine/inputs/
    fi

This will preserve and restore your pre-bootstrap inputs, while keeping
any new files created by the bootstrap. Be sure to test any bootstrap
or upgrade procedure thoroughly. [Contact us](http://watson-wilson.ca/contact-us/)
for more help and information.
