//
//  MyBalancePresenter.swift
//  salon
//
//  Created by AL Badr  on 6/22/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation

protocol MyBalancePresenterView : NSObjectProtocol {
    func setBalanceSuccess(_ balance: String)
    func setLastPageSuccess(_ lPage: Int)

    func setWalletSuccess(_ response: [WalletModel])
    func setWalletFailure()
    
    func setClientWalletSuccess(_ response: [WalletModel])
    func setProviderWalletSuccess(_ response: [WalletModel])

    func showConnectionErrorMessage()
}

class MyBalancePresenter {
    private weak var presenterView : MyBalancePresenterView?
    private let api = PostInteractors()
    
    init(_ pView: MyBalancePresenterView){
        presenterView = pView
    }
    
    init() {}
    
    func detachView() {
        presenterView = nil
    }
  
    public func getWalletBalance(page: String) {
        api.getWallet(page: page) { [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if response?.status ?? false {
                    self.presenterView?.setBalanceSuccess(response?.wallet ?? "")
                    self.presenterView?.setLastPageSuccess(response?.meta?.last_page ?? 0)
                    self.presenterView?.setWalletSuccess(response?.data ?? [])
                }else {
                    self.presenterView?.setWalletFailure()
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func getClientWallet() {
        api.getClientWalletTransactions() { [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if response?.status ?? false {

                    self.presenterView?.setClientWalletSuccess(response?.data ?? [])
                }else {
                    self.presenterView?.setWalletFailure()
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func getProviderWallet() {
        api.getProviderWalletTransactions() { [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if response?.status ?? false {
                    self.presenterView?.setProviderWalletSuccess(response?.data ?? [])
                }else {
                    self.presenterView?.setWalletFailure()
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
}
