//
//  BankTransferPresenter.swift
//  salon
//
//  Created by AL Badr  on 6/25/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation
import UIKit

protocol BankTransferPresenterView: NSObjectProtocol {
    func getReservationSuccess(_ response: ReservationResponse)
    func getReservationFailure(_ message: String)
    
    func getPaymentDataSuccess(_ response: PaymentDataModel)
    func getPaymentDataStatus(_ enabled: Bool)
    func getLievStatus(_ live: Bool)
    func getPaymentDataFailure(_ message: String)
    
    func getBankAccountsSuccess(_ response: [BankAccountsModel])
    func getBankAccountsFailure(_ message: String)

    func getSendTransferSuccess(_ message: String)
    func getSendTransferFailure(_ message: String)

    func showConnectionErrorMessage()
}

class BankTransferPresenter {
    private weak var presenterView: BankTransferPresenterView?
    private let api = PostInteractors()
    private let getApi = GetInteractors()

    
    init(_ lView: BankTransferPresenterView) {
        presenterView = lView
    }
    
    init() {}
    
    func detachView() {
        presenterView = nil
    }
    
    public func makeReservation(parameters: [String:Any], imageList: [UIImage], serviceIDs: [Int]) {
        api.makeReservation(parameters: parameters, dImage: imageList, serviceIDs: serviceIDs){ [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if(response?.status == true){
                    self.presenterView?.getReservationSuccess(response?.data ?? ReservationResponse())
                }else{
                    self.presenterView?.getReservationFailure(response?.message ?? response?.errorString ?? response?.error?[0] ?? "")
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func PaymentData() {
        getApi.paymentData(){ [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if(response?.status == true){
                    self.presenterView?.getPaymentDataStatus(response?.enabled ?? false)
                    self.presenterView?.getLievStatus(response?.live ?? false)
                    self.presenterView?.getPaymentDataSuccess(response?.data ?? PaymentDataModel())
                }else{
                    self.presenterView?.getPaymentDataFailure(response?.message ?? response?.errorString ?? response?.error?[0] ?? "")
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func BankAccounts() {
        getApi.getBankAccounts(){ [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if(response?.status == true){
                    self.presenterView?.getBankAccountsSuccess(response?.data ?? [])
                }else{
                    self.presenterView?.getBankAccountsFailure(response?.message ?? response?.errorString ?? response?.error?[0] ?? "")
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func BankTransfer(parameters: [String : Any], imageList: [UIImage]) {
        api.sendBankTransfer(parameters: parameters, dImage: imageList){ [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if(response?.status == true){
                    self.presenterView?.getSendTransferSuccess(response?.message ?? "")
                }else{
                    self.presenterView?.getSendTransferFailure(response?.message ?? response?.errorString ?? response?.error?[0] ?? "")
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func convertToBank(parameters: [String : Any], imageList: [UIImage]) {
        api.convertToBank(parameters: parameters, dImage: imageList){ [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if(response?.status == true){
                    self.presenterView?.getSendTransferSuccess(response?.message ?? "")
                }else{
                    self.presenterView?.getSendTransferFailure(response?.message ?? response?.errorString ?? response?.error?[0] ?? "")
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
}
