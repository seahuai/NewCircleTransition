//
//  CircleTransitionAnimator.swift
//  CircleTransition
//
//  Created by 张思槐 on 16/10/9.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class CircleTransitionAnimator: NSObject, UIViewControllerTransitioningDelegate {
    fileprivate var bounds: CGRect?
    fileprivate var width: CGFloat = 0
    fileprivate var transitionButton: CircleTransitonButton?{
        didSet{
            width = transitionButton!.bounds.width
        }
    }
    override init() {
        super.init()
    }
    
    static let sharedInstance = CircleTransitionAnimator()
    
    func setTransitionButton(transitionButton: CircleTransitonButton){
        self.transitionButton = transitionButton
    }
    
    fileprivate var transitionContext: UIViewControllerContextTransitioning?
    fileprivate var isPresented: Bool = false
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
    
}

extension CircleTransitionAnimator: UIViewControllerAnimatedTransitioning{
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        isPresented ? animationForPresented(transitionContext: transitionContext) : animationForDismissed(transitionContext: transitionContext)
    }
    
}

extension CircleTransitionAnimator{
    fileprivate func animationForPresented(transitionContext: UIViewControllerContextTransitioning){
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        if let toView = toView{
            containerView.addSubview(toView)
        }
        let startButton = transitionButton
        let startCycle = UIBezierPath(ovalIn: startButton!.frame)
        let MAX_X = max(startButton!.frame.origin.x, containerView.frame.size.width - startButton!.frame.origin.x)
        let MAX_Y = max(startButton!.frame.origin.y, containerView.frame.size.height - startButton!.frame.origin.y)
        
        let r = sqrt(MAX_X * MAX_X + MAX_Y * MAX_Y)
        
        let endCycle = UIBezierPath(arcCenter: containerView.center, radius: r, startAngle: 0, endAngle: CGFloat(M_PI) * 2.0, clockwise: true)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = endCycle.cgPath
        toView?.layer.mask = maskLayer
        
        let maskLayerAnimation = CABasicAnimation(keyPath: "path")
        maskLayerAnimation.fromValue = startCycle.cgPath
        maskLayerAnimation.toValue = endCycle.cgPath
        maskLayerAnimation.duration = transitionDuration(using: transitionContext)
        maskLayerAnimation.delegate = self
        maskLayerAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        maskLayer.add(maskLayerAnimation, forKey: "presented")
    }
    
    fileprivate func animationForDismissed(transitionContext: UIViewControllerContextTransitioning){
        let containerView = transitionContext.containerView
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        if let fromView = fromView{
            containerView.addSubview(fromView)
        }
        let r = sqrt(containerView.bounds.width * containerView.bounds.width + containerView.bounds.height * containerView.bounds.height) / 2
        let startCycle = UIBezierPath(arcCenter: containerView.center, radius: r, startAngle: 0, endAngle: CGFloat(M_PI) * 2.0, clockwise: true)
        let endCycle = UIBezierPath(ovalIn: transitionButton!.frame)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = endCycle.cgPath
        fromView?.layer.mask = maskLayer
        let maskLayerAnimation = CABasicAnimation(keyPath: "path")
        maskLayerAnimation.fromValue = startCycle.cgPath
        maskLayerAnimation.toValue = endCycle.cgPath
        maskLayerAnimation.duration = transitionDuration(using: transitionContext)
        maskLayerAnimation.delegate = self
        maskLayerAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        maskLayer.add(maskLayerAnimation, forKey: "dissmiss")
    }
}

extension CircleTransitionAnimator: CAAnimationDelegate{
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        transitionContext?.completeTransition(flag)
        transitionContext?.viewController(forKey: UITransitionContextViewControllerKey.from)?.view.layer.mask = nil
        if !isPresented{
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dissmissFinished"), object: nil, userInfo: ["width": width])
        }
    }
}
