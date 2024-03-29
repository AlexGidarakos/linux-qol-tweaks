#!/bin/bash
#
# Apply QoL tweaks on a fresh Linux installation.
#
# Project URL:
#   - https://github.com/AlexGidarakos/linux-qol-tweaks
# Authors:
#   - Alexandros Gidarakos <algida79@gmail.com>
#     http://linkedin.com/in/alexandrosgidarakos
# Dependencies:
#   - Bash
#   - GNU coreutils
#   - GNU Wget
# Standards:
#   - Google Shell Style Guide
#     https://google.github.io/styleguide/shellguide.html
#   - Conventional Commits
#     https://www.conventionalcommits.org
# Tested on:
#   - Debian 12 LXC container
#   - Debian 12 Docker container
#   - Ubuntu 22.04 Docker container
# Copyright 2024, Alexandros Gidarakos.
# SPDX-License-Identifier: MIT

readonly GH_1='https://raw.githubusercontent.com'
readonly GH_2='AlexGidarakos'
readonly GH_3='linux-qol-tweaks'
readonly GH_4='main'
readonly GH_5='files'
readonly GH_BASE="${GH_1}/${GH_2}/${GH_3}/${GH_4}/${GH_5}"

install_file() {
  local -r GH_FILE="${1}"
  local -r GH_URL="${GH_BASE}/${GH_FILE}"
  local -r TARGET=~/"${GH_FILE}"
  local -r DOWNLOADED="/tmp/${RANDOM}"

  if [[ -f "${GH_5}/${GH_FILE}" ]]; then
    cp "${GH_5}/${GH_FILE}" "${TARGET}"
  else
    wget -O "${DOWNLOADED}" "${GH_URL}"
    mv "${DOWNLOADED}" "${TARGET}"
  fi
}

tweak_bash_aliases() {
  install_file .bash_aliases
  source ~/.bash_aliases
}

tweak_nanorc() {
  install_file .nanorc
}

tweak_inputrc() {
  install_file .inputrc
}

tweak_path() {
  local -r NEW_PATH_CMD_1='\nPATH="${PATH:+${PATH}:}'
  local -r NEW_PATH_CMD_2='/usr/local/sbin:/usr/sbin:/sbin"'
  local -r NEW_PATH_CMD="${NEW_PATH_CMD_1}${NEW_PATH_CMD_2}"
  local content

  if [[ -f ~/.profile ]]; then
    content="$(cat ~/.profile)"
  fi

  if ! echo "${content}${PATH}" | grep "/usr/local/sbin" > /dev/null; then
    echo -e "${NEW_PATH_CMD}" >> ~/.profile
  fi

  if [[ -f ~/.profile ]]; then
    source ~/.profile
  fi
}

main() {
  tweak_bash_aliases
  tweak_nanorc
  tweak_inputrc
  tweak_path
}

main "$@"
