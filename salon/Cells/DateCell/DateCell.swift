//
//  DateCell.swift
//  salon
//
//  Created by AL Badr  on 7/7/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class DateCell: UICollectionViewCell {
    
    @IBOutlet weak var suggestedTime: UILabel!
    @IBOutlet weak var removeBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configCell(item: NewDates) {
        suggestedTime.text = CalendarHelper.displayDate(item.suggest_date ?? "")
            + " - " + CalendarHelper.displayTime(item.suggest_time)
    }

}
