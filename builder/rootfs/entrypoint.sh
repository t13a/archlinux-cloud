#!/bin/bash

set -euo pipefail

# @ref: https://wiki.archlinux.org/index.php/Install_from_existing_Linux#/dev/shm
if [ -L /dev/shm ]
then
    if [ "$(realpath "$(readlink /dev/shm)")" == /run/shm -a ! -d /run/shm ]
    then
        mkdir /run/shm
    fi
fi

groupadd -g "${PGID}" "${PUSER}"
useradd -g "${PGID}" -G wheel -m -s /bin/bash -u "${PUID}" "${PUSER}"
echo "${PUSER} ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/${PUSER}"

chown "${PUSER}:${PUSER}" /out /work

sudo -E -g "${PUSER}" -H -u "${PUSER}" "${@}"
