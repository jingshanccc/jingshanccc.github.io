---
title: Java开发环境搭建（闲时更新）
categories:
- 笔记
image: 'https://gitee.com/jingshanccc/image/raw/master/image/20200803104632.jpg'
abbrlink: 27c7c088
---
<p/>

<!-- more -->

## 前言

{% note info %}
本文主要用于个人记录开发环境的搭建，便于环境迁移时的重建工作，文中提及相关文件可在[曲奇云盘](https://quqi.com/)中获取
{% endnote %}
## Java
1. Windows
   运行jdk-8u181-windows-x64.exe以安装JDK
2. Linux
   解压`tar -zxvf jdk-xxx.tar.gz `，配置环境变量

## Maven
解压apache-maven-3.6.3-bin.zip，配置环境变量
## Git
1. 安装Git-2.27.0-64-bit.exe
2. 配置ssh key
```bash
#配置身份信息
git config --global user.name "xx"
git config --global user.email "xx@xx.com"
#生成密钥
ssh-keygen -t rsa -C "xx@xx.com"
```
进入.ssh文件夹下复制公钥id_rsa_pub文本内容，在` Github->settings->ssh and gpg keys->new ssh key `
```bash
# 测试是否配置成功
ssh -T git@github.com
```
多用户Git配置请参考{% post_link 本地配置Git多账户 %}

## Mysql
1. 解压mysql-8.0.20-winx64.zip，进入bin目录
2. 创建my.ini
   ```bash
   [mysqld]
    # 设置3306端口
    port=3306
    # 设置mysql的安装目录
    basedir=C:\\Program Files\\mysql-8.0.20
    # 设置mysql数据库的数据的存放目录
    datadir=C:\\Program Files\\mysql-8.0.20\\Data
    # 允许最大连接数
    max_connections=200
    # 允许连接失败的次数。
    max_connect_errors=10
    # 服务端使用的字符集默认为utf8mb4
    character-set-server=utf8mb4
    # 创建新表时将使用的默认存储引擎
    default-storage-engine=INNODB
    # 默认使用“mysql_native_password”插件认证
    #mysql_native_password
    default_authentication_plugin=mysql_native_password
    [mysql]
    # 设置mysql客户端默认字符集
    default-character-set=utf8mb4
    [client]
    # 设置mysql客户端连接服务端时默认使用的端口
    port=3306
    default-character-set=utf8mb4
   ```
3. 初始化Mysql
   在命令行窗口进入bin目录，执行` mysqld --initialize --console `，记录随机生成的密码
4. 安装并启动
   ```bash
   mysql --install
   # 启动服务
   net start mysql
   ```
5. 设置密码
   `mysql -u root -p`输入密码进入mysql控制台，通过`set password = password('xxx');`修改默认密码
6. 忘记默认密码？
   ```bash
    # 关闭服务 
    net stop mysql
    # 跳过验证
    mysqld --console --skip-grant-tables --shared-memory 
    # 新开一个cmd窗口，启动mysql服务，使用空密码进入 
    mysql -u root -p
    # 使用mysql数据表
    use mysql;
    update user set authentication_string='' where user='root';（将密码置为空）
    quit;

    # 关闭第二步的cmd窗口，新开一个cmd窗口，先关闭服务，重新打开。
    mysql -u -root -p进入，此时使用空密码进入
    # 修改密码即可
    ALTER USER 'root'@'localhost' IDENTIFIED BY '新密码';
   ```

## NPM
1. nvm：用于npm版本控制，运行nvm-setup.exe
2. 设置nvm镜像：
```bash
nvm npm_mirror https://npm.taobao.org/mirrors/npm/
nvm node_mirror https://npm.taobao.org/mirrors/node/
```
3. 安装指定版本nodejs
```bash   
nvm install x.x.x
```
4. 设置npm镜像
```bash   
npm config set registry https://registry.npm.taobao.org
```
5. 使用cnpm
```bash
npm install -g cnpm
```

## 博客迁移
有以下三种方法
1. [Cloud Studio](https://realmicah.cloudstudio.net/dashboard/workspace)线上开发
2. 从[Coding仓库](https://realmicah.coding.net/)克隆到本地后安装hexo和其他依赖即可
3. 复制scaffolds、source、themes、_config.yml、package.json，在新文件夹下安装hexo和其他依赖
   
## 虚拟机相关
### Vmware
1. 解压vmware-pro15.zip，安装
2. 使用镜像CentOS-7-x86_64-Minimal-1908.iso，创建虚拟机
   
### 远程连接工具
访问[XShell官网](https://www.netsarang.com/zh/xshell/)，获取家庭/学校版，填写邮箱和名字，收到邮件下载即可
