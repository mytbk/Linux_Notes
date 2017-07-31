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


添加 caddy-cgi 插件
-------------------

Caddy 有用于支持 CGI 的插件 github.com/jung-kurt/caddy-cgi.

首先下载 caddy-cgi 的源码 https://github.com/jung-kurt/caddy-cgi/archive/v1.4.tar.gz，然后还是创建 caddy-cgi 的路径，再解包：

  mkdir -p /tmp/go/src/github.com/jung-kirt
  cd /tmp/go/src/github.com/jung-kirt
  tar xvf /tmp/v1.4.tar.gz
  mv caddy-cgi-1.4 caddy-cgi

编辑 Caddy 源码中的 caddy/caddymain/run.go,在 import 列表的末尾添加 ``_ github.com/jung-kurt/caddy-cgi``. AUR 上面 caddy 这个包的做法是用一个小程序自动生成添加了 import 之后的文件。

之后编译，可以按照上面的方法指定 main.go. 也可以按照 AUR 的做法，编译 github.com/mholt/caddy/caddy 这个 package.
