# Git

#### 本地操作

- git init 初始化
- git add [filename] 将文件添加到暂存区
  - git rm [filename] 删除文件
  - git mv [filename] 重命名
- git commit -m [msg] 提交并附带说明



#### 查看情况

- git status 查看当前工作区状态
- git show 显示信息
- git log 查看提交历史



#### 分支操作

- git branch [name] 创建分支
  - 不加参数表示显示所有分支
  - Git branch -d [name] 删除分支
- git checkout [name] 切换分支
- git checkout -b [name] 创建并切换分支
- git merge [name] 合并分支



#### 远程仓库

- git clone [url] 克隆远程仓库
- git remote add [shortname] [url] 添加远程仓库
- git fetch [remotename] 从远程仓库获取更改
- git pull 拉取远程仓库并合并（fetch + merge）
- git push [remotename] [branchname] 合并到远程仓库的指定分支
  - git push -u origin master 手动设置

