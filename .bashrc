
{ eval `ssh-agent`; ssh-add ~/.ssh/id_rsa; } &>/dev/null
{ eval `ssh-agent-github`; ssh-add ~/.ssh/id_rsa_github; } &>/dev/null

export JAVA_HOME=$(/usr/libexec/java_home)
export DYLD_LIBRARY_PATH="/Library/Oracle/instantclient/Current"
if [ -f ~/.git-prompt.sh ]; then
  source ~/.git-prompt.sh
  export PS1="\[\033[1;31m\][\@]\[\033[0m\] \[\033[1;33m\]\u\[\033[0m\]@\[\033[4;34m\]\h\[\033[0m\] \[\033[1;32m\]\w\[\033[m\] \$(__git_ps1 \"\[\033[00;33m\]::%s::\") \[\033[1;37m\]$\[\033[m\]  \[\033[1;37m\]\[\033[0m\]"
else
PS1="(\[\e[0;36m\]\@\[\e[0m\])[\[\e[0;32m\]\u\[\e[0m\]@\[\e[4;34m\]\h\[\e[0m\]]:\[\e[0;33m\] \w\[\e[0m\]$ " 
#PS1="\[\033[1;31m\][\@]\[\033[0m\] \[\033[1;33m\]\u\[\033[0m\]@\[\033[4;34m\]\h\[\033[0m\] \[\033[1;32m\]\w\[\033[m\] \$(__git_ps1 \"\[\033[00;33m\]::%s::\") \[\033[1;37m\]$\[\033[m\]  \[\033[1;37m\]\[\033[0m\]"
fi

#PATH
PATH=/usr/local/bin:/usr/local/sbin:$PATH:~/scripts/

export EDITOR=/usr/bin/vim

#alias 
alias mkdir='mkdir -p'
alias ls='ls -hGF '
alias mvn="mvn -T 2C"

alias fuck='$(thefuck $(fc -ln -1))'

alias gitpurge="git checkout master && git remote update --prune | git branch -r --merged | grep -v master | sed -e 's/origin\//:/' | xargs git push origin"


#git-autocomplete
if [ -f ~/.git-completion.bash ]; then
 . ~/.git-completion.bash
fi

function gi() { curl http://www.gitignore.io/api/$@ ;}

