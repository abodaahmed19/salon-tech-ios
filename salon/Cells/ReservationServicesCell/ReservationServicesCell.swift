//
//  ReservationServicesCell.swift
//  salon
//
//  Created by AL Badr  on 6/15/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class ReservationServicesCell: UICollectionViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var discount: UILabel!
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var delete: UIButton!
    
    @IBOutlet weak var discountView: UIView!
    
    @IBOutlet weak var discountPercent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        image.layer.cornerRadius = 10
    }
    
    func configureCell(item: DepartmentsData) {
        
        if LanguageManger.shared.currentLanguage == .ar {
            name.text = item.department_name ?? ""
        }else {
            name.text = item.department_name_en ?? ""
        }
        
        time.text = String(item.duration ?? 0) + " " + ("Minutes".localiz())
        price.text = String(item.department_price ?? 0) + " " + ("SAR".localiz())
        discount.text = String(item.afterDiscount ?? 0) + " " + ("SAR".localiz())

        image.sd_setImage(with: URL(string: SITE_URL + (item.image ?? "")))
        
        discountPercent.text = String(item.discount ?? 0) + "%"

        
        if String(item.discount ?? 0.0) == "0.0" {
            discount.isHidden = true
            discountView.isHidden = true

        }else{
            price.textColor = .lightGray
            discount.isHidden = false
            discountView.isHidden = false
        }
        
    }
}
