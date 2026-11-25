//
//  EditProfilePresenter.swift
//  salon
//
//  Created by AL Badr  on 5/20/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation
import UIKit

protocol EditProfilePresenterView: NSObjectProtocol {
    func getProviderDataSuccess(_ response: LoginData)
    func getClientDataSuccess(_ response: LoginData)

    func getUpdateProfileSuccess(_ response: PostModel)
    func getUpdateProfileFailure(_ message: String)

    func setCities(_ sections: [CitiesData])
    func setCitiesFailure()
    
    func setDistricts(_ sections: [DistrictsData])
    func setDistrictsFailure()
    
    func setDepartments(_ sections: [DepartmentsData])
    func setDepartmentsFailure()
    
    func getDeleteAccountSuccess(_ message: String)
    func getDeleteAccountFailure(_ message: String)

    func showConnectionErrorMessage()
}

class EditProfilePresenter {
    private weak var view: EditProfilePresenterView?
    private let authAPI = AuthInteractors()
    private let getAPI = GetInteractors()

    init(_ lView: EditProfilePresenterView) {
        view = lView
    }
    
    init() {}
    
    func detachView() {
        view = nil
    }
    
    func deleteAccount() {
        authAPI.deleteAccount() { [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if response?.status == true {
                    self.view?.getDeleteAccountSuccess(response?.message ?? "")
                }else {
                    self.view?.getDeleteAccountFailure(response?.message ?? "")
                }
            }else {
                self.view?.showConnectionErrorMessage()
            }
        }
    }
    
    func getClientData() {
        authAPI.getClientProfile() { [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if(response?.status == true){
                    self.view?.getClientDataSuccess(response?.data ?? LoginData())
                }
            }else {
                self.view?.showConnectionErrorMessage()
            }
        }
    }
    
    func getProviderData() {
        authAPI.getProviderProfile() { [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if(response?.status == true){
                    self.view?.getProviderDataSuccess(response?.data ?? LoginData())
                }
            }else {
                self.view?.showConnectionErrorMessage()
            }
        }
    }
    
    func updateClient(parameters: [String:Any], profile: [UIImage], identity: [UIImage]) {
        authAPI.updateProfileClient(parameters: parameters, profileImage: profile, idImage: identity) { [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if(response?.status == true){
                    self.view?.getUpdateProfileSuccess(response ?? PostModel())
                }else {
                    self.view?.getUpdateProfileFailure(response?.message ?? "")
                }
            }else {
                self.view?.showConnectionErrorMessage()
            }
        }
    }
    
    func updateProvider(parameters: [String : Any],
                               profileImage: [UIImage],
                               idImage: [UIImage],
                               serviceImage: [UIImage],
                               certificateImage: [UIImage],
                               itemsIDs: [Int],
                               districrsIDs: [Int],
                               videoString: String,
                               videoData: Data) {
        
        authAPI.updateProfileProvider(parameters: parameters,
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
                    self.view?.getUpdateProfileSuccess(response ?? PostModel())
                }else{
                    self.view?.getUpdateProfileFailure(response?.error?[0] ?? response?.message ?? "")
                }
            }else {
                self.view?.showConnectionErrorMessage()
            }
        }
    }
    
    func getCities(areaId: String) {
        getAPI.getCities(){ [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if(response?.status == true){
                    self.view?.setCities(response?.data ?? [])
                }else{
                    self.view?.setCitiesFailure()
                }
            }else {
                self.view?.showConnectionErrorMessage()
            }
        }
    }
    
    func getDistricts(city_id: String) {
        getAPI.getDistricts(city_id: city_id){ [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if(response?.status == true){
                    self.view?.setDistricts(response?.data ?? [])
                }else{
                    self.view?.setDistrictsFailure()
                }
            }else {
                self.view?.showConnectionErrorMessage()
            }
        }
    }
    
    func getDepartments() {
        getAPI.getDepartments(){ [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if(response?.status == true){
                    self.view?.setDepartments(response?.data ?? [])
                }else{
                    self.view?.setDepartmentsFailure()
                }
            }else {
                self.view?.showConnectionErrorMessage()
            }
        }
    }
}
