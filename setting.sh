#!/bin/sh

#cp -i .bashrc ~/.bashrc
#cp -i .bash_profile ~/.bash_profile
#cp -i .vimrc ~/.vimrc

path=`dirname "${0}"`
# change relative path to absolute path
expr "${0}" : "/.*" > /dev/null || path=`(cd "${path}" && pwd)`

# set .bash_profile
add=`cat <<EOS
if [ -f ${path}/.bash_profile ]; then
    . ${path}/.bash_profile
fi
EOS`

if [ ! -f ~/.bash_profile ]; then
    touch ~/.bash_profile
fi

if [ -f ~/.bash_profile ]; then
  if [ "$(grep -c "${path}/.bash_profile" ~/.bash_profile)" -eq 0 ]; then
    echo "$add" >> ~/.bash_profile
  fi
fi

if [ "$(uname)" != 'Darwin' ] && [ ! -f ~/.colorrc ]; then
    dircolors -p > ~/.colorrc
fi

. ~/.bash_profile
# set .bash_profile end


# set .vimrc
add=`cat <<EOS
if filereadable(expand('${path}/.vimrc'))
  source ${path}/.vimrc
endif
EOS`

if [ ! -f ~/.vimrc ]; then
    touch ~/.vimrc
fi

if [ "$(grep -c "${path}/.vimrc" ~/.vimrc)" -eq 0 ]; then
    echo "$add" >> ~/.vimrc
fi
# set .vimrc end

#set .gitignore_global
git config --global core.excludesfile ${path}/.gitignore_global
#set .gitignore_global end

#set .gitconfig_private
parentdir=`cd \`dirname $0\`/..;pwd`
git config --global includeIf."gitdir:${parentdir}/".path "${path}/.gitconfig_private"
#set .gitconfig_private end
