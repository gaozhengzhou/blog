# JAVA基础

## 英文自我介绍
Thank you for giving me this opportunity for this interview.
My Chinese name is GaoZhengZhou and you can call me Joe which is my English name.

That’s all. Thank you for giving me the chance.
Thank you!

## JVM内存模型

## 垃圾回收机制

## 泛型
泛型的本质是参数化类型，提高java程序的类型安全，提供编译期间的类型检测，消除强制类型转换，泛化代码，代码可以更多的重复利用

## 反射
java的反射机制是指在运行时可以动态加载类，查看类的信息，生成对象，操作对象，获取对象信息。

### 线程生命周期
![img](images/java/thread-lifecycle.jpg)
sleep: 不需要在同步方法或同步块中调用，java.lang.Thread的静态方法，作用于当前线程，不会释放锁，超时或调用interrupt()可以呼醒；
wait: 只能在同步方法或同步块中调用，否则抛IllegalMonitorStateException异常，Object类中的方法，作用于对象本身，其他线程调用对象的notify()或notifyAll()可以呼醒；
join：thread.join()的作用是把当前线程放入等待池，并等待thread线程执行完毕后才会被呼醒，但不影响同一时刻处在运行状态的其他线程；
yield: 放弃当期cpu的执行权；
interrupt: 改变中断状态，不会中断运行中的线程，抛出一个InterruptException，从而提早退出阻塞状态；

### 线程分类
newCachedThreadPool
newFixedThreadPool
newSingleThreadExecutor
newScheduleThreadPool
newSingleThreadScheduledExecutor

### 线程配置参数
corePoolSize: 
maximumPoolSize:
keepAliveTime:
timeUnit:
workQueue:
threadFactory:
rejectedExecutionHanlder: 

### 线程阻塞队列


### 线程拒绝策略

## 设计模式

## AOP

## IoC

## 动态代理

## 分布式事务

## JDK8新特性

## SpringBoot组件

## SpringCloud组件

## JWT组成

## Dockerfile常用指令

## 什么开发模式可以避免OOM

## 中台