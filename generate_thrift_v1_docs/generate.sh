#!/bin/bash

set -euo pipefail
set -x

# Where's Waldo?
me="$(readlink -f ${BASH_SOURCE[0]})"
[ $? -gt 0 ] && me="${BASH_SOURCE[0]}"
mydir="$(cd "$(dirname "$me")" && pwd -P)"
rootdir="$(cd $(dirname "$mydir") && pwd -P)"
target_root="${rootdir}/public"
target_dir="${target_root}/thrift/v1"

# Prepare clean output space
rm -rfv "$target_dir"
mkdir -p "$target_dir"

# Prepare clean workspace
cd "$(mktemp -d)"
git clone https://github.com/openzipkin/zipkin-api.git
cd zipkin-api/thrift

# Generate HTML docs with Thrift
rm -fv wrapper.thrift
for source in *.thrift; do
    echo "include \"$source\"" >> wrapper.thrift
done
thrift -r --gen html -I . -out "$target_dir" wrapper.thrift

# Turn Thrift-output index.html into valid XML
# HTML Tidy exists with 1 on warnings, and we _will_ have warnings
set +e
tidy -indent -asxml -output "$target_dir/index.tidy.html" "$target_dir/index.html"
tidy_status=$?
[ $tidy_status -gt 1 ] && exit $tidy_status
set -e

# Apply some transforms to the generated HTML
java -jar /usr/share/java/Saxon-HE.jar \
     -s:"$target_dir/index.tidy.html" \
     -xsl:"$mydir/transform.xslt" \
     -o:"$target_dir/index.baked.html"
mv -v "$target_dir/index.baked.html" "$target_dir/index.html"
rm -v "$target_dir/index.tidy.html"
