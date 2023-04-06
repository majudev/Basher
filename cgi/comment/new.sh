#!/bin/bash
cd "$(dirname "$0")"
. ../config.sh
. ../user.sh

if [[ "$USER_LOGGED_IN" == false ]]; then
	echo -en "Location: $PAGE_URL/user/login.sh\n\n"
	exit
fi

if [[ "$QUERY_STRING" == "" ]]; then
	echo -en "Location: $PAGE_URL/index.sh\n\n"
	exit
fi
echo -en "Content-type: text/html\n\n"

POSTID="$QUERY_STRING"

. ../header.sh
cat <<EOF
<main>
  <div class="d-flex flex-column mb-3 justify-content-center align-items-center">
  <form action="/api/newcomment.sh" method="get">
    <h1 class="h3 mb-3 fw-normal text-center">New comment</h1>
    
    <div class="form-floating">
      <textarea class="form-control" id="floatingContent" name="content" placeholder=""></textarea>
      <label for="floatingContent">Content</label>
    </div>
    <input type="hidden" name="postid" value="$POSTID">

    <button class="w-100 btn btn-lg btn-primary" type="submit">Comment it!</button>
  </form>
  </div>
</main>
EOF
. ../footer.sh
