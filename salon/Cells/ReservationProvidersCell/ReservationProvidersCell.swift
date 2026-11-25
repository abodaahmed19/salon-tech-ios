//
//  ReservationProvidersCell.swift
//  salon
//
//  Created by AL Badr  on 6/16/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class ReservationProvidersCell: UICollectionViewCell {
    
    @IBOutlet weak var providerImage: CircleImage!
    @IBOutlet weak var providerName: UILabel!
    @IBOutlet weak var providerAddress: UILabel!
    @IBOutlet weak var certifiedFrom: UILabel!
    @IBOutlet weak var providerRate: FloatRatingView!
    
    @IBOutlet weak var certifiedView: RoundRectView!
    @IBOutlet weak var chatBtn: UIButton!
    @IBOutlet weak var radioBtn: RadioButton!
    
    @IBOutlet weak var discountView: UIView!
    @IBOutlet weak var discountPercent: UILabel!
    
    @IBOutlet weak var verified: UIImageView!
    @IBOutlet weak var certifiedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func configCell(item: ChooseProviderModel){
        providerName.text = item.user_name ?? ""
        providerAddress.text = item.user_address ?? ""
        certifiedFrom.text = item.certifiedFrom ?? ""
                
        discountPercent.text = (item.discount ?? "") + "%"
        
        providerRate.rating = Double(item.rate ?? 0)
        
        providerImage.sd_setImage(with: URL(string: SITE_URL + (item.user_image ?? "")))
        
        let descount = item.discount ?? ""
        if descount == "0" || descount == "" {
            discountView.isHidden = true
        }else{
            discountView.isHidden = false
        }
        
        if certifiedFrom.text == "" {
            certifiedView.isHidden = true
            certifiedLabel.isHidden = true
        }else {
            certifiedView.isHidden = false
            certifiedLabel.isHidden = false
        }
        
        let verify = item.verified ?? false
        
        if verify {
            verified.isHidden = false
        }else {
            verified.isHidden = true
        }
        
    }
    
    func setSelected(selected: Bool) {
        if selected {
            radioBtn.isChecked = true
        }else {
            radioBtn.isChecked = false
        }
    }
    
    func isSelected(selected: Bool) {
        setSelected(selected: selected)
    }

}
