#!/usr/bin/env bash

set -euo pipefail

function eval_template() {
    eval "cat << EOF
$(cat -)
EOF"
}

function exec_command() {
    for FILE in "${FILES[@]}"
    do
        set -o allexport
        source "${FILE}"
        set +o allexport
    done
    exec "${@}"
}

function help() {
    cat << EOF
${0} [OPTION]... [--] [CMD [ARG]...]

Optons:
  -f FILE   specify file (default: .env)
  -h        show help
  -t        eval template
EOF
}

FILES=()
EXEC=exec_command

while getopts 'f:ht-' OPT
do
    case "${OPT}" in
        f)
            FILES+=("${OPTARG}")
            ;;
        h)
            EXEC=help
            ;;
        t)
            EXEC=eval_template
            ;;
        -)
            break
            ;;
        *)
            exit 1
            ;;
    esac
done

shift $((${OPTIND} - 1))

[ ${#FILES[@]} -gt 0 ] || FILES+=("${DOTENV:-.env}")

"${EXEC}" "${@}"

