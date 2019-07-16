#!/bin/sh

PKGS=(aria2 autoconf automake bash bash-completion boost brew-cask-completion cairo cmake cpanminus curl faac fdk-aac ffmpeg fontconfig freetype fribidi fzf gcc gdbm gettext git glib gmp go gobject-introspection google-java-format graphite2 harfbuzz highlight icu4c isl joe lame libass libav libev libffi libmpc libogg libpng libssh2 libtool libvorbis libvpx libyaml lua maven midnight-commander mpfr mplayer mysql nmap node openssl opus parallel pcre pixman pkg-config protobuf python python3 qt readline rtmpdump s-lang sqlite ssh-copy-id texi2html thefuck theora tomcat tree unrar vim wakeonlan wget x264 xvid xz yasm youtube-dl yubico-piv-tool mas)
TAPS=(adoptopenjdk/openjdk buo/cask-upgrade caskroom/cask caskroom/versions domt4/autoupdate homebrew/bundle homebrew/cask homebrew/cask-drivers homebrew/cask-fonts homebrew/core homebrew/services vitorgalvao/tiny-scripts)
CASK=(airfoil atom bbedit dbeaver-community docker dotnet-sdk dropbox easyfind eclipse-java etcher font-noto-mono font-noto-sans-cjk-sc font-noto-sans-cjk-tc font-noto-sans-display font-noto-sans-mono font-noto-serif-cjk-sc font-noto-serif-cjk-tc font-source-code-pro google-chrome-beta istat-menus iterm2 java java8 kitematic logitech-myharmony microsoft-office musixmatch onedrive onyx osxfuse private-internet-access sequel-pro skype soda-player soundflower sourcetree spotify steam sublime-tex suspicious-package the-unarchiver tunnelblick visual-studio-code welly wireshark)

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
