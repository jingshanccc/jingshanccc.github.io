---
title: Spring Cloud入门
tags:
  - Spring Cloud
categories:
  - Spring Cloud
image: 'https://gitee.com/jingshanccc/image/raw/master/image/20200726173938.png'
abbrlink: a49c4b2e
date: '2020-07-23 22:14'
---

<p/>

<!-- more -->

## 前言

在入门Spring Cloud框架时写了这篇文章，记录一下学习过程，也当是给和我一样的初学者的入门避坑。本文将通过学习相关的组件概念，并进行代码实战，从零开始搭建一个基础的Spring Cloud项目。

### 环境

1. IDEA 2020.1
2. Maven 3.5.4
3. Spring Cloud Hoxton.SR6
4. Spring Boot 2.3.2
5. [项目仓库地址](https://github.com/jingshanccc/spring-cloud)

在IDEA中创建一个空的Maven项目，删除src目录，pom文件中修改打包方式为pom，表示项目为聚合/多模块项目。

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.chan</groupId>
    <artifactId>spring-cloud</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>pom</packaging>

</project>
```



### Spring Cloud版本号介绍

![image-20200726131044766](https://gitee.com/jingshanccc/image/raw/master/image/20200726131044.png)

可以看到Spring Cloud的版本号不是常规的1.0.1这样的数字形式，原因是Spring Cloud是由众多独立的子项目组成的，子项目有自己的开发节奏，版本发行时间，为了避免冲突，因此采用伦敦地铁站来命名，按字母顺序对应发行顺序，像最开始的Angel到上图中最新的Hoxton。后面的GA、SNAPSHOT、SR对应意义如下表：

|       版本号        |    版本    | 用途                                                         |
| :-----------------: | :--------: | :----------------------------------------------------------- |
| SNAPSHOT(BUILD-XXX) |   开发版   | 一般是开发团队内部使用                                       |
|         GA          |   稳定版   | 内部开发到一定阶段，没有大问题，但可能存在比较多的小bug，可以对外发布 |
|     PRE(M1,M2)      |  里程碑版  | 相较于GA版，修复了大部分的bug，成为milestone版。一个GA后一般有多个里程碑版M1,M2等 |
|         RC          | 候选发布版 | 在里程碑版之后，系统已经趋于稳定，进入等待发布阶段（Release Candidate），这个阶段主要修复新发现的等级较高的bug，发布RC1,RC2版 |
|         SR          | 正式发布版 | 正式发布，后续会进行优化或修复bug，发布SR1,SR2版本           |

上图中还出现了2020.0这样的版本号，这是在2020年新采用的命名方式，格式是` YYYY.MINOR.MICRO` ，其中`YYYY`是发行年份，`MINOR`是一年中的从零开始递增的数字，`MICOR`对应以前是用的后缀，.0通常表示RELEASE，例如.0-M2，0-RC2等。火车站将会作为代号，但不会再用于发布到Maven仓库的版本，2020的代号是IIford。

### 分布式、集群、微服务

1. 分布式：将一个系统的不同模块部署在不同的服务器上，提高并发能力。
2. 集群：将一个模块部署到不同的服务器上，构成集群向外提供相同的服务，提高可用性。
3. 微服务：将传统的系统按照功能或业务，拆分成相互独立的模块，每个模块对外提供自己的服务。

## 服务治理

### 简介

在微服务架构下，各服务之间需要相互通信、感知服务状态、调用其他服务，这些就通过服务注册中心来完成。顾名思义，它提供了服务注册功能，系统中所有的服务都需要注册到注册中心，并通过注册中心，获得所有可用的服务，调用指定服务名的服务。服务治理体系中有三种核心角色：服务注册中心（Eureka-Server）、服务提供者（Eureka-Client）、服务消费者（Eureka-Client）

### 搭建服务注册中心

在之前创建的Maven项目中通过`new -> module `新建一个子模块，使用Spring Initializr创建一个Spring Boot项目，添加eureka-server依赖。

![image-20200726125158684](https://gitee.com/jingshanccc/image/raw/master/image/20200726125205.png)

等待maven依赖下载完成后，将eureka-server的部分依赖剪切到父项目的pom文件中，因为作为多模块项目，项目的依赖应当在父项目中统一管理。

同时在父项目中添加modules节点，填入eureka-server模块，在eureka-server中添加parent节点，填入父项目信息。最终两个文件如下所示

{% fold 父模块pom %}

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.3.2.RELEASE</version>
        <relativePath/> <!-- lookup parent from repository -->
    </parent>
    <groupId>com.chan</groupId>
    <artifactId>spring-cloud</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <name>spring-cloud</name>
    <description>Demo project for Spring Cloud</description>
    <packaging>pom</packaging>

    <modules>
        <module>eureka-server</module>
    </modules>

    <properties>
        <java.version>1.8</java.version>
        <spring-cloud.version>Hoxton.SR6</spring-cloud.version>
    </properties>

    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-dependencies</artifactId>
                <version>${spring-cloud.version}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
        </dependencies>
    </dependencyManagement>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
</project>
```

{% endfold %}

{% fold 子模块pom %}

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <artifactId>spring-cloud</artifactId>
        <groupId>com.chan</groupId>
        <version>0.0.1-SNAPSHOT</version>
    </parent>
    <artifactId>eureka-server</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <name>eureka-server</name>
    <description>Spring Cloud Eureka-Server</description>

    <dependencies>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-eureka-server</artifactId>
        </dependency>
    </dependencies>

</project>

```

{% endfold %}

### 注册中心配置

如果想要看详细全面的配置介绍，可以看本文附录[注册中心配置项详解](#注册中心配置项详解)

#### 单机

```yaml
server:
  port: 7001
eureka:
  instance:
    hostname: eureka7001.com
  client:
    fetch-registry: false #单节点不向自己注册
    register-with-eureka: false
    service-url:
      defaultZone: http://${eureka.instance.hostname}:${server.port}/eureka/ #单节点

#此服务名称
spring:
  application:
    name: eurka-server
```

#### 集群

```yaml
server:
  port: 7002
eureka:
  instance:
    hostname: eureka7002.com
  client:
    service-url:
        defaultZone: http://eureka7001.com:7001/eureka/,http://eureka7003.com:7003/eureka/

#此服务名称
spring:
  application:
    name: eurka-server
```

#### 启动类

在启动类添加注解

```java
package com.chan.springcloud;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.server.EnableEurekaServer;

@SpringBootApplication
@EnableEurekaServer
public class EurekaServerApplication {

    public static void main(String[] args) {
        SpringApplication.run(EurekaServerApplication.class, args);
    }

}
```

经过上述的操作，就搭建起了spring-cloud的注册中心，可以启动应用，访问对应端口，即可看到此时的注册中心上的所有服务。

![image-20200726132742403](https://gitee.com/jingshanccc/image/raw/master/image/20200726132742.png)

### 服务提供者/消费者

通过`new->module`创建新的子模块eureka-client，加入依赖

![image-20200726134547466](https://gitee.com/jingshanccc/image/raw/master/image/20200726134547.png)

之后修改pom文件并yml文件中添加配置，在启动类添加注解@EnableDiscoveryClient

{% fold pom文件 %}

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <artifactId>spring-cloud</artifactId>
        <groupId>com.chan</groupId>
        <version>0.0.1-SNAPSHOT</version>
    </parent>
    <artifactId>eureka-client</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <name>eureka-client</name>
    <description>Spring Cloud Eureka Client</description>

    <dependencies>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
    </dependencies>

</project>
```

{% endfold %}

{% fold yml文件 %}

```yaml
server:
  port: 9003
spring:
  application:
    name: eureka-client
eureka:
  client:
    service-url:
       defaultZone: http://eureka7001.com:7001/eureka/ #单节点
#      defaultZone: http://eureka7001.com:7001/eureka/,http://eureka7002.com:7002/eureka/,http://eureka7003.com:7003/eureka/
  instance:
    instance-id: eureka-client #服务名
    prefer-ip-address: true #使用自己的ip地址注册而不是主机名
```

{% endfold %}

{% fold 启动类 %}

```java
package com.chan.springcloud;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

@SpringBootApplication
@EnableDiscoveryClient
public class EurekaClientApplication {

    public static void main(String[] args) {
        SpringApplication.run(EurekaClientApplication.class, args);
    }

}
```

{% endfold %}

完成上述操作后，可在eureka-server的监控页面中看到eureka-client服务实例，可按照上述步骤，创建两个新的模块服务提供者service-provider、服务消费者service-consumer用于接下来的学习。

## Ribbon客户端负载均衡

### 简介

Ribbon是一套客户端负载均衡工具，提供客户端的负载均衡算法，在配置文件列出的同一服务的所有实例根据规则选择一个实例使用。

### 核心组件

1. 负载均衡策略IRule：可选的有随机选择RandomRule、轮询RoundRibbonRule、RetryRule，响应时间加权WeightedResponseTimeRule。也可以通过继承AbstractLoadBalancerRule实现自定义的负载均衡策略，将其配置到Ribbon中
2. 负载均衡器ILoadBalancer：接口实现类维护了两个list，分别是`upServerList`、`allServerList`，提供了初始化添加服务、获取所有服务、可用服务维护这两个列表，通过IRule实现chooseServer方法根据负载均衡策略选择一个服务实例

### 服务消费者整合Ribbon

#### 引入依赖

```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-ribbon</artifactId>
</dependency>
```

#### 引入RestTemplate

```java
@Bean
@LoadBalanced
public RestTemplate restTemplate(){
    return new RestTemplate();
}
```

#### 使用RestTemplate调用服务

```java
@RestController
public class RibbonController {
    private final static String PREFIX = "http://provider/"; //provider是服务名

    @Autowired
    private RestTemplate template;

    @GetMapping("/hello")
    public String hello(){
        return template.getForObject(PREFIX+"hello",String.class, (Object) null);
    }
}
```

{% note success %}

未在博客出现的代码可到[项目仓库](https://github.com/jingshanccc/spring-cloud)获取

{% endnote %}

## Hystrix服务容错

### 简介

Hystrix是一套服务容错机制，提供服务降级、服务熔断、服务限流、请求缓存/合并等功能，避免因为系统部分服务不可用导致整个系统宕机无法对外提供服务，同时提高性能。

### 核心组件

1. HystrixCommand/HystrixObservableCommand：配置fallback备用逻辑
2. HystrixCricuitBreaker：提供了isOpen()判断断路器是否打开、allowRequest()判断每个Hystrix命令的请求是否允许被执行、markSuccess()用于关闭断路器

### 服务消费者集成Hystrix

#### 引入依赖

```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-hystrix</artifactId>
</dependency>
```

#### 启动类添加@EnableCircuitBreaker注解开启断路器

#### 调用服务时

通过@HystrixCommand指定fallback逻辑，当服务超时、不可用时，将通过fallback方法返回响应。

```java
@RestController
public class RibbonController {
    private final static String PREFIX = "http://provider/"; //服务名

    @Autowired
    private RestTemplate template;

    @GetMapping("/hello")
    @HystrixCommand(fallbackMethod = "hystrixFallback")
    public String hello(){
        return template.getForObject(PREFIX+"hello",String.class,(Object)null);
    }

    public String hystrixFallback(){
        return "hystrix fallback hello";
    }

}
```

{% note info %}

关于Hystrix的配置和注解项，由于篇幅过长，可在本文附录查看[Hystrix注解和配置详解](#Hystrix注解和配置详解)

{% endnote %}

## Feign

### 简介

在微服务中，服务容错和负载均衡几乎是必备的功能，因此产生了Feign。Feign是一套整合了Hystrix和Ribbon，并通过声明式进行服务调用的组件。

### 使用

- 创建一个新的服务消费者，并引入Feign依赖

  {% fold pom文件 %}

  ```xml
  <?xml version="1.0" encoding="UTF-8"?>
  <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
      <modelVersion>4.0.0</modelVersion>
      <parent>
          <artifactId>spring-cloud</artifactId>
          <groupId>com.chan</groupId>
          <version>0.0.1-SNAPSHOT</version>
      </parent>
      <groupId>com.chan.springcloud</groupId>
      <artifactId>consumer-feign</artifactId>
      <version>0.0.1-SNAPSHOT</version>
      <name>consumer-feign</name>
      <description>Spring Cloud Consumer Feign</description>
  
      <dependencies>
          <dependency>
              <groupId>org.springframework.cloud</groupId>
              <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
          </dependency>
          <dependency>
              <groupId>org.springframework.cloud</groupId>
              <artifactId>spring-cloud-starter-openfeign</artifactId>
          </dependency>
  
          <dependency>
              <groupId>org.springframework.boot</groupId>
              <artifactId>spring-boot-starter-web</artifactId>
          </dependency>
      </dependencies>
  
  
  </project>
  
  ```

  {% endfold %}

- yml文件以及启动类：可配置hystrix熔断超时时间，在启动类添加@EnableFeignClients开启Feign

- @FiegnClient：在服务调用接口service中，通过@FeignClient注解指定调用的服务以及失败回退策略

  ```java
  @FeignClient(value = "provider", fallbackFactory = ClientFallbackFactory.class)
  public interface ClientService {
  
      @GetMapping("/hello")
      String hello();
  
  }
  ```

  

- Controller调用服务：注入service，调用接口方法。

### 配置详解

#### 公用配置feign.httpclient

| 配置项                   | 说明                           |
| ------------------------ | ------------------------------ |
| connection-timeout       | 连接超时时间，单位ms，默认2s   |
| max-connections          | 最大连接数，默认200            |
| max-connection-per-route | 每个路由最大连接数，默认50     |
| disabled-ssl-validtion   | 是否关闭ssl连接验证，默认false |
| follow-redirect          | 是否支持重定向，默认true       |
| time-to-live             | 连接存活时间                   |

#### 为某个服务接口定制配置

通过feign.client.xxx：指定service名定制配置

## 配置中心Config

### 简介

存放各服务配置文件的配置中心，方便服务配置的集中管理和动态刷新，并起到分环境、分配置、通过加解密增强安全性的作用。有配置中心config-server和配置使用者config-client两种角色

在整合了配置中心后，应用在运行时会通过配置的远程配置中心地址和文件名，加载指定的配置。

### 配置中心搭建

- 新建一个项目，引入配置中心依赖，修改pom文件

  ![image-20200726155947916](https://gitee.com/jingshanccc/image/raw/master/image/20200726155948.png)

  {% fold 展开 %}

  ```xml
  <?xml version="1.0" encoding="UTF-8"?>
  <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
      <modelVersion>4.0.0</modelVersion>
      <parent>
          <artifactId>spring-cloud</artifactId>
          <groupId>com.chan</groupId>
          <version>0.0.1-SNAPSHOT</version>
      </parent>
      <groupId>com.chan.springcloud</groupId>
      <artifactId>config-server</artifactId>
      <version>0.0.1-SNAPSHOT</version>
      <name>config-server</name>
      <description>Spring Cloud Config Server</description>
  
      <dependencies>
          <dependency>
              <groupId>org.springframework.cloud</groupId>
              <artifactId>spring-cloud-config-server</artifactId>
          </dependency>
          <dependency>
              <groupId>org.springframework.cloud</groupId>
              <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
          </dependency>
  
      </dependencies>
  </project>
  
  ```

  

  {% endfold %}

- yml文件配置远程配置中心地址

  {% fold 展开 %}

  ```yaml
  server:
    port: 4001
  spring:
    application:
      name: config-server
    cloud:
      config:
        server:
          git:
            uri:
            username:
            password:
            basedir: ./repo-config/ #缓存到本地的路径 执行的是new File("./repo-config/")操作
  eureka:
    client:
      service-url:
         defaultZone: http://eureka7001.com:7001/eureka/ #单节点
  #      defaultZone: http://eureka7001.com:7001/eureka/,http://eureka7002.com:7002/eureka/,http://eureka7003.com:7003/eureka/
    instance:
      instance-id: config-server #服务名
      prefer-ip-address: true #使用自己的ip地址注册而不是主机名
  ```

  

  {% endfold %}

- 启动类增加@Enable开启配置中心

### 客户端整合配置中心

在需要使用远程配置的客户端（消费者/提供者）整合配置中心。

1. pom文件引入spring-cloud-starter-config依赖

2. 将**application.yml**改为**bootstrap.yml**配置文件，在其中加入远程配置中心的相关配置

   {% fold 展开 %}

   ```yaml
   spring:
     cloud:
       config:
         name: provider
         profile: dev
         uri: http://localhost:4001
         discovery:
           enabled: true
           service-id: config-server
   
   eureka:
     client:
       service-url:
         defaultZone: http://eureka7001.com:7001/eureka/
         instance:
           instance-id: service-provider #服务名
           prefer-ip-address: true #ip地址
   ```

   

   {% endfold %}

在服务启动后，可以在日志看到服务从远程配置中心获取指定的配置文件

![image-20200726165017386](https://gitee.com/jingshanccc/image/raw/master/image/20200726165017.png)

### 配置详解

#### config-server配置

前缀为spring.cloud.config.server

|    配置项    |          说明          |
| :----------: | :--------------------: |
|     git      | 使用git仓库，默认方式  |
|   git.uri    |        仓库地址        |
| git.username |         用户名         |
| git.password |          密码          |
| git.basedir  | 下载到本地的缓存文件夹 |

#### config-client配置

前缀为spring.cloud.config

|        配置项        |                        说明                         |
| :------------------: | :-------------------------------------------------: |
|  discovery.enabled   |          是否从配置中心获取配置，默认false          |
| discovery.service-id |                   配置中心服务名                    |
|         uri          |                config-server服务地址                |
|         name         | 配置文件名，application-dev.yml则name为appplication |
|       profile        |                         dev                         |

## 消息总线Bus

### 简介

顾名思义，消息总线用来连接分布式节点，广播消息。Spring Cloud目前支持Kafka和RabbitMq两种消息队列中间件。

接下来以分布式配置的动态刷新来在项目中使用消息中线Bus

### 使用

在config-server和config-client上搭建

#### RabbitMq

1. pom文件引入基于RabbitMq的bus依赖spring-cloud-starter-bus-amqp，同时需要spring-boot-starter-actuator依赖

2. yml文件增加RabbitMq相关配置，并向外暴露/bus-refresh接口用于触发更新

   {% fold 展开 %}

   ```yaml
   server:
     port: 4001
   spring:
     application:
       name: config-server
     cloud:
       config:
         server:
           git:
             uri:
             username:
             password:
             basedir: ./repo-config/ #缓存到本地的路径 执行的是new File("./repo-config/")操作
       bus:
         trace:
           enabled: true
     rabbitmq:
       addresses: 192.168.10.130:5672
       username: guest
       password: guest
   eureka:
     client:
       service-url:
          defaultZone: http://eureka7001.com:7001/eureka/ #单节点
   #      defaultZone: http://eureka7001.com:7001/eureka/,http://eureka7002.com:7002/eureka/,http://eureka7003.com:7003/eureka/
     instance:
       instance-id: config-server #服务名
       prefer-ip-address: true #使用自己的ip地址注册而不是主机名
   management:
     endpoints:
       web:
         exposure:
           include: bus-refresh
   ```

   

   {% endfold %}

#### Kafka

1. pom文件引入基于Kafka的bus依赖spring-cloud-starter-bus-kafka，同时需要spring-boot-starter-actuator依赖

2. yml文件增加Kafka相关配置，并向外暴露/bus-refresh接口用于触发更新

   {% fold 展开 %}

   ```yaml
   server:
     port: 4001
   spring:
     application:
       name: config-server
     cloud:
       config:
         server:
           git:
             uri:
             username:
             password:
             basedir: ./repo-config/ #缓存到本地的路径 执行的是new File("./repo-config/")操作
       bus:
         trace:
           enabled: true
       stream:
         kafka:
           binder:
             brokers: 192.168.10.130:9092
   eureka:
     client:
       service-url:
          defaultZone: http://eureka7001.com:7001/eureka/ #单节点
   #      defaultZone: http://eureka7001.com:7001/eureka/,http://eureka7002.com:7002/eureka/,http://eureka7003.com:7003/eureka/
     instance:
       instance-id: config-server #服务名
       prefer-ip-address: true #使用自己的ip地址注册而不是主机名
   management:
     endpoints:
       web:
         exposure:
           include: bus-refresh
   ```

   

   {% endfold %}

配置完成后，通过访问config-server的/bus-refresh接口，触发服务的配置更新，可以在控制台查看对应的日志输出。也可以通过/bus/refresh?destination=xxx:port指定实例更新

## Zuul网关

### 简介

对外暴露的API，面向用户，系统UI端所有请求都需要经过网关，因此，可在网关通过拦截过滤，实现认证鉴权、动态路由、负载均衡、静态资源统一处理等功能，从而减少代码冗余，提高系统性能

### 使用

- 创建一个新模块gateway，引入spring-cloud-starter-netflix-zuul依赖

- yml文件中，通过zuul.routes配置代理的服务路径、公共前缀等

  {% fold yml文件 %}

  ```yaml
  server:
    port: 5001
  spring:
    application:
      name: gateway
  eureka:
    client:
      service-url:
         defaultZone: http://eureka7001.com:7001/eureka/ #单节点
  #      defaultZone: http://eureka7001.com:7001/eureka/,http://eureka7002.com:7002/eureka/,http://eureka7003.com:7003/eureka/
    instance:
      instance-id: gateway-zuul #服务名
      prefer-ip-address: true #使用自己的ip地址注册而不是主机名
  zuul:
    routes:
      ribbon:
        path: /api-ribbon/**  #代理名称
        serviceId: service-consumer  #代理的服务
      feign:
        path: /api-feign/**
        serviceId: consumer-feign
  #      prefix: /api  #公共前缀
  ```

  

  {% endfold %}

- 启动类增加@EnableZuulProxy注解开启网关

之后可以通过localhost:5001/api-ribbon/hello调用服务提供者provider的hello接口，且由于是通过ribbon调用，因此具有负载均衡功能。

### 核心组件Filter

通过继承ZuulFilter实现自定义的校验逻辑，实现认证鉴权、动态路由等功能。filter提供了4个方法

1. filterType()：过滤时机，pre：路由之前、routing：路由时、error：发生错误、post：在routing和error之后
2. filterOrder()：过滤器优先级
3. shouldFilter()：是否开启
4. run()：校验逻辑

{% fold 查看实例代码 %}

```java
@Component
public class MyFilter extends ZuulFilter {
    @Override
    public String filterType() {
        return "pre";
    }

    @Override
    public int filterOrder() {
        return 0;
    }

    @Override
    public boolean shouldFilter() {
        return true;
    }

    @Override
    public Object run() throws ZuulException {
        System.out.println("filtered by my filter");
        return null;
    }
}
```

{% endfold %}

### 配置详解

#### 代理服务配置zuul.routes

|   配置项   |     说明      |
| :--------: | :-----------: |
| service-id |  代理服务名   |
|    path    | 代理名称/路径 |

#### 服务中配置

|            配置项            |                             说明                             |
| :--------------------------: | :----------------------------------------------------------: |
|            prefix            |                       公共前缀，默认""                       |
|         strip-prefix         |                 路由时是否删除前缀，默认true                 |
|          retryable           |                   是否支持重试，默认false                    |
|       addProxyHeaders        |           是否添加'X-forwarded-*'请求头，默认true            |
|        addHostHeader         |                  是否添加主机头，默认false                   |
|       ignoredServices        |            不代理的服务，默认为空，即代理所有服务            |
|        ignoredHeaders        |                  忽略的HTTP请求头，默认null                  |
|       sensitiveHeaders       | 不传递给下游的敏感请求头信息，默认有"cookie","set-cookie","authorization" |
| sslHostnameValidationEnabled |              是否验证ssl连接的主机名，默认true               |



## 附录

### 注册中心配置项详解

#### eureka.client

|                    配置项                     |                             说明                             |
| :-------------------------------------------: | :----------------------------------------------------------: |
|                    enabled                    |                客户端是否开启的标志，默认true                |
|         registryFetchIntervalSeconds          |        从eureka-server获取服务清单的频率，默认30s/次         |
|    instanceInfoReplicationIntervalSeconds     |              更新实例变化信息的频率，默认30s/次              |
| initialInstanceInfoReplicationIntervalSeconds |         初始化实例信息到eureka-server的时间，默认40s         |
|      eurekaServiceUrlPollIntervalSeconds      |           多久更新一次eureka-server信息，默认5分钟           |
|                   proxyPort                   |                    eureka-server代理端口                     |
|                   proxyHost                   |                    eureka-server代理主机                     |
|                 proxyUserName                 |                   eureka-server代理用户名                    |
|                 proxyPassword                 |                    eureka-server代理密码                     |
|        eurekaServerReadTimeoutSeconds         |            读取eureka-server信息超时时间，默认8s             |
|       eurekaServerConnectTimeoutSeconds       |              连接eureka-server超时时间，默认5s               |
|         eurekaServerTotalConnections          |                      总连接数，默认200                       |
|      eurekaServerTotalConnectionsPerHost      |                每个eureka-server实例连接总数                 |
|      eurekaConnectionIdleTimeoutSeconds       |                HTTP连接keepalive时间，默认30s                |
|        heartbeatExecutorThreadPoolSize        |                   心跳线程池线程数，默认2                    |
|   heartbeatExecutorExponentialBackOffBound    | 心跳执行程序回退相关的属性，是重试延迟的最大倍数值，默认为10 |
|      cacheRefreshExecutorThreadPoolSize       |                 缓存刷新线程池线程数，默认2                  |
|  cacheRefreshExecutorExponentialBackOffBound  |             缓存刷新重试延迟的最大倍数值，默认10             |
|                   serverUrl                   |             指定注册中心地址，集群以','为分隔符              |
|                  gZipContent                  |                 是否压缩注册表内容，默认true                 |
|         useDnsForFetchingServiceUrls          |           是否使用DNS来获取服务实例清单，默认false           |
|              registerWithEureka               |              是否注册到eureka-server，默认true               |
|             preferSameZoneEureka              |       优先选择同一个Zone空间的eureka-server，默认true        |
|                 logDeltaDiff                  |     是否记录eureka-server和eureka-client在实例清单的差异     |
|                 disableDelta                  |                      禁用记录的差异信息                      |
|             filterOnlyUpInstances             |                只获取状态为UP的实例，默认true                |
|                 fetchRegistry                 |        是否从eureka-server获取注册实例清单，默认true         |
|               dollarReplacement               |     序列化/反序列化eureka-server信息时的$替换符，默认_-      |
|             escapeCharReplacement             |     序列化/反序列化eureka-server信息时的-替换符，默认__      |
|                allowRedirects                 | 是否允许eureka-server将eureka-client请求转发到其他eureka-server，默认true |
|          onDemandUpdateStatusChange           |  本地状态更新将触发远程eureka-server注册信息更新，默认true   |
|                  encoderName                  |                            编码器                            |
|                  decoderName                  |                            解码器                            |
|          shouldUnregisterOnShutdown           |     eureka-client关闭后是否自动从注册中心注销，默认true      |
|        shouldEnforceRegistrationAtInit        |        eureka-client在初始化时是否必须注册，默认false        |
|                     order                     |           用于 `CompositeDiscoveryClient` 发现排序           |

#### eureka.instance服务实例

|              配置项              |                             说明                             |
| :------------------------------: | :----------------------------------------------------------: |
|           instance-id            |                  同一服务不同实例的唯一标识                  |
|             appname              | 服务名，默认UNKNOWN，如果有spring.application.name则使用该名字 |
|             hostname             |               主机名，默认使用操作系统的主机名               |
|          nonSecurePort           |                    非安全通信端口，默认80                    |
|       nonSecurePortEnabled       |               是否开始非安全通信端口，默认true               |
|            securePort            |                    安全通信端口，默认443                     |
|        securePortEnabled         |               是否开启安全通信端口，默认false                |
|  leaseRenewalIntervalInSeconds   |                  发送心跳信息间隔，默认30s                   |
| leaseExpirationDurationInSeconds |                      过期时间，默认90s                       |
|          statusPageUrl           |                状态信息Url绝对路径，默认null                 |
|           homePageUrl            |                homePageUrl绝对路径，默认null                 |
|          healthCheckUrl          |                健康检测Url绝对路径，默认null                 |
|         preferIpAddress          |                优先使用IP地址注册，默认false                 |

### Hystrix注解和配置详解

更详细内容可查看[官方文档](https://github.com/Netflix/Hystrix/wiki/Configuration)

#### @HystrixCommand

|       可配置属性        |                             说明                             |
| :---------------------: | :----------------------------------------------------------: |
|     fallbackMethod      |                           回退方法                           |
|       commandKey        |            Hystrix命令的键，默认是被注解的方法名             |
|        groupKey         |                  一组命令的标识，默认是类名                  |
|      threadPoolKey      |  线程池的标识，默认是groupKey，一个类的命令使用同一个线程池  |
| observableExecutionMode |              异步执行的命令执行模式，EAGER/LAZY              |
|    commandProperties    |            命令配置，可以以数组形式设置命令的属性            |
|  threadPoolProperties   |           线程池配置，可以以数组形式设置线程池属性           |
|    ignoreExceptions     | 忽视异常，如果执行过程出现未被忽视异常Hystrix会调用fallback。 |

#### @FeignClient

Feign使用Hystrix，可使用此注解

|   可配置属性    |                             说明                             |
| :-------------: | :----------------------------------------------------------: |
|    fallback     |           回退策略，通过实现接口FeignClient的方式            |
|      value      |                            服务名                            |
| fallbackFactory | 回退策略，通过实现FallbackFactory<FeignClient>生成实例的方式 |

#### HystrixCommandProperties

##### 线程隔离execution.

|                  配置项                   |                   说明                   |
| :---------------------------------------: | :--------------------------------------: |
|             isolation.stragy              |  隔离方式：线程池THREAD信号量SEMAPHORE   |
|              timeout.enabled              |               开启超时熔断               |
|  isolation.thread.timeoutInMilliseconds   |        超时时间，单位毫秒，默认1s        |
|    isolation.thread.interruptOnTimeout    |       超时后是否中断方法，默认true       |
| isolation.thread.interruptOnFutureCancel  |      取消后是否中断方法，默认false       |
| isolation.semaphore.maxConcurrentRequests | 使用信号量隔离方式时最大并发数，默认是10 |



##### 统计器metrics.

|                配置项                 |                          说明                           |
| :-----------------------------------: | :-----------------------------------------------------: |
|    rollingStats.timeInmilliseconds    | Hystrix滑动窗口大小，单位ms，默认1s，即统计1s内请求总数 |
| healthSnapshot.intervalInMilliseconds | Hystrix桶的大小，默认500ms，每经过500ms计算窗口的失败率 |
|        rollingStats.numBuckets        |         可视化界面时一个窗口应该拆分成多少个桶          |
|       rollingPercentile.enabled       |          是否统计方法响应时间百分比，默认true           |
| rollingPercentile.timeInMilliseconds  |        统计响应时间百分比时窗口大小，默认一分钟         |
|     rollingPercentile.numBuckets      |               一个窗口划分成几个桶，默认6               |
|     rollingPercentile.bucketSize      |       每个桶保留的请求数，默认100，即最近的100条        |

##### 熔断器circuitBreaker.

|          配置项          |                        说明                         |
| :----------------------: | :-------------------------------------------------: |
|         enabled          |              是否开启熔断器，默认true               |
|        forceOpen         |                      强制启用                       |
|       forceClosed        |                      强制关闭                       |
|  requestVolumeThreshold  | 窗口最小请求数，需要根据接口的qps来设置，避免误触发 |
| errorThresholdPercentage |         失败率阈值，超过该百分比则触发熔断          |
| sleepWindowMilliseconds  |          触发熔断后多久就放行请求，默认5s           |

#### HystrixThreadPoolProperties

|                配置项                 |                 说明                  |
| :-----------------------------------: | :-----------------------------------: |
|               coreSize                |          核心线程数，默认10           |
| allowMaximunSizeToDivergeFromCoreSize | 允许扩展到线程池最大线程数，默认false |
|              maxinumSize              |          最大线程数，默认10           |
|             maxQueueSize              |         任务队列大小，默认-1          |
|      queueSizeRejectionThreshold      |   任务队列到达此值就拒绝请求，默认5   |
|         keepAliveTimeMinutes          |        空闲存活时间，默认2分钟        |

