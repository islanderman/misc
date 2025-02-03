# Early Homebrew setup
eval "$(/opt/homebrew/bin/brew shellenv)"

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

# Bash Completion v2 Setup
if type brew &>/dev/null; then
    HOMEBREW_PREFIX="$(brew --prefix)"
    if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
        source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
    else
        for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
            [[ -r "$COMPLETION" ]] && source "$COMPLETION"
        done
    fi
fi

# Enable extended globbing for better completion
shopt -s extglob

# Source main configurations
[[ -f ~/.bash ]] && source ~/.bash
[[ -f ~/.profile ]] && source ~/.profile

# Prompt Configuration
# Git prompt configuration
if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
    source .prompt.bash
else
    PS1="(\[\e[0;36m\]\@\[\e[0m\])[\[\e[0;32m\]\u\[\e[0m\]@\[\e[4;34m\]\h\[\e[0m\]]:\[\e[0;33m\] \w\[\e[0m\]$ "
fi

# Conda initialization
__conda_setup="$('/opt/homebrew/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
elif [ -f "/opt/homebrew/anaconda3/etc/profile.d/conda.sh" ]; then
    source "/opt/homebrew/anaconda3/etc/profile.d/conda.sh"
else
    export PATH="/opt/homebrew/anaconda3/bin:$PATH"
fi
unset __conda_setup

# SDKMAN Configuration
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Created by `pipx` on 2024-11-30 23:48:54
export PATH="$PATH:/Users/chenyang/.local/bin"
