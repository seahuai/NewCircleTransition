//
//  ViewController.swift
//  CircleTransition
//
//  Created by 张思槐 on 16/10/9.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, CircleTransitionButtonDelegate {


    @IBOutlet weak var presentedBtn: CircleTransitonButton!
    
    lazy var secondVC: SecondViewController = SecondViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        
        presentedBtn.presentedViewController = secondVC
        presentedBtn.delegate = self
        
//        let btn = CircleTransitonButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
//        btn.backgroundColor = UIColor.black
//        btn.presentedViewController = secondVC
//        btn.delegate = self
//        view.addSubview(btn)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

