sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

sudo tee /etc/yum.repos.d/vscode.repo <<ADDREPO
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
ADDREPO

sudo dnf install code -y

cat keybindings.json > ~/.config/Code/User/keybindings.json

git config --global user.name "Michaël Le Marec"
git config --global user.email "lemarec@gmail.com"
git config --global --list

token=$(cat token.tk)

git clone https://michael-le-marec@$token@github.com/michael-le-marec/redhat-do180.git
