//
//  BankTransferVC.swift
//  salon
//
//  Created by AL Badr  on 6/25/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import DropDown

class BankTransferVC: UIViewController {
    
    @IBOutlet weak var transferImageBtn: UIButton!
    @IBOutlet weak var accountBtn: UIButton!

    var imageList: [UIImage] = []
    
    fileprivate var presenter: BankTransferPresenter?
    fileprivate var commissionPresenter: PayCommissionPresenter?

    var reservationId: Int = 0
    var total: String = ""
    var commissionMoney: String = ""
    var fromOrders: Bool = false
    var fromCommission: Bool = false
    
    var accountsList: [BankAccountsModel] = []
    var accounts:[String] = []
    let accountsDropDown = DropDown()
    var selectedAccountId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = BankTransferPresenter(self)
        presenter?.BankAccounts()
        
        commissionPresenter = PayCommissionPresenter(self)
    }
    
    func setupAccountsDropDown() {
        accountBtn.setTitle("Choose bank account".localiz(), for: .normal)
        accounts.removeAll()
        
        for account in accountsList{
            accounts.append((account.bank_name ?? "" ) + " - " + (account.bank_number ?? "" ))
        }
        
        accountsDropDown.anchorView = accountBtn
        accountsDropDown.bottomOffset = CGPoint(x: 0, y: 0)
        accountsDropDown.dataSource = accounts
        accountsDropDown.selectionAction = { [unowned self](index, item) in
            let bankName = self.accountsList[index].bank_name ?? ""
            let bankNumber = self.accountsList[index].bank_number ?? ""

            self.accountBtn.setTitle(bankName + " - " + bankNumber, for: .normal)
            self.selectedAccountId = "\(self.accountsList[index].id ?? 0)"
        }
    }
    
    @IBAction func chooseAccountBtn_tapped(_ sender: Any) {
        accountsDropDown.show()
    }
    
    @IBAction func deleteImage(_ sender: Any) {
        imageList.removeAll()
        transferImageBtn.setImage(#imageLiteral(resourceName: "businessblack"), for: .normal)
    }
    
    @IBAction func transferImage_tapped(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let galaryImage = #imageLiteral(resourceName: "galaryblue")
        let galaryAction = UIAlertAction(title: "Photo Library".localiz(), style: .default, handler: openGalary)
        galaryAction.setValue(galaryImage, forKey: "image")
        
        let cameraImage = #imageLiteral(resourceName: "camerablue")
        let cameraAction = UIAlertAction(title: "Camera".localiz(), style: .default, handler: openCamera)
        cameraAction.setValue(cameraImage, forKey: "image")
        
        alert.addAction(galaryAction)
        alert.addAction(cameraAction)
        alert.addAction(UIAlertAction(title: "Cancel".localiz(), style: .cancel, handler: nil))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view //to set the source of your alert
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.maxY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alert, animated: true)
    }
    
    @objc func openGalary(alert: UIAlertAction!) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = false
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc func openCamera(alert: UIAlertAction!) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let vc = UIImagePickerController()
            vc.sourceType = .camera
            vc.cameraCaptureMode = .photo
            vc.modalPresentationStyle = .fullScreen
            vc.allowsEditing = false
            vc.delegate = self
            present(vc, animated: true)
        } else {
            Helper.showFloatAlert(title: "Camera is not Available".localiz(), type: .error)
        }
    }
    
    @IBAction func closeBtn_tapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendBtn_tapped(_ sender: Any) {
        if imageList.isEmpty {
            Helper.showFloatAlert(title: "Please, Upload Bank Transfer Image".localiz(), type: .error)
        }else {
            if selectedAccountId == "" {
                Helper.showFloatAlert(title: "Choose bank account".localiz(), type: .error)
            }else {
                if fromCommission {
                    SendBankTransferCommission()
                }else {
                    SendBankTransfer()
                }
            }
        }
    }
    
    func SendBankTransfer() {
        let parameters = ["reservation_id": reservationId,
                          "money_paid": total,
                          "bank_number_id": selectedAccountId,
                          "payment_way": PayMethods.BANK] as [String:Any]
        
        if fromOrders {
            presenter?.convertToBank(parameters: parameters, imageList: imageList)
        }else {
            makeReservation(paymentWay: PayMethods.BANK)
        }
    }
    
    func SendBankTransferCommission() {
        let parameters = ["reservation_id": reservationId,
                          "commission_money": commissionMoney,
                          "e_payment_response": "",
                          "bank_number_id": selectedAccountId,
                          "payment_way": PayMethods.BANK] as [String:Any]
        
        commissionPresenter?.payBankCommission(parameters: parameters, imageList: imageList)
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
                          "bank_number_id": selectedAccountId,
                          "sensitivity": reservationData?.sensitivity ?? 0,
                          "payment_way": paymentWay] as [String:Any]
        
        presenter?.makeReservation(parameters: parameters, imageList: imageList, serviceIDs: reservationData?.service_ids ?? [])
    }

}

extension BankTransferVC: BankTransferPresenterView {
    func getLievStatus(_ live: Bool) {
        
    }
    
    func getReservationSuccess(_ response: ReservationResponse) {
        Helper.showFloatAlert(title: "Reservation Done Successfully".localiz(), type: .success)

        self.dismiss(animated: true, completion: nil)

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "completeNotification"), object: nil, userInfo: nil)
    }
    
    func getReservationFailure(_ message: String) {
        Helper.showFloatAlert(title: message, type: .error)
    }
    
    func getPaymentDataSuccess(_ response: PaymentDataModel) {}
    
    func getPaymentDataStatus(_ enabled: Bool) {}
    
    func getPaymentDataFailure(_ message: String) {}
    
    func getBankAccountsSuccess(_ response: [BankAccountsModel]) {
        accountsList = response
        setupAccountsDropDown()
    }
    
    func getBankAccountsFailure(_ message: String) {
        accountsList.removeAll()
        accountBtn.setTitle("No Accounts".localiz(), for: .normal)
    }
    
    func getSendTransferSuccess(_ message: String) {
        Helper.showFloatAlert(title: message, type: .success)
        
        self.dismiss(animated: true, completion: nil)

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "completeNotification"), object: nil, userInfo: nil)
    }
    
    func getSendTransferFailure(_ message: String) {
        Helper.showFloatAlert(title: message, type: .error)
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), type: .error)
    }
}

extension BankTransferVC: PayCommissionPresenterView {
    func getPayCommissionSuccess(_ message: String) {
        Helper.showFloatAlert(title: message, type: .success)
        
        self.dismiss(animated: true, completion: nil)

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "walletNotification"), object: nil, userInfo: nil)
    }
    
    func getPayCommissionFailure(_ message: String) {
        Helper.showFloatAlert(title: message, type: .error)
    }
}


extension BankTransferVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                
        guard let image = info[.originalImage] as? UIImage else { return }
 
        imageList.removeAll()
        imageList.append(image)
        
        transferImageBtn.setImage(image, for: .normal)
        
        picker.dismiss(animated: true)

    }
}

