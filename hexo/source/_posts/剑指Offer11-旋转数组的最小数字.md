---
title: 面试题11. 旋转数组的最小数字
tags:
  - 剑指Offer
  - 二分查找
categories:
  - 剑指Offer
abbrlink: 639f1318
---

> 把一个数组最开始的若干个元素搬到数组的末尾，我们称之为数组的旋转。输入一个递增排序数组的一个旋转，输出旋转数组的最小元素。例如，数组` [3,4,5,1,2] ` 为 ` [1,2,3,4,5] ` 的一个旋转，该数组的最小值为1.

<!-- more -->

{% note info %}

**示例 1：**

```
输入：[3,4,5,1,2]
输出：1
```

**示例 2：**

```
输入：[2,2,2,0,1]
输出：0
```

{% endnote %}

### 💡 思路

暴力解法就不详述了，遍历可以得到降序的元素。

这题和 Leetcode第 {% post_link 153-寻找旋转排序数组中的最小值 %} 题类似，建议先阅读这一篇，解法类似，区别在于这里数组的元素可能出现**重复**，因此缩小区间的时候需要考虑重复元素的情况。

本题中，中间位置元素和最右边的元素有大于小于等于三种关系：

1. 当 ` nums[mid] < nums[right] `，区间 `[mid...right]`保持**升序**，因此最小值在左侧，` right = mid `
2. 当 ` nums[mid] > nums[right] ` ，区间 ` [mid...right] ` 出现**降序**，因此最小值在右侧，` left  = mid + 1 ` 
3. 当 `nums[mid] == nums[right] `，无法确认最小值出现在哪一侧，但是我们希望可以缩小区间。由于中间元素和右边相等，因此可以将右边界左移，就算当前右边界是最小值，但是我们保留了中间元素，所以不会出现问题。

### 🧾 代码

```java
public int minArray(int[] numbers) {
    if(nums == null || nums.length == 0){
        return -1;
    }
    int l = 0 , r = numbers.length-1;
    while( l < r){//跳出循环时 l = r，区间剩下的元素就是最小值
        int mid = l + (r - l)/2;
        if(numbers[r] > numbers[mid]){
            r = mid;
        }else if (numbers[r] < numbers[mid]){
            l = mid+1;
        }else r--;
    }
    return numbers[l];
}
```

