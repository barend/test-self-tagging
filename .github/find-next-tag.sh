#!/usr/bin/env sh
# Returns the next available git tag.
#
# We use a date-based versioning scheme supporting multiple releases on one day. This
# script returns the next available git tag name on stdout. The tag name is compatible
# with the Python version specifiers standard (omitting the v).
#
# For the first release on a date, returns v2025.7.25.
# For subsequent releases, adds an increment: v2025.7.25.1, v2025.7.25.2, and so on.
#
# https://packaging.python.org/en/latest/specifications/version-specifiers/
#

set -eu

# shellcheck disable=SC3040
(set -o pipefail 2> /dev/null) && set -o pipefail

# Ensure the tags are here
if [ "$(git rev-parse --is-shallow-repository)" = "true" ]; then
    printf "Shallow clone, fetching tags\n" 1>&2
    git fetch --tags 1>&2
fi

# We use date-based versions
RELEASE_DATE="$(date "+%Y.%m.%d")"

# Prefer the bare date, we don't EXPECT to release more than once a day...
RELEASE_TAG="v${RELEASE_DATE}"
if [ "$(git tag --list "${RELEASE_TAG}")" = "${RELEASE_TAG}" ]; then
    # ...but we do ANTICIPATE releasing more than once a day.
    printf "Release %s exists\n" "${RELEASE_TAG}" 1>&2
    INCREMENT=1
    while true; do
        RELEASE_TAG="v${RELEASE_DATE}.${INCREMENT}"
        printf "Release %s " "${RELEASE_TAG}" 1>&2
        if [ "$(git tag --list "${RELEASE_TAG}")" = "${RELEASE_TAG}" ]; then
            printf "exists\n" 1>&2
            INCREMENT=$((INCREMENT + 1))
        else
            printf "available\n" 1>&2
            break
        fi
    done
else
    printf "Release %s available\n" "${RELEASE_TAG}" 1>&2
fi

printf "%s" "${RELEASE_TAG}"
