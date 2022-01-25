//
//  GradientButton.swift
//  Almonaseq
//
//  Created by Nada El Hakim on 12/18/17.
//  Copyright © 2017 Nada El Hakim. All rights reserved.
//

import UIKit

class GradientButton: UIButton {
    var gradientLayer: CAGradientLayer
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
//    convenience init(gradientLayer: CALayer) {
//        self.gradientLayer = gradientLayer
//        //                super.init(frame: frame, gradientLayer: Utils.initializeGradient(view: self))
//        //        super.init(frame: frame, gradientLayer: Utils.initializeGradient(view: self))
//        self.init(gradientLayer: Utils.initializeGradient(view: self))
//    }
//    
    
    required init?(coder aDecoder: NSCoder) {
//        self.gradientLayer = Utils.initializeGradient(view: self)

        gradientLayer = CAGradientLayer()
        gradientLayer.colors = [gradientColor2 , gradientColor1 ]
        gradientLayer.locations = [0.0, 0.9]
        //gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        //gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        //        view.layer.addSublayer(gradientLayer)
        super.init(coder:aDecoder)
        gradientLayer.frame =  self.bounds
        gradientLayer.cornerRadius = 22;
         self.layer.insertSublayer(gradientLayer, at: 0)
        self.layer.cornerRadius = 22;
    }
   
    override func layoutSubviews() {
        super.layoutSubviews()
        self.gradientLayer.frame = self.bounds
    }

}
