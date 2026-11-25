//
//  ReservationProvidersPresenter.swift
//  salon
//
//  Created by AL Badr  on 6/16/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation

protocol ReservationProvidersPresenterView: NSObjectProtocol {
    func getProvidersSuccess(_ response: [ChooseProviderModel])
    func getProviderFailure()
    
    func getReservationSuccess(_ response: ReservationResponse)
    func getReservationFailure(_ message: String)

    func showConnectionErrorMessage()
}

class ReservationProvidersPresenter {
    private weak var providerView: ReservationProvidersPresenterView?
    private let api = PostInteractors()
    
    init(_ lView: ReservationProvidersPresenterView) {
        providerView = lView
    }
    
    init() {}
    
    func detachView() {
        providerView = nil
    }

    public func getProviders(parameters: [String:Any]) {
        api.getCityProviders(parameters: parameters){ [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if(response?.status == true){
                    self.providerView?.getProvidersSuccess(response?.data ?? [])
                }else{
                    self.providerView?.getProviderFailure()
                }
            }else {
                self.providerView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func makeReservation(parameters: [String:Any]) {
        api.makeReservation(parameters: parameters, dImage: [], serviceIDs: []){ [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if(response?.status == true){
                    self.providerView?.getReservationSuccess(response?.data ?? ReservationResponse())
                }else{
                    self.providerView?.getReservationFailure(response?.message ?? "")
                }
            }else {
                self.providerView?.showConnectionErrorMessage()
            }
        }
    }
}
