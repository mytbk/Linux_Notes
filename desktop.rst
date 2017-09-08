桌面设置小记
============

前几天我给工作站装了个系统，记一下桌面设置。

我用的是 LXDE-GTK3，用 ``pacman -S lxde-gtk3`` 就行了，然后 ``systemctl enable lxdm`` 启用 LXDM.

可以安装 openbox-themes，这样在 look and feel 的设置里面就有很多窗口管理器主题可以选择。此外，look and feel 里面可以设置字体，对于高分屏用户很有帮助。

在主目录下写一个 ``$HOME/.xprofile``，把要在 X 启动时执行的命令写在里面，可以设置键盘布局和一些环境变量。