//
//  MyOrdersCell.swift
//  salon
//
//  Created by AL Badr  on 6/18/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class MyOrdersCell: UICollectionViewCell {
    @IBOutlet weak var statusImage: UIImageView!

    @IBOutlet weak var cancelBtn: RoundedButton!
    @IBOutlet weak var payAndRateBtn: RoundedButton!
    @IBOutlet weak var cancelReasonBtn: RoundedButton!
    
    @IBOutlet weak var trackBtn: RoundedButton!
    @IBOutlet weak var chatBtn: RoundedButton!
    @IBOutlet weak var trackView: UIStackView!
    
    @IBOutlet weak var bankBtn: RoundedButton!
    @IBOutlet weak var ePayBtn: RoundedButton!
    @IBOutlet weak var payView: UIStackView!
    
    @IBOutlet weak var dateCancel: RoundedButton!
    @IBOutlet weak var suggestDateBtn: RoundedButton!
    @IBOutlet weak var dateView: UIStackView!
    
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
    
    @IBOutlet weak var paymentFeeView: UIStackView!
    
    @IBOutlet weak var addValueView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        paymentFeeView.isHidden = true
    }
    
    func configCell(item: OrdersModel) {
        
        serviceNumber.text = "\(item.reservation_id)"
        orderStatus.text = item.reservation_status
        
        serviceName.text = item.reservation_details[0].details_department_name
        address.text = item.reservation_address
        serviceDate.text = item.reservation_date
        serviceTime.text = CalendarHelper.displayTime(item.reservation_time)
        providerName.text = item.reservation_provider_name
        totalService.text = item.reservation_total
        valueAdded.text = item.reservation_addValue
        requiredAmount.text = item.reservation_net
        
        let addValue = item.reservation_addValue
        
        if addValue == "" || addValue == "0" {
            addValueView.isHidden = true
        }else {
            addValueView.isHidden = false
        }

        let payType = item.reservation_paymentType
        
        if payType == PayMethods.ON_DELIVER {
            paymentFeeView.isHidden = false
            paymentType.text = "Pay on delivery".localiz()
            
            let userSettings = Helper.getObjectDefault(key: UserDefault.userSettings) as? SettingsModel
            let fee = String(userSettings?.every_service_money ?? 0.0)
            paymentFeeOnArrival.text = fee + " " + ("SAR".localiz())

        }else if payType == PayMethods.WALLET {
            paymentType.text = "Pay in points".localiz()
            paymentFeeView.isHidden = true
            
        }else if payType == PayMethods.BANK {
            paymentType.text = "Bank transfer".localiz()
            paymentFeeView.isHidden = true

        }else {
            paymentType.text = "Electronic Payment".localiz()
            paymentFeeView.isHidden = true
        }
        
        
        let status = item.reservation_status
        
        if status == OrderStatus.INITIAL {
            orderStatus.text = "Not Confirmed".localiz()
            orderStatus.textColor = Colors.blueColor
            statusImage.image = #imageLiteral(resourceName: "blue")

            trackView.isHidden = true
            payView.isHidden = true
            dateView.isHidden = true
            
            cancelReasonBtn.isHidden = true
            payAndRateBtn.isHidden = true
            
        }else if status == OrderStatus.DONE {
            orderStatus.text = "Confirmed".localiz()
            orderStatus.textColor = Colors.greenColor
            statusImage.image = #imageLiteral(resourceName: "green")
            
            dateView.isHidden = true
            cancelReasonBtn.isHidden = true
            
        }else if status == OrderStatus.CHANGE_TIME {
            orderStatus.text = "Change Appointement".localiz()
            orderStatus.textColor = Colors.blueColor
            statusImage.image = #imageLiteral(resourceName: "blue")

            trackView.isHidden = true
            payView.isHidden = true
            
            cancelReasonBtn.isHidden = true
            payAndRateBtn.isHidden = true
            cancelBtn.isHidden = true
            
        }else if status == OrderStatus.CANCELED {
            orderStatus.text = "Rejected".localiz()
            orderStatus.textColor = Colors.pinkColor
            statusImage.image = #imageLiteral(resourceName: "pink")

            trackView.isHidden = true
            payView.isHidden = true
            dateView.isHidden = true

            payAndRateBtn.isHidden = true
            cancelBtn.isHidden = true
        }else if status == OrderStatus.END {
            orderStatus.text = "Ended".localiz()
            orderStatus.textColor = .darkGray
            statusImage.image = #imageLiteral(resourceName: "gray")
            trackView.isHidden = true
            payView.isHidden = true
            dateView.isHidden = true
            
            payAndRateBtn.isHidden = true
            cancelBtn.isHidden = true
        }
        
        
    }
}
