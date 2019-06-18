#!/bin/bash

set -e

built_lock_file="/tmp/Gemfile.lock"
current_lock_file="Gemfile.lock"

function cp_built_lock_file() {
    cp "${built_lock_file}" "${current_lock_file}"
}

if [ -f "${current_lock_file}" ]; then
    diff="$(diff "${built_lock_file}" "${current_lock_file}")"
    if [ "${diff}" != "" 2>/dev/null ]; then
        cp_built_lock_file
    fi
else
    cp_built_lock_file
fi

rm -f /post-api/tmp/pids/server.pid

exec "$@"
