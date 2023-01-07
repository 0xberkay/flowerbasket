#!/usr/bin/env bash

package=$1
if [[ -z "$package" ]]; then
  echo "usage: $0 <package-name>"
  exit 1
fi
package_split=(${package//\// })
package_name=${package_split[-1]}
    
platforms=("windows/amd64" "windows/386" "darwin/amd64" "linux/amd64" "linux/386" "linux/arm")

for platform in "${platforms[@]}"
do
    platform_split=(${platform//\// })
    GOOS=${platform_split[0]}
    GOARCH=${platform_split[1]}
    output_name=$package_name'-'$GOOS'-'$GOARCH
    if [ $GOOS = "windows" ]; then
        output_name+='.exe'
    fi    

    mkdir -p build/$GOOS-$GOARCH

    env GOOS=$GOOS GOARCH=$GOARCH CGO_ENABLED=0 go build -o build/$GOOS-$GOARCH/$output_name $package
    if [ $? -ne 0 ]; then
           echo 'An error has occurred! Aborting the script execution...'
        exit 1
    fi

    echo 'Build done: ' $output_name

    cp -r log build/$GOOS-$GOARCH/
    cp -r images build/$GOOS-$GOARCH/
    cp -r views build/$GOOS-$GOARCH/

    # # zip
    # cd build/$GOOS-$GOARCH/
    # zip -r ../$GOOS-$GOARCH.zip ./*
    # cd ../..

    # # remove build folder
    # rm -rf build/$GOOS-$GOARCH
    
done