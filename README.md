# Snake
### 首先看一下貪食蛇遊戲的畫面
***
![image](https://github.com/Yen-Chen/Snake/blob/master/未命名.gif)
***

## 貪食蛇頭的運作與身體運作
如何蛇的頭可以一步一步往前跑，首先我們先固定原始的方向，先在全域變數加上這行。  
`var nowDirection:UISwipeGestureRecognizerDirection = .left`  
再加上一個Timer讓頭可以一直往下個座標移動  
`var timer:Timer?`

然後在viewDidLoad裡面加上Timer的方法，其中我設定讓這個block每0.2秒的時候做一次，就會看起來很像頭一直在移動
`timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { (action) in self.bodyRun(height: height, width: width)})`  
再來進入func裡面，func裡面帶了兩個傳入值，主要是用來計算下個點要往哪裡跑
```
//身體跟頭方向動
    func bodyRun(height:CGFloat,width:CGFloat){
        if self.snakePoint[0].center != self.randomView.center{  //當沒有吃到蘋果的時候就會執行這裡面的func
            runViewArrary()
            headDirection(height: height, width: width)
        }else{                            //當吃到蘋果就會執行下面的程式碼
            var view = UIView.init()      //先把吃到的view加到蛇的陣列裡面
            view = randomView
            let lastPoint = self.snakePoint[self.snakePoint.count - 1].center //把最後的view的座標給吃到的蘋果，這樣就會跟著頭一起跑了
            view.center = lastPoint
            runViewArrary()
            headDirection(height: height, width: width)
            self.snakePoint.append(view)
            self.mainView.score.text = String(snakePoint.count-1)
            self.randomView(height: height, width: width)     //吃到蘋果後就繼續亂數產生下一個點
            for i in 1..<snakePoint.count{
                if randomView.center == snakePoint[i].center{
                    randomView(height: height, width: width)
                }
            }
        }
    }
```
裡面有幾個func的作用在下面說明  
- 讓身體可以跟著頭跑
```
//身體動作
    func runViewArrary(){
        var tempPoint:[CGPoint] = []
        for i in snakePoint{
            tempPoint.append(i.center)
        }
        for i in 1..<snakePoint.count{
            snakePoint[i].center = tempPoint[i-1]
        }
    }
```
