---
title: Reboot and reconnect between Ansible tasks
tags: configuration management, ansible, orchestration, scripting
---

<a href="http://ansible.com"><img style='float:right' alt='go to ansible.com' width='150px' src='/static/images/ansible_logo_round.png' ></a>

You can reboot and reconnect to your hosts between [Ansible](http://ansible.com) tasks. 

    ---
	# Other task above here.

    # Now reboot and reconnect
	- block:

		# The at module allows ansible to issue the command and disconnect 
		# cleanly before the reboot disconnects the network connection.
	   - name: Reboot in one minute
		 at: command=reboot count=1 units=minutes

       # You may need to adjust this dependong on how fast your host halts.
	   - name: Wait for reboot to start and hopefully finish 
		 pause: minutes=2

	   - name: Try to re-connect to rebooted host before continuing  
		 command: /bin/true
		 register: online
		 retries: 20
		 delay: 30
		 until: online|success

	# Continue your tasks...

1. [blocks](http://docs.ansible.com/ansible/playbooks_blocks.html) group tasks for better control and debugging.
1. [at](http://docs.ansible.com/ansible/at_module.html) uses the UNIX [at](https://linux.die.net/man/1/at) tool.
1. [pause](http://docs.ansible.com/ansible/pause_module.html) pauses like sleep.
1. Retries and delay works like a [do until](http://docs.ansible.com/ansible/playbooks_loops.html#do-until-loops) loops.
