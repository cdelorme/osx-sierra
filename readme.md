
# [osx sierra](https://github.com/cdelorme/osx-sierra)

This repository houses configuration files, scripted automation, and documentation regarding how I setup OSX Sierra.

> My personal experience with apple software just keeps getting worse given the constant stream of iCloud alarms, emphasis on technologies that provide no value to me, and a never ending stream of incompatible behavior.  _That said, they still make the best laptops on the market._


## installation

Installation takes roughly 20 minutes and involves at least one reboot.

An option is available during the post-boot process to setup FileVault.  **Do not use this option, otherwise subsequent conflicting updates will require full decryption and re-encryption.**  It is best to wait until the installation is complete and the system updates are all installed before you enable this feature.

There is an option now to enable Siri; _I left this disabled since I use my laptop as a workstation not a dictation machine or mobile device._

Apple continues to push users into their iCloud to try and collect the $0.99 fee, since they know 5GB is not enough to do anything with and the alarms you get are at least as annoying as the $0.99 price tag.  _I have ceased using iCloud altogether as a result._


## configuration

The first step is to run system updates.  _This is super important if you want to encrypt your drive._  Updates may take another 30 minutes and multiple reboots.

After updates I immediately head to "Security & Privacy", "FileVault", and enable encryption.  _This process requires a reboot to encrypt OS files in-use and may take a while after to complete, but will run in the background allowing you to continue configuration._

Next I clear the dock of all the applications I don't use.

I setup "Internet Accounts".  _A recent feature is that they automatically setup a "Game Center Account", which I now remove._

In general settings I switch to Graphite and enable Dark Menu & Auto Hide.  I select to jump to the spot that is clicked in a scrollbar, I disable closing windows when closing an application (so I can restore the previous state), and I set recent items to 0.

Under "Desktop and Screensaver" I like to randomly cycle desktop backgrounds from a `~/Pictures/wallpaper` directory, but unfortunately OSX does not recurse folders and I run a script to generate symbolic links at the root (so I can organize the images).  I disable the screensaver but enable "Show With Clock".  I setup hot-corners so that the top-left causes the display to sleep, and in security I set sleep to lock within 5 minutes.

For the Dock I shrink the items and leave magnification disabled.  I shift the Dock to display from the right side rather than the bottom.  I select the "Scale" effect, to always prefer tabs, and to minimize to the application icon.

In "Mission Control" I disable automatic space reordering since it is disruptive, and I disable automatic desktop switching to open windows, since I often will launch new instances in a new space and prefer to do so from the keyboard only.  I disable the dashboard and unset the hotkey that displays it (F12).

I enable 24-hour time in "Language and Region".  In advanced I change short-format to Year/Month/Date.

In "Security and Privacy" I turn the firewall on.  I disable automatic logout in advanced settings, and this is where I can set how long to sleep before a password is required which allows me to passively lock my system if I step away by habitually using the hot corner to sleep the system.

In "Spotlight" I disable all but Applications, Calculator, and System Preferences.  I disable suggestions and under privacy I add all of my user directories except `~/Applications` (_it would be wonderful if I could hide my entire user directory without sacrificing `~/Applications`_).

In notifications I enable DND mode outside of office hours, and I disable a majority of the related applications from notifying me in general, as well as preventing any that do so on a locked screen.

Under "Energy Saver" I disable the power nap setting, set the display to sleep after an hour while on battery and never when plugged in.  _It may still be sensible to disable graphics switching as well, but I no-longer own a machine on which to test._

In the "Keyboard" settings I set Caps Lock to act as another Control key.  I disable "Smart Quotes and Dashes" under "Text".  In shortcuts I disable useless hotkeys (toggling the dock hiding, turning DND on/off, changing the way tab focus moves, turning keyboard access on or off, etc...).  I also explicitly add "Application Shortcuts" for "Zoom"; `ctrl+alt+=` for all applications, and later once Google Chrome is installed I add `shift+ctrl+=`, _because shift makes chrome maximize width in addition to height and is considered "working as intended" in spite of how conflicting that behavior is..._

In "Trackpad" I enable "Tap to Click", increase the tracking speed, and disable swipe between pages as well as launchpad.

Under "Extensions" I disable Stocks and Reminders, and disable every item I possibly can under "Share Menu".

Under "Sharing" I change the device name to something shorter and without special characters.

I disable the Guest User in the "User Preferences", and may set an icon for my account.

I open finder preferences and set the default directory to my user directory.  I delete all the meaningless tags, and I enable Hard Disks and Connected Servers as desktop items, then disable CD/DVD/iPod (because no disk drive and workstation).  I modify the sidebar to only include Applications, Documents, Downloads, and my home directory.  I disable bonjour and back to my mac.  I disable tags, but leave CD/DVD/iPod (for some reason this is how it registers dmg's in spite of not doing so for desktop icons!?).  In advanced I show all filename extensions, and disable all warnings.  I set trash to automatically empty items older than 30 days.  I change search to the current directory rather than system-wide.

I use the special preferences (`cmd+j`) to show item info on desktop, then against my user directory I always open in list view, calculate all sizes, show library directory, and then click "User as Defaults".  _Interestingly I think Sierra is the first system where this actually works as expected, whereas previously it would fail to apply if the Documents or Downloads directories had been opened with another view mode previously._


## software

Here is the software I install on my system:

- [Google Chrome](https://www.chromium.org/getting-involved/dev-channel)
- [iTerm2](http://www.iterm2.com/#/section/home)
- [homebrew](http://brew.sh/)
- [Sublime Text](https://www.sublimetext.com/3)
- [VirtualBox](https://www.virtualbox.org/)
- [VirtualBox Extensions](https://www.virtualbox.org/wiki/Downloads)
- [Transmission](https://transmissionbt.com/download/)
- [Adobe Flash Projector](http://www.adobe.com/support/flashplayer/downloads.html)
- [go version manager](https://github.com/creationix/nvm)
- [node version manager](https://github.com/moovweb/gvm)

The homebrew package manager saves the day when it comes to a myriad of support tools.  _It no-longer requires [XCode](https://itunes.apple.com/us/app/xcode/id497799835), but if you plan to use it you should install it first to avoid redundant license agreements._

Sublime Text is not free but is highly recommended.  **If you are a developer and can afford to buy a copy, you should.**

_While flash might cater to a dying industry, I like the option of being able to run `.swf` without a browser._  Copying the `.app` into `~/Applications` and setting up file association is relatively easy.

The version managers for go and node are for developers, and simplify installation and upgrades entirely in user-space without depending on a package manager.

I also choose to remove iTunes.  To do this I need to adjust permissions so I can delete the `.app`, and I need to disable the iTunes Helper and delete that using Activity Monitor to locate the process and file.  Finally I remove the plist files in `Library/Preferences/com.apple.itunes*` (both userspace and root paths).  Finally I reboot to make sure everything went correctly, _but it is possible that a subsequent update could reinstall iTunes onto the system._


## [automation](sierra.sh)

At this point I recommend running automation to install various components:

	curl -Ls0- "https://raw.githubusercontent.com/cdelorme/osx-sierra/master/sierra.sh" 2> /dev/null | bash

The automation installs configuration files, executable scripts, and custom fonts.  It also handles execution of some more complex and mundane commands.


### files

In addition to automation and documentation, this repository carries many executable scripts, configuration files, and a couple custom files.

All of these files are organized into two categories structured such that installation matches the paths on your system:

- [user](user/)
- [root](root/)

These files are installed by the automation and serve to supplement the system.

You are welcome to investigate the contents.


### [homebrew](https://brew.sh/)

**The first step, if you have a [github](https://github.com/) account, is to get an api key for homebrew to avoid rate limits.**

I install the following homebrew packages:

- caskroom/cask/osxfuse
- caskroom/cask/vagrant
- caskroom/cask/qlmarkdown
- bzr
- awscli
- jq
- tmux
- reattach-to-user-namespace
- wget
- sshfs
- mercurial
- svn
- mplayer
- vim
- git
- terraform
- docker-machine
- docker
- docker-compose
- lame
- jpeg
- jpeg-turbo
- faac
- libvorbis
- x264
- openh264
- xvid
- theora
- graphicsmagick
- imagemagick
- swftools
- libbluray
- ffmpeg
- bash-completion

Several of these packages have additional command line options (_especially `ffmpeg`_), which helps address bloat as well as ensure complete sets of functionality and features depending on the package.

_The `X` package is required in addition to a modified [`~/.tmux.conf`]() to address launching sublime text via `subl .` from `tmux` (by default it will activate the last sublime text window but not launch a new project)._


## manual

Unfortunately OSX is a very different beast from standard unix or linux, and some automation simply isn't feasible.

_These steps can be done manually after automation has completed._


### [sublime text](software/sublime-text.md)

Visit the shared document for steps and configuration file templates.

Afterwards, add the command line symlink:

    sudo ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/subl


### [iterm2](https://www.iterm2.com/)

Open the configuration and go to "Profiles" > "Text", then change the font settings (for regular font):

- Size 14 Font
- ForMateKonaVE Font Family

Next select "Profiles" > "Terminal" and click the checkbox for "Unlimited scrollback".  I also select "Silence Bell" and "Show bell icon in tabs", and clear "Send Growl/Notification Center alerts" since they are relatively disruptive and don't indicate that anything has actually changed.

Now go to "Profiles" > "Keys" and add these key combinations:

- alt + delete: HEX 0x17
- alt + left arrow: escape sequence + b
- alt + right arrow: escape sequence + f

This will allow you to use alt to jump between words while in iTerm2 (eg delete whole word, go back a word, go forward a word).

Finally, import the [`Solarized High Contrast Dark`](https://gist.github.com/jvandellen/2892531) color scheme from the GUI from "Profiles" > "Colors".


### [virtualbox](https://www.virtualbox.org/wiki/Downloads)

I recommend at least creating a Host-Only network with a predictable IP range, which you can later use to specify static IP's in your virtual machines for more convenient local communication.  _VirtualBox's aim is enterprise security, so by default it forces a NAT firewall around its networking solution._


### vim

If you spend any amount of time in the terminal editing files, you may find these plugins worth installing:

- [ctrlp](https://github.com/kien/ctrlp.vim)
- [vim-go](https://github.com/fatih/vim-go)
- [vim-json](https://github.com/elzr/vim-json)
- [vim-node](https://github.com/moll/vim-node)

_The `~/.vimrc` included with this repository is already configured to load plugins._


### [sublime text](http://www.sublimetext.com/3)

This software is free to use without a license but is _"nagware"_.  It is also arguable the best text editor for developers.

I recommend the following packages using [package control](https://packagecontrol.io/):

- [Markdown Preview](https://github.com/revolunet/sublimetext-markdown-preview)
- [SublimeCodeIntel](https://github.com/SublimeCodeIntel/SublimeCodeIntel)
- [GoSublime](https://github.com/DisposaBoy/GoSublime)
- [Origami](https://github.com/SublimeText/Origami)

Unfortunately the lack of a cli interface for plugins makes it impossible to automate the installation of any of them.  _This repository includes [configuration files](user/Library/Application%20Support/Sublime%20Text%203/Packages/User/) for many of these._


## reboot

During the final post-configuration reboot I generally clear the "Remember open windows" check box.


# references

- [OS X Fonts](http://support.apple.com/kb/ht2435)
- [iTerm2 Config](https://code.google.com/p/iterm2/issues/detail?id=1052)
- [Remap Capslock](http://stackoverflow.com/questions/127591/using-caps-lock-as-esc-in-mac-os-x)
- [iTerm2 alt hotkeys](https://code.google.com/p/iterm2/issues/detail?id=1052)
- [iTerm2 unlimited history](http://stackoverflow.com/questions/12459755/zsh-iterm2-increase-number-of-lines-history)
- [sync iterm2 profile with dotfiles repository](http://stratus3d.com/blog/2015/02/28/sync-iterm2-profile-with-dotfiles-repository/)
