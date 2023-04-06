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
	QUERY_LOGIN="`echo \"$QUERY_STRING\" | tr '&' '\n' | grep login= | head -n 1 | awk -F '=' '{for (i=2; i<=NF; i++) print $i}'`"
	QUERY_PASSWORD="`echo \"$QUERY_STRING\" | tr '&' '\n' | grep password= | head -n 1 | awk -F '=' '{for (i=2; i<=NF; i++) print $i}'`"
	if [[ "$QUERY_LOGIN" != "" ]] && [[ "$QUERY_PASSWORD" != "" ]]; then
		PASSWORD_HASH=`echo "$QUERY_LOGIN:$QUERY_PASSWORD" | sha512sum | awk '{print $1}'`
		SQL="select COUNT(*) from users where login='$QUERY_LOGIN' and password='$PASSWORD_HASH'"
		RECORDS=`echo "$SQL" | $DB_COMMAND | tail -n +2`
                if [[ "$RECORDS" -gt 0 ]]; then
			echo -en "Set-Cookie: USER_TOKEN=`echo \"$QUERY_LOGIN\" | gpg --batch --encrypt --sign -r root@basher - 2>/dev/null | base58`; HttpOnly; Path=/\n"
			echo -en "Location: $PAGE_URL/index.sh\n\n"
			exit
		fi
	fi
fi

#End page loading
echo -en "Location: $PAGE_URL/user/login.sh?error=badlogin\n\n"
