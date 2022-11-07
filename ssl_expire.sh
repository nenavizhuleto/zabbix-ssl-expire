#!/bin/bash


function usage ()
{
    echo "script usage: $(basename \$0) [-i https://example.com]" >&2
    echo "-i    [address]       address to get ssl certificate from (required)"
    echo "-s                    flag save to file"
    echo "-f    [filename]      file to save information to"
    echo "-t    [timeout]       connection timeout in seconds (default: 5 seconds)"
    echo "-h                    show this"
    exit 1
}

while getopts 'i:sf:ht:' OPTION; do
    case "$OPTION" in
        i)
            IP="$OPTARG"
            ;;
        t)
            TIMEOUT="$OPTARG"
            ;;
        f)
            FILE="$OPTARG"
            ;;
        s)
            SAVE=1
            ;;
        h)
            usage
            ;;
        ?)
            usage
            ;;
    esac
done

if [ "" == "$IP" ]
then
    echo "please provide correct address"
    usage
fi

if [ "" == "$FILE" ]
then
    FILE=$(echo "$IP" | cut -d"/" -f 3)-sslinfo
fi

if [ "" == "$TIMEOUT" ]
then
    TIMEOUT=5
fi

currentDate=$(date)

cerinfo=$(curl --connect-timeout "$TIMEOUT" "$IP" -vI --stderr - | grep -A 6  "Server certificate")

if [ "" == "$cerinfo" ]
then
    echo "connection exceeded "$TIMEOUT"s timeout. cancelling..."
    exit 1
fi

if [ "$SAVE" == 1 ]
then
    echo "$cerinfo" > "$FILE"
fi

expireDate=$(echo "$cerinfo" | grep "expire date" | cut -d":" -f 2-)
echo "$expireDate"

expireDateEpoch=$(date --date "$expireDate" "+%s")
currentDateEpoch=$(date --date "$currentDate" "+%s")

diff=$(( (expireDateEpoch - currentDateEpoch) / 86400 ))

echo "$diff"
