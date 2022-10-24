# lec 02 - git 协作，SOC 与裸机程序

## git 协作

在过去的课程中，大家使用 git 往往是进行个人项目的版本管理，很少涉及多人协作的场景。而对于“龙芯杯”比赛而言，则需要小组内成员合理分工，并使用 git 进行协作开发。使用 git 的诀窍在于脑海里时刻有一张有向图：每一个结点表示一次 commit，每一个边表示两次 commit 之间的变化。

在这张图里，所有结点的公共祖先都是第一次 commit：

```
$ mkdir my-prj && cd my-prj
$ touch README.md
$ git init && git add . && git commit -m "init commit"
Initialized empty Git repository in /home/haooops/my-prj/.git/
[master (root-commit) 2d99435] init commit
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 README.md

#    HEAD(master)
#      |
#      +
# init commit
#
# 通过 git commit 我们创建了第一个 commit 结点，一个指针
# HEAD 指向我们目前所处的分支 master。
```

对 `README.md` 进行修改：

```
$ echo "# README" >> README.md
$ git add . && git commit -m "update README.md"
[master 0493f9d] update README.md
 1 file changed, 1 insertion(+)

#                HEAD(master)
#                  |
#      +----->-----+
#         "update README.md"
#
# 上图中用一条有向边由第一次 commit 指向第二次 commit，
# 表示第二次 commit 是在第一次的基础上变化而来的。
```

创建并切换一个新的分支：

```
$ git checkout -b new
Switched to a new branch 'new'

#             master HEAD(new)
#                  |/
#      +----->-----+
#         "update README.md"
#
# 此时创建分支实际上只是创建了一个指针，指向与 master
# 相同的 commit 结点。
```

在新的分支上对 `README.md` 进行修改：

```
$ echo "## chapter 1" >> README.md
$ git add . && git commit -m "update README.md"
[new 91a9767] update README.md
 1 file changed, 1 insertion(+)

#                master       HEAD(new)
#                  |           |
#      +----->-----+----->-----+
#                   update README.md
#
# 当我们在 new 上进行修改时，master 指针没有变化。
```

回到 `master` 后创建并切换一个新的分支：

```
$ git checkout master && git checkout -b bee
Switched to branch 'master'
Switched to a new branch 'bee'

#             master HEAD(bee)  new
#                  |/           /
#      +----->-----+----->-----+
#                   update README.md
#
# 创建新分支 bee 的效果与之前从 master 上创建 new 相同。
```

在新的分支上对 `README.md` 进行修改：

```
$ echo "## chapter 2" >> README.md
$ git add . && git commit -m "update README.md"
[bee b8a67e1] update README.md
 1 file changed, 1 insertion(+)

#               master        new
#                  |           |
#      +----->-----+----->-----+
#                  \----->-----+
#                              |
#                           HEAD(bee)
```

合并 new、bee 两个分支到 new：

```
$ git checkout new && git merge bee
Switched to branch 'new'
Auto-merging README.md
CONFLICT (content): Merge conflict in README.md
Automatic merge failed; fix conflicts and then commit the result.
```

此时发生了冲突（conflict），git 提示需要进行手动合并，然后再 commit 一次：
```
$ cat README.md
# README
<<<<<<< HEAD
## chapter 1
=======
## chapter 2
>>>>>>> bee

# git 在冲突文件中将产生冲突的部分标记了出来，其中 === 上面的部分表示目前
# 所处分支 new 中的内容，而 === 下面的部分表示待 merge 分支 bee 的内容。
```

我们可以直接对产生冲突的文件进行修改。在 vscode 中，提供了默认的插件，可以方便地进行分支合并：

![](../img/conflict.png)

根据需要点击选项，留下需要的内容，然后再进行一次 commit：

```
$ git add README.md && git commit -m "merge new and bee"
[new 0c8d026] merge new and bee

#                master                 HEAD(new)
#                  |                       |
#      +----->-----+----->-----+----->-----+
#                  \----->-----+----->-----/
#                              |
#                             bee
#
# 
# 将 bee 合并到 new 后，创建了一次新的 commit，并将
# HEAD 指针移动到该 commit。
```

合并 new 分支到 master：

```
$ git checkout master && git merge new
Updating 0493f9d..0c8d026
Fast-forward
 README.md | 2 ++
 1 file changed, 2 insertions(+)

#                             HEAD(master) new
#                                         \|
#      +----->-----+----->-----+----->-----+
#                  \----->-----+----->-----/
#                              |
#                             bee
#
# 由于 new 是从 master 上发展过来的，因此 merge
# 操作仅仅是将 master 指针移动到了 new。
```

合并的规律：

+ 如果两次 commit 代表的结点有连通的路径，则合并时仅改变指针
+ 如果没有，则会创建一个新的结点，并可能产生冲突
