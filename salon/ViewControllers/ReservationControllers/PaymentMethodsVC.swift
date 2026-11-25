//
//  PaymentMethodsVC.swift
//  salon
//
//  Created by AL Badr  on 6/25/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class PaymentMethodsVC: UIViewController {

    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var ePaymentView: UIStackView!

    fileprivate var presenter: BankTransferPresenter?
    
    
    var reservationId: Int = 0
    var total: String = ""
    
    var url: String = ""
    var token: String = ""
    var environment: String = "" //test or live
    
    var method: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ePaymentView.isHidden = true
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        if LanguageManger.shared.currentLanguage == .ar {
            backBtn.image = #imageLiteral(resourceName: "forward")
        }
        
        let reservationData = Helper.getObjectDefault(key: UserDefault.userReservation) as? ReservationModel
        total = String(reservationData?.services_total ?? 0)

        NotificationCenter.default.addObserver(self, selector: #selector(GoToOrdersNotifications), name: NSNotification.Name(rawValue: "completeNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GoToOrdersNotifications), name: NSNotification.Name(rawValue: "doneNotification"), object: nil)
        
        presenter = BankTransferPresenter(self)
        presenter?.PaymentData()
    }
    
    @objc func GoToOrdersNotifications(notification: NSNotification){
        if notification.name.rawValue == "completeNotification" {
            Helper.removeKeyUserDefault(key: UserDefault.userReservation)
            
            let storyBoard = UIStoryboard(name: Storyboards.user, bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "MyOrdersVC") as! MyOrdersVC
            vc.title = "طلباتي"
            vc.fromRemoteNotifications = true
            self.navigationController?.pushViewController(vc, animated: true)
                        
        }else {
            let story = UIStoryboard(name: Storyboards.reservation, bundle: nil)
            let vc = story.instantiateViewController(withIdentifier:"ReservationDoneVC") as! ReservationDoneVC
            vc.modalPresentationStyle = .overCurrentContext
            vc.view.backgroundColor  = UIColor(white: 1, alpha: 0.5)
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func exitChat_tap(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
//        let alert = UIAlertController(title: "Chosen payment method will be: Pay When The Service Provider Arrives".localiz(), message:"", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Back to home screen".localiz(), style: .default, handler: backToHome))
//        alert.addAction(UIAlertAction(title: "Cancel".localiz(), style: .cancel, handler: nil))
//        self.present(alert, animated: true)
    }
    
    func backToHome(alert: UIAlertAction!) {
        Helper.ShowMainScreen(controller: self)
    }
    
    @IBAction func ePayBtn_tapped(_ sender: Any) {
        method = PayMethods.E_PAYMENT

        let storyboard = UIStoryboard(name: Storyboards.reservation, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "EPayVC") as! EPayVC
        vc.token = token
        vc.url = url
        vc.environment = environment
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func bankBtn_tapped(_ sender: Any) {
        method = PayMethods.BANK

        let storyboard = UIStoryboard(name: Storyboards.reservation, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "BankTransferVC") as! BankTransferVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor  = UIColor(white: 1, alpha: 0.5)
        
        vc.total = total
        vc.reservationId = reservationId
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func cashBtn_tapped(_ sender: Any) {
        method = PayMethods.ON_DELIVER
        
        let story = UIStoryboard(name: Storyboards.reservation, bundle: nil)
        let vc = story.instantiateViewController(withIdentifier:"PayOnArrivalVC") as! PayOnArrivalVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor  = UIColor(white: 1, alpha: 0.5)
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func pointsBtn_tapped(_ sender: Any) {
        method = PayMethods.WALLET
        makeReservation(paymentWay: PayMethods.WALLET)
    }
    
    func ReservationPayment(paymentWay: String) {
        let reservationData = Helper.getObjectDefault(key: UserDefault.userReservation) as? ReservationModel
        let reservationId =  reservationData?.reservation_id ?? 0
        let total = Int(reservationData?.services_total ?? 0)
        print("total", total)
        
        let parameters = ["reservation_id": reservationId,
                          "money_paid": total,
                          "payment_way": paymentWay] as [String:Any]
        
        presenter?.BankTransfer(parameters: parameters, imageList: [])
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

extension PaymentMethodsVC: BankTransferPresenterView {
    func getReservationSuccess(_ response: ReservationResponse) {
        if method == PayMethods.E_PAYMENT {
            let storyboard = UIStoryboard(name: Storyboards.reservation, bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: "EPayVC") as! EPayVC
            vc.reservationId =  response.reservation_id ?? 0
            vc.invoiceValue = response.net_without_deliver ?? 0
            vc.token = token
            vc.url = url
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if method == PayMethods.ON_DELIVER {
            let story = UIStoryboard(name: Storyboards.reservation, bundle: nil)
            let vc = story.instantiateViewController(withIdentifier:"PayOnArrivalVC") as! PayOnArrivalVC
            vc.modalPresentationStyle = .overCurrentContext
            vc.view.backgroundColor  = UIColor(white: 1, alpha: 0.5)
            self.navigationController?.present(vc, animated: true, completion: nil)
            
        }else {
            
            Helper.showFloatAlert(title: "Reservation Done Successfully".localiz(), type: .success)

            let story = UIStoryboard(name: Storyboards.reservation, bundle: nil)
            let vc = story.instantiateViewController(withIdentifier:"ReservationDoneVC") as! ReservationDoneVC
            vc.modalPresentationStyle = .overCurrentContext
            vc.view.backgroundColor  = UIColor(white: 1, alpha: 0.5)
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    
    func getReservationFailure(_ message: String) {
        Helper.showFloatAlert(title: message, type: .error)
    }
    
    func getPaymentDataSuccess(_ response: PaymentDataModel) {
        url = response.url ?? ""
        token = response.token ?? ""
    }
    
    func getPaymentDataStatus(_ enabled: Bool) {
        if enabled {
            ePaymentView.isHidden = false
        }else {
            ePaymentView.isHidden = true
        }
    }
    
    func getLievStatus(_ live: Bool) {
        if live {
            environment = "live"
        }else {
            environment = "test"
        }
    }
    
    func getPaymentDataFailure(_ message: String) {
        Helper.showFloatAlert(title: message, type: .error)
    }
    
    func getBankAccountsSuccess(_ response: [BankAccountsModel]) {}
    
    func getBankAccountsFailure(_ message: String) {}
    
    func getSendTransferSuccess(_ message: String) {
        Helper.showFloatAlert(title: message, type: .success)
        
        let story = UIStoryboard(name: Storyboards.reservation, bundle: nil)
        let vc = story.instantiateViewController(withIdentifier:"ReservationDoneVC") as! ReservationDoneVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor  = UIColor(white: 1, alpha: 0.5)
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    func getSendTransferFailure(_ message: String) {
        Helper.showFloatAlert(title: message, type: .error)
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), type: .error)
    }
}

