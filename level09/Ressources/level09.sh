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

gcc reverse_level09.c -o reverse

if [ "$?" -ne 0 ]; then
    echo "can not compile the program reverse_level09.c"
    exit 1
fi

crypted_flag_password="$(sshpass -p "${act_level_password}" ssh level${ACTUAL_LEVEL}@${VM_ID} -p 4242 'cat token' 2> /dev/null)"

flag_password=$(./reverse "${crypted_flag_password}")

token="$(sshpass -p "${flag_password}" ssh flag${ACTUAL_LEVEL}@${VM_ID} -p 4242 'getflag' 2> /dev/null)"

token="$(echo "${token}" | grep --color=never 'Check flag.Here is your token : ' | sed 's/.*Check flag.Here is your token : \(\S\+\).*/\1/' | head -n 1)"

echo "found by script:"
echo "${token}"
echo
echo "from level${ACTUAL_LEVEL}/flag:"
cat ../flag

echo "${token}" > tmp_flag
diff ../flag tmp_flag
rm -f tmp_flag
