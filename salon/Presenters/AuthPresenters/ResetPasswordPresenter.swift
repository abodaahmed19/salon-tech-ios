//
//  ResetPasswordPresenter.swift
//  salon
//
//  Created by AL Badr  on 5/20/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation

protocol ResetPasswordPresenterView: NSObjectProtocol {
    func getNewPasswordSuccess(_ message: String)

    func getNewPasswordFailure(_ message: String)

    func showConnectionErrorMessage()
}

class ResetPasswordPresenter {
    private weak var resetPasswordView: ResetPasswordPresenterView?
    private let authAPI = AuthInteractors()
    
    init(_ uView: ResetPasswordPresenterView) {
        resetPasswordView = uView
    }
    
    init() {}
    
    func detachView() {
        resetPasswordView = nil
    }

    public func ResetPassword(parameters: [String:Any]) {
        authAPI.getNewPassword(parameters: parameters){ [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if(response?.status == true){
                    self.resetPasswordView?.getNewPasswordSuccess(response?.message ?? "")
                }else{
                    self.resetPasswordView?.getNewPasswordFailure(response?.message ?? "")
                }
            }else {
                self.resetPasswordView?.showConnectionErrorMessage()
            }
        }
    }
    
}
