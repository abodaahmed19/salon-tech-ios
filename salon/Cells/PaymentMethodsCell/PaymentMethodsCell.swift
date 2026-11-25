//
//  PaymentMethodsCell.swift
//  salon
//
//  Created by AL Badr  on 6/18/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import MFSDK

class PaymentMethodsCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var checkBtn: CheckBox!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func configCell(item: MFPaymentMethod) {
        image.sd_setImage(with: URL(string: item.imageUrl ?? ""))
    }
    
    func setSelected(selected: Bool) {
        if selected {
            checkBtn.isChecked = true
        }else {
            checkBtn.isChecked = false
        }
    }
    
    func isSelected(selected: Bool) {
        setSelected(selected: selected)
    }

}
