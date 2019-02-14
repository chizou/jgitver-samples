#!/bin/bash -x

cd jgitver-tester
git tag 1.0.1 -m "Release 1.0.1"
mvn deploy -DskipStaging=true
git checkout cool-feature
git merge master -Xtheirs master -m "merge"
echo "Hello world" > content
git add content pom.xml
git commit -m "Hello world"
git checkout master
git merge cool-feature
mvn deploy -DskipStaging=true

git tag 1.0.2 -m "release 1.0.2"
mvn deploy -DskipStaging=true
