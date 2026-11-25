//
//  SubServiceCell.swift
//  salon
//
//  Created by AL Badr  on 6/14/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class SubServiceCell: UICollectionViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var discount: UILabel!
    @IBOutlet weak var serviceDescription: UILabel!

    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var check: CheckBox!
    
    @IBOutlet weak var discountView: UIView!
    
    @IBOutlet weak var discountPercent: UILabel!
    
    var type: String = ""
    var token: String = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let userDate = Helper.getObjectDefault(key: UserDefault.userData) as? LoginData
        type = userDate?.type ?? ""
        token = userDate?.api_token ?? ""
        
        image.layer.cornerRadius = 10
    }
    
    func configureCell(item: DepartmentsData) {
        if LanguageManger.shared.currentLanguage == .ar {
            name.text = item.department_name ?? ""
            serviceDescription.text = item.description_ar ?? ""
        }else {
            name.text = item.department_name_en ?? ""
            serviceDescription.text = item.description_en ?? ""
        }
        
        time.text = String(item.duration ??  0) + " " + ("Minutes".localiz())
        price.text = String(item.department_price ?? 0) + " " + ("SAR".localiz())
        discount.text = String(item.afterDiscount ?? 0) + " " + ("SAR".localiz())
        discountPercent.text = String(item.discount ?? 0) + "%"
        
        image.sd_setImage(with: URL(string: SITE_URL + (item.image ?? "")))
        
        if String(item.discount ?? 0.0) == "0.0" {
            discount.isHidden = true
            discountView.isHidden = true

        }else{
            price.textColor = .lightGray
            discount.isHidden = false
            discountView.isHidden = false
        }
        
        print("TYPE", type)
        
        if token == "" {
            check.isHidden = true
            check.isEnabled = false
        }else {
            if type == "provider" {
                check.isHidden = true
                check.isEnabled = false
                print("ghjghjghjghjghjghj")
            }else {
                check.isHidden = false
                check.isEnabled = true
            }
        }
        
    }
}
