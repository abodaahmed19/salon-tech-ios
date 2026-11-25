//
//  SuggestTimePresenter.swift
//  salon
//
//  Created by AL Badr  on 7/7/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation

protocol SuggestTimePresenterView : NSObjectProtocol {
    func setSuggestTimesSuccess(_ message: String)
    func setSuggestTimesFailure(_ message: String)
    
    func showConnectionErrorMessage()
}

class SuggestTimePresenter {
    private weak var presenterView : SuggestTimePresenterView?
    private let api = PostInteractors()
    
    init(_ pView: SuggestTimePresenterView){
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
