---
title: 剑指Offer-03. 数组中重复的数字
tags:
  - 剑指Offer
  - 哈希
  - 数组
categoires:
  - 剑指Offer
abbrlink: 2f50b40c
---

>找出数组中的重复数字
>
>在一个长度为 n 的数组 nums 里的所有数字都在 0~n-1 的范围内，其中某些数字是重复的，但不知道有几个数字重复了，也不知道每个数字重复了几次。请找出数组中的任意一个重复的数字。

<!-- more -->

示例 1：

```java
输入：[2, 3, 1, 0, 2, 5, 3]
输出：2 或 3 
```

### 👊 暴力解法

重复的数字在数组中出现次数会大于1。在遍历数组的过程中，使用HashSet来记录出现过的数字，当HashSet中存在该元素时，说明重复，返回该元素即可。由于数字范围在 0~n-1 范围内，因此可以使用一个数组来记录某个元素出现的次数达到优化的目的。

```java
public int findRepeatNumber(int[] nums) {
    int[] freq = new int[nums.length];
    for(int i : nums){
        if(freq[i] == 0){
            freq[i] ++;
        }else{
            return i;
        }
    }
    return -1;
}
```

### ✍️ 优化

暴力解法的实践和空间复杂度均达到了O(N)，本题由于数组数字范围和长度相同，因此可以将原数组作为哈希表，达到优化空间的目的，但是会**修改输入**。

由于数字范围和数组长度一致，如果没有重复数字，那么每个位置上在排序后的状态下数字和位置是一一对应的，但是我们并不做排序这个工作，因为这样时间复杂度是O(nlogn)级别的。我们只是利用这一特征，遍历数组时，如果当前数字和位置不对应，则将当前数字交换到它应该在的位置上。如果应该在的位置上已经有了正确的数字，那么说明当前数字就是重复的。

```java
public int findRepeatNumber(int[] nums) {
    for(int i = 0; i < nums.length; i++){
        while(nums[i] != i){
            if(nums[nums[i]] == nums[i]){
                return nums[i];
            }
            int a = nums[nums[i]];
            nums[nums[i]] = nums[i];
            nums[i] = a;
        }
    }
    return -1;
}
```



