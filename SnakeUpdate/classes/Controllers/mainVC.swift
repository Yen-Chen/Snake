//
//  mainVC.swift
//  SnakeUpdate
//
//  Created by Huang on 2017/12/8.
//  Copyright © 2017年 Huang. All rights reserved.
//
import UIKit
class mainVC: UIViewController {
    var randomView:UIView!
    var timer:Timer?
    var snakePoint = [UIView]()
    var nowDirection:UISwipeGestureRecognizerDirection = .left
    var ani:UIDynamicAnimator!
    @IBOutlet var mainView: mainView!
    @IBOutlet var appearView: UIView!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var endBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let height = self.mainView.secondView.frame.height
        let width = self.mainView.secondView.frame.width
        circleView(height: height, width: width)
        randomView(height: height, width: width)
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { (action) in
            self.bodyRun(height: height, width: width)
        })
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        let height = appearView.frame.height
        mainView.addSubview(appearView)
        appearView.translatesAutoresizingMaskIntoConstraints = false
        appearView.heightAnchor.constraint(equalToConstant: height).isActive = true
        appearView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 10).isActive = true
        appearView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -10).isActive = true
        let hide = appearView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: height)
        hide.identifier = "hide"
        hide.isActive = true
        resetBtn.layer.cornerRadius = 10
        endBtn.layer.cornerRadius = 10
        appearView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0)
        super.viewWillAppear(animated)
    }
    //蛇的頭
    func circleView(height:CGFloat,width:CGFloat){
        snakePoint.append(UIView())
        snakePoint[0] = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 10, height: 10))
        snakePoint[0].center = CGPoint(x: width/2, y: height/2)
        snakePoint[0].backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        snakePoint[0].layer.cornerRadius = snakePoint[0].frame.width/2
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
    //頭方向
    func headDirection(height:CGFloat,width:CGFloat){
        let point = self.snakePoint[0].center
        if self.nowDirection == .up{
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
    //讓View向上滑的Func
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
    @IBAction func resetAction(_ sender: Any) {
        let height = self.mainView.secondView.frame.height
        let width = self.mainView.secondView.frame.width
        tapViewBtn()
        lose(height: height, width: width)
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { (action) in
            self.bodyRun(height: height, width: width)
        })
    }
    @IBAction func endAction(_ sender: Any) {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let backVCId = storyBoard.instantiateViewController(withIdentifier: "mainStoryBoard")
        UIApplication.shared.keyWindow?.rootViewController = backVCId
    }
    //按View的按鈕
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
    //身體跟頭方向動
    func bodyRun(height:CGFloat,width:CGFloat){
        if self.snakePoint[0].center != self.randomView.center{
            runViewArrary()
            headDirection(height: height, width: width)
        }else{
            var view = UIView.init()
            view = randomView
            let lastPoint = self.snakePoint[self.snakePoint.count - 1].center
            view.center = lastPoint
            runViewArrary()
            headDirection(height: height, width: width)
            self.snakePoint.append(view)
            self.mainView.score.text = String(snakePoint.count-1)
            self.randomView(height: height, width: width)
            for i in 1..<snakePoint.count{
                if randomView.center == snakePoint[i].center{
                    randomView(height: height, width: width)
                }
            }
        }
    }
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
    //輸func
    func lose(height:CGFloat,width:CGFloat){
        for view in self.mainView.secondView.subviews{
            view.removeFromSuperview()
        }
        self.mainView.score.text = "0"
        self.snakePoint.removeAll()
        self.timer?.invalidate()
        self.circleView(height: height, width: width)
        self.randomView(height: height,width: width)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
