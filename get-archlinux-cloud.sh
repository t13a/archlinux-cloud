#!/usr/bin/env bash

set -euo pipefail

function cmd_iso() {
    echo 'Fetching ISO...' >&2

    local url="$(cmd_iso_url)"

    if [ "${OUTPUT}" == - ]
    then
        run_or_dryrun curl -L "${url}"
    else
        local output="${OUTPUT:-$(basename "${url}")}"
        local part="${output}.part"

        if [ -e "${output}" ]
        then
            echo "${output}: Already exists" >&2
            exit 1
        fi

        run_or_dryrun curl -L "${url}" -o "${part}"
        run_or_dryrun mv "${part}" "${output}"
    fi
}

function cmd_iso_url() {
    echo "https://github.com/${SOURCE}/releases/download/${TAG}/archlinux-cloud-${ISO_VERSION}-x86_64.iso"
}

function cmd_latest_iso_version() {
    if [ -z "${ISO_VERSION}" ]
    then
        function func() {
            curl -LSs "https://api.github.com/repos/${SOURCE}/releases/tags/${TAG}" \
            | jq -r '.assets[] | .name' \
            | grep -o '^archlinux-cloud-.*-x86_64\.iso$' \
            | sed -e 's/^archlinux-cloud-//g' -e 's/-x86_64\.iso$//g' \
            | sort \
            | tail -n1
        }

        echo 'Fetching latest ISO version...' >&2

        local ret

        if ! ret="$(func)" || [ -z "${ret}" ]
        then
            echo 'Failed to get latest ISO version' >&2
            return 1
        fi

        ISO_VERSION="${ret}"
    fi

    echo "${ISO_VERSION}"
}

function cmd_latest_tag() {
    if [ -z "${TAG}" ]
    then
        function func() {
            curl -LSs "https://api.github.com/repos/${SOURCE}/releases/latest" \
            | jq -r '.tag_name'
        }

        echo 'Fetching latest tag...' >&2

        local ret

        if ! ret="$(func)" || [ "${ret}" == 'null' ]
        then
            echo 'Failed to get latest tag' >&2
            return 1
        fi

        TAG="${ret}"
    fi

    echo "${TAG}"
}

function help() {
    cat << EOF
${0} [OPTION]... [TARGET]

Options:
  -h                show help
  -n                dry run
  -o OUTPUT         specify output filename (default: basename of ISO)
  -s SOURCE         specify source repository (default: '${SOURCE}')
  -t TAG            specify tag (default: latest)
  -v ISO_VERSION    specify ISO version (default: latest)

Targets:
  iso (default)
  iso-url
  latest-iso-version
  latest-tag
EOF
}

function run_or_dryrun() {
    if [ -z "${DRYRUN}" ]
    then
        "${@}"
    else
        echo '[DRYRUN]' "${@}" >&2
    fi
}

DRYRUN=
ISO_VERSION=
OUTPUT=
SOURCE=t13a/archlinux-cloud
TAG=
TARGET=

while getopts hno:s:t:v: OPT
do
    case "${OPT}" in
        h)
            help
            exit 0
            ;;
        n)
            DRYRUN=yes
            ;;
        o)
            OUTPUT="${OPTARG}"
            ;;
        s)
            SOURCE="${OPTARG}"
            ;;
        t)
            TAG="${OPTARG}"
            ;;
        v)
            ISO_VERSION="${OPTARG}"
            ;;
        *)
            exit 1
            ;;
    esac
done

shift $((${OPTIND} - 1))

if [ -z "${TAG}" ]
then
    if ! TAG="$(cmd_latest_tag)"
    then
        exit 1
    fi
fi

if [ -z "${ISO_VERSION}" ]
then
    if ! ISO_VERSION="$(cmd_latest_iso_version)"
    then
        exit 1
    fi
fi

TARGET="${1:-iso}"

"cmd_${TARGET//-/_}"
