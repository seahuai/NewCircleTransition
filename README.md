#CircleTransition
![platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat)
![language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat)

##Demo
![gif](https://github.com/zhangsihuai/NewCircleTransition/blob/master/Demo.gif)


##Usage
###More details you can find in the project sample
###CircleTransitonButton is a SubClass of UIButton

	   let btn = CircleTransitonButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))

	   btn.backgroundColor = UIColor.black
	   
	   btn.presentedViewController = secondVC
	   
	   btn.delegate = self 
	   
 `UIViewController should observer CircleTransitionButtonDelegate`
 ```class FirstViewController: UIViewController, CircleTransitionButtonDelegate```
 
 


