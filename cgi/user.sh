#!/bin/bash

USER_LOGGED_IN=false

TOKEN="`echo \"$HTTP_COOKIE\" | tr ';' '\n' | grep USER_TOKEN | head -n 1`"
if [[ "$TOKEN" != "" ]]; then
	TOKEN="`echo \"$TOKEN\" | awk -F '=' '{for (i=2; i<=NF; i++) print $i}' | base58 -d | gpg --batch --decrypt 2>/dev/null`"
	if [[ "$TOKEN" != "" ]]; then
		USER_LOGIN="$TOKEN"
		USER_LOGGED_IN=true
	fi
fi

if [[ "$DB_COMMAND" != "" ]]; then
	USER_ADMIN=false
	if [[ "`echo \"select COUNT(*) from users where login='$USER_LOGIN' AND admin=TRUE\" | $DB_COMMAND | tail -n +2`" -gt 0 ]]; then
		USER_ADMIN=true
	fi
fi

function urldecode() { : "${*//+/ }"; echo -e "${_//%/\\x}"; }
