//
//  RefundVC.swift
//  salon
//
//  Created by AL Badr  on 7/6/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class RefundVC: UIViewController {
    
    @IBOutlet weak var refundTF: UITextView!
    
    var transactionId: Int = 0
    
    fileprivate var presenter: RefundPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeyboard()
        
        if LanguageManger.shared.currentLanguage == .ar {
            refundTF.text = "How do you want to refund?".localiz()
            refundTF.textAlignment = .right
        }
        
        presenter = RefundPresenter(self)
    }
    
    func setupKeyboard() {
        let toolbar = setupKeyboardToolbar()
        refundTF.inputAccessoryView = toolbar
        refundTF.delegate = self
    }
    
    @IBAction func cancelBtn_tapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmBtn_tapped(_ sender: Any) {
        if refundTF.text == "" {
            Helper.showFloatAlert(title: "Please enter how do want to get refund".localiz(), type: .error)
        }else {
            sendRefundRequest()
        }
    }
    
    func sendRefundRequest() {
        let parameters = ["id" : transactionId,
                          "text": refundTF.text ?? ""] as [String : Any]
        
        presenter?.getRefund(parameters: parameters)
    }
    
}

extension RefundVC: RefundPresenterView {
    func setRefundSuccess(_ message: String) {
        Helper.showFloatAlert(title: message, type: .success)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "walletNotification"), object: nil, userInfo: nil)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func setRefundFailure(_ message: String) {
        Helper.showFloatAlert(title: message, type: .error)
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), type: .error)
    }
}

extension RefundVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if refundTF.text == "How do you want to refund?".localiz() {
            refundTF.text = ""
        }
        
        refundTF.textColor = .black
    }
}

