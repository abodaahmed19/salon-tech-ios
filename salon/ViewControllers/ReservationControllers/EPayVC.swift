//
//  EPayVC.swift
//  salon
//
//  Created by AL Badr  on 6/25/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import MFSDK
import SwiftyJSON

class EPayVC: UIViewController {
    
    @IBOutlet weak var ePayMethodsCV: UICollectionView!
    
    var methodsList: [MFPaymentMethod] = []
    var selectedPaymentMethod: Int = -1
    var invoiceValue: Double = 0
    
    var reservationId: Int = 0
    var fromCommission: Bool = false
    var fromOrders: Bool = false
    var responseString: String = ""
    
    var invoiceStatus: String = ""
    var transactionID: String = ""
    
    var url: String = ""
    var token: String = ""
    var environment: String = "" //test or live

    let pinkColor = UIColor(red: 0.96, green: 0.37, blue: 0.56, alpha: 1.00)
    
    private var isLoadingMethods = false
    private let methodsSpinner = UIActivityIndicatorView(style: .medium)
    private let methodsMessage = UILabel()
    private let retryMethodsButton = UIButton(type: .system)
    private let methodsRefresh = UIRefreshControl()

    fileprivate var presenter: EPayPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !fromOrders && !fromCommission {
            let reservationData = Helper.getObjectDefault(key: UserDefault.userReservation) as? ReservationModel
            invoiceValue = reservationData?.services_total ?? 0
        }

        initView()
        getPaymentMethods()
    }
    
    func initView() {
        presenter = EPayPresenter(self)

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        ePayMethodsCV.dataSource = self
        ePayMethodsCV.delegate = self
        ePayMethodsCV.register(UINib(nibName: "PaymentMethodsCell", bundle: nil), forCellWithReuseIdentifier: "PaymentMethodsCell")
        ePayMethodsCV.alwaysBounceVertical = true
        methodsRefresh.addTarget(self, action: #selector(retryPaymentMethods), for: .valueChanged)
        ePayMethodsCV.refreshControl = methodsRefresh

        methodsMessage.numberOfLines = 0
        methodsMessage.textAlignment = .center
        methodsMessage.font = .preferredFont(forTextStyle: .body)
        retryMethodsButton.setTitle("Retry".localiz(), for: .normal)
        retryMethodsButton.addTarget(self, action: #selector(retryPaymentMethods), for: .touchUpInside)
        let stack = UIStackView(arrangedSubviews: [methodsSpinner, methodsMessage, retryMethodsButton])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        let background = UIView()
        background.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: background.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -24)
        ])
        ePayMethodsCV.backgroundView = background
    }
    
    @objc private func retryPaymentMethods() {
        getPaymentMethods()
    }

    private func finishLoadingMethods(message: String? = nil) {
        isLoadingMethods = false
        methodsSpinner.stopAnimating()
        methodsRefresh.endRefreshing()
        methodsMessage.text = message
        retryMethodsButton.isHidden = message == nil
        ePayMethodsCV.backgroundView?.isHidden = message == nil
        ePayMethodsCV.reloadData()
    }

    func getPaymentMethods() {
        guard !isLoadingMethods, selectedPaymentMethod != -2 else {
            methodsRefresh.endRefreshing()
            return
        }
        isLoadingMethods = true
        selectedPaymentMethod = -1
        methodsList.removeAll()
        ePayMethodsCV.reloadData()
        ePayMethodsCV.backgroundView?.isHidden = false
        methodsMessage.text = "Loading payment methods".localiz()
        retryMethodsButton.isHidden = true
        methodsSpinner.startAnimating()
        guard !token.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              invoiceValue.isFinite, invoiceValue > 0 else {
            finishLoadingMethods(message: "Payment is unavailable. Please go back and try again.".localiz())
            return
        }

        var env: MFEnvironment = .test
        if environment == "live" {
            env = .live
        }else {
            env = .test
        }
        
        MFSettings.shared.configure(token: token, country: .saudiArabia, environment: env)
//        MFSettings.shared.configure(token: token, baseURL: url)

        let them = MFTheme(navigationTintColor: .white,
                           navigationBarTintColor: pinkColor,
                           navigationTitle: "Saloon Tech Payment".localiz(),
                           cancelButtonTitle: "Cancel".localiz())
        
        MFSettings.shared.setTheme(theme: them)
                
        let initiatePayment = MFInitiatePaymentRequest(invoiceAmount: Decimal(invoiceValue), currencyIso: .saudiArabia_SAR)
                    
        MFPaymentRequest.shared.initiatePayment(request: initiatePayment, apiLanguage: .arabic) { [weak self] (response) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch response {
                case .success(let initiatePaymentResponse):
                    self.methodsList = initiatePaymentResponse.paymentMethods ?? []
                    self.finishLoadingMethods(message: self.methodsList.isEmpty
                        ? "No payment methods available. Please try again.".localiz() : nil)
                case .failure:
                    self.finishLoadingMethods(message: "Unable to load payment methods. Check your connection and try again.".localiz())
                }
            }
        }
    }
  
    @IBAction func chooseBtn_tapped(_ sender: Any) {
        guard !isLoadingMethods else { return }
        if selectedPaymentMethod == -1 {
            Helper.showFloatAlert(title: "Choose payment method".localiz(), type: .error)
            return
        }
        
        if selectedPaymentMethod == -2 {
            Helper.showFloatAlert(title: "You can pay twice for the same order".localiz(), type: .error)
            return
        }

        if fromOrders || fromCommission {
            excutePayment()
        }else {
            makeReservation(paymentWay: PayMethods.E_PAYMENT)
        }
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
    
    func excutePayment() {        
        let request = MFExecutePaymentRequest(invoiceValue: Decimal(invoiceValue), paymentMethod: selectedPaymentMethod)
        request.displayCurrencyIso = .saudiArabia_SAR
    
        MFPaymentRequest.shared.executePayment(request: request, apiLanguage: .arabic) { [weak self] (response,invoiceId) in
            guard let self = self else { return }
            switch response {
            case .success(let executePaymentResponse):
                let transactionMirror = Mirror(reflecting: executePaymentResponse as Any)
                let properties = transactionMirror.children

                for property in properties {
                    self.responseString += "\(property.label ?? "") = \(property.value), "
                }
                
                self.invoiceStatus = executePaymentResponse.invoiceStatus ?? ""
                self.transactionID = executePaymentResponse.invoiceTransactions?[0].transactionID ?? ""
                
                if self.fromCommission {
                    self.CommissionPayment(paymentResponse: self.responseString)
                }else {
                    self.E_Payment(paymentable_id: self.reservationId)
                }

            case .failure(let failError):
                print(failError.errorDescription)
                
                Helper.showFloatAlert(title: "Payment Failed".localiz(), type: .error)
                
//                Helper.ShowMainScreen(controller: self)
                
            }
        }
    }
  
    func CommissionPayment(paymentResponse: String) {
        let parameters = ["reservation_id": reservationId,
                          "commission_money": invoiceValue,
                          "e_payment_response": paymentResponse,
                          "payment_way": PayMethods.E_PAYMENT] as [String:Any]
        
        presenter?.payCommission(parameters: parameters)
    }
    
    func E_Payment(paymentable_id: Int) {
        var payType = ""
        
        if fromCommission {
            payType = "commission"
        }else {
            payType = "reservation"
        }
        
        let parameters = ["paymentable_id": paymentable_id,
                          "amount": invoiceValue,
                          "full_response": responseString,
                          "status": invoiceStatus,
                          "transaction_id": transactionID,
                          "type": payType] as [String:Any]
        
        presenter?.ePayment(parameters: parameters)
    }
}

extension EPayVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width - 5) * 0.3, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return methodsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PaymentMethodsCell", for: indexPath) as?
            PaymentMethodsCell else {
                return UICollectionViewCell()
        }
        
        cell.configCell(item: methodsList[indexPath.row])
        
        cell.checkBtn.addTarget(self, action: #selector(ChooseMethod), for: UIControl.Event.touchUpInside)
        cell.checkBtn.tag = indexPath.row
        
        return cell
    }
    
    @objc func ChooseMethod(_ sender: UIButton) {
        selectedPaymentMethod = methodsList[sender.tag].paymentMethodId

        for i in 0..<methodsList.count {
            guard let cell = ePayMethodsCV.cellForItem(at: IndexPath(row: i, section: 0)) as? PaymentMethodsCell else { return }
            i == sender.tag ? cell.setSelected(selected: true) : cell.setSelected(selected: false)
        }
    }
    
}

extension EPayVC: EPayPresenterView {
    func getReservationSuccess(_ response: ReservationResponse) {
        reservationId =  response.reservation_id ?? 0
        invoiceValue = response.net_without_deliver ?? 0
        
        excutePayment()
    }
    
    func getReservationFailure(_ message: String) {
        Helper.showFloatAlert(title: message, type: .error)
    }
    
    func getPaymentSuccess(_ paymentableId: Int) {
        E_Payment(paymentable_id: paymentableId)
    }
    
    func getConfirmPaymentSuccess(_ message: String) {
        selectedPaymentMethod = -2
        
        Helper.removeKeyUserDefault(key: UserDefault.userReservation)

        if fromCommission {
            Helper.showFloatAlert(title: message, type: .success)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "walletNotification"), object: nil, userInfo: nil)
            self.navigationController?.popViewController(animated: true)

        }else {
//            UIApplication.shared.windows[0].rootViewController = UIStoryboard(
//                name:Storyboards.main,
//                bundle: nil
//            ).instantiateViewController(withIdentifier: "mainNC")
            
            Helper.ShowMainScreen(controller: self)
            Helper.showFloatAlert(title: message, type: .success)
        }
    }
    
    func getPayFailure(_ message: String) {
        Helper.showFloatAlert(title: message, type: .error)
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), type: .error)
    }
}
