# Basher

This project is gonna make you cry.

## What is it?

This is simple CRUD webpage written purely in Bash. It runs on Apache and uses
MariaDB for internal storage. For convinience it has been packed into Docker
container, however it should run on any Linux distro with basic shell tools and
Apache configured to support cgi.

## How to build?

```
docker build -t majudev/basher .
```

Run with
```
docker run -p 127.0.0.1:8080:8080 -ti --rm majudev/basher
```
