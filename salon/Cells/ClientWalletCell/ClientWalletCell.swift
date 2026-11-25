//
//  ClientWalletCell.swift
//  salon
//
//  Created by AL Badr  on 7/6/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class ClientWalletCell: UICollectionViewCell {
    
    @IBOutlet weak var orderNumber: UILabel!
    @IBOutlet weak var orderStatus: UILabel!

    @IBOutlet weak var deservedAmount: UILabel!
    @IBOutlet weak var paidamount: UILabel!
    @IBOutlet weak var refundAmount: UILabel!
    
    @IBOutlet weak var refundBtn: RoundedButton!
    @IBOutlet weak var convertBtn: RoundedButton!
    
    var CONVERT_TO_POINTS = "convert_to_points"
    var CASH_BACK = "account_recovery"
    var WAITING = "wait"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configCell(item: WalletModel) {
        orderNumber.text = String(item.transaction_reservation_id ?? 0)
        
        if item.transaction_status ?? "" == WAITING {
            orderStatus.text = "Waiting".localiz()
            
            refundBtn.isHidden = false
            convertBtn.isHidden = false

        }else if item.transaction_status ?? "" == CASH_BACK {
            orderStatus.text = "Cash Back".localiz()
            
            refundBtn.isHidden = true
            convertBtn.isHidden = true
            
        }else if item.transaction_status ?? "" == CONVERT_TO_POINTS {
            orderStatus.text = "Convert To Points".localiz()
            
            refundBtn.isHidden = true
            convertBtn.isHidden = true
        }
        

        deservedAmount.text = (item.reservation?.reservation_net ?? "") + " " + ("SAR".localiz())
        paidamount.text = (item.reservation?.reservation_money_pay ?? "") + " " + ("SAR".localiz())
        refundAmount.text = (item.reservation?.reservation_rest ?? "") + " " + ("SAR".localiz())
    }
}
