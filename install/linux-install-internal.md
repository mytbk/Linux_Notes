## Linux系统的安装原理
让我们再来回顾一下[Arch Linux的安装](install-archlinux.md)，接下来，我们再简单地看一下Debian和Gentoo的安装方法，最后总结一下Linux系统的安装原理。

### Debian和Gentoo的安装
我们开始安装Debian和Gentoo系统。为了实验的方便，我先在虚拟机上安装好一个现成的Arch Linux，/所在分区使用btrfs文件系统，从而可以利用btrfs的分卷机制方便地安装新的系统。

#### 用debootstrap安装Debian
在PC上用Debian的安装盘安装Debian比较简单，因为安装盘中有图形界面的安装程序。在这里，我们来看看如何用debootstrap安装Debian.debootstrap是一个perl脚本，作用和Arch Linux安装盘上的pacstrap类似，可以从网络上下载软件包并构建一个文件系统。用debootstrap安装Debian是构建非x86平台(如ARM开发板，龙芯笔记本)的Debian系统的常用方式。为了方便，在这里我们在现有的Linux安装之上，在一个新的分区中安装Debian，然后用GRUB完成双系统的引导。

#### 安装Gentoo
Gentoo的安装也是类似的，接下来我们再建一个分区来安装Gentoo.

### Linux系统的安装原理: rootfs+chroot
从Arch,Debian,Gentoo的安装中，我们可以发现一些共同点：
* 都构建了一个基本的文件系统(rootfs): Arch使用pacstrap,Debian使用debootstrap,Gentoo使用已经打好包的stage3
* 使用一种叫chroot的手段，进入构建好的rootfs中进行root密码修改，以及进一步的软件安装等操作

因此，Linux系统的安装就是：**rootfs + chroot**.

熟悉了Linux系统的安装原理，相信你已经可以轻松的安装大多数的Linux发行版，跟着手册安装LFS(Linux From Scratch)和CLFS(Cross LFS)也不成问题。同时，也可以根据Linux的结构，修复一些Linux的问题。
