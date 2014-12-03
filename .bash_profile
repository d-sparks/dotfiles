# aliases
alias ls="ls -G"
alias ssh="vssh"

showmefunc() {
	fab instances:$1
}

alias fabops="workon ops && cd ~/dev/fabulaws"
alias showme="fabops && showmefunc"

# vim controls
set -o vi

# clever
source ~/.clever_bash

# node
. ~/nvm/nvm.sh

# python
source /usr/local/bin/virtualenvwrapper.sh

# go
export GOPATH=~/go
export GOROOT=/usr/local/Cellar/go/1.3.1/libexec

# path 
export PATH=$PATH:$GOPATH/bin:~/bin:~/dev/clever-ops/bin

# colors
export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;35m\]\u\[\033[01;30m\]@\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ '

# bash completion
if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
fi
