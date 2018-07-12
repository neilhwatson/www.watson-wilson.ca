---
title: More Ansible tips
tags: ansible, continuous integration, yaml, yamllint, configuration management, scripting
---

<a href="http://ansible.com"><img style='float:right' alt='go to ansible.com' width='150px' src='/static/images/ansible_logo_round.png' ></a>

Here are more cool [Ansible](https://ansible.com) tips I've learned recently.

---

### Breaking long lines

Some times your playbooks have long lines and you want to break them up. Here are some ways to do that:

    ---
    - hosts: localhost

      vars:
        one: >
          long variable
          all lines joined together
          A NEWLINE ENDS
        two: >-
          long variable
          all lines joined together
          NO NEWLINE ENDS

      tasks:
        - debug:
            msg: "{{ one }}"

        - debug:
            msg: "{{ two }}"

        - name: Works with jinja expressions too!
          debug:
            msg: >-
              {{
                two
              }}

        - name: Preserves line breaks
          shell: |
            for i in one two three
            do
              echo $i
            done
          register: cmd

        - debug:
            msg: "{{ cmd.stdout }}"

Now lets run it. 

    PLAY [localhost] *********************************************************

    TASK [Gathering Facts] ***************************************************
    ok: [localhost]

    TASK [debug] *************************************************************
    ok: [localhost] => {
        "msg": "long variable all lines joined together A NEWLINE ENDS\n"
    }

    TASK [debug] *************************************************************
    ok: [localhost] => {
        "msg": "long variable all lines joined together NO NEWLINE ENDS"
    }

    TASK [Works with jinja expressions too!] *********************************
    ok: [localhost] => {
        "msg": "long variable all lines joined together NO NEWLINE ENDS"
    }

    TASK [Preserves line breaks] *********************************************
    changed: [localhost]

    TASK [debug] *************************************************************
    ok: [localhost] => {
        "msg": "one\ntwo\nthree"
    }

    PLAY RECAP ***************************************************************
    localhost                 : ok=6    changed=1    unreachable=0    failed=0    

Here's the [answer](https://stackoverflow.com/a/21699210) that taught me this.

### Using a YAML linter

A YAML linter helps me find those annoying hard to find errors. I use [Vim](https://www.vim.org), but I'm sure you can find something with your editor. Here's what I did.

1. Installed [yamllint](https://github.com/adrienverge/yamllint). It's in Debian's package list.
1. Installed [syntastic](https://github.com/vim-syntastic/syntastic). Debian also has this, but it's too old. Version 3.8 is required.
1. Created an ftplugin file `~/.vim/ftplugin/vim.yaml`. Here's [mine](https://github.com/neilhwatson/nustuff/blob/master/vim/ftplugin/yaml.vim).
