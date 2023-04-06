#!/bin/bash

USER_LOGGED_IN=false

TOKEN="`echo \"$HTTP_COOKIE\" | tr ';' '\n' | grep USER_TOKEN | head -n 1`"
if [[ "$TOKEN" != "" ]]; then
	TOKEN="`echo \"$TOKEN\" | awk -F '=' '{for (i=2; i<=NF; i++) print $i}' | base58 -d | gpg --batch --decrypt`"
	if [[ "$TOKEN" != "" ]]; then
		USER_LOGIN="$TOKEN"
		USER_LOGGED_IN=true
	fi
fi
