#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

set -euo pipefail

echo 'Installing Homebrew'

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"  || true

if ! which brew; then echo 'brew not installed'; exit; fi

echo 'Homebrew bundle'

brew bundle

echo 'Linking settings...'

for f in 'gitconfig' 'gitignore' 'agignore' 'npmrc'; do
  if [ -f "${HOME}/.${f}" ]; then
      echo "'${HOME}/.${f}' already exist. ln from '$PWD/${f}' postponed - do it yourself"
  else
    ln -s "$PWD/${f}" "${HOME}/.${f}"
  fi
done

lines=(
'export PATH="/usr/local/opt/openssl/bin:$PATH"'
'export LDFLAGS="-L/usr/local/opt/openssl/lib"'
'export CPPFLAGS="-I/usr/local/opt/openssl/include"'
'export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"'
'. $(brew --prefix)/etc/bash_completion'
)
echo 'Lines for your bash_profile:'
for line in "${lines[@]}"; do
  echo "  '$line'"
done
while true; do
    read -p "Do you wish to install the bash_profile lines above? " yn
    case $yn in
        [Yy]* )
          for line in "${lines[@]}"; do
            echo "Looking for line in bash_profile:"
            echo "  '$line'"
            grep -qxF "$line" "${HOME}/.bash_profile" || echo $line >> "${HOME}/.bash_profile"
          done
          break;;
        [Nn]* ) break;;
        * ) echo "Please answer [yY]* or [nN]*.";;
    esac
done

while true; do
    read -p "Do you wish to append aliases to your bash_profile? " yn
    case $yn in
        [Yy]* )
          cat .aliases >> "${HOME}/.bash_profile"
          break;;
        [Nn]* ) break;;
        * ) echo "Please answer [yY]* or [nN]*.";;
    esac
done

while true; do
    read -p "Do you wish to setup gcloud auth? " yn
    case $yn in
        [Yy]* )
          gcloud auth login
          gcloud auth configure-docker
          break;;
        [Nn]* ) break;;
        * ) echo "Please answer [yY]* or [nN]*.";;
    esac
done

while true; do
    read -p "Do you wish to initialize your helm client? " yn
    case $yn in
        [Yy]* )
          helm init
          break;;
        [Nn]* ) break;;
        * ) echo "Please answer [yY]* or [nN]*.";;
    esac
done

while true; do
    read -p "Do you wish to initialize hub client? " yn
    case $yn in
        [Yy]* )
          cd $DIR
          echo Login with you github credentials:
          hub issue
          echo Hub is setup with this config \'~/.config/hub\'
          cat ~/.config/hub
          break;;
        [Nn]* ) break;;
        * ) echo "Please answer [yY]* or [nN]*.";;
    esac
done


echo 'All done. Happy coding!'
