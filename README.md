[![CI](https://github.com/AlexGidarakos/linux-qol-tweaks/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/AlexGidarakos/linux-qol-tweaks/actions/workflows/ci.yml?query=branch%3Amain)

# Linux QoL Tweaks
A collection of quality-of-life tweaks that I like to apply as soon as possible on a fresh Linux installation, be it bare-metal, VM or container.

- [Linux QoL Tweaks](#linux-qol-tweaks)
  - [List of Tweaks](#list-of-tweaks)
  - [Features](#features)
  - [Dependencies](#dependencies)
  - [Usage](#usage)
  - [Standards](#standards)
  - [Tested on](#tested-on)

## List of Tweaks
The script provides the following functions that can be called individually:
* `tweak_bash_aliases`: Adds `ls` alias to `ls --color=auto` and `ll` alias to `ls -al`.
* `tweak_bash_prompt`: When the current working directory is a Git repository, the bash prompt shows the current Git branch and status [[1](https://code.mendhak.com/simple-bash-prompt-for-developers-ps1-git/)].
* `tweak_nanorc`: `nano` shows the cursor position.
* `tweak_inputrc`: Adds shell history navigation using arrow keys.

## Features
* **Self-contained**: The script has no external file dependencies.
* **Idempotent**: Run the script or individual functions multiple times without creating duplicate entries. The script intelligently checks if a tweak has already been applied.
* **Safe & non-destructive**: The script respects existing user configurations and will not overwrite custom aliases or settings. For significant changes (like the bash prompt), it automatically creates a numbered backup (e.g., `.bashrc.1`).
* **Modular**: Apply only the tweaks you want by calling the specific functions.

## Dependencies
* Bash
* GNU Coreutils
* Git (optional, for `tweak_bash_prompt`)

## Usage
1.  **Download the script**
    ```bash
    wget https://raw.githubusercontent.com/AlexGidarakos/linux-qol-tweaks/main/tweaks.sh
    ```

2.  **Source the script**
    Load the functions into your current shell session by "sourcing" the script:
    ```bash
    source tweaks.sh
    ```

3.  **Call the desired functions**
    Now you can call any of the available tweak functions directly.
    ```bash
    # Example: Apply the nanorc and bash aliases tweaks
    tweak_nanorc
    tweak_bash_aliases
    ```

## Standards
* [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
* [Conventional Commits](https://www.conventionalcommits.org)

## Tested on
* [Debian 13 LXC container](https://images.linuxcontainers.org/images/debian/trixie/amd64/default/)
* [Debian 12 Docker container](https://gallery.ecr.aws/docker/library/debian)
* [Debian 13 Docker container](https://gallery.ecr.aws/docker/library/debian)
* [Ubuntu 22.04 Docker container](https://gallery.ecr.aws/docker/library/ubuntu)
* [Ubuntu 24.04 Docker container](https://gallery.ecr.aws/docker/library/ubuntu)
