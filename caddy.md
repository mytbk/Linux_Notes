手动编译 Caddy
==============

从 Caddy 0.10.4 开始，Caddy 终于把它的依赖包打进来了，因此不再需要 go get 了。

从 go help gopath 可以看出，程序源码树下的 vendor 目录是可以指导 go 的 import 的，于是在源码根目录下编译，就可以用上 vendor 目录下的源码了。

首先，我们建立一个临时的 GOPATH，并且把 Caddy 的路径也建立起来：

  mkdir -p /tmp/go/src/github.com/mholt  
  cd /tmp/go/src/github.com/mholt  

把 Caddy 的源码包解到这个目录下：

  tar xvf /tmp/caddy-0.10.5.tar.gz  
  mv caddy-0.10.5 caddy  
  cd caddy  

然后编译主程序 caddy/main.go:

  GOPATH=/tmp/go go build -v caddy/main.go

最后编译出一个 main 程序，编译成功。
