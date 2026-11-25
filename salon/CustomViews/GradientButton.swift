//
//  GradientButton.swift
//  harajsahm
//
//  Created by AL Badr  on 4/23/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class GradientButton: UIButton {
    let gradientLayer = CAGradientLayer()
    
    @IBInspectable
    var topGradientColor: UIColor? {
        didSet {
            setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor)
        }
    }
    
    @IBInspectable
    var bottomGradientColor: UIColor? {
        didSet {
            setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor)
        }
    }
    
    @IBInspectable var cornerRaduis: CGFloat = 1.0
    
    @IBInspectable var borderColor: UIColor = UIColor.white

    @IBInspectable var borderWidth: CGFloat = 1.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = min(16, max(12, cornerRaduis))
        layer.cornerCurve = .continuous
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = layer.cornerRadius
        clipsToBounds = true
    }
    
    private func setGradient(topGradientColor: UIColor?, bottomGradientColor: UIColor?) {
        if let topGradientColor = topGradientColor, let bottomGradientColor = bottomGradientColor {
            gradientLayer.frame = bounds
            gradientLayer.colors = [topGradientColor.cgColor, bottomGradientColor.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
            gradientLayer.borderColor = layer.borderColor
            gradientLayer.borderWidth = layer.borderWidth
            gradientLayer.cornerRadius = layer.cornerRadius

            layer.insertSublayer(gradientLayer, at: 0)
        } else {
            gradientLayer.removeFromSuperlayer()
        }
    }
}
