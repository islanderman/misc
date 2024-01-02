#!/bin/sh

for TYPE in 'java' 'sh' 'json'
do

echo *.$TYPE
# tabs to 4-space
    find . -name *.$TYPE ! -type d -exec bash -c 'expand -t 4 "$0" > /tmp/e && mv /tmp/e "$0"' {} \;

# add newline to the end of file if it's not there
    if [ "$(uname)" == "Darwin" ]; then
            find . -name *.$TYPE ! -type d | xargs sed -i '' -e '$a\'
    else
        find . -name *.$TYPE ! -type d | xargs sed -i -e '$a\'
    fi

done


git reflog expire --expire=now --all
git fsck --full --unreachable
git prune 
git repack -a -d --depth=250 --window=250
git gc --prune=now

git pull origin develop; git remote update --prune; git branch --merged | egrep -v "(^\*|master|dev)" | xargs git branch -d
git checkout -q develop && git for-each-ref refs/heads/ "--format=%(refname:short)" | while read branch; do mergeBase=$(git merge-base develop $branch) && [[ $(git cherry develop $(git commit-tree $(git rev-parse $branch\^{tree}) -p $mergeBase -m _)) == "-"* ]] && git branch -D $branch; done

git maintenance run --auto  >> /dev/null 2>&1
git reflog expire --expire=now --expire-unreachable=now --all >> /dev/null 2>&1
git fsck --full --unreachable  >> /dev/null 2>&1
git prune  >> /dev/null 2>&1
git repack -a -d --depth=250 --window=250
