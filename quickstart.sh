#!/usr/bin/env bash

set -euo pipefail

# This will be set to 1 if we instruct the user to manually verify signatures,
# when they have GPG but don't have the BinTray public key. Would be super confusing
# to tell the user to use files that we've cleaned up.
DO_CLEANUP=0

usage() {
    cat <<EOF
$0
Downloads the latest version of the Zipkin Server executable jar

$0 GROUP:ARTIFACT:VERSION:CLASSIFIER TARGET
Downloads the "VERSION" version of GROUP:ARTIFACT with classifier "CLASSIFIER"
to path "TARGET" on the local file system. "VERSION" can take the special value
"LATEST", in which case the latest Zipkin release will be used. For example:

$0 io.zipkin.java:zipkin-autoconfigure-collector-kafka10:LATEST:module kafka10.jar
downloads the latest version of the artifact with group "io.zipkin.java",
artifact id "zipkin-autoconfigure-collector-kafka10", and classifier "module"
to PWD/kafka10.jar
EOF
}

welcome() {
    cat <<EOF
Thank you for trying OpenZipkin!

This installer is provided as a quick-start helper, so you can try Zipkin out
without a lengthy installation process.

EOF
}

farewell() {
    local artifact_classifier="$1"; shift
    local filename="$1"; shift
    if [ "$artifact_classifier" = 'exec' ]; then
        cat <<EOF

You can now run the downloaded executable jar:

    java -jar $filename

EOF
    else
        cat << EOF

The downloaded artifact is now available at $filename.
EOF
    fi
}

handle_shutdown() {
    local status=$?
    local base_filename="$1"; shift
    if [ $status -eq 0 ]; then
        if [ "$DO_CLEANUP" -eq 0 ]; then
            rm -f "$base_filename"{.md5,.asc,.md5.asc}
        fi
    else
        cat <<EOF

It looks like quick-start setup has failed. Please run the command again
with the debug flag like below, and open an issue on
https://github.com/openzipkin/zipkin/issues/new. Make sure to include the
full output of the run.

    \curl -sSL http://zipkin.io/quickstart.sh | bash -sx -- $@

In the meanwhile, you can manually download and run the latest executable jar
from the following URL:

https://dl.bintray.com/openzipkin/maven/io/zipkin/java/zipkin-server/

EOF
    fi
}

fetch_latest_version() {
    local artifact_group="$1"; shift
    local artifact_id="$1"; shift
    local url="https://api.bintray.com/search/packages/maven?g=${artifact_group}&a=${artifact_id}&subject=openzipkin"
    local package_data="$(curl -fsL "$url")"
    local package_count
    local have_jq

    # We'll have more robustness if jq is present, but will do our best without it as well
    if \which jq >/dev/null 2>&1; then
        have_jq=true
    else
        have_jq=false
    fi

    # Count how many packages we got from the search
    if $have_jq; then
        package_count="$(echo "$package_data" | jq length)"
    else
        package_count="$(echo "$package_data" | tr , '\n' | grep -c latest_version)"
    fi
    # We want exactly one result.
    if [ "$package_count" -eq 0 ]; then
        echo >&2 "No package information found; the provided group or artifact ID may be invalid."
        echo >&2 "Used search URL: ${url}"
        exit 1
    elif [ "$package_count" -gt 1 ]; then
        echo >&2 "More than one package returned from search by Maven group and artifact ID."
        echo >&2 "Used search URL: ${url}"
        exit 1
    fi

    # Finally, extract the actual package version
    if $have_jq; then
        echo "$package_data" | jq '.[0].latest_version' -r
    else
        echo "$package_data" | tr , '\n' | grep latest_version | sed 's/^.*"latest_version" *: *"*\([^"]*\)".*$/\1/'
    fi
}

artifact_part() {
    local index="$1"; shift
    cut -f "$index" -d:
}

verify_version_number() {
    if ! echo "$1" | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' >/dev/null 2>&1; then
        cat <<EOF
The target version is "$1". That doesn't look like a valid Zipkin release version
number; this script is confused. Bailing out.

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
            DO_CLEANUP=1
        fi
    else
        echo "gpg not found on path, skipping checksum verification"
    fi
}

main() {
    local artifact_group=io.zipkin.java
    local artifact_id=zipkin-server
    local artifact_version=LATEST
    local artifact_classifier=exec
    if [ $# -eq 0 ]; then
        local filename="zipkin.jar"
        trap "handle_shutdown \"$filename\" $*" EXIT
    elif [ "$1" = '-h' ] || [ "$1" = '--help' ]; then
        usage
        exit
    elif [ $# -eq 2 ]; then
        local filename="$2"
        trap "handle_shutdown \"$filename\" $*" EXIT
        local artifact_group="$(echo "$1" | artifact_part 1)"
        local artifact_id="$(echo "$1" | artifact_part 2)"
        local artifact_version="$(echo "$1" | artifact_part 3)"
        local artifact_classifier="$(echo "$1" | artifact_part 4)"
    else
        usage
        exit 1
    fi

    if [ -n "$artifact_classifier" ]; then
        artifact_classifier_suffix="-$artifact_classifier"
    else
        artifact_classifier_suffix=''
    fi

    welcome

    local artifact_version_lowercase="$(echo "${artifact_version}" | tr '[:upper:]' '[:lower:]')"
    if [  "${artifact_version_lowercase}" = 'latest' ]; then
        echo "Fetching version number of latest ${artifact_group}:${artifact_id} release..."
        artifact_version="$(fetch_latest_version "$artifact_group" "$artifact_id")"
    fi
    verify_version_number "$artifact_version"

    echo "Downloading $artifact_group:$artifact_id:$artifact_version:$artifact_classifier to $filename..."
    local artifact_group_with_slashes="$(echo "${artifact_group}" | tr '.' '/')"
    local url="https://dl.bintray.com/openzipkin/maven/${artifact_group_with_slashes}/${artifact_id}/$artifact_version/${artifact_id}-${artifact_version}${artifact_classifier_suffix}.jar"
    echo "$url -> $url"
    curl -L -o "$filename" "$url"
    verify_checksum "$url" "$filename"
    verify_signature "$url" "$filename"
    verify_signature "$url.md5" "$filename.md5"

    farewell "$artifact_classifier" "$filename"

}

main "$@"
