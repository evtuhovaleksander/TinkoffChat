//
//  Animator.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 27.11.2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import UIKit


class Animator:NSObject,CAAnimationDelegate{
    var image:UIImageView
    var point:CGPoint
    var parent:UIView
    var away:CGPoint
    var width:Int
    var height:Int
    
    init(_ point:CGPoint, _ parent:UIView,_ wx:Int,_ wy:Int) {
        self.point = point
        self.parent = parent
        
        self.image = UIImageView(frame: CGRect(x: point.x, y: point.y, width: 50, height: 50))
        self.image.image = UIImage.init(named: "Avatar")//backgroundColor = .red
        self.image.alpha = 0
        self.parent.addSubview(image)
        self.width = wx
        self.height = wy
        self.image.layer.cornerRadius = 50
        self.image.clipsToBounds = true
        
        
        self.away = CGPoint(x: -100, y: -100)
    }
    
    func start(){
        
        
        
        let duration = 1.0
        
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnimation.values = [0,1,0]
        scaleAnimation.duration = duration
        
        let opaAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opaAnimation.values = [0,1,0]
        opaAnimation.duration = duration
        
        
        
        let x =  Int(arc4random_uniform(UInt32(width)))
        let y =  Int(arc4random_uniform(UInt32(height)))
        
        let posAnimation = CABasicAnimation(keyPath: "position")
        posAnimation.fromValue = image.frame.origin
        posAnimation.toValue = CGPoint(x: x, y: y)
        posAnimation.duration = duration
        
        
        var group = CAAnimationGroup()
        group.animations = [scaleAnimation,opaAnimation,posAnimation]
        group.duration = duration
        group.delegate = self
        self.image.layer.add(group, forKey: "groupAnimation")
        
        
        CATransaction.setCompletionBlock {
         
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.image.removeFromSuperview()
    }
}
