---
title: Netty面试问题
tags:
  - Netty
  - Java后端面试
categories:
  - Java后端面试
image: 'https://realmicah.xyz/img/'
abbrlink: ca79e873
---

<p>

<!-- more -->

## Netty是什么？

Netty是一个基于NIO的Client-Server（客户端服务器）框架，简化并优化了TCP和UDP套接字服务器等网络编程，并且性能以及安全性等很多方面甚至都要更好，支持多种协议，如FTP、SMTP、HTTP以及各种二进制和基于文本的传统协议，使用它可以快速简单地开发网络应用程序。

## 为什么要使用Netty？

1. 统一的API，支持多种传输类型，阻塞和非阻塞的
2. 简单而强大的线程模型
3. 自带编解码器解决TCP粘包/拆包问题
4. 真正的无连接数据包套接字支持
5. 支持多种协议FTP、SMTP、HTTP
6. 比JDK自带的NIO相关API更加易用、更高的吞吐量、更低的延迟、更少的内存复制
7. 有完整的SSL/TLS支持，具有良好的安全性

## Netty应用场景了解么？

1. 作为RPC框架的网络通信工具：在Dubbo的RPC调用中，服务消费者使用NettyClient，服务提供者使用NettyServer，当发生服务调用时，将数据通过Dubbo协议编码发送到Server，Server进行解码并完成方法调用，返回数据。
2. 实现简单的HTTP服务器：在NettyServer的Handler中获取Uri并组装HttpResponse返回。
3. 实现即时通讯系统。

## Netty核心组件有哪些？分别有什么作用？

### Channel

Channel接口是Netty对网络操作的抽象，它包括基本的I/O操作，如` bind()`、`connect()`、`read()`、`write()`等。

#### 实现类

1. `NioServerSocketChannel`：对应Java BIO中的ServerSocket
2. `NioSocketChannel`：对应Java BIO中的Socket

### EventLoop

> `EventLoop`定义了Netty的核心抽象，用于处理连接的生命周期中所发生的事件。

- 作用：负责监听网络事件并调用事件处理器进行相关的I/O操作。
- `EventLoop`负责处理，`Channel`负责读写，`Channel`注册在`EventLoop`上。

### ChannelFuture

Netty是异步非阻塞的，无法立刻得到操作的执行结果（异步），可以通过`ChannelFuture`接口的`addListener()`方法可以注册一个`ChannelFutureListener`，监听结果。

#### 其他方法

- `channel()`：获取关联的Channel
- `sync()`：让异步操作变为同步

### ChannelHandler和ChannelPipeline

ChannelHandler是消息的具体处理器，ChannelPipeline的`addLast()`用来添加一个或多个ChannelHandler，形成一条处理数据的链，一个数据从第一个Handler处理完之后传递到下一个Handler。

### EventGroup

在Netty中，通常由Boss EventLoopGroup接受连接，Worker EventLoopGroup处理连接事件。一个EventGroup是一个线程组，其中包含多个EventLoop，一个EventLoop有一个线程。

### Bootstrap和ServerBootstrap

Bootstrap是客户端的启动引导类，ServerBootstrap是服务器的启动引导类。

#### 使用

- Bootstrap通过`connect()`方法连接到服务端的主机和端口，作为TCP通信的客户端，或者使用`bind()`方法绑定本地端口，作为UDP通信的一端。通常只需要配置一个EventLoopGroup。

- SreverBootstrap使用`bind()`方法绑定一个本地端口，等待客户端连接。配置两个线程组-BOSS和WORKER用于接收和处理连接事件。

## Netty线程模型

基于Reactor模式开发，Reactor是事件驱动模型，采用多路复用将事件分发给相应的事件处理器Handler处理。在Netty中主要通过NioEventLoopGroup线程组来实现具体的线程模型。

1. 单线程模型

   一个线程负责接受客户端连接并处理事件，包括`accept|read|decode|process|encode|send`。

   ```java
   //指定线程数为1，不指定时为CPU核心数*2
   EventLoopGroup eventGroup = new NioEventLoopGroup(1); 
   //服务器启动引导类
   ServerBootstrap serverBootstrap = new ServerBootstrap();
   serverBootstrap.group(eventGroup, eventGroup);//指定处理的线程组
   ```

   

2. 多线程模型

   一个acceptor线程负责监听客户端连接，一个NIO线程组负责处理`accept|read|decode|process|encode|send`事件。

   ```java
   EventLoopGroup acceptor = new NioEventLoopGroup(1);
   EventLoopGroup workerGroup = new NioEventLoopGroup();
   ServerBootstrap serverBootstrap = new ServerBootstrap();
   serverBootstrap.group(acceptor, workerGroup);
   ```

   

3. 主从多线程模型

   从主线程池中选择一个线程作为acceptor线程监听端口，接收客户端连接，其他线程负责后续的接入认证等工作。连接建立后，由从线程池负责具体处理I/O读写。

   ```java
   EventLoopGroup masterGroup = new NioEventLoopGroup();
   EventLoopGroup subGroup = new NioEventLoopGroup();
   ServerBootstrap serverBootstrap = new ServerBootstrap();
   serverBootstrap.group(masterGroup, subGroup);
   ```

   