
lab start cli-desktop

passwd

lab finish cli-desktop

whoami
whoami ; hostname
date
date +%R
date +%x

file /etc/passwd
file /bin/passwd
file /home

ll
cat install-vscode.sh keybindings.json

head keybindings.json
tail -n 3 keybindings.json

wc keybindings.json
wc -l -w -c keybindings.json # is the same

ls --"TAB" "TAB"

history
!wc # launch last wc command

# Ctrl+R to reverse search
# Ctrl+K to get last argument


lab start cli-review
date
date +%R

file ~/zcat
wc ~/zcat
head ~/zcat
head -4 ~/zcat
tail -n 20 ~/zcat
history
!23
lab finish cli-review

