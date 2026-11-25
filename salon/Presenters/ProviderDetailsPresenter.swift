//
//  ProviderDetailsPresenter.swift
//  salon
//
//  Created by AL Badr  on 6/14/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation

protocol ProviderDetailsPresenterView: NSObjectProtocol {
    func getProvidersDetailsSuccess(_ response: ProviderDetailsData)
    func getSubDepartmentsSuccess(_ response: [Sub_departments])
    func getWorkPlacesSuccess(_ response: [Work_places])
    
    func AddToFavouriteSuccess(_ message: String)
    func AddToFavouriteFailure(_ message: String)
    
    func removeFromFavouriteSuccess(_ message: String)
    func removeFromFavouriteFailure(_ message: String)

    func showConnectionErrorMessage()
}

class ProviderDetailsPresenter {
    private weak var detailsView: ProviderDetailsPresenterView?
    private let api = GetInteractors()
    private let postAPI = PostInteractors()

    init(_ lView: ProviderDetailsPresenterView) {
        detailsView = lView
    }
    
    init() {}
    
    func detachView() {
        detailsView = nil
    }

    public func GetProviderDetails(provider_id: String) {
        api.getProviderDetails(provider_id: provider_id){ [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if response?.status == true {
                    self.detailsView?.getProvidersDetailsSuccess((response?.data)!)
                    self.detailsView?.getSubDepartmentsSuccess(response?.data?.sub_departments ?? [])
                    self.detailsView?.getWorkPlacesSuccess(response?.data?.work_places ?? [])
                }
            }else {
                self.detailsView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func addToFavourite(parameters: [String : Any]) {
        postAPI.addFavourites(parameters: parameters) { [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if response?.status ?? false {
                    self.detailsView?.AddToFavouriteSuccess(response?.message ?? "")
                }else {
                    self.detailsView?.AddToFavouriteFailure(response?.message ?? "")
                }
            }else {
                self.detailsView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func removeFromFavourite(provider_id: String) {
        postAPI.removeFavourites(provider_id: provider_id) { [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if response?.status ?? false {
                    self.detailsView?.removeFromFavouriteSuccess(response?.message ?? "")
                }else {
                    self.detailsView?.removeFromFavouriteFailure(response?.message ?? "")
                }
            }else {
                self.detailsView?.showConnectionErrorMessage()
            }
        }
    }
    
}
