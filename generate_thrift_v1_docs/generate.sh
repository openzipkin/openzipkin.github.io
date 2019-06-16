#!/bin/bash

set -euo pipefail
set -x

# Where's Waldo?
[ ! -d ./generate_thrift_v1_docs ] && cd ..
if [ ! -d ./generate_thrift_v1_docs ]; then
    echo "Please run this script either from the root of the zipkin-website repository"
    echo "or from the generate_thrift_v1_docs folder in that repository."
    exit 1
fi

rootdir="$(pwd -P)"
target_root="${rootdir}/public"
target_dir="${target_root}/thrift/v1"

# Prepare clean output space
rm -rfv "$target_dir"

# Prepare clean workspace
#   base temp dir to /tmp to avoid having to custom configure OS/x Docker
cd "$(mktemp -d /tmp/XXXXXXXXXX)"
git clone https://github.com/openzipkin/zipkin-api.git
cd incubator-zipkin-api/thrift

# Generate HTML docs with Thrift
rm -fv wrapper.thrift
for source in *.thrift; do
    echo "include \"$source\"" >> wrapper.thrift
done
mkdir html
docker run --rm -v "$PWD:/workspace" -u "$(id -u)" thrift:0.11 \
       thrift -r --gen html -I /workspace -out "/workspace/html" /workspace/wrapper.thrift

# Turn Thrift-output index.html into valid XML
# HTML Tidy exists with 1 on warnings, and we _will_ have warnings
set +e
docker run --rm -v "$PWD:/workspace" -u "$(id -u)" imega/tidy \
       -indent -asxml -output "/workspace/html/index.tidy.html" "/workspace/html/index.html"
tidy_status=$?
[ $tidy_status -gt 1 ] && exit $tidy_status
set -e

# Apply some transforms to the generated HTML
cp "$rootdir/generate_thrift_v1_docs/transform.xslt" ./
# Currently, this image doesn't work with a user override https://github.com/klakegg/docker-saxon/issues/2
# docker run --rm -v "$PWD:/workspace" -u "$(id -u)" klakegg/saxon xslt \
docker run --rm -v "$PWD:/workspace" klakegg/saxon xslt \
       -s:/workspace/html/index.tidy.html \
       -xsl:/workspace/transform.xslt \
       -o:/workspace/html/index.baked.html
mv -v html/index.baked.html html/index.html
rm -v html/index.tidy.html
mv html "$target_dir"
