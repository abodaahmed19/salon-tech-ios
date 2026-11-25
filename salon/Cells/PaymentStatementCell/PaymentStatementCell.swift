//
//  PaymentStatementCell.swift
//  salon
//
//  Created by AL Badr  on 6/18/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class PaymentStatementCell: UICollectionViewCell {
    @IBOutlet weak var orderNumber: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var type: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func configCell(item: StatementsModel) {
        orderNumber.text = "\(item.reservation_id ?? 0)"
        total.text = (item.reservation_net ?? "") + " " + ("SAR".localiz())
        
        if LanguageManger.shared.currentLanguage == .ar {
            type.text = item.reservation_payment_way ?? ""
        }else {
            let method = item.reservation_payment_way_en ?? ""
            
            if method == PayMethods.ON_DELIVER {
                type.text = "ON DELIVER"
                
            }else if method == PayMethods.E_PAYMENT {
                type.text = "Electronic Payment"
                
            }else if method == PayMethods.BANK {
                type.text = "Bank Transfer"
                
            }else if method == PayMethods.WALLET {
                type.text = "WALLET"
            }
        }
        
        
    }
    
    
}
