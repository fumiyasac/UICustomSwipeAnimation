//
//  AnimationHandler.swift
//  UICustomSwipeAnimation
//
//  Created by Siddhesh Mahadeshwar on 09/05/16.
//  Copyright © 2016 Siddhesh Mahadeshwar. All rights reserved.
//

import UIKit

enum TransitionTo:Int {
    case Push
    case Pop
}
class AnimationHandler: NSObject,UIViewControllerAnimatedTransitioning
{
    var transitionTo: TransitionTo?
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
       
        return 0.4
    }
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        
        let containerView = transitionContext.containerView()
        let fromController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        if self.transitionTo == TransitionTo.Push
        {
            
            containerView?.addSubview(fromController!.view)
            containerView?.addSubview(toController!.view)
            toController?.view.frame = CGRectMake(0, CGRectGetMaxY(containerView!.frame), CGRectGetWidth(containerView!.frame), CGRectGetHeight(containerView!.frame));
            
            UIView.animateWithDuration(self .transitionDuration(transitionContext), animations: { 
                
                toController?.view.frame = CGRectMake(0, 0, CGRectGetWidth(containerView!.frame), CGRectGetHeight(containerView!.frame));
                
                }, completion: { (Bool) in
                    
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            })
        }
        else
        {
            let snapShot = fromController?.view.snapshotViewAfterScreenUpdates(false)
            containerView?.addSubview((toController?.view)!)
            containerView?.addSubview(snapShot!)
            fromController?.view.hidden = true
            
            UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: .BeginFromCurrentState, animations: {
                
                snapShot?.frame  = CGRectMake(0, CGRectGetHeight(containerView!.frame), CGRectGetWidth(containerView!.frame), CGRectGetHeight(containerView!.frame))
                
            }) { (Bool) in
                
                fromController!.view.hidden  = false;
                snapShot!.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            }
        }
    }
}
