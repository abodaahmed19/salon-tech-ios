//
//  PayOnArrivalVC.swift
//  salon
//
//  Created by AL Badr  on 6/25/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class PayOnArrivalVC: UIViewController {
    
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var taxNumberLabel: UILabel!
    
    @IBOutlet weak var taxView: UIStackView!
    
    fileprivate var presenter: BankTransferPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = BankTransferPresenter(self)

        getSettings()
    }
    
    func getSettings() {
        let userSettings = Helper.getObjectDefault(key: UserDefault.userSettings) as? SettingsModel
        
        let everyService = userSettings?.every_service_money ?? 0.0
        let taxNumber = userSettings?.tax_number ?? ""
        let valueAdded = userSettings?.value_added ?? 0
        
        print("=====", everyService, " ==== ", taxNumber, " === ", valueAdded)

        feeLabel.text = ("We will add").localiz() + " "
        feeLabel.text! += String(everyService) + " "
        feeLabel.text! += ("SAR".localiz()) + " "
        feeLabel.text! += ("to your order").localiz()
        
        taxNumberLabel.text = taxNumber
        
        if everyService == 0.0 {
            feeLabel.isHidden = true
        }else {
            feeLabel.isHidden = false
        }
        
        if taxNumber == "" || valueAdded == 0 {
            taxView.isHidden = true
        }else {
            taxView.isHidden = false
        }
        
        let reservationData = Helper.getObjectDefault(key: UserDefault.userReservation) as? ReservationModel
        
        totalLabel.text = "\(reservationData?.services_total ?? 0)" + " " + ("SAR".localiz())
    }
    
    @IBAction func closeBtn_tapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func proceedBtn_tapped(_ sender: Any) {
        makeReservation(paymentWay: PayMethods.ON_DELIVER)
    }
    
    func makeReservation (paymentWay: String) {
        let reservationData = Helper.getObjectDefault(key: UserDefault.userReservation) as? ReservationModel
 
        let parameters = ["provider_id": reservationData?.provider_id ?? "",
                          "address": reservationData?.address ?? "",
                          "lat": reservationData?.lat ?? "",
                          "lon": reservationData?.lon ?? "",
                          "comment": "Comment",
                          "time": reservationData?.time ?? "",
                          "date": reservationData?.date ?? "",
                          "coupon_id": reservationData?.coupon_id ?? "",
                          "coupon_percentage": reservationData?.coupon_percentage ?? "",
                          "sensitivity": reservationData?.sensitivity ?? 0,
                          "payment_way": paymentWay] as [String:Any]
        
        presenter?.makeReservation(parameters: parameters, imageList: [], serviceIDs: reservationData?.service_ids ?? [])
    }
    
    
}

extension PayOnArrivalVC: BankTransferPresenterView {
    func getLievStatus(_ live: Bool) {
        
    }
    
    func getReservationSuccess(_ response: ReservationResponse) {
        self.dismiss(animated: true, completion: nil)

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "doneNotification"), object: nil, userInfo: nil)
    }
    
    func getReservationFailure(_ message: String) {
        Helper.showFloatAlert(title: message, type: .error)
    }
    
    func getPaymentDataSuccess(_ response: PaymentDataModel) {}
    
    func getPaymentDataStatus(_ enabled: Bool) {}
    
    func getPaymentDataFailure(_ message: String) {}
    
    func getBankAccountsSuccess(_ response: [BankAccountsModel]) {}
    
    func getBankAccountsFailure(_ message: String) {}
    
    func getSendTransferSuccess(_ message: String) {}
    
    func getSendTransferFailure(_ message: String) {}
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), type: .error)
    }
}

