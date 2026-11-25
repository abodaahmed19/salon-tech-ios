//
//  DuePresenter.swift
//  salon
//
//  Created by AL Badr  on 7/12/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation

protocol DuePresenterView : NSObjectProtocol {
    func getPaymentDataSuccess(_ response: PaymentDataModel)
    func getPaymentDataStatus(_ enabled: Bool)
    func getLievStatus(_ live: Bool)
    func getPaymentDataFailure(_ message: String)

    func setPayDueSuccess(_ response: [DueModel])
    func setRequestDueSuccess(_ response: [DueModel])
    
    func setPayableSuccess(_ payable: String)
    func setRequiredSuccess(_ required: String)

    func setLastPageSuccess(_ lPage: Int)

    func setDueFailure()
    
    func showConnectionErrorMessage()
}

class DuePresenter {
    private weak var presenterView : DuePresenterView?
    private let api = GetInteractors()
    private let getApi = GetInteractors()

    init(_ pView: DuePresenterView){
        presenterView = pView
    }
    
    init() {}
    
    func detachView() {
        presenterView = nil
    }
    
    public func PaymentData() {
        getApi.paymentData(){ [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if(response?.status == true){
                    self.presenterView?.getPaymentDataStatus(response?.enabled ?? false)
                    self.presenterView?.getLievStatus(response?.live ?? false)
                    self.presenterView?.getPaymentDataSuccess(response?.data ?? PaymentDataModel())
                }
                else{
                    self.presenterView?.getPaymentDataFailure(response?.message ?? response?.errorString ?? response?.error?[0] ?? "")
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
  
    public func payDue(page: String) {
        api.payableData(page: page) { [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if response?.status ?? false {
                    self.presenterView?.setLastPageSuccess(response?.meta?.last_page ?? 1)
                    self.presenterView?.setPayableSuccess(String(response?.payable ?? 0))
                    self.presenterView?.setPayDueSuccess(response?.data ?? [])
                }else {
                    self.presenterView?.setDueFailure()
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func requestDue(page: String) {
        api.paymentRequests(page: page) { [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if response?.status ?? false {
                    self.presenterView?.setLastPageSuccess(response?.meta?.last_page ?? 1)
                    let payment_required = (response?.payment_required ?? 0).rounded(toPlaces: 2)
                    self.presenterView?.setRequiredSuccess(String(payment_required))
                    self.presenterView?.setRequestDueSuccess(response?.data ?? [])
                }else {
                    self.presenterView?.setDueFailure()
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }

}
