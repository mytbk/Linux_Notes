### 用hostapd,dnsmasq,ndppd建立IPv6路由

首先配置hostapd开热点，这个很简单，就不谈了。

#### dnsmasq

dnsmasq建立IPv4内网很简单: 

```
dhcp-range=192.168.0.50,192.168.0.150,12h
```

并给wlp1s0分配地址192.168.0.1/24

对于IPv6,也用DHCP,并且广播:
```
dhcp-range=2001:da8:201:1233:1::2, 2001:da8:201:1233:1::500, 80, 12h
enable-ra
```

注意让dnsmasq只监听wifi端，否则会通过有线网发广播...
```
interface=wlp1s0
```

同样给wlp1s0分配地址2001:da8:201:1233:1::1/80

#### ndppd
当内网的机器通过DHCPv6获得IPv6地址后，就可以访问网关了，但外网的机器要访问内网机器时，要让网关转发数据包，于是需要邻居发现协议。
```
# 假设内网机器IPv6地址为2001:da8:201:1233:1::32c
ip -6 neigh add proxy 2001:da8:201:1233:1::32c dev enp0s25
```
手工添加太麻烦，因此需要用ndppd.
```
# /etc/ndppd.conf
proxy enp0s25 {
  rule 2001:da8:201:1233:1::/80 {
  }
}
```

### 内核配置
```
sysctl net.ipv4.conf.all.forwarding=1
sysctl net.ipv6.conf.all.forwarding=1
sysctl net.ipv6.conf.all.proxy_ndp=1

iptables -t nat -A POSTROUTING -o enp0s25 -j MASQUERADE
ip6tables -A INPUT -p ipv6-icmp -j ACCEPT
ip6tables -A OUTPUT -p ipv6-icmp -j ACCEPT
ip6tables -A FORWARD -p ipv6-icmp -j ACCEPT
```
