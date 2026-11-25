//
//  SubmitNewDatePresenter.swift
//  salon
//
//  Created by AL Badr  on 6/29/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation

protocol SubmitNewDatePresenterView : NSObjectProtocol {
    func setNewDateSuccess(_ message: String)
    func setNewDateFailure(_ message: String)
    
    func showConnectionErrorMessage()
}

class SubmitNewDatePresenter {
    private weak var presenterView : SubmitNewDatePresenterView?
    private let api = OrdersInteractors()
    
    init(_ pView: SubmitNewDatePresenterView){
        presenterView = pView
    }
    
    init() {}
    
    func detachView() {
        presenterView = nil
    }
    
    public func submitNewDate(parameters: [String : Any]) {
        api.submitAnotherDate(parameters: parameters) { [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if response?.status ?? false {
                    self.presenterView?.setNewDateSuccess(response?.message ?? "")
                }else {
                    self.presenterView?.setNewDateFailure(response?.message ?? "")
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
}
