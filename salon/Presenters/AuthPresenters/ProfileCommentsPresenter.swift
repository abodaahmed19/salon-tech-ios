//
//  ProfileCommentsPresenter.swift
//  salon
//
//  Created by AL Badr  on 7/14/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation

protocol ProfileCommentsPresenterView: NSObjectProtocol {
    func getProviderCommentsSuccess(_ response: [CommentsModel])
    func getClientCommentsSuccess(_ response: [CommentsModel])
    
    func getCommentsFailure()
    
    func showConnectionErrorMessage()
}

class ProfileCommentsPresenter {
    private weak var view: ProfileCommentsPresenterView?
    private let api = GetInteractors()

    init(_ lView: ProfileCommentsPresenterView) {
        view = lView
    }
    
    init() {}
    
    func detachView() {
        view = nil
    }
    
    func getProviderComments() {
        api.getProviderComments(){ [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if response?.status == true {
                    self.view?.getProviderCommentsSuccess(response?.data ?? [])
                }else {
                    self.view?.getCommentsFailure()
                }
            }else {
                self.view?.showConnectionErrorMessage()
            }
        }
    }
    
    func getClientComments() {
        api.getClientComments(){ [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if response?.status == true {
                    self.view?.getClientCommentsSuccess(response?.data ?? [])
                }else {
                    self.view?.getCommentsFailure()
                }
            }else {
                self.view?.showConnectionErrorMessage()
            }
        }
    }    
}
