#!/bin/bash

cd lib

rm -rf .git
git init
git config user.name Nobody
git config user.email nobody@nowhere.com
git add .
git commit -m "inital version"
git tag -m "1.0 release" 1.0
mvn clean install

cd ../app
rm -rf .git
git init
git config user.name Nobody
git config user.email nobody@nowhere.com
git add .
git commit -m "inital version"
git tag -m "1.0 release" 1.0
mvn clean install

