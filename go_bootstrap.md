Building Go 1.8 on CentOS
=========================

I don't like third party binary packages, and I also want to bootstrap Go with only a C compiler. So here I'm going to build Go 1.8 without an existing Go compiler.

First, clone the repository, and clone several copies as `go14`, `go16` and `go18`.

Go 1.4 is the last Go distribution that is written in C, so build it first.

Then use Go 1.4 to build Go 1.6, because I had problems building Go 1.8 with Go 1.4.

At last, use Go 1.6 to Go 1.8. Remember to set the `GOROOT_FINAL` variable.
