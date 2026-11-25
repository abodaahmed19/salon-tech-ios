//
//  ConfirmDuePresenter.swift
//  salon
//
//  Created by AL Badr  on 7/12/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//


import Foundation

protocol ConfirmDuePresenterView : NSObjectProtocol {
    func setConfirmDueSuccess(_ message: String)
    func setConfirmDueFailure(_ message: String)
    
    func showConnectionErrorMessage()
}

class ConfirmDuePresenter {
    private weak var presenterView : ConfirmDuePresenterView?
    private let api = PostInteractors()
    
    init(_ pView: ConfirmDuePresenterView){
        presenterView = pView
    }
    
    init() {}
    
    func detachView() {
        presenterView = nil
    }
  
    public func confirmPayment(parameters: [String : Any]) {
        api.confirmPaymentFromAdmin(parameters: parameters) { [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if response?.status ?? false {
                    self.presenterView?.setConfirmDueSuccess(response?.message ?? "")
                }else {
                    self.presenterView?.setConfirmDueFailure(response?.message ?? "")
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }


}
