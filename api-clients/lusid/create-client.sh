#!/bin/bash 

service=$1

mkdir $service
cd $service

cp ../create-client.sh generate-client.sh
echo "#!/bin/bash" > generate-client.sh
echo "" >> generate-client.sh
echo "../generate-lusid-client.sh $service" >> generate-client.sh

echo "export * from './generated';" > index.ts

cd ..
