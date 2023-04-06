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
	QUERY_TITLE=$(urldecode "`echo \"$QUERY_STRING\" | tr '&' '\n' | grep title= | head -n 1 | awk -F '=' '{for (i=2; i<=NF; i++) print $i}'`")
	QUERY_CONTENT=$(urldecode "`echo \"$QUERY_STRING\" | tr '&' '\n' | grep content= | head -n 1 | awk -F '=' '{for (i=2; i<=NF; i++) print $i}'`")
	if [[ "$QUERY_TITLE" != "" ]] && [[ "$QUERY_CONTENT" != "" ]]; then
		SQL="insert into posts(login, title, content) values('$USER_LOGIN', '$QUERY_TITLE', '$QUERY_CONTENT')"
		RECORDS=`echo "$SQL" | $DB_COMMAND 2>&1 | wc -l`
                if [[ "$RECORDS" -eq 0 ]]; then
			echo -en "Location: $PAGE_URL/index.sh\n\n"
			exit
		fi
	fi
fi

#End page loading
echo -en "Location: $PAGE_URL/post/new.sh?error\n\n"
