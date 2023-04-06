#!/bin/bash

echo -en "Set-Cookie: USER_TOKEN=`echo TeST | gpg --batch --encrypt --sign -r root@basher - | base58`; HttpOnly\n\n"
env

TOKEN="`echo \"$HTTP_COOKIE\" | tr ';' '\n' | grep USER_TOKEN | head -n 1`"
if [[ "$TOKEN" != "" ]]; then
	TOKEN="`echo \"$TOKEN\" | awk -F '=' '{for (i=2; i<=NF; i++) print $i}' | base58 -d | gpg --batch --decrypt`"
	echo $TOKEN
fi
