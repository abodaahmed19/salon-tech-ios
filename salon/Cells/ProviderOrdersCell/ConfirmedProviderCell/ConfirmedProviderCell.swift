//
//  ConfirmedProviderCell.swift
//  salon
//
//  Created by AL Badr  on 6/30/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class ConfirmedProviderCell: UICollectionViewCell {
    @IBOutlet weak var statusImage: UIImageView!
    
    @IBOutlet weak var locationBtn: RoundedButton!
    @IBOutlet weak var chatBtn: RoundedButton!
    @IBOutlet weak var completeBtn: RoundedButton!
    @IBOutlet weak var finishBtn: RoundedButton!
    
    @IBOutlet weak var serviceNumber: UILabel!
    @IBOutlet weak var orderStatus: UILabel!
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var serviceDate: UILabel!
    @IBOutlet weak var serviceTime: UILabel!
    @IBOutlet weak var providerName: UILabel!
    @IBOutlet weak var paymentType: UILabel!
    @IBOutlet weak var totalService: UILabel!
    @IBOutlet weak var valueAdded: UILabel!
    @IBOutlet weak var paymentFeeOnArrival: UILabel!
    @IBOutlet weak var requiredAmount: UILabel!
    @IBOutlet weak var paidAmount: UILabel!
    
    @IBOutlet weak var paidAmountView: UIStackView!

    @IBOutlet weak var paymentFeeView: UIStackView!
    
    @IBOutlet weak var addValueView: UIStackView!
    
    @IBOutlet weak var sensitivity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        paymentFeeView.isHidden = true
        completeBtn.isHidden = true
        finishBtn.isHidden = true
        
    }
    
    func configCell(item: OrdersModel) {
        let sens = item.sensitivity
        
        let sensitiveText = "*I have sensitive skin or hair loss".localiz()
        let notSensitiveText = "*I don't have sensitive skin or hair loss".localiz()
        
        if sens == 0 {
            sensitivity.text = notSensitiveText
        }else {
            sensitivity.text = sensitiveText
        }
        
        serviceNumber.text = "\(item.reservation_id )"
        orderStatus.text = item.reservation_status 
        
        if item.reservation_details.isEmpty == false {
            if LanguageManger.shared.currentLanguage == .ar {
                serviceName.text = item.reservation_details[0].details_department_name ?? ""
            }else {
                serviceName.text = item.reservation_details[0].details_department_name_en ?? ""
            }
        }
        
        address.text = item.reservation_address 
        serviceDate.text = item.reservation_date 
        serviceTime.text = CalendarHelper.displayTime(item.reservation_time) 
        providerName.text = item.reservation_client_name 
        totalService.text = item.reservation_total + " " + ("SAR".localiz())
        requiredAmount.text = item.reservation_net + " " + ("SAR".localiz())
        paidAmount.text = item.reservation_money_pay + " " + ("SAR".localiz())
        
        let paidValue = item.reservation_money_pay
        
        if paidValue == "" || paidValue == "0" || paidValue == "0.0" || paidValue == "0.00" {
            paidAmountView.isHidden = true
        }else {
            paidAmountView.isHidden = false
        }

        let addValue = String(item.reservation_addedValue.rounded(toPlaces: 2))
        valueAdded.text = addValue + " " + ("SAR".localiz())

        if addValue == "0" || addValue == "0.0" || addValue == "0.00" {
            addValueView.isHidden = true
        }else {
            addValueView.isHidden = false
        }
        
        let providerEnd = item.reservation_if_provider_end
        
        if providerEnd {
            completeBtn.setTitle("Waiting for client Rate".localiz(), for: .normal)
            finishBtn.setTitle("Waiting for client Rate".localiz(), for: .normal)
            
            completeBtn.isEnabled = false
            finishBtn.isEnabled = false
        }
        else {
            completeBtn.setTitle("Receive the amount and complete the service".localiz(), for: .normal)
            finishBtn.setTitle("FINISH SERVICE".localiz(), for: .normal)
            
            completeBtn.isEnabled = true
            finishBtn.isEnabled = true
        }
            
        let payType = item.reservation_paymentType 
        
        if payType == PayMethods.ON_DELIVER {
            paymentFeeView.isHidden = false
            completeBtn.isHidden = false
            finishBtn.isHidden = true
            
            paymentType.text = "Pay on delivery".localiz()
            
//            let userSettings = Helper.getObjectDefault(key: UserDefault.userSettings) as? SettingsModel
//            let fee = userSettings?.every_service_money ?? "0"
            paymentFeeOnArrival.text = String(item.every_service_money) + " " + ("SAR".localiz())
            
        }else if payType == PayMethods.WALLET {
            paymentType.text = "Pay in points".localiz()
            paymentFeeView.isHidden = true
            completeBtn.isHidden = true
            finishBtn.isHidden = false
            
        }else if payType == PayMethods.BANK {
            paymentType.text = "Bank transfer".localiz()
            paymentFeeView.isHidden = true
            completeBtn.isHidden = true
            finishBtn.isHidden = false
            
        }else {
            paymentType.text = "Electronic Payment".localiz()
            paymentFeeView.isHidden = true
            completeBtn.isHidden = true
            finishBtn.isHidden = false
        }
        
        orderStatus.text = (providerEnd ? "Completed" : "Processing").localiz()
        orderStatus.textColor = Colors.greenColor
        statusImage.image = #imageLiteral(resourceName: "green")
    }
}
