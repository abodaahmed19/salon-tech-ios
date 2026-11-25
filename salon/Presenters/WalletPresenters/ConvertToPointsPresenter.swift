//
//  ConvertToPointsPresenter.swift
//  salon
//
//  Created by AL Badr  on 7/6/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation

protocol ConvertToPointsPresenterView : NSObjectProtocol {
    func setConvertToPointsSuccess(_ message: String)
    func setConvertToPointsFailure(_ message: String)
    
    func showConnectionErrorMessage()
}

class ConvertToPointsPresenter {
    private weak var presenterView : ConvertToPointsPresenterView?
    private let api = PostInteractors()
    
    init(_ pView: ConvertToPointsPresenterView){
        presenterView = pView
    }
    
    init() {}
    
    func detachView() {
        presenterView = nil
    }
    
    public func convertToPoints(parameters: [String : Any]) {
        api.convertToPoints(parameters: parameters) { [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if response?.status ?? false {
                    self.presenterView?.setConvertToPointsSuccess(response?.message ?? "")
                }else {
                    self.presenterView?.setConvertToPointsFailure(response?.message ?? "")
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
}
