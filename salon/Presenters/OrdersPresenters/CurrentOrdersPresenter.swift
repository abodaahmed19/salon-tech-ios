//
//  CurrentOrdersPresenter.swift
//  salon
//
//  Created by AL Badr  on 6/19/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//


import Foundation
import UIKit

protocol CurrentOrdersPresenterView: NSObjectProtocol {
    func getPaymentDataSuccess(_ response: PaymentDataModel)
    func getPaymentDataStatus(_ enabled: Bool)
    
    func getProviderOrdersSuccess(_ response: [OrdersModel])
    func getProviderOrdersFailure()
    
    func getMyOrdersSuccess(_ response: [OrdersModel])
    func getMyOrdersFailure()
    
    func removeOrderSuccess(_ message: String)
    func removeOrderFailure(_ message: String)
    
    func getApproveOrderSuccess(_ message: String)
    func getApproveOrderFailure(_ message: String)
    
    func setCashSuccess(_ message: String)
    func setCashFailure(_ message: String)
        
    func showConnectionErrorMessage()
}

class CurrentOrdersPresenter {
    private weak var myOrdersView: CurrentOrdersPresenterView?
    private let api = OrdersInteractors()
    private let getApi = GetInteractors()

    init(_ lView: CurrentOrdersPresenterView) {
        myOrdersView = lView
    }
    
    init() {}
    
    func detachView() {
        myOrdersView = nil
    }
    
    public func PaymentData() {
        getApi.paymentData(){ [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if(response?.status == true){
                    self.myOrdersView?.getPaymentDataStatus(response?.enabled ?? false)
                    self.myOrdersView?.getPaymentDataSuccess(response?.data ?? PaymentDataModel())
                }
            }else {
                self.myOrdersView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func getProviderOrders(reservation_id: String) {
        api.providerOrders(reservation_id: reservation_id){ [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if(response?.status == true){
                    self.myOrdersView?.getProviderOrdersSuccess((response?.data)!)
                }else{
                    self.myOrdersView?.getProviderOrdersFailure()
                }
            }else {
                self.myOrdersView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func getMyOrders(reservation_id: String) {
        api.myOrders(reservation_id: reservation_id){ [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if(response?.status == true){
                    self.myOrdersView?.getMyOrdersSuccess(response?.data ?? [])
                }else{
                    self.myOrdersView?.getMyOrdersFailure()
                }
            }else {
                self.myOrdersView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func deleteOrder(reservation_id: String) {
        api.removeOrder(reservation_id: reservation_id) { [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if response?.status ?? false {
                    self.myOrdersView?.removeOrderSuccess(response?.message ?? "")
                }else {
                    self.myOrdersView?.removeOrderFailure(response?.message ?? "")
                }
            }else {
                self.myOrdersView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func approveOrder(parameters: [String : Any]) {
        api.approveOrder(parameters: parameters){ [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if(response?.status == true){
                    self.myOrdersView?.getApproveOrderSuccess(response?.message ?? "")
                }else{
                    self.myOrdersView?.getApproveOrderFailure(response?.message ?? "")
                }
            }else {
                self.myOrdersView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func endCashOrder(parameters: [String : Any]) {
        api.endCashOrder(parameters: parameters) { [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if response?.status ?? false {
                    self.myOrdersView?.setCashSuccess(response?.message ?? "")
                }else {
                    self.myOrdersView?.setCashFailure(response?.message ?? "")
                }
            }else {
                self.myOrdersView?.showConnectionErrorMessage()
            }
        }
    }
 
    
}
