#!/bin/bash
if [[ "$QUERY_STRING" == "" ]]; then
	. ../config.sh
	echo -en "Location: $PAGE_URL/\n\n"
	exit
fi

echo -en "Content-type: text/html\n\n"

cd "$(dirname "$0")"
. ../config.sh
. ../user.sh

. ../header.sh
id="$QUERY_STRING"
TITLE="`echo \"select title from posts where id='$id'\" | $DB_COMMAND | tail -n +2`"
CONTENT="`echo \"select content from posts where id='$id'\" | $DB_COMMAND | tail -n +2 | tr '~' '-'`"
BRAINFUCK_EXTRACT="echo $CONTENT | sed -e 's/\(<brainfuck>\)\(.*\)\(<\/brainfuck>\)/\2/g'"
BRAINFUCK_RESPONSE="`echo $BRAINFUCK_EXTRACT | ../brainfuck.sh`"
CONTENT="`echo $CONTENT | sed -e 's~\(<brainfuck>\)\(.*\)\(<\/brainfuck>\)~'\"$(echo $BRAINFUCK_RESPONSE)\"'~g'`"
LOGIN="`echo \"select login from posts where id='$id'\" | $DB_COMMAND | tail -n +2`"
TIME="`echo \"select time from posts where id='$id'\" | $DB_COMMAND | tail -n +2`"
cat <<EOF
<script src="https://cdn.jsdelivr.net/npm/masonry-layout@4.2.2/dist/masonry.pkgd.min.js" integrity="sha384-GNFwBvfVxBkLMJpYMOABq3c+d3KnQxudP/mGPkzpZSTYykLBNsZEnG2D9G/X/+7D" crossorigin="anonymous" async></script>

<main class="container py-5">
  <h1>$TITLE</h1>
  <p class="lead">Written by <b>$LOGIN</b> at $TIME</p>

  <p>$CONTENT</p>
EOF
if [[ "$USER_LOGGED_IN" == true ]]; then
	echo "<a class=\"btn btn-dark\" href=\"$PAGE_URL/comment/new.sh?$id\">Make comment</a> "
	if [[ "$LOGIN" == "$USER_LOGIN" ]] || [[ "$USER_ADMIN" == true ]]; then
	echo "<!---<button class=\"btn btn-dark\">Edit</button>---> <a class=\"btn btn-danger\" href=\"$PAGE_URL/api/droppost.sh?$id\">Delete</a>"
	fi
fi
cat <<EOF
  <hr class="my-5">

  <div class="row" data-masonry="{&quot;percentPosition&quot;: true }" style="position: relative; height: 687.068px;">
EOF
for id in `echo "select id from comments where postid='$id'" | $DB_COMMAND | tail -n +2`; do
	COMMENT_CONTENT="`echo \"select content from comments where id='$id'\" | $DB_COMMAND | tail -n +2`"
	COMMENT_AUTHOR="`echo \"select login from comments where id='$id'\" | $DB_COMMAND | tail -n +2`"
	COMMENT_TIME="`echo \"select time from comments where id='$id'\" | $DB_COMMAND | tail -n +2`"
	COMMENT_ACTIONTAB=""
	if [[ "$USER_LOGGED_IN" == true ]] && [[ "$COMMENT_AUTHOR" == "$USER_LOGIN" ]] || [[ "$USER_ADMIN" == true ]]; then
		COMMENT_ACTIONTAB="<!--- <button class=\"btn\">Edit</button>---> <a class=\"btn btn-danger\" href=\"$PAGE_URL/api/dropcomment.sh?$id\">Delete</a>"
	fi
	cat <<EOF
    <div class="col-sm-6 col-lg-4 mb-4">
      <div class="card p-3">
        <figure class="p-3 mb-0">
          <blockquote class="blockquote">
            <p>$COMMENT_CONTENT</p>
          </blockquote>
          <figcaption class="blockquote-footer mb-0 text-muted">
            Commented by <cite title="$COMMENT_AUTHOR">$COMMENT_AUTHOR</cite> at $COMMENT_TIME
          </figcaption>
          $COMMENT_ACTIONTAB
        </figure>
      </div>
    </div>
EOF
done
cat <<EOF
    <!--- <div class="col-sm-6 col-lg-4 mb-4">
      <div class="card p-3">
        <figure class="p-3 mb-0">
          <blockquote class="blockquote">
            <p>A well-known quote, contained in a blockquote element.</p>
          </blockquote>
          <figcaption class="blockquote-footer mb-0 text-muted">
            Someone famous in <cite title="Source Title">Source Title</cite>
          </figcaption>
        </figure>
      </div>
    </div>
    <div class="col-sm-6 col-lg-4 mb-4">
      <div class="card">
        <div class="card-body">
          <h5 class="card-title">Card title</h5>
          <p class="card-text">This is another card with title and supporting text below. This card has some additional content to make it slightly taller overall.</p>
          <p class="card-text"><small class="text-muted">Last updated 3 mins ago</small></p>
        </div>
      </div>
    </div> --->
  </div>

</main>
EOF
. ../footer.sh
