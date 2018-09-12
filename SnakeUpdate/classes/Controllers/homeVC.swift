//
//  homeVC.swift
//  SnakeUpdate
//
//  Created by Huang on 2017/12/20.
//  Copyright © 2017年 Huang. All rights reserved.
//

import UIKit

class homeVC: UIViewController {

    @IBOutlet var homwViews: homeView!
    override func viewDidLoad() {
        super.viewDidLoad()
        homwViews.playBtn.layer.cornerRadius = 7
        homwViews.playBtn.setTitle("PLAY", for: .normal)
        homwViews.titleLabel.text = "🐢🐢🐢"
        // Do any additional setup after loading the view.
    }
    @IBAction func playAction(_ sender: Any) {
        performSegue(withIdentifier: "goPlay", sender: nil)
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
