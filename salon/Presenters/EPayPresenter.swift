//
//  EPayPresenter.swift
//  salon
//
//  Created by Mahmoud Elzaiady on 15/03/2021.
//  Copyright © 2021 ALBadr. All rights reserved.
//

import Foundation
import UIKit

protocol EPayPresenterView: NSObjectProtocol {
    func getReservationSuccess(_ response: ReservationResponse)
    func getReservationFailure(_ message: String)
    
    func getPaymentSuccess(_ paymentableId: Int)
    func getConfirmPaymentSuccess(_ message: String)

    func getPayFailure(_ message: String)
    

    func showConnectionErrorMessage()
}

class EPayPresenter {
    private weak var presenterView: EPayPresenterView?
    private let api = PostInteractors()
    
    init(_ lView: EPayPresenterView) {
        presenterView = lView
    }
    
    init() {}
    
    func detachView() {
        presenterView = nil
    }
    
    public func makeReservation(parameters: [String:Any], imageList: [UIImage], serviceIDs: [Int]) {
        api.makeReservation(parameters: parameters, dImage: imageList, serviceIDs: serviceIDs){ [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if(response?.status == true){
                    self.presenterView?.getReservationSuccess(response?.data ?? ReservationResponse())
                }else{
                    self.presenterView?.getReservationFailure(response?.message ?? "")
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }

    public func payCommission(parameters: [String : Any]) {
        api.payBankCommission(parameters: parameters, dImage: []){ [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if(response?.status == true){
                    self.presenterView?.getPaymentSuccess(response?.paymentable_id ?? 0)
                }else{
                    self.presenterView?.getPayFailure(response?.message ?? "")
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func ePayment(parameters: [String : Any]) {
        api.ePayment(parameters: parameters){ [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if(response?.status == true){
                    self.presenterView?.getConfirmPaymentSuccess(response?.message ?? response?.msg ?? "")
                }else{
                    self.presenterView?.getPayFailure(response?.message ?? response?.msg ?? "")
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
    
    
}
