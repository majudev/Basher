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

## Security considerations

There is no security whatsoever. Session token never expires and there are no SQL injection checks.

## How to embedd brainfuck code into posts?
Just insert your brainfuck code inbetween `<brainfuck></brainfuck>` tags:

```
Let's <brainfuck>--[----->+<]>----.[--->+<]>----.+++[->+++<]>++.++++++++.+++++.--------.-[--->+<]>--.+[->+++<]>+.++++++++.!</brainfuck>ify web together!
```

It will become:

```
Let's brainfuckify web together!
```

Please note the `!` character at the end of the brainfuck code. It means that code has ended and now we supply data for the program.
Since this program doesn't need any input it's the last character, however if your program needs any input data (ie it has any
`,` characters) you need to supply the data after the `!` character, just as you would supply it onto standard input.

## Demo

Please visit [https://basher.majudev.net](https://basher.majudev.net)

It gets cleaned every two weeks.
