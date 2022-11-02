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

## 如何正确地使用 shell

> “Unix 哲学是这样的：一个程序只做一件事，并做好。程序要能协作。程序要能处理文本流，因为这是最通用的接口。” — _Doug McIlroy_

shell 是我们与 Linux 操作系统交互的直接方式，因此正确地使用 shell 是尤为重要的。上面这段话是 Unix 管道发明人、 Unix 传统的奠基人之一 Doug McIlroy 对于 Unix 哲学的总结。所谓正确地使用 shell，就是依据 Unix 哲学来思考问题，然后使用 shell 解决这个问题。

### 对于 Unix 哲学的思考

+ 思考 1：每个工具都只做了一件事，并且把这件事做的很好。

+ 思考 2：工具之间可以通过*管道*连接，将一个工具的输出作为另一个工具的输入，组合起来完成更复杂的任务。

+ 思考 3：我们可以将一切 shell 中工具的输入和输出视为文本流，只有我们自己或是管道中的下一个工具才能决定它的含义。

### 例子

比如说有一个需求：希望查看一个仓库每两次相邻提交的变化，并将其保存到不同的文件中。

首先直接搜索这个需求，发现是不行的，说明这个问题太过复杂且不具有普遍性，因此需要拆解这个问题：

1. 使用 `git log` 可以获得所有的提交记录及其对应的 commit SHA 
2. 将提交记录里的 commit SHA 都提取出来
3. 遍历上面的 commit SHA 列表，每次取当前项和下一项（即两次相邻的提交对应的 commit SHA），将这两个值交给 `git diff`，然后重定向到文件中

这样，我们就获得了一个可行的方案，接下来利用管道和 shell 脚本来解决这个问题。

#### 通过管道组合简单任务

1. 获得提交记录比较简单，只需要

```sh
$ git log
```

2. 提取提交记录中的 commit SHA 这个任务乍一想不太号实现，观察 `git log` 的输出

```
commit 27c7c471563c8c345af7c94f51bd9537e38a66e3 (HEAD -> nscscc-2023, origin/nscscc-2023)
Author: MiaoHao-oops <haomiao19@mails.ucas.ac.cn>
Date:   Tue Oct 18 22:04:52 2022 +0800

    try hint block headings

commit fbccaa0c2ced843d8abaa80cd57a6dadad44eb06
Author: MiaoHao-oops <haomiao19@mails.ucas.ac.cn>
Date:   Tue Oct 18 22:01:35 2022 +0800

    realign hint blocks

```

发现有一定的规律：所有 commit SHA 前面都有一个 “commit” ，这个任务很简单，通过搜索“shell 字符串匹配”等类似关键字就可以找到解决方法。我们可以使用 `grep` 工具提取：

```sh
$ git log | grep commit
commit 12f057bec6902814583350c85358bb73c0e0a837
commit 76a02fae60e4246128f763866f5b3011225916ff
commit f9da5d53d2a9bd2e4aee168dae14a70558f32b58
commit 4ed33590aec4562a3531bb293c252c21be90417a
    This reverts commit c298e171dd69e6527d71017c71008116c0d69cbe.
commit fa3e985cba2b90908c142491aa3d34144a935192
...
commit edf1881e261f98a57fe7941c3496d78606203f16
    Initial commit
```

可以发现，中间和结尾的地方出现了一些我们不想要的东西，这时候可以使用更加强大的[正则表达式](https://www.runoob.com/regexp/regexp-tutorial.html)来提取：

```sh
$ git log | grep '^commit [a-z|0-9]'
commit 12f057bec6902814583350c85358bb73c0e0a837
commit 76a02fae60e4246128f763866f5b3011225916ff
commit f9da5d53d2a9bd2e4aee168dae14a70558f32b58
commit 4ed33590aec4562a3531bb293c252c21be90417a
commit fa3e985cba2b90908c142491aa3d34144a935192
...
commit edf1881e261f98a57fe7941c3496d78606203f16
```

现在离成功还差一步，也就是去掉每行行首的 “commit”，通过类似的方法，将这个任务抽象成“获取每行字符串的第二个字段”便可以找到解决方法。使用 `awk` 命令：

```sh
$ git log | grep '^commit [a-z|0-9]' | awk '{print $2}'
12f057bec6902814583350c85358bb73c0e0a837
76a02fae60e4246128f763866f5b3011225916ff
f9da5d53d2a9bd2e4aee168dae14a70558f32b58
4ed33590aec4562a3531bb293c252c21be90417a
fa3e985cba2b90908c142491aa3d34144a935192
...
edf1881e261f98a57fe7941c3496d78606203f16
```

#### 利用 shell 脚本将命令顺序保存下来

每次都输入一长串命令十分麻烦，因此可以使用脚本将命令保存到文件中：

```sh
$ echo 'git log | grep '\''^commit [a-z|0-9]'\'' | awk '\''{print $2}'\' > get-diff.sh    # 将命令写入脚本文件 get-diff.sh
$ chmod +x get-diff.sh  # 为脚本文件添加可执行权限
$ ./get-diff.sh
12f057bec6902814583350c85358bb73c0e0a837
76a02fae60e4246128f763866f5b3011225916ff
f9da5d53d2a9bd2e4aee168dae14a70558f32b58
4ed33590aec4562a3531bb293c252c21be90417a
fa3e985cba2b90908c142491aa3d34144a935192
...
edf1881e261f98a57fe7941c3496d78606203f16
```

仅用脚本将 commit SHA 输出是不够的，我们还需要对它们做一些操作，因此，将结果保存到一个变量中是一个更好的选择：

```sh
#!/usr/bin/bash
CMT_SIGN=`git log | grep '^commit [a-z|0-9]' | awk '{print $2}'`
echo ${CMT_SIGN}
```

在上面的脚本文件中，我们首先使用 `#!` 标记了该脚本所使用的解释器为 bash；然后使用反引号 `` ` `` 将命令包裹起来，并将结果保存在了变量 `CMT_SIGN` 中；最后使用 `echo` 命令查看 `CMT_SIGN` 的内容是否正确。

接下来，我们希望能够像操作数组那样操作 commit SHA 的列表，由于 CMT_SIGN 中每一个 commit SHA 是用空格隔开的，因此可以利用 shell 中定义数组的语法来将 `CMT_SIGN` 转化为一个数组：

```sh
#!/usr/bin/bash
CMT_SIGN=`git log | grep '^commit [a-z|0-9]' | awk '{print $2}'`
# shell 中定义数组的语法，每个元素用空格隔开：
# array_name=(value_1 value_2 ... value_n)
CMT_SIGN=(${CMT_SIGN})
```

而后，想要遍历这个数组，首选方法便是使用一个循环。在 shell 中，支持 C 语言风格循环：

```sh
#!/usr/bin/bash
CMT_SIGN=`git log | grep '^commit [a-z|0-9]' | awk '{print $2}'`
CMT_SIGN=(${CMT_SIGN})

# 首先获取数组 CMT_SIGN 的长度
LEN=${#CMT_SIGN[@]}

# C 语言风格 for 循环
for ((i=0;i<${LEN}-1;i++))
do
        # 获取数组的第 i、i+1 项
        new=${CMT_SIGN[$i]}
        old=${CMT_SIGN[$i+1]}
done
```

我们使用了一个 for 循环来遍历这个数组，并且将相邻的两个 commit SHA 分别存在变量 new 和 old 中。最后，我们使用 `git diff` 命令生成补丁文件：

```sh
#!/usr/bin/bash
CMT_SIGN=`git log | grep '^commit [a-z|0-9]' | awk '{print $2}'`
CMT_SIGN=(${CMT_SIGN})

LEN=${#CMT_SIGN[@]}

for ((i=0;i<${LEN}-1;i++))
do
        new=${CMT_SIGN[$i]}
        old=${CMT_SIGN[$i+1]}
        git diff ${old} ${new} > $i.patch
done
```

最终，我们运行该脚本，便能够在当前目录下得到一系列补丁文件 `{0, 1, ..., $LEN}.patch`，由新到旧保存了相邻提交的差异。

{% hint style="info" %}
#### 练习

+ **背景**：对于 6.1 版本的 Linux 内核，已经加入了一些使用 [rust 语言](https://www.rust-lang.org/)编写的模块，因此我们想对其中的 rust 源码进行一些统计。

+ **要求**：
	1. 编写一个脚本，能够下载、解压 6.1 版本内核源码，并打印出其中行数最多的 rust 源文件名称和行数
	2. （选做）若本目录下已经存在 Linux 源码，则直接打印出统计信息
{% endhint %}
