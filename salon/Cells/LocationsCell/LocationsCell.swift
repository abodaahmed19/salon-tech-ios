//
//  LocationsCell.swift
//  salon
//
//  Created by AL Badr  on 6/18/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class LocationsCell: UICollectionViewCell {
    
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var chooseRadioBtn: RadioButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configCell(item: LocationsModel) {
        location.text = item.place_title ?? ""
    }
    
    func configDatesCell(item: NewDates) {
        location.text = CalendarHelper.displayDate(item.suggest_date ?? "")
            + " - " + CalendarHelper.displayTime(item.suggest_time)
     }
    
    func setSelected(selected: Bool) {
        if selected {
            chooseRadioBtn.isChecked = true
        }else {
            chooseRadioBtn.isChecked = false
        }
    }
    
    func isSelected(selected: Bool) {
        setSelected(selected: selected)
    }

}
