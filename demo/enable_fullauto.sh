#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o noclobber

# capturing non-zero exit code (for example, grep):
# cat /tmp/doesnotexist && rc=$? || rc=$?

SCRIPT_DIR="$(cd $(dirname "$0"); pwd)"

REPO="$1"
SOURCE_REPO="$SCRIPT_DIR/.."

if [[ ! -d "$REPO" ]]; then
    echo "$REPO does not exist"
    exit 1
fi

git_op () {
    git -C "$REPO" "$@"
}

git_op checkout -b feature/enable-dependabot
cp -r "$SOURCE_REPO/github/3-fullauto/." "$REPO/.github"
git_op add --all
git_op commit -m "Enabled fully automatic dependabot"
git_op push --set-upstream origin feature/enable-dependabot
git_op checkout main
