#!/bin/bash
cd "$(dirname "$0")"
. ../config.sh
. ../user.sh
echo -en "Content-Type: text/plain\n"
echo -en "Set-Cookie: USER_TOKEN=invalid; HttpOnly; Path=/\n"
echo -en "Location: $PAGE_URL/index.sh\n\n"
