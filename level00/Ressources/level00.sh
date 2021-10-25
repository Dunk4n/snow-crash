#!/bin/bash

VM_ID='192.168.56.3'

rm -rf john
sshpass -p 'level00' scp scp://level00@${VM_ID}:4242//usr/sbin/john john 2> /dev/null

if [ "$?" -ne 0 ]; then
    echo "Getting the file john failed"
    exit 1
fi

gcc cesar.c -o cesar

if [ "$?" -ne 0 ]; then
    echo "Compilling the cesar program failed"
    exit 1
fi

chmod +r john

john_file_content="$(cat john)"
if [ "$?" -ne 0 ]; then
    echo "Getting content of file john failed"
    exit 1
fi

rm -rf john

flag00_password=$(./cesar "${john_file_content}" 11)

if [ "$?" -ne 0 ]; then
    echo "Getting the password of the flag00 failed"
    exit 1
fi

rm -rf cesar

token="$(sshpass -p "${flag00_password}" ssh flag00@${VM_ID} -p 4242 getflag 2> /dev/null)"

token="$(echo "${token}" | sed 's/Check flag.Here is your token : \(\S\+\)/\1/' | head -n 1)"

echo "found by script:"
echo "${token}"
echo
echo "from level${ACTUAL_LEVEL}/flag:"
cat ../flag

echo "${token}" > tmp_flag
diff ../flag tmp_flag
rm -f tmp_flag
