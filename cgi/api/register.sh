#!/bin/bash
cd "$(dirname "$0")"
. ../config.sh
. ../user.sh
if [[ "$USER_LOGGED_IN" == true ]]; then
	echo -en "Location: $PAGE_URL/index.sh\n\n"
	exit
fi
echo -en "Content-Type: text/plain\n"

if [[ "$QUERY_STRING" != "" ]]; then
	QUERY_LOGIN=$(urldecode "`echo \"$QUERY_STRING\" | tr '&' '\n' | grep login= | head -n 1 | awk -F '=' '{for (i=2; i<=NF; i++) print $i}'`")
	QUERY_PASSWORD=$(urldecode "`echo \"$QUERY_STRING\" | tr '&' '\n' | grep password= | head -n 1 | awk -F '=' '{for (i=2; i<=NF; i++) print $i}'`")
	if [[ "$QUERY_LOGIN" != "" ]] && [[ "$QUERY_PASSWORD" != "" ]]; then
		PASSWORD_HASH=`echo "$QUERY_LOGIN:$QUERY_PASSWORD" | sha512sum | awk '{print $1}'`
		SQL="insert into users(login, password) values ('$QUERY_LOGIN', '$PASSWORD_HASH')"
		RECORDS=`echo "$SQL" | $DB_COMMAND 2>&1 | wc -l`
		if [[ "$RECORDS" -eq 0 ]]; then
			echo -en "Location: $PAGE_URL/user/login.sh\n\n"
			exit
		fi
	fi
fi

#End page loading
echo -en "Location: $PAGE_URL/user/register.sh?error=dberror\n\n"
