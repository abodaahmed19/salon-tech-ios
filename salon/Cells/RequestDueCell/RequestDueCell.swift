//
//  RequestDueCell.swift
//  salon
//
//  Created by AL Badr  on 7/12/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class RequestDueCell: UICollectionViewCell {
    @IBOutlet weak var orderNumber: UILabel!
    @IBOutlet weak var serviceDate: UILabel!
    @IBOutlet weak var requiredAmount: UILabel!
    @IBOutlet weak var paidAmount: UILabel!
    @IBOutlet weak var totalServices: UILabel!
    @IBOutlet weak var valueAdded: UILabel!
    @IBOutlet weak var commission: UILabel!
    @IBOutlet weak var remainingBalance: UILabel!
    @IBOutlet weak var deservedAmount: UILabel!
    
    @IBOutlet weak var requestBtn: RoundedButton!
    
    let greenColor = UIColor(red: 0.00, green: 0.65, blue: 0.32, alpha: 1.00)

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configRequestCell(item: DueModel) {
        orderNumber.text = String(item.reservation_id ?? 0)
        serviceDate.text = item.reservation_date ?? ""
        requiredAmount.text = (item.reservation_money_required ?? "") + " " + ("SAR".localiz())
        paidAmount.text = (item.reservation_money_paid ?? "") + " " + ("SAR".localiz())
        totalServices.text = (item.reservation_total ?? "") + " " + ("SAR".localiz())
        valueAdded.text = (item.reservation_add_value ?? "") + " " + ("SAR".localiz())
        commission.text = (item.reservation_commission_money ?? "") + " " + ("SAR".localiz())
        remainingBalance.text = (item.reservation_rest ?? "") + " " + ("SAR".localiz())
        deservedAmount.text = (item.payable_to_provider ?? "") + " " + ("SAR".localiz())
        
        let admin_agree = item.admin_agree ?? ""
        let amount = Double(item.payable_to_provider ?? "") ?? 0
        if admin_agree == "" || amount <= 0 {
            requestBtn.isHidden = true
        }else {
            requestBtn.isHidden = false
        }
        
        if item.status == "paid" {
            requestBtn.isEnabled = false
            requestBtn.backgroundColor = .lightGray
            requestBtn.setTitle("Payment completed".localiz(), for: .normal)
            requestBtn.setTitleColor(.black, for: .normal)
        }else {
            requestBtn.isEnabled = true
            requestBtn.backgroundColor = greenColor
            requestBtn.setTitle("REQUEST DUE".localiz(), for: .normal)
            requestBtn.setTitleColor(.white, for: .normal)
        }
                
    }
}
