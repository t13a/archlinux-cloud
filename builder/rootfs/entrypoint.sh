#!/bin/bash

set -euo pipefail

groupadd -g "${PGID}" "${PUSER}"
useradd -g "${PGID}" -G wheel -m -s /bin/bash -u "${PUID}" "${PUSER}"
echo "${PUSER} ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/${PUSER}"

chown "${PUSER}:${PUSER}" /out /work

sudo -E -g "${PUSER}" -H -u "${PUSER}" "${@}"
