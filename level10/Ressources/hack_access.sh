#!/bin/bash

link=$1
target_token=$2
target_fake=$3

if [ -z "${link}" ]; then
    echo 'link is empty'
    exit 0
fi

if [ -z "${target_token}" ]; then
    echo 'target_token is empty'
    exit 0
fi

if [ -z "${target_fake}" ]; then
    echo 'target_fake is empty'
    exit 0
fi

while [ 1 ]
do
    ln --force --symbolic "${target_token}" "${link}"
    ln --force --symbolic "${target_fake}" "${link}"
done
