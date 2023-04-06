#!/bin/bash
cd "$(dirname "$0")"
. ../config.sh
. ../user.sh

echo -en "Content-Type: text/plain\n"

if [[ "$USER_LOGGED_IN" != true ]]; then
	echo -en "Location: $PAGE_URL/user/login.sh\n\n"
	env
	exit
fi

if [[ "$QUERY_STRING" != "" ]]; then
	SQL="select COUNT(*) from comments where login='$USER_LOGIN' and id='$QUERY_STRING'"
	RECORDS=`echo "$SQL" | $DB_COMMAND | tail -n +2`
	if [[ "$RECORDS" -gt 0 ]] || [[ "$USER_ADMIN" == true ]]; then
		SQL="delete from comments where id='$QUERY_STRING'"
		RECORDS=`echo "$SQL" | $DB_COMMAND 2>&1 | wc -l`
		if [[ "$RECORDS" -eq 0 ]]; then
			echo -en "Location: $PAGE_URL/index.sh\n\n"
			exit
		fi
	fi
fi

#End page loading
echo -en "Location: $PAGE_URL/index.sh?error\n\n"
