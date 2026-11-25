//
//  ObjectionPresenter.swift
//  salon
//
//  Created by Mahmoud Elzaiady on 17/04/2023.
//  Copyright © 2023 ALBadr. All rights reserved.
//

import Foundation

protocol ObjectionPresenterView: NSObjectProtocol {
    func getCommentsObjectionSuccess(_ response: String)
    func getCommentsObjectionFailure(_ response: String)
        
    func showConnectionErrorMessage()
}

class ObjectionPresenter {
    private weak var view: ObjectionPresenterView?
    private let api = PostInteractors()

    init(_ lView: ObjectionPresenterView) {
        view = lView
    }
    
    init() {}
    
    func detachView() {
        view = nil
    }

    func objectionCommentClient(comment_id: String, parameters: [String : Any]) {
        api.clientCommentObjection(comment_id: comment_id, parameters: parameters) { [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if response?.status == true {
                    self.view?.getCommentsObjectionSuccess(response?.message ?? "")
                }else {
                    self.view?.getCommentsObjectionFailure(response?.message ?? "")
                }
            }else {
                self.view?.showConnectionErrorMessage()
            }
        }
    }
    
    func objectionCommentProvider(comment_id: String, parameters: [String : Any]) {
        api.providerCommentObjection(comment_id: comment_id, parameters: parameters) { [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if response?.status == true {
                    self.view?.getCommentsObjectionSuccess(response?.message ?? "")
                }else {
                    self.view?.getCommentsObjectionFailure(response?.message ?? "")
                }
            }else {
                self.view?.showConnectionErrorMessage()
            }
        }
    }
    
}
