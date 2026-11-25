//
//  RadioButton.swift
//  salon
//
//  Created by AL Badr  on 6/16/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation
import UIKit

class RadioButton: UIButton {
    let checkedImage = UIImage(systemName: "largecircle.fill.circle") ?? UIImage()
    let uncheckedImage = UIImage(systemName: "circle") ?? UIImage()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        layer.cornerRadius = 5.0
//        clipsToBounds = true
        
    }
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            accessibilityValue = isChecked ? SalonDesign.text("محدد", "Selected") : SalonDesign.text("غير محدد", "Not selected")
            if isChecked == true {
                self.setImage(checkedImage, for: .normal)
            } else {
                self.setImage(uncheckedImage, for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tintColor = SalonDesign.primary
        accessibilityTraits.insert(.button)
        self.addTarget(self, action: #selector(buttonClicked), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
