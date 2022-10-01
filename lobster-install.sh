#!/bin/bash

echo '╭╮╱╱╭━━━┳━━╮╭━━━┳━━━━┳━━━┳━━━╮╭╮╱╱╭━━┳━╮╱╭┳╮╱╭┳━╮╭━╮'
echo '┃┃╱╱┃╭━╮┃╭╮┃┃╭━╮┃╭╮╭╮┃╭━━┫╭━╮┃┃┃╱╱╰┫┣┫┃╰╮┃┃┃╱┃┣╮╰╯╭╯'
echo '┃┃╱╱┃┃╱┃┃╰╯╰┫╰━━╋╯┃┃╰┫╰━━┫╰━╯┃┃┃╱╱╱┃┃┃╭╮╰╯┃┃╱┃┃╰╮╭╯'
echo '┃┃╱╭┫┃╱┃┃╭━╮┣━━╮┃╱┃┃╱┃╭━━┫╭╮╭╯┃┃╱╭╮┃┃┃┃╰╮┃┃┃╱┃┃╭╯╰╮'
echo '┃╰━╯┃╰━╯┃╰━╯┃╰━╯┃╱┃┃╱┃╰━━┫┃┃╰╮┃╰━╯┣┫┣┫┃╱┃┃┃╰━╯┣╯╭╮╰╮'
echo '╰━━━┻━━━┻━━━┻━━━╯╱╰╯╱╰━━━┻╯╰━╯╰━━━┻━━┻╯╱╰━┻━━━┻━╯╰━╯'
echo ''
echo 'Starting transformation process...'
sleep 5 # some time to bail out

# First update (may require restart)
sudo apt-get update
sudo apt-get upgrade -y

# Installing Nala
sudo apt-get install nala -y

# Nala configuration (fetch better mirrors)
#sudo nala fetch
sudo nala update

# Preparing to install oh-my-zsh
sudo nala install zsh git curl zip unzip -y

###################################################
## Oh My Zsh
###################################################
#sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended
wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh
mv install.sh oh-my-zsh-install.sh
chmod +x oh-my-zsh-install.sh
./oh-my-zsh-install.sh --unattended

# Get my theme
cd .oh-my-zsh/themes
wget https://raw.githubusercontent.com/HFMorais/oh-my-zsh-purpleblood-theme/main/purpleblood.zsh-theme
cd ~
sed -i 's/robbyrussell/purpleblood/g' .zshrc

rm oh-my-zsh-install.sh

###################################################
## Firefox
###################################################
# Remove Firefox snap yuk... YUK! And add ppa
sudo snap remove --purge firefox
sudo add-apt-repository ppa:mozillateam/ppa -y

# Alter the Firefox package priority
echo '
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001
' | sudo tee /etc/apt/preferences.d/mozilla-firefox

# Unattended upgrades for firefore
echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' | sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox

# Install
sudo nala update
sudo nala install firefox -y


###################################################
## Codium
###################################################
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | gpg --dearmor | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' | sudo tee /etc/apt/sources.list.d/vscodium.list

sudo nala update
sudo nala install codium -y

###################################################
## Themes
###################################################
mkdir ~/.themes
mkdir ~/.icons

# GTK / XFCE Theme
#wget -O Dracula-Gtk-Theme.zip https://github.com/dracula/gtk/archive/master.zip
unzip files/Dracula-Gtk-Theme.zip -d ~/.themes/
mv ~/.themes/gtk-master ~/.themes/Dracula
xfconf-query -c xsettings -p /Net/ThemeName -s "Dracula"
xfconf-query -c xfwm4 -p /general/theme -s "Dracula"
#rm Dracula-Gtk-Theme.zip

# Icons
#wget -O Dracula-Icon-Theme.zip.zip https://github.com/dracula/gtk/files/5214870/Dracula.zip
unzip Dracula-Icon-Theme.zip.zip -d ~/.icons/
xfconf-query -c xsettings -p /Net/IconThemeName -s "Dracula"
gtk-update-icon-cache ~/.icons/Dracula/
#rm Dracula-Icon-Theme.zip.zip

# Cursors (2 cursors for different tastes)
unzip files/Simp1e-Nord-Light.zip -d ~/.icons/
unzip files/Breeze.zip -d ~/.icons/
#xfconf-query -c xsettings -p /Gtk/CursorThemeName -s "Simp1e-Nord-Light"
xfconf-query -c xsettings -p /Gtk/CursorThemeName -s "Breeze"

# Change button order
xfconf-query -c xfwm4 -p /general/button_layout -s "CMH|O"

###################################################
## Final Touches
###################################################
# Change default shell to zsh
sudo chsh -s /bin/zsh $USER

echo 'You have been lobstered. Enjoy!'