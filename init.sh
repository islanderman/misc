#!/bin/sh

PKGS=(aria2 autoconf automake bash bash-completion boost brew-cask-completion cairo cmake cpanminus curl faac fdk-aac ffmpeg fontconfig freetype fribidi fzf gcc gdbm gettext git glib gmp go gobject-introspection google-java-format graphite2 harfbuzz highlight icu4c isl joe lame libass libav libev libffi libmpc libogg libpng libssh2 libtool libvorbis libvpx libyaml lua maven midnight-commander mpfr mplayer mysql nmap node openssl opus parallel pcre pixman pkg-config protobuf python python3 qt readline rtmpdump s-lang sqlite ssh-copy-id texi2html thefuck theora tomcat tree unrar vim wakeonlan wget x264 xvid xz yasm youtube-dl yubico-piv-tool mas)
TAPS=(adoptopenjdk/openjdk buo/cask-upgrade caskroom/cask caskroom/versions domt4/autoupdate homebrew/bundle homebrew/cask homebrew/cask-drivers homebrew/cask-fonts homebrew/core homebrew/services vitorgalvao/tiny-scripts)
CASK=(airfoil font-noto-mono iterm2 osxfuse suspicious-package atom font-noto-sans-cjk-sc java private-internet-access font-noto-sans-cjk-tc java8 sequel-pro  the-unarchiver bbedit font-noto-sans-display  kitematic skype tunnelblick dbeaver-community font-noto-sans-mono logitech-myharmony soda-player  visual-studio-code docker font-noto-serif-cjk-sc welly dotnet-sdk  font-noto-serif-cjk-tc  microsoft-office soundflower  wireshark dropbox font-source-code-pro musixmatch  sourcetree easyfind onedrive spotify eclipse-java google-chrome-beta onyx steam etcher istat-menus sublime-text)

SEGMENT=7

install() {
  param1=("${!1}")

  for (( i=0; i<${#param1[@]} ; i+=$3 )) ; do
	    PKG=""
		for (( j=0; j<$3 ; j++ )) ; do
	    	PKG="$PKG ${param1[i+j]}"
		done
		brew $2 $PKG
  done
}

# xcode
xcode-select --install

# brew related
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
install TAPS[@] tap 1
install PKGS[@] install $SEGMENT
install CASK[@] cask install $SEGMENT

brew cask cleanup
brew cleanup

# space-vim
#sh -c "$(wget -qO- https://raw.githubusercontent.com/liuchengxu/space-vim/master/install.sh)" 

wget https://raw.githubusercontent.com/islanderman/misc/master/.bashrc -O ~/.bash
echo "source ~/.bash" >> ~/.bashrc
