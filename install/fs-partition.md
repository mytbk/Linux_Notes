## 分区与文件系统

我们来了解一些文件系统的基本概念，从而能更好地认识我们使用的操作系统。

### 文件系统
数据存放在存储介质(如硬盘)上，在没有任何数据结构的组织下，我们依然可以直接在硬盘上读写数据，但是这样做很不方便，因此我们才需要文件系统。

文件系统的一个组成部分是文件，它是对磁盘的一个抽象。文件系统把存放了数据的文件按照一定的方式组织起来，这样用户就可以很方便的通过文本形式的路径和文件名访问一个文件。

### 分区和分区表
为了更好地组织数据，我们需要对磁盘进行分区，这样可以把功能相近的文件集中放置，便于管理。

有了分区之后，自然就需要一个数据结构存放分区信息，如分区的起始位置和终止位置(或分区大小)，还有更多的信息如分区类型，这个就是分区表。在Linux下可以使用`fdisk`查看一块磁盘的分区表中存放的信息，如:

> ```
> $ LANG= sudo fdisk -l /dev/sda
> Disk /dev/sda: 119.2 GiB, 128035676160 bytes, 250069680 sectors
> Units: sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disklabel type: gpt
> Disk identifier: C26BA9CA-4A2B-48EB-8382-1863F4A6E0AB
> 
> Device         Start       End   Sectors  Size Type
> /dev/sda1       2048    616447    614400  300M Windows recovery environment
> /dev/sda2     616448    821247    204800  100M EFI System
> /dev/sda3     821248   1083391    262144  128M Microsoft reserved
> /dev/sda4    1083392 122882047 121798656 58.1G Microsoft basic data
> /dev/sda5  122882048 250069646 127187599 60.7G Linux filesystem
> ```

以上所展现的分区表显示了/dev/sda所指的这块磁盘有5个分区，每个分区的起始扇区，终止扇区和分区类型如表所示。

分区表可以用不同的方式存放在磁盘上，常见的有MBR和GPT两种分区方案。

#### MBR分区表
MBR分区表，或者叫DOS分区表，是最早用于IBM PC的经典分区表方案。BIOS启动系统的时候要读取磁盘的第一个扇区并执行这个扇区的代码，一个扇区有512字节，其中前440字节放置启动代码，6字节放置MBR标志，末两字节放置启动标志，剩下还有64字节可以放下4个16字节长的分区表条目。

于是，MBR分区方案最多可以放下4个分区。那么，如果要想有更多的分区，就要把其中的一个分区变成扩展分区，在这个扩展分区中再放一个分区表，这样就可以拥有更多的分区了。这样，MBR分区方案从结构上看，有主分区和扩展分区两种类型，主分区中直接存放分区内容，扩展分区中存放的是更多的分区，扩展分区内的分区称为逻辑分区。

#### GUID分区表(GPT)
在MBR分区方案中，由于只有64字节可以存放分区信息，只能支持4个主分区，要依靠扩展分区来增加分区个数。此外，每个分区表条目中都用4个字节记录分区的起始扇区和终止扇区，于是最大只支持2^32扇区*512B/扇区=2TB大小。GPT使用更大的空间存放分区信息，解决了这些问题，并且还使用了一些设计方案，增强了稳定性。

关于GPT的结构及特点，可以参考[ArchWiki](https://wiki.archlinux.org/index.php/GUID_Partition_Table#About_the_GUID_Partition_Table).

### 常见Linux文件系统类型
分区要通过一定的方式组织文件，于是有很多文件系统类型，以下列出一些常见的Linux文件系统类型，做一些简单的介绍。
* ext2: Linux最早的实用文件系统，非常稳定，使用典型的Unix文件系统结构。
* ext3: 在ext2的基础上加入日志功能，现已被废弃，建议使用ext4.
* ext4: 对ext3的改进，有更好的设计，更好的性能和稳定性。内核的ext4驱动包含对ext2和ext3的支持。
* btrfs: 面向未来的文件系统，提供分区分卷，快照，压缩等高级功能。
* xfs: 早期为IRIX操作系统设计的文件系统，后被移植至Linux.主要针对大文件优化。
* f2fs: 三星针对NAND闪存设计的文件系统。

### 挂载