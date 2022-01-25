//
//  UIView+Rounding.swift
//  ZAD
//
//  Created by Manar Magdy on 8/20/16.
//  Copyright © 2016 Manar Magdy. All rights reserved.
//

import UIKit


extension UIView {
    
    
    class func roundView(view: UIView, radius: CGFloat) {
        view.layer.cornerRadius = radius;
        view.clipsToBounds = true;
    }
    
    class func circularView(view: UIView) {
                view.layer.masksToBounds = false
        view.layer.cornerRadius = view.frame.size.width/2
        view.clipsToBounds = true
    }
    
    func setGradientBackground(view: UIView) {
        let colorTop =  UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds
        
        view.layer.insertSublayer(gradientLayer, at:0);
    }
    
    func setViewGradientBackground(view: UIView) {
        let colorTop =  UIColor(red: 78.0/255.0, green: 148.0/255.0, blue: 86.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 43.0/255.0, green: 90.0/255.0, blue: 132.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
       gradientLayer.locations = [0.0, 0.0]
        gradientLayer.frame = view.bounds
        
        view.layer.insertSublayer(gradientLayer, at:0);
    }
    
    
    

}
