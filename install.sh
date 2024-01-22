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
readonly GH_BASE="${GH_1}/${GH_2}/${GH_3}/${GH_4}"

install_bash_aliases() {
  local -r GH_FILE='files/.bash_aliases'
  local -r GH_URL="${GH_BASE}/${GH_FILE}"
  local -r TARGET=~/.bash_aliases
  local -r DOWNLOADED="/tmp/${RANDOM}"

  if [[ -f "${GH_FILE}" ]]; then
    cp "${GH_FILE}" "${TARGET}"
  else
    wget -O "${DOWNLOADED}" "${GH_URL}"
    mv "${DOWNLOADED}" "${TARGET}"
  fi

  source "${TARGET}"
}

main() {
  install_bash_aliases
}

main "$@"
