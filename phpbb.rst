搭建 phpBB 论坛
===============

安装 lighttpd, php, postgresql. 同时安装 php-pgsql 用于支持 php 连接 postgresql, 和 phpbb 需要的 php-xml::

  apt install lighttpd php7.0-fpm postgresql php-pgsql php-xml

配置 lighttpd 的 fastcgi::

  fastcgi.server = (
  	".php" => ((
  		"socket" => "/var/run/php/php7.0-fpm.sock"
  	))
  )

默认 Debian 安装 postgresql 后使用 peer 认证，我们修改 pg_hba.conf 使用密码认证::

  # /etc/postgresql/9.6/main/pg_hba.conf
  local   all             phpbb                                     password

重启 lighttpd 和 postgresql 服务后，将 phpBB 的 zip 解包到网站目录下，然后安装即可。