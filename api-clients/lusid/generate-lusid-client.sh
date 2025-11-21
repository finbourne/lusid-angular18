#!/bin/bash

set -euo pipefail

service=$1
ngVersion=$2
NG_MAJOR_VERSION=${ngVersion:0:2} # Asumes versions ar between 10 and 99
useLocalCli="false"
localSwaggerUrl="../../../../../swagger.json"

baseUrl="https://www.lusid.com"
swaggerUrl=$baseUrl/$service/swagger/v0/swagger.json
generatorVersion=7.8.0
scriptDir=$(pwd)
outputDir=.generated
useSingleRequestParameter=true # we want this to be true, but that will need some updating to the LUSID website

echo "About to generate a client for '$service' from $swaggerUrl for Angular version $ngVersion"
echo "    using generator version $generatorVersion"
echo "    code will be created in $scriptDir/$outputDir"

# remove any existing generated code
rm -rf $scriptDir/$outputDir

# generate the code
if [ $useLocalCli = "true" ]
then
  if [ $localSwaggerUrl ]; then
    swaggerUrl=$localSwaggerUrl
  fi
  echo "Generating using local openapi-generator-cli; swaggerUrl=${swaggerUrl}"
  echo `pwd`
  openapi-generator-cli version-manager set $generatorVersion
  openapi-generator-cli generate \
        -g typescript-angular \
        -o $scriptDir/$outputDir \
        -i $swaggerUrl \
        --reserved-words-mappings package=package \
        --type-mappings object=any \
        --type-mappings Object=any \
        --type-mappings DateTime=string \
        --additional-properties npmName=@finbourne/lusid-sdk-angular$ngVersion \
        --additional-properties supportsES6=true \
        --additional-properties useSingleRequestParameter=$useSingleRequestParameter \
        --additional-properties ngVersion=$ngVersion
else
  echo "Generating using podman hosted openapi-generator-cli"
  MSYS_NO_PATHCONV=1 podman run --rm -v $scriptDir:/local \
      openapitools/openapi-generator-cli:v$generatorVersion generate \
        -g typescript-angular \
        -o /local/$outputDir \
        -i $swaggerUrl \
        --reserved-words-mappings package=package \
        --type-mappings object=any \
        --type-mappings Object=any \
        --type-mappings DateTime=string \
        --additional-properties npmName=@finbourne/lusid-sdk-angular$ngVersion \
        --additional-properties supportsES6=true \
        --additional-properties useSingleRequestParameter=$useSingleRequestParameter \
        --additional-properties ngVersion=$ngVersion
fi
echo "Files have been generated"
echo

# set the version number
pushd $scriptDir/
package_json=../../package.json
openapi_version=$(jq .version .generated/package.json | tr -d '"')
echo "Createing $package_json based on ../../package-template.json, setting version to '$openapi_version' (from .generated/package.json)"
cat ../../package-template.json | sed "s/{API_VERSION}/$openapi_version/" | sed "s/{NG_MAJOR_VERSION}/$NG_MAJOR_VERSION/g" > $package_json
popd

# Handle the issue with the generated model/params.ts exporting a DataType class, which we also generate
if [ -f $scriptDir/$outputDir/index.ts ]; then
  echo "Aliasing the export of generated param.ts from $scriptDir/$outputDir/index.ts (otherwise DataType is declared in 2 places)"
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sed -i "" "s@export \* from './param'@export \* as OpenApi from './param'@" $scriptDir/$outputDir/index.ts
  else
    # Linux/Windows
    sed -i "s@export \* from './param'@export \* as OpenApi from './param'@" $scriptDir/$outputDir/index.ts
  fi
  echo
fi
