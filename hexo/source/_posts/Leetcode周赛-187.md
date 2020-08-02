---
title: Leetcode周赛-187
tags:
  - Leetcode周赛
categories:
  - Leetcode
image: 'https://gitee.com/jingshanccc/image/raw/master/image/20200722004843.png'
abbrlink: 2b34ab19
---

<p/>

<!-- more -->

### 旅行终点站

> 给你一份旅游线路图，该线路图中的旅行线路用数组 `paths` 表示，其中 `paths[i] = [cityAi, cityBi]` 表示该线路将会从 `cityAi` 直接前往 `cityBi` 。请你找出这次旅行的终点站，即没有任何可以通往其他城市的线路的城市*。*
>
> 题目数据保证线路图会形成一条不存在循环的线路，因此只会有一个旅行终点站。

{% note info %}

**示例 1：**

```
输入：paths = [["London","New York"],["New York","Lima"],["Lima","Sao Paulo"]]
输出："Sao Paulo" 
解释：从 "London" 出发，最后抵达终点站 "Sao Paulo" 。本次旅行的路线是 "London" -> "New York" -> "Lima" -> "Sao Paulo" 。
```

**示例 2：**

```
输入：paths = [["B","C"],["D","B"],["C","A"]]
输出："A"
解释：所有可能的线路是：
"D" -> "B" -> "C" -> "A". 
"B" -> "C" -> "A". 
"C" -> "A". 
"A". 
显然，旅行终点站是 "A" 。
```

**示例 3：**

```
输入：paths = [["A","Z"]]
输出："Z"
```

{% endnote %}

### 💡 解法

终点站不会出现在任何线路的起点，因此将所有终点存入一个set，然后将出现在起点的站点从set中删除，最终剩下的就是终点站。

```java
public String destCity(List<List<String>> paths) {
    Set<String> city = new HashSet<>();
    for(List<String> cs : paths){
        city.add(cs.get(1));

    }
    for(List<String> cd : paths){
        if(city.contains(cd.get(0))){
            city.remove(cd.get(0));
        }
    }
    return city.iterator().next();
}
```

## 是否所有 1 都至少相隔 k 个元素

> 给你一个由若干 `0` 和 `1` 组成的数组 `nums` 以及整数 `k`。如果所有 `1` 都至少相隔 `k` 个元素，则返回 `True` ；否则，返回 `False` 。

{% note info %}

**示例 1：**

**![img](https://gitee.com/jingshanccc/image/raw/master/image/20200722004857.png)**

```
输入：nums = [1,0,0,0,1,0,0,1], k = 2
输出：true
解释：每个 1 都至少相隔 2 个元素。
```

**示例 2：**

**![img](https://gitee.com/jingshanccc/image/raw/master/image/20200722004907.png)**

```
输入：nums = [1,0,0,1,0,1], k = 2
输出：false
解释：第二个 1 和第三个 1 之间只隔了 1 个元素。
```

**示例 3：**

```
输入：nums = [1,1,1,1,1], k = 0
输出：true
```

**示例 4：**

```
输入：nums = [0,1,0,1], k = 1
输出：true
```

{% endnote %}

### 💡 解法

只要所有1之间最小的间隔等于k即可。换句话说，如果还没出现k个0就再次出现1，返回false。

```java
public boolean kLengthApart(int[] nums, int k) {
    int distance = k;

    for(int i = 0 ; i < nums.length; i++){
        if(nums[i] == 1 && distance < k){
            return false;
        }
        distance = nums[i]==0 ? distance + 1 : 0;
    }
    return true;
}
```

## 绝对差不超过限制的最长连续子数组

> 给你一个整数数组 `nums` ，和一个表示限制的整数 `limit`，请你返回最长连续子数组的长度，该子数组中的任意两个元素之间的绝对差必须小于或者等于 `limit` *。*
>
> 如果不存在满足条件的子数组，则返回 `0` 。

{% note info %}

**示例 1：**

```
输入：nums = [10,1,2,4,7,2], limit = 5
输出：4 
解释：满足题意的最长子数组是 [2,4,7,2]，其最大绝对差 |2-7| = 5 <= 5 。
```

{% endnote %}

### 💡 解法

最长连续子数组问题，都可以通过暴力枚举以每一个位置开头的最长连续子数组来求解。要求子数组任意两个元素之间绝对差小于等于` limit `，而最大的绝对差来自最大值和最小值的差，因此需要动态维护子数组中的最大值和最小值。

```java
public int longestSubarray(int[] nums, int limit) {
    if(nums == null || nums.length == 0){
        return 0;
    }
    int n = nums.length;
    int res = 1;
    for(int i = 0; i < n; i++){
        int min = nums[i];
        int max = nums[i];
        int count = 1;
        for(int j = i + 1; j < n; j++){
            if(Math.abs(nums[j]-min) > limit || Math.abs(max-nums[j]) > limit){
                break;
            }else{
                count ++;
                max = Math.max(max, nums[j]);
                min = Math.min(min, nums[j]);
            }
        }
        res = Math.max(count, res);
    }
    return res;
}
```

提交之后会获得一个**超时**的结果😂。

### 📈 优化

上述过程中，由于没有利用到上一次求取过程中的信息，每一个位置的求解都需要遍历该位置元素之后的整个数组，因此是O(N²)的复杂度。解题和优化的思路和Leetcode第 {% post_link 3-无重复字符的最长子串 %} 题类似，既然开头行不通，那么我们可以反过来求解以每一个位置为结尾的满足要求的最长连续子数组。遍历每一个位置，从右向左查找满足条件的。` [left...i-1] `一定是满足条件的，通过 ` i ` 和其左边的数字，更新left，表示包含 ` i` 之后，符合条件的最左下标。

```java
public int longestSubarray(int[] nums, int limit) {
    int left = 0;//满足条件的最小下标数组值。
    int res= 0 ;
    if(nums.length == 1) return 1;
    for(int i = 1 ; i < nums.length; ++ i){
        //队列维护
        for(int j = i - 1; j >= left; j --){
            //如果存在相同的值，直接跳过，不处理left
            if(nums[i] == nums[j]){
                break;
            }
            // 从右往左处理，如果有不满足，直接更新left.
            if(Math.abs(nums[j] - nums[i])> limit){
                left = j + 1;
                break;
            }
        }
        res = Math.max(res, i - left + 1);
    }
    return res;
}
```

{% note warning %}

文中题目以及图片来自 [Leetcode 第 187 场周赛](https://leetcode-cn.com/contest/weekly-contest-187/) .

{% endnote %}