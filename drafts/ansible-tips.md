---
title: Ansible tips
tags: ansible, continuous integration, configuration management, scripting
---

<a href="http://ansible.com"><img style='float:right' alt='go to ansible.com' width='150px' src='/static/images/ansible_logo_round.png' ></a>

Here are some cool [Ansible](https://ansible.com) tips I've learned recently.

---

Validating input

The [assert module](https://docs.ansible.com/ansible/latest/modules/assert_module.html) evaluates if statements are true of false. Use it to validate input.

    - assert:
        msg: "'myhost' must be defined 'ansible-playbook -e 'myhost=me.example.com'"
        that:
         - myhost is defined

Running it looks like this:

    TASK [assert] ******************************************************************
    fatal: [localhost]: FAILED! => {
        "assertion": "myhost is defined", 
        "changed": false, 
        "evaluated_to": false, 
        "msg": "'myhost' must be defined 'ansible-playbook -e 'myhost=me.example.com'"
    }

Working with APIs

When I'm doing continuous integration I'm often calling APIs. The [URI module](https://docs.ansible.com/ansible/latest/modules/uri_module.html) makes https calls.

    - name: Get github events
      uri:
        url: https://api.github.com/repos/neilhwatson/nustuff/events
        status_code: 200
        return_content: true
      register: events

    - debug:
        msg: "{{ events }}"

* The task fails when the status code does not match.
* We return the content and store it in the 'events' variable.
* The events variable is very large. I leave it for you to look at.
* Use the assert module to validate what was returned.

Readable Ansible output

I loath Ansible's default output. It's ugly and hard to read like JSON, but it's not valid JSON. What's the point of it except to torture honest users? Fight back and turn the output into readable YAML.

    ANSIBLE_STDOUT_CALLBACK=yaml ansible-playbook ~/src/neil/test/playbook.yml

Now the output is in readable YAML format. Make this change permanent by adding this to ansible.cfg

    [default]
    stdout_callback = yaml

* If you're still stuck on Ansible 2.4 use 'debug' instead of 'yaml'.
