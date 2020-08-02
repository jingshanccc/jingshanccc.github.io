---
title: 面试题09. 用两个栈实现队列
tags:
  - 剑指Offer
  - 栈
  - 队列
categories:
  - 剑指Offer
abbrlink: eaced0a1
date: 2020-03-20 00:04:02
---

> 用两个栈来实现一个队列，完成队列的Push和Pop操作。 

<!-- more -->

分析题目，提炼关键信息：队列的特点是**先进先出**，栈的特点是**后进先出**。

我们应当关心的是-：**如何保证出的顺序是先进先出？**注意到-假如栈1入栈顺序为1,2,3,则出栈顺序为3,2,1，那么按栈1出栈顺序将元素放入栈2，则栈2入栈顺序为3,2,1,则出栈顺序为1,2,3。 两个栈一个为进一个为出，这样栈1负责入队，栈2负责出队，就满足队列先进先出的要求。

算法执行过程：

当栈2为空时，将栈1中元素弹出压入到栈2。

![图片](https://gitee.com/jingshanccc/image/raw/master/image/20200722004551.jpg)

当栈2不为空时，直接返回栈2栈顶元素即可。

代码如下：

    import java.util.Stack;
    
    public class Solution {
        Stack<Integer> stack1 = new Stack<Integer>();
        Stack<Integer> stack2 = new Stack<Integer>();
        
        public void push(int node) {
            stack1.push(node);
        }
        
        public int pop() {
            if(stack2.isEmpty()){
                while(!stack1.isEmpty())stack2.push(stack1.pop());
            }
            return stack2.isEmpty() ? -1 : stack2.pop();
        }
    }