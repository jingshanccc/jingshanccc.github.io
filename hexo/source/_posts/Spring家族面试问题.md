---
title: Spring家族面试问题
tags:
  - Java后端面试
  - Spring Cloud
categories:
  - Java后端面试
image: 'https://gitee.com/jingshanccc/image/raw/master/image/20200722151317.png'
abbrlink: caab1d3c
date: '2020-07-16 22:14'
---

<p></p>

<!-- more -->

## Spring IOC

### IOC是什么？

IOC即控制反转，将对象的创建工作交给容器来实现，所以需要创建一个容器并且它需要知道创建对象间的关系，在Spring中管理对象及其依赖关系就是通过IOC容器实现的。IOC的实现方式有**依赖注入**和**依赖查找**，依赖查找通过容器和API来主动查找，例如`applicationContext.getBean("name");`，依赖注入是对象被动地接受依赖类，在容器实例化时将依赖注入给对象，Spring中除了初始化的Bean查找，组件及其依赖项都是用注入方式。

### IOC容器的初始化过程是怎么样的

Spring在启动时，其refresh方法完成了对容器的初始化以及Bean的创建

1. prepareRefresh完成了设置上下文状态和时间，以及属性的验证
2. obtainFreshBeanFactory初始化Bean工厂，销毁存在的并重新创建
3. loadBeanDefinitions加载Bean定义，通过读取配置文件CONFIG_LOCATION_PARAM，解析xml文件，通过beanDefinitionRegistry将BeanDefinition存放到HashMap中
4. prepareBeanFactory中为BeanFactory添加类加载器、表达式解析器、自动装配等配置
5. postProcessBeanFactory中将BeanFactory的后置处理器注册到BeanFacotry上，之后在invokeBranFactoryPostProcessor中按优先级调用所有后置处理方法
6. registerBeanPostProcessor注册Bean的后置处理器
7. initMessageSource和initApplicationEventMulticaster负责初始化国际化组件和事件多播器
8. onRefresh是为子类提供的由子类实现的逻辑，在这里调用
9. registerListeners方法查找所有的监听器并注册到7中的广播器
10. finishBeanFactoryInitialization初始化剩余的其他单例bean：先调用applyBeanPostProcessorsBeforeInitialization方法，执行每个BeanPostProcessor的postProcessBeforeInitialization，然后调用invokeInitMethods方法，执行bean的初始化方法，使用set设置属性，最后调用applyBeanPostProcessorsAfterInitialization方法，执行每个BeanPostProcessor的postProcessAfterInitialization方法。
11. finishRefresh完成其他工作如清除缓存、发布事件等，IOC容器初始化结束

![img](https://gitee.com/jingshanccc/image/raw/master/image/20200722143755.png)



### 简述Bean的生命周期和作用范围

首先是Spring对Bean进行实例化，将值和Bean的引用注入到其对应的属性中，如果实现了BeanNameAware接口，调用setBeanName方法，让Bean可以获取自己的ID/name，如果实现了BeanFactoryAware接口，调用setBeanFactory，让Bean可以获取配置自己的BeanFactory，拥有Spring容器的功能；将Bean实例传递给Bean的前置处理器的postProcessBeforeInitialization，调用Bean的初始化方法，如果是InitializingBean则先调用afterPropertiesSet方法（可以做一些属性验证和设置），再调用设置的init-method，然后调用后置处理器的postProcessAfterInitialization，之后在工程中使用Bean，在容器关闭之前，调用DisposableBean的destroy方法，如果Bean有自定义销毁方法也会被调用

#### 什么是InitializingBean？

Spring提供了两种初始化Bean的方法，一是实现InitializingBean接口，实现afterPropertiesSet方法；二是在配置文件中指定init-method；两种方法可以同时使用。

{% fold 两种有什么区别？ %}

实现InitializingBean接口是直接调用afterPropertiesSet方法，比通过反射调用init-method方法效率更高，但后者消除了对spring的依赖

{% endfold %}

可以通过scope指定Bean的作用范围，有以下5种类型：

1. Singleton：单例的，每次容器返回的对象是同一个，在初始化IOC容器时完成创建
2. Prototype：多例的，每次返回的是新创建的实例
3. Request：仅作用于HttpRequest，每次Http请求创建一个实例
4. Session：仅作用于HttpSession，不同的session使用不同的实例
5. Global Session：所有的HttpSession使用同一个实例，仅用于Protlet容器

### BeanFactory和FactoryBean、ApplicationContext的区别

BeanFactory是一个Factory接口，用来管理Bean的IOC容器，对象工厂，BeanFactory 实例化后并不会自动实例化 Bean，只有当 Bean 被使用时才实例化与装配依赖关系，使用了**延迟加载**，适合多例模式；FactoryBean是一个通过写代码的方式用来自定义实例化bean的接口，传统方式xml/property注解方式可能需要大量的配置 通过实现FactoryBean来简化这个操作，在getObject方法中实现自定义的实例化逻辑；ApplicationContext是BeanFactory的子接口，做了扩展，使用**立即加载**，适合单例模式

### 依赖注入的实现方式有哪些？在Spring中有哪些相关的注解？

有构造方法注入、Setter注入、接口注入三种方式，由于构造方法无法被继承，因此Setter方法注入会更灵活一些，但是无法在对象构造完成后马上进入就绪状态。接口方式通过接口提供方法来注入依赖对象，要求实现接口，侵入性强。

在Spring中，通过getBean方法获取Bean实例，该方法会调用doGetBean从IOC容器中获取Bean，在创建Bean的过程中会完成依赖注入，在populateBean方法中，注入过程通过setPropertyValues实现，将Bean对象实例设置到它所依赖的Bean对象属性上，BeanWrapperImpl以**JDK反射形式**，通过属性的**setter方法**为属性设置注入后的值。

1. @Autowired：自动按类型注入，如果有多个匹配则按照指定Bean的id查找；可与@Qualifier匹配上下文的Bean
2. @Resource：直接按照Bean的id注入，只能注入Bean类型
3. @Value：用于注入基本数据类型和String类型



## AOP是什么？

AOP即面向切面编程，某个业务与具体对象无关，是一种通用的功能代码，在具体的时间点(Pointcut)需要被执行，业务功能代码和切面代码分开，合并成完整的业务(称为织入Weave)。常用场景包括权限认证、自动缓存、错误处理、日志、调试和事务等。

有三种织入方式：

1. 编译时织入：需要特殊的Java编译器，如AspectJ
2. 类加载时织入：需要特殊的编译器，如AspectJ和AspectWerkz
3. 运行时织入：通过动态代理的方式

在Spring中使用AOP：导入依赖，创建切面`@Aspect`，定义切入点`@PointCut(execution(xxx))`方法，定义时机Advice`@Before,AfterReturning/Throwing等`，在方法内实现需要的逻辑。

SpringAOP通过Bean的后置处理器将Bean包装成Proxy，调用时通过Proxy来调用，有两种实现方式，如果类实现了接口，则使用JDK动态代理，否则使用CGLib动态代理。

### JDK动态代理

被代理类需要实现含有业务方法的接口，代理类需要实现InvocationHandler invoke方法来调用具体的业务方法，最终通过Proxy.newInstance生成代理类，会调用ProxyGenerator的generate方法生成字节码，再用类加载器来装载生成的代理类。

在Spring AOP中，生成的Proxy类拥有真实类实现的接口的所有方法，其实就是通过**实现相同的接口**，然后在对应的方法周围加入切面逻辑。从Proxy的字节码可以看到，声明了私有静态成员变量Method 01234...通过静态代码块**利用反射**来初始化各个方法。通过Proxy类的成员变量invocationHandler的invoke方法调用具体方法。invoke中在调用具体方法前后会有**切入**的逻辑。

{% fold 展开代码 %}

```java
//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//
 
import aop.UserService;
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;
import java.lang.reflect.UndeclaredThrowableException;
 
public final class $Proxy11 extends Proxy implements UserService {
    private static Method m1;
    private static Method m4;
    private static Method m3;
    private static Method m2;
    private static Method m0;
 
    public $Proxy11(InvocationHandler var1) throws  {
        super(var1);
    }
 
    public final boolean equals(Object var1) throws  {
        try {
            return (Boolean)super.h.invoke(this, m1, new Object[]{var1});
        } catch (RuntimeException | Error var3) {
            throw var3;
        } catch (Throwable var4) {
            throw new UndeclaredThrowableException(var4);
        }
    }
 
    public final void A() throws  {
        try {
            super.h.invoke(this, m4, (Object[])null);
        } catch (RuntimeException | Error var2) {
            throw var2;
        } catch (Throwable var3) {
            throw new UndeclaredThrowableException(var3);
        }
    }
 
    public final void B() throws  {
        try {
            super.h.invoke(this, m3, (Object[])null);
        } catch (RuntimeException | Error var2) {
            throw var2;
        } catch (Throwable var3) {
            throw new UndeclaredThrowableException(var3);
        }
    }
 
    public final String toString() throws  {
        try {
            return (String)super.h.invoke(this, m2, (Object[])null);
        } catch (RuntimeException | Error var2) {
            throw var2;
        } catch (Throwable var3) {
            throw new UndeclaredThrowableException(var3);
        }
    }
 
    public final int hashCode() throws  {
        try {
            return (Integer)super.h.invoke(this, m0, (Object[])null);
        } catch (RuntimeException | Error var2) {
            throw var2;
        } catch (Throwable var3) {
            throw new UndeclaredThrowableException(var3);
        }
    }
 
    static {
        try {
            m1 = Class.forName("java.lang.Object").getMethod("equals", Class.forName("java.lang.Object"));
            m4 = Class.forName("aop.UserService").getMethod("A");
            m3 = Class.forName("aop.UserService").getMethod("B");
            m2 = Class.forName("java.lang.Object").getMethod("toString");
            m0 = Class.forName("java.lang.Object").getMethod("hashCode");
        } catch (NoSuchMethodException var2) {
            throw new NoSuchMethodError(var2.getMessage());
        } catch (ClassNotFoundException var3) {
            throw new NoClassDefFoundError(var3.getMessage());
        }
    }
}
```

{% endfold %}

### CGLIB动态代理

以继承的方式动态生成目标类的代理，通过修改字节码(asm框架)的方式织入，**不需要接口**，因为cglib是利用**继承真实类通过super来调用真实类方法**，并加入新逻辑的方式来实现的。



## Spring MVC有哪些核心组件？

SpringMVC是一个基于MVC设计模型的请求驱动的轻量级WEB框架，将WEB应用架构划分为视图层View、处理器层Controller、持久层Model。

1. DispatcherServlet：前端控制器，负责接受请求并转发到对应的处理组件
2. Handler：处理器，完成具体业务逻辑，类似Servlet或Action
3. HandlerInterceptor：拦截器，通过实现这个接口完成拦截处理
4. HandlerExecutionChain：处理链，包含Handler和HandlerInterceptor。应用了[责任链模式](https://realmicah.xyz/posts/503970b4.html#讲讲责任链模式)
5. HandlerAdapter：适配器，Handler执行处理业务方法之前，需要完成表单数据验证、数据类型转换、封装到JavaBean等操作，由Adapter完成，通过Adapter执行不同的Handler。应用了[适配器模式](https://realmicah.xyz/posts/503970b4.html#适配器模式了解吗？有什么应用？)
6. ModelAndView：装在模型数据和视图信息，作为Handler处理结果返回给DispatcherServlet
7. ViewResolver：视图解析器，DispatcherServlet通过解析器将逻辑视图转换为物理视图，最终将渲染的结果返回给客户端



## Spring Data JPA和My Batis的区别？

两者都是ORM对象关系映射框架，将JavaBean对象映射到关系型数据库，通过操作实体类来操作数据库表。Spring Data JPA在运行时通过JDK动态代理创建了Proxy对象SimpleJpaRepository，通过hibernate完成数据库操作。My Batis是一种半自动的ORM框架，使用时通过XML与JavaBean对象产生映射关系连接起来，同时需要书写sql语句，查询的结果通过ResultMap映射到Java对象。从表关联上看，My Batis更加灵活，JPA并不提供多表关联查询



## SpringBoot

### 什么是SpringBoot？有什么优点？

SpringBoot是Spring组件一站式解决方案，主要是简化了使用Spring的难度，基于约定大于配置原则，通过AutoConfigure自动配置，当有特殊需求时才需要自行配置，提供了各种starter更加方便地将其他框架集成到项目中。

1. 容易上手，开发效率更高，远离繁琐的配置
2. 提供了一系列大型项目通用的非业务性功能，如内嵌服务器、安全管理、运行数据监控、运行状况检查、外部化配置等
3. 避免了大量的Maven导入和各种版本冲突

### SpringBoot的核心注解？

@SpringBootApplication：包含了@Configuration实现配置文件功能、@EnableAutoConfiguration打开自动配置功能，如关闭某个自动配置选项、@ComponentScan实现组件扫描

### SpringBoot的starter了解吗？

starter是在我们的项目需要集成其他组件框架时一种快速集成的方式，starter为我们省去了麻烦的配置信息。在没有starter/SpringBoot之前，每一个项目在需要集成其他的框架像redis等之前都需要手动的配置许多信息，SpringBoot推崇约定大于配置，starter里将组件的配置封装在properities中，并通过AutoConfiguration来装配默认配置。SpringBoot启动时将扫描所有AutoConfiguration类，完成自动配置。

### SpringBoot如何进行自动配置？

通过@EnableAutoConfiguration开启自动配置，这个注解引入了AutoConfigurationImportSelector，它的selectImports方法从META-INF/spring.factories文件中读取了自动配置类路径，将自动配置类加入到容器中，自动配置类中通过@EnableConfigurationPeoperties引入了对应的配置类xxxProperties.class，类中的属性可以通过yml文件自定义配置，否则使用默认配置，从而实现了自动配置功能。



## SpringCloud

### 什么是服务治理？

微服务的服务注册发现、监控、下线、续期等自动化的管理，

### 讲一讲注册中心原理？

eureka主要通过定时任务和rest调用来实现服务注册和发现，服务实例会把自己的信息发送到注册中心，之后注册中心通过定时任务（心跳）来检查服务状态和进行信息更新。

### 注册中心存放了什么内容？用什么数据结构？

存放了服务实例的信息，如名称、实例id、ip等，使用了Map来存储，第一层Map，key是服务名，值是所有实例，第二层key是实例id，值是实例的信息。



### 什么是客户端负载均衡？和服务端负载均衡的区别？

我们在使用spring-cloud分布式框架时，同一个服务会有多个实例，当一个请求传递过来时，对于这多个实例，Ribbon通过策略决定本次请求使用哪个实例的方式就是客户端负载均衡。在spring-cloud分布式框架中客户端负载均衡对开发者是透明的，添加@LoadBalanced注解就可以了。服务端负载均衡则是在服务器上游做分发，如常见的nginx和lvs，分别是七层和四层的负载均衡，可以通过url、ip、端口来做负载均衡策略的选择。客户端负载均衡和服务器负载均衡的核心差异在**服务列表**本身，客户端负载均衡服务列表通过客户端维护，服务器负载均衡服务列表由中间服务单独维护。

#### 为什么Ribbon要使用客户端负载均衡？

客户端负载均衡的服务列表由客户端维护，因此可以直接在自身内存中获取可用的服务实例，效率更高，不需要每个请求都从注册中心获取可用的服务实例，也可以减轻注册中心的压力

### 负载均衡策略

1. 随机选择RandomRule：通过`ThreadLocalRandom.current().nextInt(serverCount)`获取随机索引，在`upServerList`中获取
2. 轮询RoundRibbonRule：通过递增实现轮询，默认最多选择十次
3. 重试RetryRule：基于轮询策略，反复重试直到获取到实例
4. 响应时间加权WeightedResponseTimeRule：先遍历所有服务 得到平均响应时间总和 然后用这个总和减去服务的平均响应时间，作为权重

### 服务熔断有什么用？

熔断机制是应对雪崩效应的一种微服务链路保护机制。当某个微服务不可用或者响应时间太长时，会进行服务降级，进而熔断该节点微服务的调用，快速返回“错误”的响应信息。当检测到该节点微服务调用响应正常后恢复调用链路。在SpringCloud框架里熔断机制通过Hystrix实现，Hystrix会监控微服务间调用的状况，当失败的调用到一定阈值，缺省是5秒内调用20次，如果失败，就会启动熔断机制。

服务降级，一般是从整体负荷考虑。就是当某个服务熔断之后，服务器将不再被调用，此时客户端可以自己准备一个本地的fallback回调，返回一个缺省值。这样做，虽然水平下降，但好歹可用，比直接挂掉强。

### 如何理解分布式框架/分布式服务？

分布式服务即是将传统的单体应用，从业务角度或其他角度切分为多个应用，独立运行，对外提供服务。部署在不同的服务器节点，称为分布式服务。框架用来具体实施时告诉你如何搭建出一套分布式系统。分布式框架中，最重要的两个组件就是注册中心和RPC框架，注册中心负责维护服务状态，RPC实现服务间的通信。

