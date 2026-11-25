//
//  DoneClientCell.swift
//  salon
//
//  Created by AL Badr  on 6/29/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class DoneClientCell: UICollectionViewCell {
    @IBOutlet weak var statusImage: UIImageView!

    @IBOutlet weak var cancelBtn: RoundedButton!
    @IBOutlet weak var payAndRateBtn: RoundedButton!

    @IBOutlet weak var trackBtn: RoundedButton!
    @IBOutlet weak var chatBtn: RoundedButton!
    @IBOutlet weak var trackView: UIStackView!
    
    @IBOutlet weak var bankBtn: RoundedButton!
    @IBOutlet weak var ePayBtn: RoundedButton!
    @IBOutlet weak var payView: UIStackView!
    
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
        providerName.text = item.reservation_provider_name
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
//        let follow = item.reservation_if_follow_open
        
        let reserveDate = item.reservation_date
        let reserveTime = item.reservation_time
        let reserveFullDate = reserveDate + " " + reserveTime
        let follow = Helper.isTrackingOpen(arrivalDate: reserveFullDate)
        
        
        let clientEnd = item.reservation_if_client_end
        
        if clientEnd {
            payAndRateBtn.setTitle("Waiting for provider Rate".localiz(), for: .normal)
            payAndRateBtn.isEnabled = false
        }
        else {
            payAndRateBtn.setTitle("Pay and Rate".localiz(), for: .normal)
            payAndRateBtn.isEnabled = true
        }

        if payType == PayMethods.ON_DELIVER {
            paymentFeeView.isHidden = false
            payView.isHidden = false
            
            paymentType.text = "Pay on delivery".localiz()
            
            //            let userSettings = Helper.getObjectDefault(key: UserDefault.userSettings) as? SettingsModel
            //            let fee = userSettings?.every_service_money ?? "0"
            paymentFeeOnArrival.text = String(item.every_service_money) + " " + ("SAR".localiz())
            
            checkTrackBtn(followOpen: follow)
            
        }else if payType == PayMethods.WALLET {
            paymentType.text = "Pay in points".localiz()
            paymentFeeView.isHidden = true
            payView.isHidden = true
            
            checkTrackBtn(followOpen: follow)
            
        }else if payType == PayMethods.BANK {
            paymentType.text = "Bank transfer".localiz()
            paymentFeeView.isHidden = true
            payView.isHidden = true
            
            checkTrackBtn(followOpen: follow)

        }else {
            paymentType.text = "Electronic Payment".localiz()
            paymentFeeView.isHidden = true
            payView.isHidden = true
            
            checkTrackBtn(followOpen: follow)
        }
        
        let providerEnded = item.reservation_if_provider_end
        cancelBtn.isHidden = providerEnded
        chatBtn.isHidden = providerEnded
        if providerEnded {
            payView.isHidden = true
            trackBtn.isHidden = true
            payAndRateBtn.setTitle((clientEnd ? "Completed" : "Rate").localiz(), for: .normal)
        }
        orderStatus.text = (providerEnded ? "Completed" : "Confirmed").localiz()
        orderStatus.textColor = Colors.greenColor
        statusImage.image = #imageLiteral(resourceName: "green")
    }
    
    func checkTrackBtn(followOpen: Bool) {
        if followOpen {
            trackBtn.isHidden = false
        }else {
            trackBtn.isHidden = true
        }
    }
}
