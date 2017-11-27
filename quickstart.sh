#!/usr/bin/env bash

set -euo pipefail

handle_shutdown() {
    if [ $? -eq 0 ]; then
        local base_filename="$1"; shift
        rm -f "$base_filename"{.asc,.md5,.md5.asc}
    else
        cat <<EOF

It looks like quick-start setup has failed. Please run the command again
with the debug flag like below, and open an issue on
https://github.com/openzipkin/zipkin/issues/new. Make sure to include the
full output of the run.

    \curl -sSL http://zipkin.io/quickstart.sh | bash -sx

In the meanwhile, you can manually download and run the latest executable jar
from the following URL:

https://dl.bintray.com/openzipkin/maven/io/zipkin/java/zipkin-server/

EOF
    fi
}

extract_latest_version() {
    local package_data="$1"
    if \which jq >/dev/null 2>&1; then
        echo "$package_data" | jq '.latest_version' -r
    else
        echo "$package_data" | sed 's/^.*"latest_version" *: *"*\([^"]*\)".*$/\1/'
    fi
}

verify_version_number() {
    if ! echo "$1" | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' >/dev/null 2>&1; then
        cat <<EOF
It looks like the current version number is "$1". That doesn't look like a
valid Zipkin release version number; this script is confused. Bailing out.

EOF
        exit 1
    fi
}

verify_checksum() {
    local url="$1"; shift
    local filename="$1"; shift

    if \which md5sum >/dev/null 2>&1; then
        echo
        echo "Verifying checksum..."
        curl -sL -o "$filename.md5" "$url.md5"
        echo "$(cat $filename.md5)  $filename" | md5sum --check
    else
        echo "md5sum not found on path, skipping checksum verification"
    fi
}

verify_signature() {
    local url="$1"; shift
    local filename="$1"; shift

    local bintray_gpg_key='D401AB61'

    if \which gpg >/dev/null 2>&1; then
        echo
        echo "Verifying signature of $filename..."
        curl -sL -o "$filename.asc" "$url.asc"
        if gpg --list-keys "$bintray_gpg_key" >/dev/null 2>&1; then
            gpg --verify "$filename.asc" "$filename"
        else
            cat <<EOF

JFrog BinTray GPG signing key is not known, skipping signature verification.
You can import it, then verify the signature of $filename, using the following
commands:

    gpg --keyserver keyserver.ubuntu.com --recv $bintray_gpg_key
    # Optionally trust the key via 'gpg --edit-key $bintray_gpg_key', then typing 'trust',
    # choosing a trust level, and exiting the interactive GPG session by 'quit'
    gpg --verify $filename.asc $filename

EOF
        fi
    else
        echo "gpg not found on path, skipping checksum verification"
    fi
}

main() {
    local filename="zipkin.jar"
    trap "handle_shutdown $filename" EXIT
    cat <<EOF
Thank you for trying OpenZipkin!

This installer is provided as a quick-start helper, so you can try Zipkin out
without a lengthy installation process.

EOF
    echo 'Fetching version number of latest Zipkin release...'
    local package_data="$(curl -fsL  https://bintray.com/api/v1/packages/openzipkin/maven/zipkin)"
    local latest_version="$(extract_latest_version "$package_data")"
    verify_version_number "$latest_version"

    echo "Downloading executable jar for Zipkin $latest_version..."
    local url="https://dl.bintray.com/openzipkin/maven/io/zipkin/java/zipkin-server/$latest_version/zipkin-server-$latest_version-exec.jar"
    curl -sL -o "$filename" "$url"
    verify_checksum "$url" "$filename"
    verify_signature "$url" "$filename"
    verify_signature "$url.md5" "$filename.md5"

    cat <<EOF

You can now run the Zipkin Server:

    java -jar $filename
EOF
}

main "$@"
