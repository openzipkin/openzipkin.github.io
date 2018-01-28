#!/bin/bash

set -euo pipefail
set -x

target_root="$(pwd)/public"
cd "$(mktemp -d)"
git clone https://github.com/openzipkin/zipkin-api.git
cd zipkin-api/thrift
rm -fv wrapper.thrift
for source in *.thrift; do
    echo "include \"$source\"" >> wrapper.thrift
done
thrift --gen html wrapper.thrift
mv gen-html "$target_root/thrift"
