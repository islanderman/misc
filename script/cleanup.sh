#!/bin/sh

for TYPE in 'java' 'xml' 'sh' 'json'
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
