//
//  CirclePresentedButton.swift
//  CircleTransition
//
//  Created by 张思槐 on 16/10/9.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

protocol CircleTransitionButtonDelegate {}

class CircleTransitonButton: UIButton {
    
    var delegate: CircleTransitionButtonDelegate?
    var presentedViewController: UIViewController?{
        didSet{
            setUp()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //系统方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        NotificationCenter.default.addObserver(self, selector: #selector(self.recoverButton(note:)), name: NSNotification.Name("dissmissFinished"), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NotificationCenter.default.addObserver(self, selector: #selector(self.recoverButton(note:)), name: NSNotification.Name("dissmissFinished"), object: nil)
//        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension CircleTransitonButton: CAAnimationDelegate{
    
    fileprivate func setUp(){
        addTarget(self, action: #selector(self.buttonClick), for: .touchUpInside)
        presentedViewController?.modalPresentationStyle = .custom
        presentedViewController?.transitioningDelegate = CircleTransitionAnimator.sharedInstance
        CircleTransitionAnimator.sharedInstance.setTransitionButton(transitionButton: self)
    }
    
    @objc fileprivate func buttonClick(){
        
        layer.masksToBounds = true
        let anim = CABasicAnimation(keyPath: "bounds.size.width")
        anim.fromValue = bounds.width
        anim.toValue = bounds.height
        anim.duration = 0.2
        anim.fillMode = kCAFillModeForwards
        anim.isRemovedOnCompletion = false
        layer.add(anim, forKey: "anim")
        let ridusAnim = CABasicAnimation(keyPath: "cornerRadius")
        ridusAnim.beginTime = anim.duration + CACurrentMediaTime()
        ridusAnim.fromValue = 0
        ridusAnim.toValue = bounds.height * 0.5
        ridusAnim.duration = anim.duration
        ridusAnim.fillMode = kCAFillModeForwards
        ridusAnim.isRemovedOnCompletion = false
        ridusAnim.delegate = self
        layer.add(ridusAnim, forKey: "ridusAnim")
    
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        bounds = CGRect(x: 0, y: 0, width: bounds.height, height: bounds.height)
        (delegate as? UIViewController)?.present(presentedViewController!, animated: true, completion:nil)
    }
}

extension CircleTransitonButton{
    @objc fileprivate func recoverButton(note: NSNotification){
        let width = note.userInfo?["width"] as! CGFloat
        let recoverAnim = CABasicAnimation(keyPath: "cornerRadius")
        recoverAnim.fromValue = layer.cornerRadius
        recoverAnim.toValue = 0
        recoverAnim.duration = 0.5
        recoverAnim.fillMode = kCAFillModeForwards
        recoverAnim.isRemovedOnCompletion = false
        layer.add(recoverAnim, forKey: "recoverCornerRadius")
        
        let anim = CABasicAnimation(keyPath: "bounds.size.width")
        anim.fromValue = bounds.width
        anim.toValue = width
        anim.duration = 0.2
        anim.fillMode = kCAFillModeForwards
        anim.isRemovedOnCompletion = false
        layer.add(anim, forKey: "recoverWidth")
        
        bounds.size.width = width

    }
}
