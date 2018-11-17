#!/bin/bash

if [ -z $1 -o $1 == "--help" ]; then
  echo "Usage:"
  echo "./bootstrap.sh /installation/path"
  exit
fi

if [ ! -v $2 ]; then
  echo "Too many arguments"
  exit
fi

mkdir -p $1

mkdir $1/source
mkdir $1/log
git clone https://gitlab.com/claudiop/Kleep.git $1/source/
cp configurations/settings.json $1/source/
cp vulnerabilities.db $1/
cp configurations/uwsgi/kleep.ini $1/uwsgi.ini
sqlite3 vulnerabilities.db < vulnerabilities.sql
