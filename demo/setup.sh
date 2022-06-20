#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o noclobber

# capturing non-zero exit code (for example, grep):
# cat /tmp/doesnotexist && rc=$? || rc=$?

SCRIPT_DIR="$(cd $(dirname "$0"); pwd)"

REPO="$1"

if [[ ! -d "$REPO" ]]; then
    echo "$REPO does not exist"
    exit 1
fi

SOURCE_REPO="$SCRIPT_DIR/.."

git_op () {
    git -C "$REPO" "$@"
}

git_op checkout main
git_op fetch --force --tags
other_branches="$(git_op for-each-ref --format "%(if:notequals=main)%(refname:lstrip=2)%(then)%(refname:lstrip=2)%(end)" 'refs/heads/**')"
# strip newlines
other_branches="${other_branches//$'\n'/ }"
if [[ ! -z "${other_branches// /}" ]]; then
    git_op branch --delete --force $other_branches
fi
tags="$(git_op for-each-ref --format "%(refname:lstrip=2)" 'refs/tags/**')"
# strip newlines
tags="${tags//$'\n'/ }"
if [[ ! -z "${tags// /}" ]]; then
    git_op tag --delete $tags
fi
remotesToDelete="$tags $other_branches"
if [[ ! -z "${remotesToDelete// /}" ]]; then
    git_op push --verbose --delete origin $remotesToDelete
fi

TEMP_BRANCH_NAME=f35a208b-4f86-4538-abab-9aaa52188b3a
git_op checkout --orphan "$TEMP_BRANCH_NAME"
git_op rm -rf .
git_op clean -dxf
for dir in example-app integration-test server; do
    cp -r "$SOURCE_REPO/$dir" "$REPO"
done
cp "$SOURCE_REPO/Dockerfile" "$SOURCE_REPO/LICENSE" "$REPO"
mkdir -p "$REPO/.github"
cp -r "$SOURCE_REPO/github/." "$REPO/.github"
cat > "$REPO/README.md" <<END
# $(basename "$REPO")

This is a copy of the material in https://github.com/warrenb-cgi/github-actions-talk used for demonstration purposes
END
git_op add --all
git_op commit -m "Initial content"
git_op branch -M main

for patch in layout title; do
    git_op checkout -b feature/$patch
    patch --unified --directory="$REPO" --input="$SOURCE_REPO/patches/$patch.patch" -p0
    git_op add --all
    git_op commit -m "Changed $patch"
    git_op checkout main
done

git_op checkout --orphan gh-pages
git_op rm -rf .
git_op clean -dxf
mkdir -p "$REPO/.github"
cp -r "$SOURCE_REPO/github/workflows" "$REPO/.github"
cat > "$REPO/index.html" << END
<!DOCTYPE html>
<html>
    <head>
        <title>Index</title>
        <metadata name="generator" content="action-indexer">
    </head>
    <body>
        <h1>No content</h1>
    </body>
</html>
END
git_op add --all
git_op commit -m "Initial pages content"

git_op checkout main

git_op push --set-upstream origin --all --force
