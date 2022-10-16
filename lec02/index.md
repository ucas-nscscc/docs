# Linux 操作系统漫谈

## Linux 发行版

当我们尝试安装一个 Linux 操作系统时，常常面临许多选择：[ubuntu](https://ubuntu.com)、[deepin](https://www.deepin.org/index/zh)、[manjaro](https://manjaro.org) 等等，这些选择便是不同的 Linux 发行版（Linux Distribution）。一个 Linux 发行版可以视为**一系列软件的集合**，其中核心的软件包括：

+ [Linux 内核](https://www.kernel.org/)
+ shell，一个典型的例子是 [bash](https://www.gnu.org/software/bash/)

通常情况下，一个发行版中还会包括安装工具，帮助用户将其中包含的软件安装到硬盘上。这些安装工具和软件被打包成 `.iso` 格式的光盘映像文件，在安装时，首先将其烧录到 U 盘中，然后进入固件选择 U 盘启动，便可以进入发行版的安装界面。

## Shell 与 Terminal

在计算机的远古时代，硬件资源十分昂贵，因此通常是一台主机连接到许多[**硬件终端**](http://www.it.uu.se/education/course/homepage/os/vt18/images/module-0/linux/shell-and-terminal/DEC-VT100-terminal.jpg)上，用户通过终端与主机进行交互。

用户在终端中看到所运行的程序则是 shell，通过在 shell 中输入命令，用户便可以获取操作系统所提供的服务。

对于现代计算机，硬件成本大幅下降，几乎每人都有一至多台计算机，因此终端也不必以硬件形式存在，并发展为了**软件终端**。当我们打开终端窗口，其中运行的程序仍然是 shell，软件终端模拟了硬件终端的功能，因此它也被称为**终端模拟器**。

总结而言，终端提供了一个用户与 shell 的交互平台，用户利用终端项 shell 发出命令，由 shell 解释为具体的系统调用帮助用户获取系统服务。

## 环境变量
