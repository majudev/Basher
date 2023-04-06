#!/bin/bash
echo -en "Content-type: text/html\n\n"

cd "$(dirname "$0")"
. config.sh
. user.sh

. header.sh
cat <<EOF
<script src="https://cdn.jsdelivr.net/npm/masonry-layout@4.2.2/dist/masonry.pkgd.min.js" integrity="sha384-GNFwBvfVxBkLMJpYMOABq3c+d3KnQxudP/mGPkzpZSTYykLBNsZEnG2D9G/X/+7D" crossorigin="anonymous" async></script>

<main class="container py-5">
  <h1>The Basher Blog</h1>
  <p class="lead">Absolute and utter abomination written in bash and 
EOF
echo "--[----->+<]>----.[--->+<]>----.+++[->+++<]>++.++++++++.+++++.--------.-[--->+<]>--.+[->+++<]>+.++++++++.!" | ./brainfuck.sh
cat <<EOF
</p>

  <p>Create an account, write some post, leave a comment.</p>

  <p>Keep in mind this is just a demo page, it may be cleaned periodically.</p>
EOF
if [[ "$USER_LOGGED_IN" == true ]]; then
echo "<p>It's nice to see you again, <b>$USER_LOGIN</b>.</p>"
echo "<a class=\"btn btn-dark\" href=\"$PAGE_URL/post/new.sh\">Create new post</a>"
fi
if [[ "$USER_ADMIN" == true ]]; then
echo "<p>You are an administrator, so you can do whatever you like.</p>"
fi
cat <<EOF
  <hr class="my-5">

  <div class="row" data-masonry="{&quot;percentPosition&quot;: true }" style="position: relative; height: 687.068px;">
EOF
for id in `echo "select id from posts" | $DB_COMMAND | tail -n +2`; do
	TITLE="`echo \"select title from posts where id='$id'\" | $DB_COMMAND | tail -n +2`"
	CONTENT="`echo \"select content from posts where id='$id'\" | $DB_COMMAND | tail -n +2 | tr '~' '-' | sed -e 's~\(<brainfuck>\)\(.*\)\(<\/brainfuck>\)~[BRAINFUCK CODE]~g' | head -c 600`<i>...</i> <a href=\"$PAGE_URL/post/show.sh?$id\">Read more</a>"
	LOGIN="`echo \"select login from posts where id='$id'\" | $DB_COMMAND | tail -n +2`"
	TIME="`echo \"select time from posts where id='$id'\" | $DB_COMMAND | tail -n +2`"
	ACTIONTAB=""
	if [[ "$USER_LOGGED_IN" == true ]] && [[ "$LOGIN" == "$USER_LOGIN" ]] || [[ "$USER_ADMIN" == true ]]; then
		ACTIONTAB="<!---<button class=\"btn btn-dark\">Edit</button>---> <a class=\"btn btn-danger\" href=\"$PAGE_URL/api/droppost.sh?$id\">Delete</a>"
	fi
	cat <<EOF
    <div class="col-sm-6 col-lg-4 mb-4">
      <div class="card p-3">
        <figure class="p-3 mb-0">
          <blockquote class="blockquote">
            <p>$TITLE</p>
          </blockquote>
          <figcaption class="blockquote-footer mb-0 text-muted">
            Posted by <cite title="$LOGIN">$LOGIN</cite> at $TIME
          </figcaption>
          <p>$CONTENT</p>
          $ACTIONTAB
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
. footer.sh
