---
title: 面试题06. 从尾到头打印链表
tags:
  - 剑指Offer
  - 链表
  - 栈
categories:
  - 剑指Offer
abbrlink: 9649f58
---

> 输入一个链表的头节点，从尾到头反过来返回每个节点的值（用数组返回）。
>
> 示例1：
>
> ```java
> 输入：head = [1,3,2]
> 输出：[2,3,1]
> ```

<!-- more -->

### 💡 思路

对于链表的操作，无法方便地使用下标来获取元素，因此，必然需要从头节点开始通过next指针操作。但是需要从尾到头打印，也就是头节点最后被打印，尾节点第一个被打印。因此我们可以利用栈的后进先出的特点，帮助我们完成这道题。

```java
public int[] reversePrint(ListNode head) {
    ListNode cur = head;//不修改输入
    Stack<Integer> stack = new Stack<>();
    while(cur != null){
        stack.push(cur.val);
        cur = cur.next;
    }
    int[] res = new int[stack.size()];
    for(int i = 0 ; i < stack.size(); i++){
        res[i] = stack.pop();
    }
    return res;
}
```

### 📈 优化

使用栈需要额外的空间复杂度，我们注意到返回结果是一个数组，而数组可以方便地使用下标来存取元素。因此我们先遍历链表获得链表的长度，初始化数组，再次遍历链表，将第一个节点值放在数组的最后一个位置，第二个节点放在倒数第二个位置，...以此类推。

```java
public int[] reversePrint(ListNode head) {
    ListNode cur = head;
    int size = 0;
    while(cur != null){
        size ++;
        cur = cur.next;
    }
    int[] res = new int[size];
    cur = head;
    while(cur != null){
        res[--size] = cur.val;
        cur = cur.next;
    }
    return res;
}
```

