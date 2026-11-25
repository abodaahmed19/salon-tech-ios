//
//  SpecialistCell.swift
//  salon
//
//  Created by AL Badr  on 6/11/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class SpecialistCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var verifiedImage: UIImageView!

    @IBOutlet weak var servicesLabel: UILabel!
    @IBOutlet weak var rate: FloatRatingView!
    
    @IBOutlet weak var deleteBtn: UIButton!
    
    var subCategoriesArray: [String] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        
        image.layer.cornerRadius = image.frame.height / 2
        image.layer.borderColor = UIColor.black.cgColor
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 20
        contentView.layer.cornerCurve = .continuous
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = SalonDesign.line.cgColor
        title.font = SalonDesign.font(17, bold: true)
        title.textColor = SalonDesign.ink
        servicesLabel.font = SalonDesign.font(13)
        servicesLabel.textColor = SalonDesign.secondary
        image.tintColor = SalonDesign.primary
        image.backgroundColor = SalonDesign.primarySoft

    }
    
    func configureCell(item: Providers) {
        title.text = item.user_name ?? ""
        
        subCategoriesArray.removeAll()
        
        if item.sub_departments?.isEmpty == false {
            for department in item.sub_departments ?? [] {
                if LanguageManger.shared.currentLanguage == .ar {
                    subCategoriesArray.append(department.name ?? "")
                }else {
                    subCategoriesArray.append(department.name_en ?? "")
                }
            }
            
            servicesLabel.text = subCategoriesArray.joined(separator: "، ")
        }else {
            servicesLabel.text = ""
        }
        
        image.sd_setImage(with: URL(string: SITE_URL + (item.user_image ?? "")), placeholderImage: UIImage(systemName: "person.crop.circle"))
        rate.rating = Double(item.rate ?? 0)
        
        let verified = item.verified ?? false
        
        if verified {
            verifiedImage.isHidden = false
        }else {
            verifiedImage.isHidden = true
        }
    }
    
    func configFavouriteCell(item: FavouritesModel) {
        title.text = item.user_name ?? ""

        if item.sub_departments?.isEmpty == false {
            for department in item.sub_departments ?? [] {
                if LanguageManger.shared.currentLanguage == .ar {
                    subCategoriesArray.append(department.name ?? "")
                }else {
                    subCategoriesArray.append(department.name_en ?? "")
                }
            }
            
            servicesLabel.text = subCategoriesArray.joined(separator: "، ")
        }else {
            servicesLabel.text = ""
        }
        
        image.sd_setImage(with: URL(string: SITE_URL + (item.user_image ?? "")))
        rate.rating = Double(item.rate ?? 0)
        
        let verified = item.verified ?? false
        
        if verified {
            verifiedImage.isHidden = false
        }else {
            verifiedImage.isHidden = true
        }
    }

}
