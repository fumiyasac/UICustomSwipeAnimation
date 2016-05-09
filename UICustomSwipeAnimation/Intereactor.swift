//
//  Intereactor.swift
//
//  Created by Siddhesh Mahadeshwar on 09/05/16.
//  Copyright © 2016 Siddhesh Mahadeshwar. All rights reserved.
//

import UIKit

public class Intereactor: UIPercentDrivenInteractiveTransition {

    var interactionInProgress = false
    
    private var shouldCompleteTransition = false
    private weak var viewController: UIViewController!

    var containerView:UIView?
    var fromController:UIViewController?
    var toController:UIViewController?
    var snapShot:UIView?
    var isdirectionUp:Bool?
    var contextData:UIViewControllerContextTransitioning?
    var translationYPoint:CGFloat?
    var gesture:UIPanGestureRecognizer?
    var progress:CGFloat?
    let animationTime:CFloat = 0.4
    internal func wireToViewController(viewController: UIViewController!) {
        
        self.viewController = viewController
        prepareGestureRecognizerInView(viewController.view)
    }
    
    private func prepareGestureRecognizerInView(view: UIView) {
        gesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        gesture!.minimumNumberOfTouches = 0
        view.addGestureRecognizer(gesture!)
    }
    
    func handleGesture(gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        
        let translation = gestureRecognizer.translationInView(gestureRecognizer.view!.superview!)
        translationYPoint = translation.y
        
        let velocity = gestureRecognizer.velocityInView(gestureRecognizer.view!.superview!)
        if velocity.y > 0
        {
            isdirectionUp = false
        }
        else{
            isdirectionUp = true
        }
        
        let verticalMovement = translation.y / (gestureRecognizer.view!.superview!).bounds.height
//        print("verticalMovement \(verticalMovement)")

        let progressPositiveValue = abs(verticalMovement)
//        print("progressPositiveValue \(progressPositiveValue)")

        progress = CGFloat(progressPositiveValue)
        
//        print("Progress \(progress)")
        
        switch gestureRecognizer.state {
            
        case .Began:
            interactionInProgress = true
            viewController.navigationController?.popViewControllerAnimated(true)
            
        case .Changed:

            shouldCompleteTransition = progress > 0.1
            updateInteractiveTransition(progress!)
            
        case .Cancelled:

            interactionInProgress = false
            cancelInteractiveTransition()
            
        case .Ended:
            interactionInProgress = false
            if !shouldCompleteTransition {
                cancelInteractiveTransition()
            } else {
                finishInteractiveTransition()
            }
            
        default:
            print("Unsupported")
        }
    }
    
    public override func startInteractiveTransition(transitionContext: UIViewControllerContextTransitioning) {
//        print("startInteractiveTransition")
        
        contextData = transitionContext
        containerView = transitionContext.containerView()
        fromController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        toController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        snapShot = fromController?.view.snapshotViewAfterScreenUpdates(false)
        containerView?.addSubview((toController?.view)!)
        containerView?.addSubview(snapShot!)
        fromController?.view.hidden = true
        
    }
    public override func updateInteractiveTransition(percentComplete: CGFloat) {
        super.updateInteractiveTransition(percentComplete)
//        print("updateInteractiveTransition")
        
        snapShot?.frame = CGRectMake(0, translationYPoint!,CGRectGetWidth(containerView!.frame) , CGRectGetHeight(containerView!.frame))
        
    }
    public override func finishInteractiveTransition() {
        super.finishInteractiveTransition()
//        print("finishInteractiveTransition")
        
        //formula.. total duration * 1 - remaining completion %.

        UIView.animateWithDuration(Double(animationTime)*(1 - Double(progress!)), delay: 0, options: .BeginFromCurrentState, animations: {
            
            if self.isdirectionUp! == true
            {
                self.snapShot?.frame  = CGRectMake(0, -CGRectGetHeight(self.snapShot!.frame), CGRectGetWidth(self.containerView!.frame), CGRectGetHeight(self.containerView!.frame))
            }
            else
            {
                self.snapShot?.frame  = CGRectMake(0, CGRectGetHeight(self.snapShot!.frame), CGRectGetWidth(self.containerView!.frame), CGRectGetHeight(self.containerView!.frame))
            }

            }) { (Bool) in
                
                self.fromController!.view.hidden  = false;
                self.snapShot!.removeFromSuperview()
                self.viewController.view.removeGestureRecognizer(self.gesture!)
                self.contextData!.completeTransition(!self.contextData!.transitionWasCancelled())
        }
    }
    
    public override func cancelInteractiveTransition() {
        super.cancelInteractiveTransition()
        
        UIView.animateWithDuration(Double(animationTime)*(1 - Double(progress!)), delay: 0, options: .BeginFromCurrentState, animations: {
            
            self.snapShot?.frame  = CGRectMake(0, 0, CGRectGetWidth(self.containerView!.frame), CGRectGetHeight(self.containerView!.frame))
            
        }) { (Bool) in
            

                self.fromController?.view.hidden  = false;
                self.snapShot?.removeFromSuperview()
                self.contextData?.completeTransition(false)
        }
    }
}
