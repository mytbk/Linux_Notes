在 Arch, Devuan, LEDE 上使用 WireGuard
=========================================

由于我的实验室内网只能访问国内地址，同时我还有安全上网的需求，因此我在社团服务器上部署了 VPN 用于在实验室内网访问国外网站，同时在我的 VPS 上也部署了 VPN 用于安全上网。

此前我用的是 OpenVPN. 但是它配置麻烦，用 easy-rsa 生成密钥的操作也十分繁琐。此外，OpenVPN 已经被安全研究人员进行了流量分析研究，因此用 OpenVPN 进行安全上网还很容易被切断连接。此前我还试用过 tinc，配置简单一些，但是却有一些奇怪的问题让我没法用它安全上网，最后就没再使用。

`WireGuard <https://www.wireguard.io/>`_ 是 2017 年兴起的一个 VPN 软件，它在 Linux 内核的基础上构建，直接使用 Linux 内核中的网络功能，可以用 iproute2 等工具对 VPN 的网络接口进行操作。它使用 Curve25519, Chacha20-Poly1305, Blake2 等先进而高效的密码学算法，安全性好，CPU 要求低。此外，它也提供预共享密钥的设置以抵抗量子计算机的攻击。

WireGuard 提供 wg(8) 工具以配置 WireGuard 网络接口，此外还提供了 wg-quick(8) 脚本来实现设置 IP 地址，设置路由表等功能。

以下是我在不同系统下配置 WireGuard 的方法。


密钥生成
--------

要使用 WireGuard，首先要知道怎样生成密钥。

- 私钥和公钥：每个机器上都要有一个密钥对，用 ``wg genkey`` 可以直接生成一个私钥，然后用 ``echo <privkey> | wg pubkey`` 从私钥计算出公钥。在 WireGuard 的配置文件中，私钥填在 ``[Interface]`` 节的 ``PrivateKey`` 字段中，公钥填在对应端 ``[Peer]`` 节的 ``PublicKey`` 字段中。
- 预共享密钥：预共享密钥是个可选项。用 ``wg genpsk`` 可以生成预共享密钥。预共享密钥为两端共享，要填在 ``[Peer]`` 节的 ``PresharedKey`` 字段中。


Arch
----

我的 VPS 安装的是 Arch. 在 Arch 上安装 WireGuard, 直接安装 ``wireguard-dkms`` 和 ``wireguard-tools`` 即可。VPS 只用于安全上网，只作为 WireGuard 服务端使用。

配置文件 ``/etc/wireguard/wg0.conf`` 如下（本文中的配置文件将敏感信息全部改为 ``<redacted>`` ）::

  [Interface]
  PrivateKey = <redacted>
  ListenPort = 13394
  Address = 192.168.243.1/24
  
  [Peer]
  PublicKey = <redacted>
  PresharedKey = <redacted>
  AllowedIPs = 192.168.243.0/24

这里我用 UDP 端口 13394 （WireGuard 只用 UDP），服务端 IP 地址为 192.168.243.1，接受所有来自 192.168.243.0/24 的连接。

然后用 ``systemctl enable wg-quick@wg0`` 和 ``systemctl start wg-quick@wg0`` 设置系统启动时启动 WireGuard，之后启动 WireGuard.

Devuan
------

由于新版本 Debian 默认使用 systemd，所以我们社团的一位大佬让社团服务器改用 Devuan，最近我把 Devuan 升级到了 testing 版本 Ascii.

Devuan Ascii 官方源没有 WireGuard，因此我下源码，按官网的教程安装，过程很简单，在这里就省略。

由于 Devuan 不用 systemd，WireGuard 源码包没有 sysvinit 的模板，所以我就用 OpenVPN 的改了一个，然后用 ``update-rc.d`` 让它在系统启动时启动::

  #!/bin/sh -e
  
  ### BEGIN INIT INFO
  # Provides:          wireguard
  # Required-Start:    $network $remote_fs $syslog
  # Required-Stop:     $network $remote_fs $syslog
  # Should-Start:      network-manager
  # Should-Stop:       network-manager
  # X-Start-Before:    $x-display-manager gdm kdm xdm wdm ldm sdm nodm
  # X-Interactive:     true
  # Default-Start:     2 3 4 5
  # Default-Stop:      0 1 6
  # Short-Description: WireGuard VPN service
  # Description: This script will start WireGuard tunnels as specified
  #              in /etc/wireguard/*.conf
  ### END INIT INFO
  
  . /lib/lsb/init-functions
  
  test $DEBIAN_SCRIPT_DEBUG && set -v -x
  
  WGQUICK=/usr/bin/wg-quick
  DESC="WireGuard virtual private network daemon"
  CONFIG_DIR=/etc/wireguard
  test -x $WGQUICK || exit 0
  test -d $CONFIG_DIR || exit 0
  
  case "$1" in
  	start)
  		log_daemon_msg "Starting $DESC"
  
  		for wg in $CONFIG_DIR/*.conf
  		do
  			$WGQUICK up `basename $wg .conf`
  		done
  		;;
  	stop)
  		log_daemon_msg "Stopping $DESC"
  
  		for wg in $CONFIG\_DIR/*.conf
  		do
  			$WGQUICK down `basename $wg .conf`
  		done
  		;;
  	*)
  		echo "Usage: $0 {start|stop|reload|restart|force-reload|cond-restart|soft-restart|status}" >&2
  		exit 1
  		;;
  esac
  
  exit 0
  
  # vim:set ai sts=2 sw=2 tw=0:

这个机器要连接我的 VPS 做客户端用于安全上网，也要作为服务端让我用这个机器做路由上国外网站。首先是我连接 VPS 的配置文件 ``/etc/wireguard/wg-vps.conf``::

  [Interface]
  Address = 192.168.243.2/24
  PrivateKey = <redacted>
  
  [Peer]
  PublicKey = <redacted>
  PresharedKey = <redacted>
  Endpoint = [<redacted IPv6 address>]:13394
  AllowedIPs = 192.168.243.0/24
  AllowedIPs = 8.0.0.0/8, 52.0.0.0/8, 74.125.0.0/16, 173.194.0.0/16, 172.217.0.0/16
  AllowedIPs = 207.0.0.0/8, 216.56.0.0/14, 104.0.0.0/8, 199.59.0.0/16

我把这个机器的 IP 设为 192.168.243.2, ``AllowedIPs`` 里面除了 VPS 那端的 IP 外，还加入了我要连接的各个墙外网站的 IP，因为那些网站的流量也会发往 WireGuard 接口，因此要加入 ``AllowedIPs`` 的列表里面。

这个机器也要作为 WireGuard 的服务端，和 Arch 上配置 WireGuard 服务端类似，我使用 69 端口::

  [Interface]
  Address = 192.168.189.1/24
  PrivateKey = <redacted>
  ListenPort = 69
  
  [Peer]
  PublicKey = <redacted>
  PresharedKey = <redacted>
  AllowedIPs = 192.168.189.0/24


LEDE
----

`LEDE <https://lede-project.org>`_ 是一个基于 OpenWrt 的用于路由器等嵌入式设备的操作系统。要在 LEDE 中使用 WireGuard，需要安装 wireguard 和 wireguard-tools.

`LEDE的wiki中介绍了如何配置WireGuard. <https://lede-project.org/docs/user-guide/tunneling_interface_protocols#protocol_wireguard_wireguard_vpn>`_ 我在LEDE上的 ``/etc/config/network`` 的 WireGuard 部分配置如下（此处省略了很多 ``allowed_ips`` ）::

  config interface 'vpn'
  	option proto 'wireguard'
  	list addresses '192.168.189.2/24'
  	option private_key '<redacted>'
  
  config wireguard_vpn
  	option public_key '<redacted>'
  	option preshared_key '<redacted>'
  	option endpoint_host '<redacted>'
  	option endpoint_port '69'
  	option persistent_keepalive '60'
  	list allowed_ips '192.168.189.0/24'
  	list allowed_ips '162.105.129.65/32'
  	# 0.x.x.x to 95.x.x.x
  	list allowed_ips '0.0.0.0/2'
  	list allowed_ips '64.0.0.0/3'
  	option route_allowed_ips '1'

首先 ``interface`` 部分的写法和OpenWrt/LEDE里面其他网络接口的写法一样， ``proto`` 要设为 ``wireguard`` ，接下来是针对 peer 的配置，和 wg(8) 所读取的ini格式的配置文件类似，填上公钥、预共享密钥、 ``allowed_ips`` 等信息就行了，最后设置 ``route_allowed_ips`` 选项用于设置路由表。
