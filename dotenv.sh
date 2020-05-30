#!/usr/bin/env bash

set -euo pipefail

eval "cat << EOF
$(cat -)
EOF"
