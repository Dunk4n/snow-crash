#!/bin/bash

VM_ID='192.168.56.3'
ACTUAL_LEVEL=02
PREVIOUS_LEVEL=$(printf %02d $(( ${ACTUAL_LEVEL} - 1)))

if [ ! -f "../../level${PREVIOUS_LEVEL}/flag" ]; then
    echo "../../level${PREVIOUS_LEVEL}/flag does not exist"
    exit 1
fi

act_level_password=$(cat "../../level${PREVIOUS_LEVEL}/flag")

rm -rf level02.pcap
sshpass -p "${act_level_password}" scp scp://level${ACTUAL_LEVEL}@${VM_ID}:4242/level02.pcap level02.pcap 2> /dev/null

if [ "$?" -ne 0 ]; then
    echo "Getting the file from the vm failed"
    exit 1
fi

chmod +r level02.pcap

flag_password="$(tcpick -yU -r level02.pcap)"

flag_password=$(echo "${flag_password}" | grep --only --null-data --color=never 'Password:.*<00>' | sed --null-data 's/Password:[^\n]*\n//g' | sed 's/\r//g' | sed --null-data 's/<00>\n<01>\n<00>//g' | sed 's/\x0//g')

while [ "$(echo "${flag_password}" | grep --color=never --max-count=1 -c '<7f>')" -ne 0 ]
do
    flag_password=$(echo "${flag_password}" | sed --null-data 's/\n[^\n]\n<7f>//g')
done

flag_password=$(echo "${flag_password}" | sed --null-data 's/\n//g')

token="$(sshpass -p "${flag_password}" ssh flag${ACTUAL_LEVEL}@${VM_ID} -p 4242 getflag 2> /dev/null)"

token="$(echo "${token}" | sed 's/Check flag.Here is your token : \(\S\+\)/\1/' | head -n 1)"

echo "found by script:"
echo "${token}"
echo
echo "from level${ACTUAL_LEVEL}/flag:"
cat ../flag

echo "${token}" > tmp_flag
diff ../flag tmp_flag
rm -f tmp_flag
