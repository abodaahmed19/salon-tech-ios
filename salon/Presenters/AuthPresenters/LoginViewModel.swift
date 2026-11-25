//
//  LoginViewModel.swift
//  salon
//
//  Created by Mahmoud Elzaiady on 21/07/2022.
//  Copyright © 2022 ALBadr. All rights reserved.
//

import Foundation

class LoginViewModel {
    private let api = AuthInteractors()

    var user: Observable<LoginData?> = Observable(LoginData())
    var error: Observable<String?> = Observable("")
    var connectionError: Observable<String?> = Observable("")
    var loginStatus: Observable<Bool?> = Observable(false)

    func LoginStatus() {
        api.loginStatus(){ [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                self.loginStatus.value = response?.status ?? false
            }
        }
    }

    func Login(parameters: [String:Any]) {
        api.login(parameters: parameters){ [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if response?.status == true {
                    self.user.value = response?.data ?? LoginData()
                }else {
                    self.error.value = response?.message ?? response?.error?[0] ?? ""
                }
            }else {
                self.connectionError.value = connectionErrorMessage
            }
        }
    }
    
    func SocialLogin(parameters: [String:Any]) {
        api.socialLogin(parameters: parameters){ [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if response?.status == true {
                    self.user.value = response?.data ?? LoginData()
                }else {
                    self.error.value = response?.message ?? response?.error?[0] ?? ""
                }
            }else {
                self.connectionError.value = connectionErrorMessage
            }
        }
    }
}
