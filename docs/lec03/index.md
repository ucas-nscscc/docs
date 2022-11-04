# Lec 03 - SOC 搭建

本次培训将指导大家使用 Vivado 的 Block Design 功能搭建自己的 SOC，并在此基础上添加串口控制器，与其他计算机进行串口通信。

## 将 RTL 代码封装为 IP 核

经过本周的实验，大家的 CPU 核已经改为向外暴露一个 AXI 接口，从而使得*片上互联*与*外设扩展*变得简单。我们使用 Vivado 提供的 Block Design（简称为 BD）功能便能搭建出一个基于 AXI 总线的 SOC，并能方便地进行外设扩展。而在 BD 中，搭建的单位由 Verilog 源码变为了 IP 核，因此需要将 SOC 中的主从设备先封装为 IP 核。

以封装 mycpu 为 IP 核为例，从 RTL 代码到 IP 核的过程为：

- 新建 Vivado 工程，其中仅包含 mycpu 的 RTL 源码，即顶层模块为 `mycpu_top`

!!! warning "注意"

    如果你的 CPU 核中调用了 Xilinx IP 核，那么需要将 IP 核一同加入到工程中。如果想要在新项目中加入一个已经在其他项目中定制的 IP 核，那么**无需重新定制**，只需要将描述 IP 核的 `.xci` 文件添加到项目中即可，添加方式与添加 RTL 源码相同。`.xci` 文件具体的位置为 `<Project Home>/*.srcs/sources_1/ip/<IP Name>/*.xci`。

- 将 `mycpu_top.v` 中的 `debug_wb_*` 接口注释掉，这是为了后续定义 IP 接口时不产生混淆

### 封装前的配置

- 点击 Tools :material-arrow-right: Create and Package New IP... 选项，开始封装一个 IP 核：

![](../img/lec03/create-and-package.png)

- 而后，将弹出一个设置界面，点击 Next：

![](../img/lec03/cpni-1.png)

- 选择 Package your current project，设置封装目标为当前项目，然后点击 Next：

![](../img/lec03/cpni-2.png)

- 接下来在 IP location 输入框中输入自定义路径，该路径为 IP 文件的输出路径，然后点击 Next：

![](../img/lec03/cpni-3.png)

- 之后将弹出一个窗口询问是否拷贝源码，点击 OK：

![](../img/lec03/cpni-4.png)

!!! warning "注意"

    如果 IP location 填写的路径下已经存在了之前封装过的 IP，则会弹出一个窗口询问是否覆盖，为了创建最新版本的 IP，点击 Overwrite：
    ![](../img/lec03/cpni-5.png)

- 最后，点击 Finish，将会弹出一个新的临时工程用于配置 IP：

![](../img/lec03/cpni-6.png)

### 在临时工程中配置 IP

弹出的临时工程将自动打开 Package IP 的配置界面，按照下面的步骤对 mycpu IP 进行配置。

- 点击 Ports and Interfaces :material-arrow-right: 右键 interface_aximm[^1] :material-arrow-right: Edit Interface配置 mycpu 对外暴露的 AXI 接口：

![](../img/lec03/pi-1.png)

- 在弹出的窗口中，可以看到对该接口的配置信息，切换到 Port Mapping 选项卡，在**最下面**的窗口中检查 AXI 接口信号（左侧大写）与 `mycpu_top` 中的信号（右侧小写）是否匹配[^2]：

![](../img/lec03/pi-2.png)

- 切换到 Parameters 选项卡，配置接口的参数。点击右侧的 :octicons-diff-added-16: 按钮创建参数，在弹出的窗口中输入参数名为 `FREQ_HZ`，创建完成后，该参数位于 Optional 中，修改 value 一列对应的值为 mycpu 的**实际运行频率**，建议为 50MHz：

![](../img/lec03/pi-3.png)

- 点击 OK 关闭 Edit Interface 窗口后，点击 Review and Package :material-arrow-right: Package IP 按钮封装 IP：

![](../img/lec03/pi-4.png)

- 由于上一小节在 IP location 中填写的是该目录的位置，因此 IP 的 `.xml` 描述文件位于该项目的根目录下：

![](../img/lec03/pi-5.png)

[^1]: 实际接口名称可能不是 interface_aximm
[^2]: 之前注释 `debug_wb_*` 信号就是为了这一部几乎无需修改映射信息