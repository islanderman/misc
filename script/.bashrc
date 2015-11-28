
if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
fi

if [ -f /usr/local/bin/.git-prompt.sh ]; then
  source /usr/local/bin/.git-prompt.sh
  export PS1="\[\033[1;31m\][\@]\[\033[0m\] \[\033[1;33m\]\u\[\033[0m\]@\[\033[4;34m\]\h\[\033[0m\] \[\033[1;32m\]\w\[\033[m\] \$(__git_ps1 \"\[\033[00;33m\]::%s::\") \[\033[1;37m\]$\[\033[m\]  \[\033[1;37m\]\[\033[0m\]"
else
PS1="(\[\e[0;36m\]\@\[\e[0m\])[\[\e[0;32m\]\u\[\e[0m\]@\[\e[4;34m\]\h\[\e[0m\]]:\[\e[0;33m\] \w\[\e[0m\]$ " 
#PS1="\[\033[1;31m\][\@]\[\033[0m\] \[\033[1;33m\]\u\[\033[0m\]@\[\033[4;34m\]\h\[\033[0m\] \[\033[1;32m\]\w\[\033[m\] \$(__git_ps1 \"\[\033[00;33m\]::%s::\") \[\033[1;37m\]$\[\033[m\]  \[\033[1;37m\]\[\033[0m\]"
fi

#PATH
export EDITOR=/usr/bin/vim

#alias 
alias mkdir='mkdir -p'
alias ls='ls -hGF '

export JAVA_HOME=$(/usr/libexec/java_home)

