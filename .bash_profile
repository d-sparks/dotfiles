export CODE_HOME=~/dev/sparks

showme() {
  # (just so you can do it from any virtualenv / working dir)
  fab instances:$1
}
vssh() {
  # sshs in and sets -o vi, and VISUAL=vim
  /usr/bin/ssh -t $1 " \
	  export VISUAL=vim && \
	  export DOCKER_HOST=tcp://localhost:4243 && \
	  bash -o vi"
}
lnrepo() {
  # make symlinks (usually for a node module or Go package)
  ln -s $CODE_HOME/$1 `pwd`/$1
}
golink() {
  REPONAME=`pwd | sed -e "s/.*\///"`
  CLEVERGO=$GOPATH/src/github.com/Clever
  if [[ $1 ]]; then
    REPONAME=$1
  fi
  if [ "$REPONAME" != "" ]; then
    rm -rf $CLEVERGO/$REPONAME
    echo "Linking $CODE_HOME/$REPONAME <- $CLEVERGO/$REPONAME"
    ln -s $CODE_HOME/$REPONAME $CLEVERGO/$REPONAME
  fi
}
goclear() {
  REPONAME=`pwd | sed -e "s/.*\///"`
  CLEVERGO=$GOPATH/pkg/darwin_amd64/github.com/Clever
  if [[ $1 ]]; then
    REPONAME=$1
  fi
  if [ "$REPONAME" != "" ]; then
    echo "Removing $CLEVERGO/$REPONAME"
    rm -rf $CLEVERGO/$REPONAME
  fi
}
git-status() {
  # for easier parsing into bash programs
  git status | grep modified | sed -e "s/.*modified://" | xargs -n 1
}
mongo-server() {
  # replica set for the win
  mongod --replSet clever-dev &
  echo 'rs.initiate()' > /tmp/temp.js
  mongo < /tmp/temp.js
  rm /tmp/temp.js
}
docker-all() {
  # `dockerall <stop> <ps>` or `dockerall <rmi> <images>`
  docker $1 $(docker $2 --all | tail -n +2 | awk '{print $1;}' | grep -v "<none>")
}
copy() {
  # copies an expression to the clipboard
  echo -n $1 | pbcopy
}
fab-clearhosts() {
  # clears all things from known_hosts from fab_instances matching $1
  fab instances:$1 | grep agents | awk '{print $9}' | xargs -IX ssh-keygen -R X
  cat ~/.ssh/known_hosts | grep -v sparks > /tmp/known_hosts
  mv /tmp/known_hosts ~/.ssh/known_hosts
}
tunnel() {
  # tunnels to argument $1, optional argument $2 for port
  SOURCE_PORT=27017
  TARGET_PORT=30000
  if [[ $2 ]]; then
    TARGET_PORT=$2
  fi
  if [[ $3 ]]; then
    SOURCE_PORT=$3
  fi

  /usr/bin/ssh -f ubuntu@$1 -L $TARGET_PORT:$1:$SOURCE_PORT -N
}
mou() {
  # open markdown file in mou from command line
  open /Applications/Mou.app $1
}
chrome() {
  # launch a file in chrome
  open -a "Google Chrome" $1
}

# aliases
alias ls="ls -G"
alias ssh="vssh"
alias fabops="workon ops && cd ~/dev/fabulaws"
alias ygrep='grep -inr --exclude-dir=node_modules --include=\*.{coffee,jade} --color'
alias showme="fabops && showme"
alias temp="curl -s  http://4ca.st/ajax.php?action=current\&zip=94105 | json current.temperature"

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
