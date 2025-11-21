#!/bin/bash -e

root=$(cd `dirname $0`/../../.. && pwd)
echo "root: $root"

ngVersion=18
project_folder=finbourne/lusid-sdk-angular18
project_name=@$project_folder
service=api

pushd src/lib
echo "generating files for service=${service}; ngVersion=${ngVersion}"
$root/api-clients/lusid/generate-lusid-client.sh $service $ngVersion
popd

echo "removing old files"
echo "  rm -rf $root/dist/$project_folder/ " && rm -rf $root/dist/$project_folder/

pushd $root
echo "Building libaray: npm ci && npm run build -- $project_name" && npm ci && npm run build -- $project_name
echo
pushd dist/$project_folder
echo "packaging and publishing the generated code"
npm publish . --access public
popd

popd
