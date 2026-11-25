//
//  RejectedProviderCell.swift
//  salon
//
//  Created by AL Badr  on 6/30/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class RejectedProviderCell: UICollectionViewCell {
    @IBOutlet weak var statusImage: UIImageView!
    
    @IBOutlet weak var rejectBtn: RoundedButton!
    
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
        rejectBtn.isHidden = true
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
        
        let payType = item.reservation_paymentType
        
        if payType == PayMethods.ON_DELIVER {
            paymentFeeView.isHidden = false
            paymentType.text = "Pay on delivery".localiz()
            
            //            let userSettings = Helper.getObjectDefault(key: UserDefault.userSettings) as? SettingsModel
            //            let fee = userSettings?.every_service_money ?? "0"
            paymentFeeOnArrival.text = String(item.every_service_money) + " " + ("SAR".localiz())
            
        }else if payType == PayMethods.WALLET {
            paymentFeeView.isHidden = true
            paymentType.text = "Pay in points".localiz()
            
        }else if payType == PayMethods.BANK {
            paymentFeeView.isHidden = true
            paymentType.text = "Bank transfer".localiz()
            
        }else {
            paymentFeeView.isHidden = true
            paymentType.text = "Electronic Payment".localiz()
        }
        
//        orderStatus.text = "Rejected".localiz()
        orderStatus.textColor = Colors.pinkColor
        statusImage.image = #imageLiteral(resourceName: "pink")
        
        let whoCancel = item.reservation_who_cancel
        let has_report = item.has_report
        
        print("whoCancel", whoCancel)
        print("has_report", has_report)

        if whoCancel == "client" {
            orderStatus.text = "Canceled by client".localiz()
            
        }else if whoCancel == "provider" {
            
            if has_report {
                orderStatus.text = "Complaint".localiz()
            }else {
                orderStatus.text = "Canceled by provider".localiz()
            }
 
        }else {
            orderStatus.text = "Canceled by admin".localiz()
            
        }
        
    }
}
