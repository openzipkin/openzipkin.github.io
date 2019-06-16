#!/bin/bash
# Generates, commits, and pushes the Zipkin documentation site
# into the `asf-site` branch

set -xeuo pipefail

# Bail out if there are any changes in git
if ! git diff-index --quiet HEAD --; then
    echo 'Uncommitted changes exist. Bailing out.'
    exit 1
fi

# Create a temporary directory in a way that works on both Linux and macOS.
# See https://unix.stackexchange.com/questions/30091/fix-or-alternative-for-mktemp-in-os-x
readonly builddir="$(mktemp -d 2>/dev/null || mktemp -d -t 'mytmpdir')"

# We'll add the current commit sha to the commit message on the target branch
readonly master_sha="$(git rev-parse --short HEAD)"

# Grab the target branch, delete the existing files so we can do a clean build
git clone --branch asf-site -- git@github.com:apache/incubator-zipkin-website "$builddir"
rm -rf "${builddir:?}/*"

# Generate the site
bundle exec jekyll build --destination "$builddir"

# Commit and push the content
cd "$builddir"
git add .
git commit -m "Generated site from ${master_sha}"
git push
