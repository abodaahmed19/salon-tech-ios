//
//  DistrictsCell.swift
//  salon
//
//  Created by AL Badr  on 6/28/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class DistrictsCell: UICollectionViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configDistrictsCell(item: DistrictsData) {
        if LanguageManger.shared.currentLanguage == .ar {
            name.text = item.name_ar ?? ""
        }else {
            name.text = item.name_en ?? ""
        }
    }
    
    func configDepartmentsCell(item: DepartmentsData) {
        if LanguageManger.shared.currentLanguage == .ar {
            name.text = item.department_name ?? ""
        }else {
            name.text = item.department_name_en ?? ""
        }
    }
}
