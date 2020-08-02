---
title: 本地配置Git多账户
tags: git
categories:
  - 开发环境相关
image: 'https://gitee.com/jingshanccc/image/raw/master/image/20200722002951.png'
abbrlink: 372eebb7
---

<p>

<!-- more -->

## 1. 生成公钥和私钥

{% note info %}

在命令行窗口或`git bash`下输入命令，默认生成路径为当前路径，建议在系统`.ssh`文件夹（默认是`C:\Users\Administrator\.ssh`）下使用命令行或`git bash`

{% endnote %}

```bash
ssh-keygen -t rsa -C "a@email.com"
```

![图片](https://gitee.com/jingshanccc/image/raw/master/image/20200722003007.png)

1. 进行多用户配置时需要针对不同的账号设置不同的文件名，比如`id_rsa_a`和`id_rsa_b`

## 2. 配置ssh-agent

{% note info %}

`ssh-agent`即ssh代理，管理着本地的所有密钥。当我们进行多用户配置时，需要将多个不同的密钥添加到ssh代理中。启动ssh-agent可能报错，需要用管理员权限打开PowerSheel，执行`Set-Service -Name ssh-agent -StartupType automatic`

{% endnote %}

```csharp
ssh-agent bash
ssh-add id_rsa_a
```

## 3. 添加公钥到Github账户

路径为`settings->SSH and GPG keys->New SSH key`[](https://github.com/settings/keys)，将`.ssh`文件夹下的`id_rsa.pub`文件内容粘贴到文本框中，完成添加

## 4. config文件配置

```bash
//如果不存在，则创建config文件
touch config
```

1. 配置config文件内容

```bash
#该文件用于配置私钥对应的服务器
#account1(email)
 Host git@github.com
 HostName https://github.com
 User a //这里填写username
 IdentityFile id_rsa_a

#account2(email)
 Host git@gitlab.com
 HostName https://gitlab.com
 User b//这里填写username
 IdentityFile id_rsa_b
```

## 5. 测试是否可用

```bash
ssh -T git@github.com

//if success will return
//Hi a! You've successfully authenticated, but GitHub does not provide shell access.
//else return 
//some errors
```

## 6. 切换账号

1. 在`.ssh`文件夹下，创建脚本文件用于切换账号，避免每次都手写切换代码

   ```bash
   //创建切换到a账户脚本
   touch changeToA.sh
   //填入内容
   git config --global user.name "a"
   git config --global user.email  "a@email.com"
   ```

2. 执行脚本以切换账号

   ```bash
   ./changeToA.sh
   ```