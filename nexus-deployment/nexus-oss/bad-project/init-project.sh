#!/bin/bash -x

mkdir jgitver-tester
cd jgitver-tester
mvn archetype:generate -B -DarchetypeGroupId=org.apache.maven.archetypes -DarchetypeArtifactId=maven-archetype-quickstart \
      -DarchetypeVersion=1.1 -DgroupId=com.company -DartifactId=jgitver-tester -Dversion=0 -Dpackage=com.company.project

# init the created project with jgitver-maven-plugin
sh -c "$(wget https://raw.githubusercontent.com/jgitver/jgitver-maven-plugin/master/src/doc/scripts/install.sh -O -)"

cp ../pom.xml .
git config --global user.email "you@example.com"
git config --global user.name "Your Name"

# let's do some modifications/commits/tags
echo A > content
git init
git add .
git commit -m "initial commit"
echo B > content && git add -u && git commit -m "added B data"
git tag 1.0 -m "release 1.0"
echo C > content && git add -u && git commit -m "added C data"
git checkout -b cool-feature
echo D > content && git add -u && git commit -m "added D data"
git checkout master
echo E > content && git add -u && git commit -m "added E data"
mvn validate
