//
//  RegisterPresenter.swift
//  salon
//
//  Created by AL Badr  on 5/20/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation
import UIKit

protocol RegisterPresenterView: NSObjectProtocol {
    func getSignupSuccess(_ response: LoginData)
    func getSignupFailure(_ message: String)

    func setCities(_ sections: [CitiesData])
    func setCitiesFailure()
    
    func setDistricts(_ sections: [DistrictsData])
    func setDistrictsFailure()
    
    func setDepartments(_ sections: [DepartmentsData])
    func setDepartmentsFailure()

    func showConnectionErrorMessage()
}

class RegisterPresenter {
    private weak var SignupView: RegisterPresenterView?
    private let authAPI = AuthInteractors()
    private let getAPI = GetInteractors()

    init(_ lView: RegisterPresenterView) {
        SignupView = lView
    }
    
    init() {}
    
    func detachView() {
        SignupView = nil
    }

    public func ClientSignup(parameters: [String:Any], profile: [UIImage], identity: [UIImage]) {
        authAPI.signAsClient(parameters: parameters, profileImage: profile, idImage: identity) { [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if(response?.status == true){
                    self.SignupView?.getSignupSuccess(response?.data ?? LoginData())
                }else {
                    self.SignupView?.getSignupFailure(response?.error?[0] ?? response?.message ?? "")
                }
            }else {
                self.SignupView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func ProviderSignup(parameters: [String : Any],
                               profileImage: [UIImage],
                               idImage: [UIImage],
                               serviceImage: [UIImage],
                               certificateImage: [UIImage],
                               itemsIDs: [Int],
                               districrsIDs: [Int],
                               videoString: String,
                               videoData: Data) {
        
        authAPI.signAsProvider(parameters: parameters,
                               profileImage: profileImage,
                               idImage: idImage,
                               serviceImage: serviceImage,
                               certificateImage: certificateImage,
                               itemsIDs: itemsIDs,
                               districrsIDs: districrsIDs,
                               videoString: videoString,
                               videoData: videoData){ [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if(response?.status == true){
                    self.SignupView?.getSignupSuccess(response?.data ?? LoginData())
                }else{
                    self.SignupView?.getSignupFailure(response?.error?[0] ?? response?.message ?? "")
                }
            }else {
                self.SignupView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func getCities(areaId: String) {
        getAPI.getCities(){ [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if(response?.status == true){
                    self.SignupView?.setCities(response?.data ?? [])
                }else{
                    self.SignupView?.setCitiesFailure()
                }
            }else {
                self.SignupView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func getDistricts(city_id: String) {
        getAPI.getDistricts(city_id: city_id){ [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if(response?.status == true){
                    self.SignupView?.setDistricts(response?.data ?? [])
                }else{
                    self.SignupView?.setDistrictsFailure()
                }
            }else {
                self.SignupView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func getDepartments() {
        getAPI.getDepartments(){ [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if(response?.status == true){
                    self.SignupView?.setDepartments(response?.data ?? [])
                }else{
                    self.SignupView?.setDepartmentsFailure()
                }
            }else {
                self.SignupView?.showConnectionErrorMessage()
            }
        }
    }
}
