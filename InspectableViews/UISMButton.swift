//
//  UISMButton.swift
//  UICustomSwipeAnimation
//
//  Created by Siddhesh Mahadeshwar on 09/05/16.
//  Copyright © 2016 Siddhesh Mahadeshwar. All rights reserved.
//

import UIKit

@IBDesignable class UISMButton: UIButton {

    var buttonTopColor:UIColor?
    var buttonBottomColor:UIColor?
    let gradLayer = CAGradientLayer()
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    @IBInspectable var radiusValue: String?
        {
        didSet
        {
            if let radiusValue = radiusValue
            {
                if radiusValue == "yes"
                {
                    setupButton()

                }
            }
        }
    }

    func setupButton()
    {
        
        layer.cornerRadius = self.frame.size.height/2
        layer.masksToBounds = true
        
        gradLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        self.layer.addSublayer(gradLayer)
        gradLayer.colors = [UIColor(red: (255/255), green: (84/255), blue: (67/255), alpha: 1).CGColor, UIColor(red: (255/255), green: (148/255), blue: (73/255), alpha: 1).CGColor];
    }
    
    func updateGradColors()
    {
        guard let buttonTopColor = buttonTopColor, buttonBottomColor = buttonBottomColor else{return}
//        if let topColor = buttonTopColor, bottomColor = buttonBottomColor
//        {
            gradLayer.colors = [buttonTopColor, buttonBottomColor];
//        }
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
