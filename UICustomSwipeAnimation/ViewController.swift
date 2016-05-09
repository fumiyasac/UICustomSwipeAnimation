//
//  ViewController.swift
//  UICustomSwipeAnimation
//
//  Created by Siddhesh Mahadeshwar on 09/05/16.
//  Copyright © 2016 Siddhesh Mahadeshwar. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UINavigationControllerDelegate {

    @IBOutlet weak var smButton: UIButton!
    let animationHandler:AnimationHandler = AnimationHandler()
    let interactor:Intereactor = Intereactor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        startAnimation()
    }
    
    func startAnimation()
    {
        let pulseAnimation:CABasicAnimation = CABasicAnimation(keyPath: "transform.scale");
        pulseAnimation.duration = 2;
        pulseAnimation.fromValue = NSNumber(float: 0.9);
        pulseAnimation.toValue = NSNumber(float: 1.0);
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut);
        pulseAnimation.autoreverses = true;
        pulseAnimation.repeatCount = FLT_MAX;
        smButton.layer.addAnimation(pulseAnimation, forKey: "pulseAnimation")
    }
    
    func removeAnimation()
    {
        smButton.layer.removeAnimationForKey("pulseAnimation")
    }

    @IBAction func buttonClicked(sender: AnyObject) {
        performSegueWithIdentifier("PushToPicture", sender: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let ToController = segue.destinationViewController
        interactor.wireToViewController(ToController)
        self.navigationController?.delegate = self
        removeAnimation()
        
    }
    
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        return interactor.interactionInProgress ? interactor : nil
    }
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .Push
        {
            animationHandler.transitionTo = TransitionTo.Push
            return animationHandler
        }
        else
        {
            animationHandler.transitionTo = TransitionTo.Pop
            return animationHandler
        }
    }
}

