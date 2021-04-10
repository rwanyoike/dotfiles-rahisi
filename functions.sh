# This file must be used with "source <FILE>" *from bash*. You cannot run it
# directly

ui_sgr0=$(tput sgr0)
ui_002=$(tput setaf 2)
ui_bold=$(tput bold)

# ${1}: message
function dotfiles_print() {
  printf "${ui_bold}${ui_002}%s${ui_sgr0}\n" "${1}"
}
export -f dotfiles_print

# ${1}: repo
# ${2}: dest
# ${3}: version
function dotfiles_git() {
  if [[ ! -d ${2} ]]; then
    git clone "${1}" "${2}"
  fi
  pushd "${2}" >/dev/null 2>&1 || (echo "! pushd fail" && exit 1)
  git fetch -pPt
  git reset --hard "origin/${3:-main}"
  popd >/dev/null 2>&1 || (echo "! popd fail" && exit 1)
}
export -f dotfiles_git

# ${1}: source
# ${2}: dest
function dotfiles_link() {
  if [[ ! -h ${2} ]]; then
    ln -sv "${1}" "${2}"
  fi
}
export -f dotfiles_link

# ${1}: path
function dotfiles_mkdir() {
  if [[ ! -d ${1} ]]; then
    mkdir -pv "${1}"
  fi
}
export -f dotfiles_mkdir

# ${1}: files
function dotfiles_init() {
  find "${1}" -type f | while read -r fname; do
    relative_path="${fname//${1}\//.}"
    dotfiles_mkdir "${HOME}/$(dirname "${relative_path}")"
    dotfiles_link "${fname}" "${HOME}/${relative_path}"
  done
}
export -f dotfiles_init
