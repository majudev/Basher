#!/bin/bash
(return 0 2>/dev/null) || exit
cat <<EOF
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="Maju">
    <title>Basher</title>

    <!-- Bootstrap core CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">

    <style>
      .bd-placeholder-img {
        font-size: 1.125rem;
        text-anchor: middle;
        -webkit-user-select: none;
        -moz-user-select: none;
        user-select: none;
      }

      @media (min-width: 768px) {
        .bd-placeholder-img-lg {
          font-size: 3.5rem;
        }
      }
    </style>
  </head>
  <body>
    
<nav class="navbar navbar-expand-md navbar-dark bg-dark mb-4">
  <div class="container-fluid">
    <a class="navbar-brand" href="$PAGE_URL">Basher</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarCollapse" aria-controls="navbarCollapse" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarCollapse">
      <ul class="navbar-nav me-auto mb-2 mb-md-0">
        <li class="nav-item">
          <a id="link_profile" class="nav-link active" href="$PAGE_URL/profile">Main page</a>
        </li>
        <!--- <li class="nav-item">
          <a id="link_trial" class="nav-link" href="$PAGE_URL/trial">Moja próba</a>
        </li>
        <li class="nav-item">
          <a id="link_appointments" class="nav-link" href="$PAGE_URL/appointments">Moje spotkania z kapitułą</a>
        </li> --->
      </ul>
      <ul class="navbar-nav mb-2 mb-md-0">
        <li class="nav-item">
EOF
if [[ "$USER_LOGGED_IN" == true ]]; then
echo '          <a class="nav-link active" aria-current="page" href="'$PAGE_URL'/api/logout.sh">Logout</a>'
else
echo '          <a class="nav-link active" aria-current="page" href="'$PAGE_URL'/user/login.sh">Log in</a>'
fi
cat <<EOF
        </li>
      </ul>
    </div>
  </div>
</nav>
EOF
