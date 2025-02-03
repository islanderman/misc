#!/usr/bin/env bash

# Early PATH setup for pyenv and other tools
export PATH="/opt/homebrew/bin:$PATH"  # Ensure Homebrew is available early
export HOMEBREW_PREFIX="/opt/homebrew"

# Pyenv Configuration
export PYENV_ROOT="$HOME/.pyenv"
if command -v pyenv >/dev/null; then
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
fi

# NVM Configuration with proper checks
export NVM_DIR="$HOME/.nvm"
if [ -d "$NVM_DIR" ]; then
    [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
fi

# Environment Variables
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

#export EDITOR=/opt/homebrew/bin/vim
export EDITOR="zed --wait"
export BASH_SILENCE_DEPRECATION_WARNING=1
export DOCKER_DEFAULT_PLATFORM="linux/amd64"

# Java Configuration
if /usr/libexec/java_home -v 22 &>/dev/null; then
    export JAVA_HOME=$(/usr/libexec/java_home -v 22)
fi
export MAVEN_OPTS="-XX:+TieredCompilation -XX:TieredStopAtLevel=1 -Dmaven.artifact.threads=$(sysctl -n hw.ncpu)"

# Golang Configuration
if command -v brew >/dev/null; then
    export GOROOT="$(brew --prefix golang)/libexec"
fi
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export GOPRIVATE="*.apple.com"
export GOENV_ROOT="$HOME/.goenv"

# Kubernetes
export KUBECONFIG=~/.kube/config
export SIDECAR_CWD=$PWD/sidecars

# Development Tokens
#export GITHUB_TOKEN=
#export ARTIFACTORY_USERNAME='jerry.yang'
#export ARTIFACTORY_IDENTITY_TOKEN=

# Consolidated PATH (after all tool initialization)
PATH=$HOME/scripts:/usr/local/bin:/usr/local/sbin:/opt/homebrew/bin:/opt/homebrew/anaconda3/bin:/usr/local/opt/openssl@3/bin:/Library/TeX/texbin:$PATH
[[ -d $GOPATH/bin ]] && PATH=$GOPATH/bin:$PATH
[[ -d $GOROOT/bin ]] && PATH=$GOROOT/bin:$PATH
[[ -d $GOENV_ROOT/bin ]] && PATH=$GOENV_ROOT/bin:$PATH
[[ -d $(pyenv root)/shims ]] && PATH=$(pyenv root)/shims:$PATH

# Aliases
alias mkdir='mkdir -p'
alias mvn="mvn -T $(sysctl -n hw.ncpu)C"
#alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'
alias snowsql=/Applications/SnowSQL.app/Contents/MacOS/snowsql

# Define a base alias for common options
alias ezac='eza --hyperlink --follow-symlinks --git-repos --git --color=always --group-directories-first --icons=always -hM --time-style long-iso '

# Use the base alias to define specific commands
alias tree='ezac --tree '
alias ls='ezac -a '
alias ll='ezac -la '
alias la='ezac -laG '
alias lt='ezac --tree --level=3 '
alias lg='ezac  -l '
alias ptt='ssh bbsu@ptt.cc'
alias ptt2='ssh bbsu@ptt2.cc'

# Set custom colors for file types
export EZA_COLORS="di=34:fi=37:ln=36:ex=32:*.md=38;5;121:*.log=38;5;248:*.go=36:*.java=36:*.cpp=36:ic=38;5;46"

# Tool Initializations (with existence checks)
command -v goenv >/dev/null && eval "$(goenv init -)"
command -v zoxide >/dev/null && eval "$(zoxide init bash)"
command -v eksctl >/dev/null && . <(eksctl completion bash)
command -v grep >/dev/null && [[ -e "$HOME/.ssh/config" ]] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2 | tr ' ' '\n')" scp sftp ssh

command -v grep >/dev/null && [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]] && source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"    # Completions

CONDA_ROOT=/opt/homebrew/anaconda3  # Adjust this path to your actual conda installation
if [[ -r $CONDA_ROOT/etc/profile.d/conda.sh ]]; then
    source $CONDA_ROOT/etc/profile.d/conda.sh
    if [[ -r $CONDA_ROOT/share/bash-completion/completions/conda ]]; then
        source $CONDA_ROOT/share/bash-completion/completions/conda
    fi
fi

# tab enhancement
#bind 'set show-all-if-ambiguous on'
#bind 'TAB:menu-complete'
#source .local/share/blesh/ble.sh
