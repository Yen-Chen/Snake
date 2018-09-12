# Snake
### 首先看一下貪食蛇遊戲的畫面
***
![image](https://github.com/Yen-Chen/Snake/blob/master/未命名.gif)
***

## 貪食蛇頭的運作與身體運作
如何蛇的頭可以一步一步往前跑，首先我們先固定原始的方向，先在全域變數加上這行。
  `var nowDirection:UISwipeGestureRecognizerDirection = .left`
