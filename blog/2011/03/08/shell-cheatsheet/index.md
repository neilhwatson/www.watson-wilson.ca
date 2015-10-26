---
title: Shell cheatsheet
tags: shell, cli, cheatsheet
---

The following may not apply to all shells.

## Job control
- Resume job after suspend: ```ctrl-q```
- Resume job in background: ```bg <job number>```
- Resume job in foreground: ```fg <job number>```
- Suspend delay (suspend at stdin): ```ctrl-y```
- Suspend:  ```ctrl-z```

## Command line laziness

- Recall history line 66: ```!66```
- Recall last command: ```!!```
- Recall last arguement from last command: ```!$```
- Recall all arguements from last command: ```!*```
- Clear shell history: ```history -c```
- Delete shell history entry: ```history -d <number>```
- Rename rpmnew files:
```
find -type f -name "*.rpmnew" |\
sed 's/\(^.*\)\(\.rpmnew\)$/mv -f \1\2 \1/' |sh
```
- Search and replace files in place:
```
find /path -name "*.*" -exec | perl -pi -e 's///g' {} \;
```
- vi cli editing: ```set -o vi``` Now esc to enter command mode where vi keys
  work. Pressing enter returns to normal mode.
