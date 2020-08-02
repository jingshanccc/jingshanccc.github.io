---
title: Java异常体系
tags:
  - Java
categories:
  - 笔记
image: 'https://gitee.com/jingshanccc/image/raw/master/image/20200722004813.png'
abbrlink: f885a170
---

<p></p>

<!-- more -->

## Java的异常体系

Java中的异常都是Throwable的子类，分为Error和Exception，Error用来表示JVM无法处理的错误，Exception分为受检异常和不受检异常，又叫编译期异常和运行时异常，其区别是编译期异常如果不处理会编译失败，运行时异常可以通过编译。

运行时异常时RuntimeException及其所有子类，除此之外都是编译期异常。其体系结构如下图：

![图片](https://gitee.com/jingshanccc/image/raw/master/image/20200722004826.png)

Error下有OutOfMemoryError和StackOverflowError，Exception下有RuntimeException和IOException。常见的Runtime有NumberFormatException，ClassNotFoundException，ClassCastException，CloneNotSpportException，IndexOutOfBoundException，常见的IOException有FileNotFoundException，FileExistsException，EncodeException，DecodeException，SocketException等。

## 异常的处理

### try catch finally

1. 逻辑：如果有finally，执行完try会执行finally，如果有finally有return或者让程序结束的语句，则直接结束，否则会回到try中执行。

2. 字节码：先是try中的翻译成机器指令(比如4-8条)，然后是finally块的指令(比如9-10条)，然后是return(11条)。接下来的字节码是catch中的指令(12-14)，然后是final的指令(15-16跟第一个finally一样的)，最后是goto指令(17)。每个catch有这么一段，goto指令都指向最后一句return(38)。最后还会有未被catch的其他异常，字节码结构为astore存储异常(33)，finally的指令(34-35)，aload取出异常，然后是抛出异常的athrow指令，最后一句是return(38条).也就是所有catch之后goto的位置。接下来是异常表Exception Table决定在抛异常后跳转到的位置，格式如下：

   | from指令开始行 | to指令最后行 | target跳转到目标指令行号 |   type异常类型    |                             说明                             |
   | :------------: | :----------: | :----------------------: | :---------------: | :----------------------------------------------------------: |
   |       4        |      8       |            12            | Exception1--异常1 |                 在try中抛出了异常Exception1                  |
   |       4        |      8       |            18            | Exception2--异常2 |                 在try中抛出了异常Exception2                  |
   |       4        |      8       |            33            |   any--其他异常   |                 在try中抛出了未被catch的异常                 |
   |       12       |      17      |            33            |   any--其他异常   |               在处理Exception1时抛出了其他异常               |
   |       18       |      23      |            33            |   any--其他异常   |               在处理Exception2时抛出了其他异常               |
   |       33       |      37      |            33            |   any--其他异常   | 在处理其他异常的时候抛出了异常，准确来说是处理其他异常时finally抛出的异常 |

### throw和throws

1. throw：用在方法体内，抛出异常，在运行时是一定会抛出的，由上层调用者处理抛出的异常
2. throws：用在方法声明中，表示在运行时可能抛出异常，由上层调用者处理