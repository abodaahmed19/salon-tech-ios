//
//  RefundPresenter.swift
//  salon
//
//  Created by AL Badr  on 7/6/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation

protocol RefundPresenterView : NSObjectProtocol {
    func setRefundSuccess(_ message: String)
    func setRefundFailure(_ message: String)
    
    func showConnectionErrorMessage()
}

class RefundPresenter {
    private weak var presenterView : RefundPresenterView?
    private let api = PostInteractors()
    
    init(_ pView: RefundPresenterView){
        presenterView = pView
    }
    
    init() {}
    
    func detachView() {
        presenterView = nil
    }
    
    public func getRefund(parameters: [String : Any]) {
        api.getRefund(parameters: parameters) { [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if response?.status ?? false {
                    self.presenterView?.setRefundSuccess(response?.message ?? "")
                }else {
                    self.presenterView?.setRefundFailure(response?.message ?? "")
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
}
