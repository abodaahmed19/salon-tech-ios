//
//  LoginPresenter.swift
//  salon
//
//  Created by AL Badr  on 5/20/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation

protocol LoginPresenterView: NSObjectProtocol {
    func getLoginStatus(_ response: Bool)

    func getLoginSuccess(_ response: LoginData)
    func getLoginFailure(_ message: String)

    func showConnectionErrorMessage()
}

class LoginPresenter {
    private weak var loginView: LoginPresenterView?
    private let authAPI = AuthInteractors()
    
    init(_ lView: LoginPresenterView) {
        loginView = lView
    }
    
    init() {}
    
    func detachView() {
        loginView = nil
    }
    
    public func LoginStatus() {
        authAPI.loginStatus(){ [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                self.loginView?.getLoginStatus(response?.status ?? false)
            }
        }
    }

    public func Login(parameters: [String:Any]) {
        authAPI.login(parameters: parameters){ [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if(response?.status == true){
                    self.loginView?.getLoginSuccess((response?.data)!)
                }else{
                    if (response?.error ?? []).isEmpty {
                        self.loginView?.getLoginFailure(response?.message ?? "")
                    }else {
                        self.loginView?.getLoginFailure(response?.error?[0] ?? "")
                    }
                }
            }else {
                self.loginView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func SocialLogin(parameters: [String:Any]) {
        authAPI.socialLogin(parameters: parameters){ [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if(response?.status == true){
                    self.loginView?.getLoginSuccess((response?.data)!)
                }else{
                    if (response?.error ?? []).isEmpty {
                        self.loginView?.getLoginFailure(response?.message ?? "")
                    }else {
                        self.loginView?.getLoginFailure(response?.error?[0] ?? "")
                    }
                }
            }else {
                self.loginView?.showConnectionErrorMessage()
            }
        }
    }

    
}
