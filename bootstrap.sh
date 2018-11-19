#!/bin/bash

BUILD_IMAGE=false
PULL_IMAGES=false
CREATE_LAUNCHER=true

usage() {
  echo "Usage:"
  echo "./bootstrap.sh /installation/path"
  echo "If this is your first time running this, might be wise to read this script's code."
  echo "There are a few options I could not be bothered to implement as flags."
  exit 1
}

bootstrap() {
    echo "Installing onto $1"
    echo "Creating folder structure"
    mkdir -p $1/source $1/log $1/configurations $1/databases

    echo "Cloning Kleep git"
    git clone --quiet https://gitlab.com/claudiop/Kleep.git $1/source/

    echo "Copying configurations"
    cp -r configurations $1
    mv $1/configurations/settings.json $1/source/

    echo "Creating empty vulnerability database"
    sqlite3 vulnerabilities.db < kleep/vulnerabilities.sql
    mv vulnerabilities.db $1/databases/

    if [ "$BUILD_IMAGE" = true ] ; then
        echo "Building docker image"
        docker build  -t claudioap/kleep .
    else
        echo "Skipped docker image build"
    fi

    if [ "$PULL_IMAGES" = true ] ; then
        echo "Downloading other required images"
        docker pull nginx
    else
        echo "Skipped pulling other images"
    fi

    if [ "$CREATE_LAUNCHER" = true ] ; then
        echo "Creating launch script (launch.sh in the destination folder)"
        cd $1
        touch launch.sh
        echo "docker network create privateNet" > launch.sh
        echo "docker run --name nginx --rm -d -p -v $(pwd):/kleep --network privateNet claudioap/kleep &" >> launch.sh
        echo "docker run --name kleep --rm -d -p 80:80 -v $(pwd)/html:/srv/http:ro -v $(pwd)/configurations/nginx:/etc/nginx:ro --network privateNet nginx &" >> launch.sh
        chmod +x launch.sh
    fi
}

if [ -z $1 ] || [ "$1" == "--help" ]; then
    usage
elif [ ! -v $2 ]; then
    echo "Too many arguments"
    usage
else
    bootstrap $1
fi
