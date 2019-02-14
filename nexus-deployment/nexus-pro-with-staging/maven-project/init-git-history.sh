#!/usr/bin/env bash

# let's do some cleanup
rm -rf .git
rm -rf .mvn
rm -rf target
rm README.md

# first add latest jgitver-maven-plugin extension
sh -c "$(curl -fsSL https://raw.githubusercontent.com/jgitver/jgitver-maven-plugin/master/src/doc/scripts/install.sh)"

# configure git
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(cyan)%d%Creset %s %C(green)(%cr)%Creset %C(cyan)<%an>%Creset' --abbrev-commit"
git init
git config user.name "Bob TheBuilder"
git config user.email bob.thebuilder@jgitver.github.com
git add .
git commit -m "add project to git"
git tag -m "version 0.0.1" 0.0.1
mvn validate
git checkout -b feat-readme
echo "# jgitver rocks" > README.md
git add README.md
git commit -m "README added"
git checkout master
git merge feat-readme
mvn validate
git lg