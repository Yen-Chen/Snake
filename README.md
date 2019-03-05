# Snake
### 首先看一下貪食蛇遊戲的畫面
***
![image](https://github.com/Yen-Chen/Snake/blob/master/未命名.gif)
***

## 貪食蛇頭、身體和吃蘋果的運作
如何蛇的頭可以一步一步往前跑，首先我們先創出蛇頭，並讓它賦予可以隨著手勢滑動而更改方向  
```swift
//蛇的頭
func circleView(height:CGFloat,width:CGFloat){
    snakePoint.append(UIView())
    snakePoint[0] = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 10, height: 10))
    snakePoint[0].center = CGPoint(x: width/2, y: height/2)
    snakePoint[0].backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
    snakePoint[0].layer.cornerRadius = snakePoint[0].frame.width/2      //以下兩行讓蛇的頭變成圓形
    snakePoint[0].clipsToBounds = true
    self.mainView.secondView.addSubview(snakePoint[0])
    //down
    let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
    swipeDown.direction = .down
    swipeDown.numberOfTouchesRequired = 1
    mainView.addGestureRecognizer(swipeDown)
    //left
    let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
    swipeLeft.direction = .left
    swipeLeft.numberOfTouchesRequired = 1
    mainView.addGestureRecognizer(swipeLeft)
    //right
    let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
    swipeRight.direction = .right
    swipeRight.numberOfTouchesRequired = 1
    mainView.addGestureRecognizer(swipeRight)
    //up
    let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
    swipeUp.direction = .up
    swipeUp.numberOfTouchesRequired = 1
    mainView.addGestureRecognizer(swipeUp)
}
```

再來加上滑動的方法，必須加上判斷以防同時往一個方向滑兩次以上，會造成頭一次跳兩格以上  
```swift
//滑動func
@objc func swipeAction(recognizer:UISwipeGestureRecognizer){
    let directions = recognizer.direction
    if directions == .left && nowDirection != .right{
        nowDirection = directions
    }else if directions == .right && nowDirection != .left{
        nowDirection = directions
    }else if directions == .up && nowDirection != .down{
        nowDirection = directions
    }else if directions == .down && nowDirection != .up{
        nowDirection = directions
    }
}
```

再來我們先固定蛇頭原始的方向，先在全域變數加上這行  
`var nowDirection:UISwipeGestureRecognizerDirection = .left`  

再加上一個Timer讓頭可以一直往下個座標移動  
`var timer:Timer?`

然後在viewDidLoad裡面加上Timer的方法，其中我設定讓這個block每0.2秒的時候做一次，就會看起來很像頭一直在移動  
`timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { (action) in self.bodyRun(height: height, width: width)})`  

再來進入func裡面，func裡面帶了兩個傳入值，主要是用來計算下個點要往哪裡跑  
```swift
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
```swift
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
- 再來我們利用方向去算出下個點要往哪裡跑
```swift
//頭方向
func headDirection(height:CGFloat,width:CGFloat){
    let point = self.snakePoint[0].center
    if self.nowDirection == .up{   //如果是向上的話就讓頭的y持續減10px()
        if point.y >= 10{
            self.snakePoint[0].center = CGPoint(
                x: self.snakePoint[0].center.x,
                y: self.snakePoint[0].center.y - 10)
        }else{
            self.snakePoint[0].center.y = height - 5
        }
    }else if self.nowDirection == .down{
        if point.y <= height - 10{
            self.snakePoint[0].center = CGPoint(
                x: self.snakePoint[0].center.x,
                y: self.snakePoint[0].center.y + 10)
        }else{
            self.snakePoint[0].center.y = 5
        }
    }else if self.nowDirection == .left{
        if point.x >= 10 {
            self.snakePoint[0].center = CGPoint(
                x: self.snakePoint[0].center.x - 10,
                y: self.snakePoint[0].center.y)
        }else{
            self.snakePoint[0].center.x = width - 5
        }
    }else if self.nowDirection == .right{
        if point.x <= width - 10{
            self.snakePoint[0].center = CGPoint(
                x: self.snakePoint[0].center.x + 10,
                y: self.snakePoint[0].center.y)
        }else{
            self.snakePoint[0].center.x = 5
        }
    }
    var tempPoint:[CGPoint] = []
    for i in snakePoint{
        tempPoint.append(i.center)
    }
    //以下等等再講，這是動畫的部分
    for i in 1..<snakePoint.count{
        if self.snakePoint[0].center == tempPoint[i]{
            ani = UIDynamicAnimator(referenceView: mainView.secondView)
            //引力
            let gravity = UIGravityBehavior(items: snakePoint)
            //碰撞
            let collision = UICollisionBehavior(items: snakePoint)
            //在邊界停止
            collision.translatesReferenceBoundsIntoBoundary = true
            //重力加速度的方向
            gravity.gravityDirection = CGVector (dx: 0.0, dy: 1.0)
            let itemBehavior = UIDynamicItemBehavior(items: snakePoint)
            //碰到牆旋轉速度
            itemBehavior.angularResistance = 0
            //反彈力
            itemBehavior.elasticity = 1.0
            ani.addBehavior(itemBehavior)
            ani.addBehavior(collision)
            ani.addBehavior(gravity)
            timer?.invalidate()
            viewSlideUp()
        }
    }
}
```
- 產生出下一顆蘋果，並讓蘋果中心的座標隨機產生，並讓它的顏色也是隨機產生的
```swift
//蘋果
func randomView(height:CGFloat,width:CGFloat){
    let x = arc4random_uniform(UInt32((width/5)-1))
    let y = arc4random_uniform(UInt32((height/5)-1))
    if (x % 2 != 0) && (y % 2 != 0){
        randomView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 10, height: 10))
        randomColor()
        randomView.layer.cornerRadius = randomView.frame.width / 2
        randomView.clipsToBounds = true
        randomView.center = CGPoint(x: CGFloat(x) * 5, y: CGFloat(y) * 5)
        self.mainView.secondView.addSubview(randomView)
    }else{
        randomView(height: height, width: width)
    }
}
//蘋果顏色
func randomColor(){
    let red:CGFloat = CGFloat(Float(arc4random_uniform(100))/Float(100))
    let green:CGFloat = CGFloat(Float(arc4random_uniform(100))/Float(100))
    let blue:CGFloat = CGFloat(Float(arc4random_uniform(100))/Float(100))
    let RandomColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
    randomView.backgroundColor = RandomColor
}
 ```
 
 ## 當頭碰到身體後的動畫運作
 剛剛有在頭的方向的func裡有提到，就是當頭往下個點移動的時候就會進行一次判斷，看看頭有沒有撞到身體，有的話就執行以下程式碼
 ```swift
 //把蛇陣列裡面的每個點都賦予引力和碰撞，再加上重力加速度，所有的物體自然會往下掉
for i in 1..<snakePoint.count{
    if self.snakePoint[0].center == tempPoint[i]{
        ani = UIDynamicAnimator(referenceView: mainView.secondView)
        let gravity = UIGravityBehavior(items: snakePoint)      //引力
        let collision = UICollisionBehavior(items: snakePoint)  //碰撞
        collision.translatesReferenceBoundsIntoBoundary = true  //在邊界停止
        gravity.gravityDirection = CGVector (dx: 0.0, dy: 1.0)  //重力加速度的方向
        let itemBehavior = UIDynamicItemBehavior(items: snakePoint)
        itemBehavior.angularResistance = 0      //碰到牆旋轉速
        itemBehavior.elasticity = 1.0       //反彈力
        ani.addBehavior(itemBehavior)
        ani.addBehavior(collision)
        ani.addBehavior(gravity)
        timer?.invalidate()
        viewSlideUp()
    }
}
 ```

## 滑出的一個結束遊戲與重新遊戲的視窗
首先需要在Main.storyBoard裡面的MainVC拉一個View進去上面那排狀態列，就會跑出一個小View在ViewController上面，如下圖  
![image](https://github.com/Yen-Chen/Snake/blob/master/photo.png)

再來記得把view和裡面的按鈕拉OutLet進來，以供UI設計使用，之後記得把這個滑出的動畫的程式碼放在ViewWillAppear裡面，才不會跑不出畫面來
```swift
override func viewWillAppear(_ animated: Bool) {
    let height = appearView.frame.height
    mainView.addSubview(appearView)
    appearView.translatesAutoresizingMaskIntoConstraints = false
    //以下三行為設定view的約束
    appearView.heightAnchor.constraint(equalToConstant: height).isActive = true
    appearView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 10).isActive = true
    appearView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -10).isActive = true
    //把底部的約束當作一個id來用，用來當作判斷是否有呼叫到此id，有的話就讓底部的約束改變這時就會進入ViewSlideUp的方法裡
    let hide = appearView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: height)
    hide.identifier = "hide"
    hide.isActive = true
    resetBtn.layer.cornerRadius = 10
    endBtn.layer.cornerRadius = 10
    appearView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0)
    super.viewWillAppear(animated)
}
```

當頭碰到身體死掉的時候就會呼叫下面func，當找到id為hide的時候就讓約束改變，並讓view跑上來主要的mainView上，再限制view跑1.25秒才會到指定位置上
```swift
func viewSlideUp(){
    for i in mainView.constraints{
        if i.identifier == "hide"{
            let showHeight = (mainView.frame.height - appearView.frame.height)/2
            i.constant = -showHeight
            break
        }
    }
    UIView.animate(withDuration: 1.25) {
        self.mainView.layoutIfNeeded()
    }
}
```

最後就是當按下重新遊戲的時候，再讓view回到原始的位置上
```swift
func tapViewBtn(){
    for i in mainView.constraints{
        if i.identifier == "hide"{
            let showHeight = (mainView.frame.height - appearView.frame.height)/2
            i.constant = showHeight
            break
        }
    }
    UIView.animate(withDuration: 1.0) {
        self.mainView.layoutIfNeeded()
    }
}
```
