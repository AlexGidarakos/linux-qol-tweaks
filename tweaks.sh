#!/bin/bash
# shellcheck source=/dev/null
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
#   - Git (optional, for "tweak_bash_prompt")
# Standards:
#   - Google Shell Style Guide
#     https://google.github.io/styleguide/shellguide.html
#   - Conventional Commits
#     https://www.conventionalcommits.org
# Tested on:
#   - Debian 13 LXC container
#   - Debian 12 Docker container
#   - Debian 13 Docker container
#   - Ubuntu 22.04 Docker container
#   - Ubuntu 24.04 Docker container
# Copyright 2024, Alexandros Gidarakos.
# SPDX-License-Identifier: MIT

# backup_file creates a numbered backup of a given file.
# If the original file does not exist, no backup is created.
# Backups are named original_file.1, original_file.2, etc.
backup_file() {
  local original_file="$1"
  local backup_path
  local counter=1

  # Check if the original file exists and is a regular file
  if [[ ! -f "${original_file}" ]]; then
    return 0 # Nothing to back up
  fi

  # Find the next available backup number
  while true; do
    backup_path="${original_file}.${counter}"
    if [[ ! -f "${backup_path}" ]]; then
      break
    fi
    ((counter++))
  done

  echo "Info: Backing up '${original_file}' to '${backup_path}'" >&2
  cp "${original_file}" "${backup_path}" || { echo "Error: Failed to create backup of '${original_file}'." >&2; return 1; }
}

# tweak_bash_aliases adds "ls" and "ll" aliases
tweak_bash_aliases() {
  local aliases_file=~/.bash_aliases
  local changes_made=false

  # Ensure the file exists before we start checking it
  touch "${aliases_file}"

  # Check for 'ls' alias
  if ! grep -q -E "^[[:space:]]*alias[[:space:]]+ls=" "${aliases_file}"; then
    echo "Info: Adding 'ls' alias to ${aliases_file}" >&2
    echo "alias ls='ls --color=auto' # Added by linux-qol-tweaks" >> "${aliases_file}"
    changes_made=true
  else
    echo "Info: 'ls' alias already exists in ${aliases_file}. Skipping." >&2
  fi

  # Check for 'll' alias
  if ! grep -q -E "^[[:space:]]*alias[[:space:]]+ll=" "${aliases_file}"; then
    echo "Info: Adding 'll' alias to ${aliases_file}" >&2
    echo "alias ll='ls -al'          # Added by linux-qol-tweaks" >> "${aliases_file}"
    changes_made=true
  else
    echo "Info: 'll' alias already exists in ${aliases_file}. Skipping." >&2
  fi

  if [[ "${changes_made}" == true ]]; then
    source "${aliases_file}"
  fi
}

# tweak_bash_prompt enhances the bash prompt to show the current Git branch and status
tweak_bash_prompt() {
  if ! which git > /dev/null; then
    echo "Warning: 'git' command not found. Skipping bash_prompt tweak." >&2
    echo "  To enable git branch info in your prompt, please install git and re-run this function." >&2
    return 1
  fi

  # Check if the tweak has already been applied
  if [[ -f ~/.bashrc ]] && grep -q "function parse_git_branch" ~/.bashrc; then
    echo "Info: git prompt tweak already applied to ~/.bashrc. Skipping." >&2
    return 0
  fi

  backup_file ~/.bashrc
  cat >> ~/.bashrc << 'EOF'

function parse_git_dirty {
  [[ $(git status --porcelain 2> /dev/null) ]] && echo "*"
}

# Added by linux-qol-tweaks
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/ (\1$(parse_git_dirty))/"
}

export PS1="\t ${debian_chroot:+($debian_chroot)}\u@\h:\[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "
EOF
  source ~/.bashrc
}

# tweak_nanorc improves nano by showing the cursor position
tweak_nanorc() {
  local nanorc_file=~/.nanorc

  # Ensure the file exists
  touch "${nanorc_file}"

  # Check if 'set constantshow' is already present
  if grep -q -E "^[[:space:]]*set[[:space:]]+constantshow" "${nanorc_file}"; then
    echo "Info: 'set constantshow' already exists in ${nanorc_file}. Skipping." >&2
  else
    echo "Info: Adding 'set constantshow' to ${nanorc_file}" >&2
    echo "set constantshow # Added by linux-qol-tweaks" >> "${nanorc_file}"
  fi
}

# tweak_inputrc improves shell history navigation using arrow keys
tweak_inputrc() {
  local inputrc_file=~/.inputrc
  local changes_made=false

  # Ensure the file exists
  touch "${inputrc_file}"

  # Define the key bindings to add
  declare -A bindings=(
    ['"\e[A": history-search-backward']="Up arrow key"
    ['"\e[B": history-search-forward']="Down arrow key"
    ['"\e[1~": beginning-of-line']="Home key"
    ['"\e[4~": end-of-line']="End key"
  )

  for binding_line in "${!bindings[@]}"; do
    local comment="${bindings[${binding_line}]}"
    # Check if the binding is already present
    if ! grep -qF "${binding_line}" "${inputrc_file}"; then
      echo "Info: Adding '${binding_line}' to ${inputrc_file}" >&2
      echo "${binding_line} # ${comment} - Added by linux-qol-tweaks" >> "${inputrc_file}"
      changes_made=true
    else
      echo "Info: '${binding_line}' already exists in ${inputrc_file}. Skipping." >&2
    fi
  done

  # If changes were made, inform the user that they might need to restart their shell
  if [[ "${changes_made}" == true ]]; then
    echo "Note: Changes to ${inputrc_file} may require restarting your shell or running 'bind -f ${inputrc_file}' to take effect." >&2
  fi
}

# tweak_all runs all available tweak_* functions
tweak_all() {
  local tweak_functions
  tweak_functions=$(declare -F | awk '{print $3}' | grep '^tweak_' | grep -v '^tweak_all$')

  for func in ${tweak_functions}; do
    echo "Running ${func}..."
    "${func}"
  done
}
