#!/usr/bin/env bash

set -euo pipefail

printf "%s\n\n" "::: dotfiles-rahisi v0.1"

DOTFILES_DIR="${HOME}/.dotfiles"

# Ref: http://www.binaryphile.com/bash/2020/01/12/determining-the-location-of-your-script-in-bash.html
HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")"; cd -P "$(dirname "$(readlink "${BASH_SOURCE[0]}" || echo "${BASH_SOURCE[0]}")")"; pwd)

# shellcheck source=functions.sh
. "${HERE}/functions.sh"

# symlink system_All
if [[ -d ${DOTFILES_DIR}/dotfiles/system_All ]]; then
  dotfiles_print "--> symlink ${DOTFILES_DIR}/dotfiles/system_All"
  dotfiles_init "${DOTFILES_DIR}/dotfiles/system_All"
fi

# symlink system_$(uname)
if [[ -d ${DOTFILES_DIR}/dotfiles/system_$(uname) ]]; then
  dotfiles_print "--> symlink ${DOTFILES_DIR}/dotfiles/system_$(uname)"
  dotfiles_init "${DOTFILES_DIR}/dotfiles/system_$(uname)"
fi

# execute dotfiles.d
if [[ -d ${DOTFILES_DIR}.d ]]; then
  dotfiles_print "--> execute ${DOTFILES_DIR}.d"
  for file in "${DOTFILES_DIR}.d"/*.sh; do
    dotfiles_print "  $ ./$(basename "${file}")"
    bash "${file}" || break
  done
fi
