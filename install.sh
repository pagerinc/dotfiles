#!/usr/bin/env bash

set -euo pipefail

echo 'Installing Homebrew and bundle'

./brew.rb && brew bundle

echo 'Linking settings...'

for f in 'gitconfig' 'gitignore' 'agignore' 'npmrc'; do
  ln -s "$PWD/${f}" "${HOME}/.${f}"
done

echo 'All done. Happy coding!'
