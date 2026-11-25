//
//  RoundRectView.swift
//  JAK
//
//  Created by Zeinab Reda on 5/23/17.
//  Copyright © 2017 Zeinab Reda. All rights reserved.
//

import UIKit
import Foundation

@IBDesignable class RoundRectView: UIView {
    let gradientLayer = CAGradientLayer()

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerCurve = .continuous
        if layer.cornerRadius > 0 { layer.cornerRadius = min(20, max(12, layer.cornerRadius)) }
        if layer.borderWidth > 0 {
            layer.borderWidth = 1
            layer.borderColor = SalonDesign.line.cgColor
        }
        if layer.shadowOpacity > 0 {
            layer.shadowColor = SalonDesign.ink.cgColor
            layer.shadowOpacity = 0.04
            layer.shadowRadius = 8
            layer.shadowOffset = CGSize(width: 0, height: 3)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = layer.cornerRadius
    }

    @IBInspectable
    var topGradientColor: UIColor? {
        didSet {
            setGradientView(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor)
        }
    }
    
    @IBInspectable
    var bottomGradientColor: UIColor? {
        didSet {
            setGradientView(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor)
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.white {
         didSet {
             self.layer.borderColor = borderColor.cgColor
         }
     }

     @IBInspectable var borderWidth: CGFloat = 2.0 {
         didSet {
             self.layer.borderWidth = borderWidth
         }
     }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
   
    
    public func setGradientView(topGradientColor: UIColor?, bottomGradientColor: UIColor?) {
        if let topGradientColor = topGradientColor, let bottomGradientColor = bottomGradientColor {
            gradientLayer.frame = bounds
            gradientLayer.colors = [topGradientColor.cgColor, bottomGradientColor.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
            gradientLayer.borderColor = layer.borderColor
            gradientLayer.borderWidth = layer.borderWidth
            gradientLayer.cornerRadius = layer.cornerRadius

            layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    public func removeGradientView() {
        gradientLayer.removeFromSuperlayer()
    }
}
