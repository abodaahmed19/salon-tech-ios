//
//  MyPointsCell.swift
//  salon
//
//  Created by AL Badr  on 6/18/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class MyPointsCell: UICollectionViewCell {
    
    @IBOutlet weak var orderNumber: UILabel!
    @IBOutlet weak var deservedAmount: UILabel!
    @IBOutlet weak var paidamount: UILabel!
    @IBOutlet weak var earnedPoints: UILabel!
    @IBOutlet weak var statement: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func configCell(item: PointsModel) {
        orderNumber.text = String(item.point_reservation_id ?? 0)
        deservedAmount.text = (item.point_amount_required ?? "") + " " + ("SAR".localiz())
        paidamount.text = (item.point_amount_paid ?? "") + " " + ("SAR".localiz())
        earnedPoints.text = (item.point_practical_points ?? "") + " " + ("Point".localiz())
        statement.text = item.point_statement ?? ""
    }

}
