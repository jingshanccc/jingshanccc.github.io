---
title: 面试题04. 二维数组中的查找
tags:
  - 剑指Offer
  - 二维数组
categoires:
  - 剑指Offer
abbrlink: dda4a850
---

>在一个 n * m 的二维数组中，每一行都按照从左到右递增的顺序排序，每一列都按照从上到下递增的顺序排序。请完成一个函数，输入这样的二维数组和一个整数，判断数组中是否含有该整数。

<!-- more -->
示例：

```java
matrix: 
[
  [1,   4,  7, 11, 15],
  [2,   5,  8, 12, 19],
  [3,   6,  9, 16, 22],
  [10, 13, 14, 17, 24],
  [18, 21, 23, 26, 30]
]
给定 target = 5，返回 true。
给定 target = 20，返回 false。
```

### 👊 暴力解法

遍历二维数组的每一个位置，判断是否和 ` target ` 相等。

```java
public boolean findNumberIn2DArray(int[][] matrix, int target) {
    //代码的鲁棒性
    if(matrix == null || matrix.length == 0 || matrix[0].length == 0){
        return false;
    }
    for(int i = 0 ; i < matrix.length; i++){
        for(int j = 0; j < matrix[0].length ; j++){
            if(matrix[i][j] == target){
                return true;
            }
        }
    }
    return false;
}
```

😂~~就这都能双一百你敢信？~~

![图片](http://119.3.165.25/img/剑指Offer/04/1.png)

### 📈 优化

暴力解法没有利用题目提供的每行有序和每列有序的特性。查找的过程无非是判断数字之间的大小关系，并且最好通过大小关系可以帮我们减小查找的范围，就像二分查找，每次可以排除一般的查找范围。

这个二维数组拥有以下特征：对于每一个元素，它所在的行，左侧的元素都比它小，右侧的元素都比它大；它所在的列，上方的元素比它小，下方的元素比它大。要确保所有位置都被考虑到，因此需要确定从四个顶点的哪一个开始。如果从左上角开始，根据target和左上角元素的大小关系，我们无法缩小范围，因为对于左上角来说，只有右侧和下侧，都是比它大的。右小角同理。而对于右上角来说，比它小的在左侧，比它大的在下方，因此如果target比它大，则会出现在下方，我们可以不再考虑当前行；如果比它小，则会出现在左侧，我们可以不必考虑当前列。达到缩小查找范围的目的。左下角同理。

```java
public boolean findNumberIn2DArray(int[][] matrix, int target) {
    //代码的鲁棒性
    if(matrix == null || matrix.length == 0 || matrix[0].length == 0){
        return false;
    }
    int row = matrix.length, col = matrix[0].length;
    int curRow = 0, curCol = col-1;
    while( curRow < row && curCol >= 0){
        if(matrix[curRow][curCol] == target){
            return true;
        }else if(matrix[curRow][curCol] < target){
            curRow ++;//下一行
        }else{
            curCol --;//前一列
        }
    }
    return false;
}
```



