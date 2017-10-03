#!/bin/bash -e

# notify user that sudo privileges may be required for some steps
echo "this script will require sudo privileges..."
sudo echo "beginning automated setup of osx sierra..."

# keep sudo refreshed in the background while the script completes
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# ask for information to help automate configuration
[ -z "$github_username" ] && read -p "please enter your github username: " github_username
[ -z "$github_password" ] && read -p "please enter your github password: " -s github_password; echo ""
[ -z "$sshkey_password" ] && read -p "please enter the password for your ssh key (we will create it if it does not eixst): " -s sshkey_password; echo ""

# show the user everything that transpires henceforth
set -x

# if no ssh key exists attempt to generate one with an optional password
if [ ! -s ~/.ssh/id_rsa ]; then
	ssh-keygen -q -b 4096 -t rsa -N "$sshkey_password" -f ~/.ssh/id_rsa

	# if the password is not empty, attempt to store it in osx keychain
	if [ -n "$sshkey_password" ]; then
		expect << EOF
			spawn ssh-add
			expect "Enter passphrase"
			send "$sshkey_password\r"
			expect eof
		EOF
	fi
fi

# acquire information from and setup authentication with github
if [ -n "$github_username" ]; then
	export github_name=$(curl -Ls https://api.github.com/users/$github_username | grep "name" | tr -d '":,' | awk '{$1=""; print $0}' | xargs)
	if [ -n "$github_password" ]; then
		export github_email=$(curl -Ls -u "${github_username}:${github_password}" https://api.github.com/users/$github_username | grep "email" | tr -d '":,' | awk '{$1=""; print $0}' | xargs)
		curl -Ls -u "${github_username}:${github_password}" -H "Content-Type: application/json" -H "Accept: application/json" -X POST -d "{\"title\":\"$(hostname -s) ($(date '+%Y/%m/%d'))\",\"key\":\"$(cat $HOME/.ssh/id_rsa.pub)\"}" https://api.github.com/user/keys || echo "failed to register ssh key"
		export HOMEBREW_GITHUB_API_TOKEN=$(curl -Ls -u "${github_username}:${github_password}" -H "Content-Type: application/json" -H "Accept: application/json" -X POST -d "{\"scopes\":[\"gist\",\"repo\",\"user\"],\"note\":\"homebrew $(hostname -s)\"}" https://api.github.com/authorizations | grep '"token":' | tr -d '":,' | awk '{$1=""; print $0}' | xargs)
	fi
fi

# install homebrew if it is not already installed
which brew &> /dev/null || /usr/bin/ruby -e "$(curl -Ls https://raw.githubusercontent.com/Homebrew/install/master/install 2>& /dev/null)"

# install homebrew packages
brew tap caskroom/cask
brew cask install qlmarkdown
brew cask install osxfuse
brew cask install vagrant
brew install bzr
brew install awscli
brew install jq
brew install tmux
brew install reattach-to-user-namespace
brew install wget
brew install sshfs
brew install mercurial
brew install svn
brew install mpv --with-bundle
brew install bash
brew install vim --with-override-system-vi
brew install git
brew install lame
brew install jpeg
brew install jpeg-turbo
brew install faac
brew install libvorbis
brew install x264
brew install openh264
brew install xvid
brew install theora
brew install packer
brew install graphicsmagick
brew install imagemagick
brew install swftools
brew install libbluray
brew install ffmpeg --with-fdk-aac --with-libass --with-libssh --with-libvidstab --with-openjpeg --with-openssl --with-rtmpdump --with-tools --with-webp --with-x265 --with-fontconfig --with-freetype --with-libbluray --with-libcaca --with-libvorbis --with-libvpx --with-speex --with-theora --with-game-music-emu --with-openh264

# add and switch default shell to the homebrew bash
echo "$(brew --prefix)/bin/bash" | sudo tee -a /etc/shells > /dev/null
chsh -s "$(brew --prefix)/bin/bash"

# configure git to use the appropriate usnamer, email, a credential helper, and use git protocol for owned repos
git config --global user.name "$github_name"
git config --global user.email "$github_email"
git config --global credential.helper osxkeychain
[ -n "$github_username" ] && git config --global url."git@github.com:$github_username".insteadOf "https://github.com/$github_username"

# clone repo and install configuration files
rm -rf /tmp/osx-sierra
git clone https://github.com/cdelorme/osx-sierra /tmp/osx-sierra
sudo rsync -Pav /tmp/osx-sierra/root/ /
rsync -Pav /tmp/osx-sierra/user/ ~/

# setup crontab to download ssh keys from github then load and clear the crontab
[ -n "$github_username" ] && echo "*/15 * * * * /usr/local/bin/update-keys $github_username" >> ~/.crontab
crontab ~/.crontab
rm ~/.crontab

# add homebrew token to ~/.bash_profile for future
[ -n "$token" ] && echo -ne "\n# homebrew github token (remove rate-limiting)\nexport HOMEBREW_GITHUB_API_TOKEN=${token}" >> ~/.bash_profile

# install youtube-dl
sudo curl -Lo /usr/local/bin/youtube-dl "https://yt-dl.org/downloads/latest/youtube-dl"
sudo chmod +x /usr/local/bin/youtube-dl
sudo chown $USER:$USER /usr/local/bin/youtube-dl

# install gvm and nvm loading from ~/.bash_profile, and the latest go version
PROFILE=~/.bash_profile bash < <(curl -Ls https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer 2>& /dev/null)
GVM_NO_UPDATE_PROFILE=1 bash < <(curl -Ls https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer 2>& /dev/null)
grep "gvm" ~/.bash_profile &> /dev/null || echo ". ~/.gvm/scripts/gvm" >> ~/.bash_profile
. ~/.gvm/scripts/gvm
gvm install go1.9 -B
gvm use go1.9 --default

# add sublime text command
sudo ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/subl
