#!/bin/bash
cd "$(dirname "$0")"
. ../config.sh
. ../user.sh

if [[ "$USER_LOGGED_IN" == false ]]; then
	echo -en "Location: $PAGE_URL/user/login.sh\n\n"
	exit
fi
echo -en "Content-type: text/html\n\n"

. ../header.sh
cat <<EOF
<main>
  <div class="d-flex flex-column mb-3 justify-content-center align-items-center">
  <form action="/api/newpost.sh" method="get">
    <h1 class="h3 mb-3 fw-normal text-center">New post</h1>
    
    <div class="form-floating">
      <input type="text" class="form-control" id="floatingInput" name="title" placeholder="">
      <label for="floatingInput">Title</label>
    </div>
    <div class="form-floating">
      <textarea class="form-control" id="floatingContent" name="content" placeholder=""></textarea>
      <label for="floatingContent">Content</label>
    </div>

    <button class="w-100 btn btn-lg btn-primary" type="submit">Post it!</button>
  </form>
  <p>How to embedd brainfuck code?</p>
  <p>Just insert your brainfuck code inbetween &lt;brainfuck&gt;&lt;/brainfuck&gt; tags. You can have only one tag per post. Exclamation mark denotes end of code and start of input data for the program.</p>
  <p>Example: "Let's &lt;brainfuck&gt;--[----->+<]>----.[--->+<]>----.+++[->+++<]>++.++++++++.+++++.--------.-[--->+<]>--.+[->+++<]>+.++++++++.!&lt;/brainfuck&gt;ify the web!" will become "Let's brainfuckify the web!"</p>
  </div>
</main>
EOF
. ../footer.sh
