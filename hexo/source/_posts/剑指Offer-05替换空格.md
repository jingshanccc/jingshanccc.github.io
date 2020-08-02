---
title: 面试题05. 替换空格
tags:
  - 剑指Offer
  - 字符串
categoires:
  - 剑指Offer
abbrlink: 48c165ca
---

> 请实现一个函数，把字符串中的每个空格替换成“%20%”。
>
> 示例1：
>
> ```java
> 输入：s = "we are happy"
> 输出："we%20are%happy"
> ```

<!-- more -->

### 👊 暴力解法

遍历字符串，如果遇到空格就替换成%20%

```java
public String replaceSpace(String s) {
    StringBuilder sb = new StringBuilder();
    for(int i = 0 ; i < s.length(); i ++){
        if(s.charAt(i) == ' '){
            sb.append("%20");
        }else sb.append(s.charAt(i));
    }
    return sb.toString();
}
```

### 💡 耍赖

` return s.replaceAll(" " , "%20%" ); `