# 在 Linux 上安装 Vivado 可能遇到的问题

## 未将 Vivado 添加至环境变量

在使用 `xsetup` 安装后，`vivado` 是没有被添加到环境变量中的，因此需要手动添加：

```
$ echo 'export PATH=<Vivado Install>/bin:$PATH' >> ~/.bashrc
$ source ~/.bashrc
```

需要将 `<Vivado Install>` 修改为你的 Vivado 安装目录，如果安装到 `/opt/Xilinx` ，那么该目录为 `/opt/Xilinx/Vivado/<Version>`。

## 启动时提示缺少 libtinfo.so.5

使用 `apt` 工具安装缺少的库即可：

```
$ sudo apt install libtinfo5
```

## 运行仿真时报错 Failed to compile generated C file *.c

这是由于缺少库 libncurses5 导致的。使用 `apt` 安装即可：

```
$ sudo apt install libncurses5
```

## Hardware Manager 无法连接开发板

需要安装 FPGA cable 驱动程序：

```
$ cd <Vivado Install>/data/xicom/cable_drivers/lin64/install_script/install_drivers
$ sudo ./install_drivers
```

然后重新连接开发板数据线。
