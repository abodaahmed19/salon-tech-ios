//
//  ChangePasswordPresenter.swift
//  salon
//
//  Created by AL Badr  on 5/20/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation

protocol ChangePasswordPresenterView: NSObjectProtocol {
    func getChangePasswordSuccess(_ message: String)

    func getChangePasswordFailure(_ message: String)

    func showConnectionErrorMessage()
}

class ChangePasswordPresenter {
    private weak var changePasswordView: ChangePasswordPresenterView?
    private let authAPI = AuthInteractors()
    
    init(_ uView: ChangePasswordPresenterView) {
        changePasswordView = uView
    }
    
    init() {}
    
    func detachView() {
        changePasswordView = nil
    }

    public func ChangePassword(parameters: [String:Any]) {
        authAPI.changePassword(parameters: parameters){ [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if(response?.status == true){
                    self.changePasswordView?.getChangePasswordSuccess(response?.message ?? "")
                }else{
                    self.changePasswordView?.getChangePasswordFailure(response?.message ?? "")
                }
            }else {
                self.changePasswordView?.showConnectionErrorMessage()
            }
        }
    }

}
