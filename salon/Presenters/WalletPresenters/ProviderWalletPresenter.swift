//
//  ProviderWalletPresenter.swift
//  salon
//
//  Created by AL Badr  on 7/9/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation

protocol ProviderWalletPresenterView : NSObjectProtocol {
    func setSuggestTimesSuccess(_ message: String)
    func setSuggestTimesFailure(_ message: String)
    
    func showConnectionErrorMessage()
}

class ProviderWalletPresenter {
    private weak var presenterView : ProviderWalletPresenterView?
    private let api = PostInteractors()
    
    init(_ pView: ProviderWalletPresenterView){
        presenterView = pView
    }
    
    init() {}
    
    func detachView() {
        presenterView = nil
    }
    
    public func suggestTimes(parameters: [String : Any]) {
        api.suggestTimes(parameters: parameters) { [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if response?.status ?? false {
                    self.presenterView?.setSuggestTimesSuccess(response?.message ?? "")
                }else {
                    self.presenterView?.setSuggestTimesFailure(response?.message ?? "")
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
}
