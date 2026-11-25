//
//  ConvertToPointsVC.swift
//  salon
//
//  Created by AL Badr  on 7/6/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class ConvertToPointsVC: UIViewController {
    
    var transactionId: Int = 0
    
    fileprivate var presenter: ConvertToPointsPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = ConvertToPointsPresenter(self)
    }
    
    @IBAction func cancelBtn_tapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmBtn_tapped(_ sender: Any) {
        let parameters = ["id" : transactionId] as [String : Any]
        
        presenter?.convertToPoints(parameters: parameters)
    }
    
}

extension ConvertToPointsVC: ConvertToPointsPresenterView {
    func setConvertToPointsSuccess(_ message: String) {
        Helper.showFloatAlert(title: message, type: .success)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "walletNotification"), object: nil, userInfo: nil)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func setConvertToPointsFailure(_ message: String) {
        Helper.showFloatAlert(title: message, type: .error)
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), type: .error)
    }
}
