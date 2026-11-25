//
//  SelectionCell.swift
//  salon
//
//  Created by Mahmoud Elzaiady on 11/01/2023.
//  Copyright © 2023 ALBadr. All rights reserved.
//

import UIKit

class SelectionCell: UITableViewCell {
    @IBOutlet weak var nameLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(item: CitiesData) {
        if LanguageManger.shared.currentLanguage == .ar {
            nameLbl.text = item.city_name ?? ""
        }else {
            nameLbl.text = item.city_name_en ?? ""
        }
    }

}
