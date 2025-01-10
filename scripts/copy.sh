#!/bin/bash

# Up from scripts dir
cd ..

cp -r .config ${HOME}
cp -r .fonts ${HOME}
cp 81-bluetooth-hci.rules /etc/udev/rules.d/81-bluetooth-hci.rules
#cp .bashrc ${HOME}
#cp .git-completion.bash ${HOME}
#cp .git-rundown.sh ${HOME}
#cp .gitmessage ${HOME}
#cp .bash_profile ${HOME}
#cp .vimrc ${HOME}
