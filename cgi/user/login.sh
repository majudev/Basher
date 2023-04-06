#!/bin/bash
echo -en "Content-type: text/html\n\n"

cd "$(dirname "$0")"
. ../config.sh
. ../user.sh

. ../header.sh
cat <<EOF
<main>
  <div class="d-flex flex-column mb-3 justify-content-center align-items-center">
  <form action="$PAGE_URL/api/login.sh" method="get">
    <h1 class="h3 mb-3 fw-normal text-center">Log in</h1>
EOF
if [[ "`echo $HTTP_QUERY | grep error | grep -c badlogin`" -gt 0 ]]; then
echo '<p style="text-color: red">Error: you supplied wrong login or password</p>'
fi
cat <<EOF
    <div class="form-floating">
      <input type="text" class="form-control" id="floatingInput" name="login" placeholder="">
      <label for="floatingInput">Login</label>
    </div>
    <div class="form-floating">
      <input type="password" class="form-control" id="floatingPassword" name="password" placeholder="">
      <label for="floatingPassword">Password</label>
    </div>

    <button class="w-100 btn btn-lg btn-primary" type="submit">Log in</button>
    <p class="mt-3 text-center">No account yet? <a href="$PAGE_URL/user/register.sh">Register</a>.</p>
  </form>
  </div>
</main>
EOF
. ../footer.sh
