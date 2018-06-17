#!/bin/sh

PKGS=(aria2 autoconf automake bash bash-completion boost brew-cask-completion cairo cmake cpanminus curl faac fdk-aac ffmpeg fontconfig freetype fribidi fzf gcc gdbm gettext git glib gmp go gobject-introspection google-java-format graphite2 harfbuzz highlight icu4c isl joe lame libass libav libev libffi libmpc libogg libpng libssh2 libtool libvorbis libvpx libyaml lua maven midnight-commander mpfr mplayer mysql nmap node openssl opus parallel pcre pixman pkg-config protobuf python python3 qt readline rtmpdump s-lang sqlite ssh-copy-id texi2html thefuck theora tomcat tree unrar vim wakeonlan wget x264 xvid xz yasm youtube-dl yubico-piv-tool mas)
TAPS=(buo/cask-upgrade caskroom/cask caskroom/fonts caskroom/versions domt4/autoupdate homebrew/cask homebrew/cask-drivers homebrew/cask-fonts homebrew/cask-versions homebrew/core homebrew/services)
CASK=(java java8 robo-3t atom docker cacher caskroom/versions/google-chrome-beta caskroom/versions/iterm2-beta eclipse-java etcher font-fontawesome font-source-code-pro quicklook-csv quicklook-json sequel-pro sourcetree visual-studio-code welly airfoil font-noto-mono google-chrome-beta osxfuse the-unarchiver atom font-noto-sans-cjk-sc istat-menus soda-player tunnelblick battle-net font-noto-sans-cjk-tc iterm2 sonos visual-studio-code bbedit font-noto-sans-display java8 soundflower welly dbeaver-community font-noto-sans-mono microsoft-intellipoint sourcetree wireshark docker font-noto-serif-cjk-sc microsoft-office spotify dropbox font-noto-serif-cjk-tc musixmatch steam easyfind font-source-code-pro onedrive suspicious-package eclipse-java google-backup-and-sync origin synology-surveillance-station-client)

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
