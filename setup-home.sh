#!/bin/sh
set -e

CURDIR="$(realpath $(dirname $0))"
CONFDIR="${CURDIR}/home"

BACKUP_EXT=".orig.$(date +%Y%m%d%H%M%S)"

symlink() {
    SOURCE="$1"

    [ "${SOURCE}" = "${CONFDIR}" ] && echo "W: Skipping config directory..." && return

    TARGET="${HOME}/$(basename ${SOURCE})"

    [[ -e "${TARGET}" && ! -l "${TARGET}" ]] && echo "W: Target ${TARGET} already exists, moving to ${BACKUP_EXT}..." && mv ${TARGET} ${TARGET}${BACKUP_EXT}

    echo "I: Symlinking ${SOURCE} to ${TARGET}..."
    ln -s ${SOURCE} ${TARGET}
}

for f in `find ${CONFDIR} -maxdepth 1`
do
    symlink $f
done

touch ~/.gitconfig.local
touch ~/.bashrc.local

mkdir -p ~/tmp
