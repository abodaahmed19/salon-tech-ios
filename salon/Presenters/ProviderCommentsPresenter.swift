//
//  ProviderCommentsPresenter.swift
//  salon
//
//  Created by AL Badr  on 6/15/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation

protocol ProviderCommentsPresenterView: NSObjectProtocol {
    func getProviderCommentsSuccess(_ response: [CommentsModel])
    func getProviderCommentsFailure()


    func showConnectionErrorMessage()
}

class ProviderCommentsPresenter {
    private weak var detailsView: ProviderCommentsPresenterView?
    private let api = GetInteractors()
    
    init(_ lView: ProviderCommentsPresenterView) {
        detailsView = lView
    }
    
    init() {}
    
    func detachView() {
        detailsView = nil
    }

    public func GetProviderComments(provider_id: String) {
        api.getProviderDetailsComments(provider_id: provider_id){ [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if response?.status == true {
                    self.detailsView?.getProviderCommentsSuccess(response?.data ?? [])
                }else {
                    self.detailsView?.getProviderCommentsFailure()
                }
            }else {
                self.detailsView?.showConnectionErrorMessage()
            }
        }
    }
    
}
