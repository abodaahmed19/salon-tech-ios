//
//  ServicesCell.swift
//  salon
//
//  Created by AL Badr  on 6/4/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class ServicesCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var selectedView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

//        image.layer.cornerRadius = image.frame.height / 2
//        image.layer.borderColor = UIColor.black.cgColor
        
        selectedView.isHidden = true
        title.font = SalonDesign.font(15, bold: true)
        title.textColor = SalonDesign.ink
        image.tintColor = SalonDesign.primary
        image.contentMode = .center
        image.layer.cornerRadius = 14
        image.clipsToBounds = true
        image.backgroundColor = SalonDesign.primarySoft

    }
    
    func configureCell(item: DepartmentsData) {
        if LanguageManger.shared.currentLanguage == .ar {
            title.text = item.department_name ?? ""
        }else {
            title.text = item.department_name_en ?? ""
        }
        
        let name = (item.department_name ?? "") + " " + (item.department_name_en ?? "").lowercased()
        let symbol: String
        if name.contains("صبغ") || name.contains("color") { symbol = "paintbrush.pointed" }
        else if name.contains("مكياج") || name.contains("make") { symbol = "paintbrush" }
        else if name.contains("شعر") || name.contains("hair") { symbol = "scissors" }
        else if name.contains("مساج") || name.contains("massage") { symbol = "hands.sparkles" }
        else if name.contains("بشر") || name.contains("skin") { symbol = "drop" }
        else { symbol = "sparkles" }
        let placeholder = UIImage(systemName: symbol, withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .light))
        image.contentMode = .center
        image.sd_setImage(with: URL(string: SITE_URL + (item.image ?? "")), placeholderImage: placeholder) { [weak self] loaded, _, _, _ in
            self?.image.contentMode = loaded == nil ? .center : .scaleAspectFill
        }
        
        item.selectedState
        ? setSelected(selected: true)
        : setSelected(selected: false)
    }
    
    func configureSubServiceCell(item: Sub_departments) {
        if LanguageManger.shared.currentLanguage == .ar {
            title.text = item.name ?? ""
        }else {
            title.text = item.name_en ?? ""
        }
        
        image.sd_setImage(with: URL(string: SITE_URL + (item.image ?? "")))
    }
 
    func setSelected(selected: Bool) {
        if selected {
            selectedView.isHidden = false
        }
        else {
            selectedView.isHidden = true
        }
    }

}
