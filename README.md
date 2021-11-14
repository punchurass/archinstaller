# archinstaller
Simple script to install Arch Linux with a GUI

*I strongly reccomend editing the scripts BEFORE running them*


Usage:
<br>clone the contents of the repository onto a usb drive ( Make sure the repository is cloned into the root of the drive )</br>
<br>Insert the drive into the computer that you need to install Arch Linux on</br>
<br>Boot into the Arch Linux live USB drive</br>
<br>Mount the drive to /mnt ( mount /dev/sdX1 /mnt )</br>
<br>copy the archinstaller directory to /archinstaller. ( cp -r /mnt/archinstaller / )</br>
<br>Run 'bash /archinstaller/install_begin.sh' ( The script will automatically unmount the thumb drive. )</br>

Projects used in this script:
<a href="https://github.com/tenacityteam/tenacity">Tenacity</a>,
<a href="https://github.com/wxWidgets/wxWidgets">WxWidgets</a>,
<a href="https://www.7-zip.org/download.html">7-zip</a>
