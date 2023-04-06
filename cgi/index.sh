#!/bin/bash
echo -en "Content-type: text/html\n\n"

cd "$(dirname "$0")"
. config.sh
. user.sh

. header.sh
#content
. footer.sh
