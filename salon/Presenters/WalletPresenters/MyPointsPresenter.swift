//
//  MyPointsPresenter.swift
//  salon
//
//  Created by AL Badr  on 6/22/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation

protocol MyPointsPresenterView : NSObjectProtocol {
    func setPointsCountSuccess(_ points: Int)

    func setPointsSuccess(_ response: [PointsModel])
    func setPointsFailure()

    func showConnectionErrorMessage()
}

class MyPointsPresenter {
    private weak var presenterView : MyPointsPresenterView?
    private let api = GetInteractors()
    
    init(_ pView: MyPointsPresenterView){
        presenterView = pView
    }
    
    init() {}
    
    func detachView() {
        presenterView = nil
    }
  
    public func getPoints() {
        api.getPoints() { [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if response?.status ?? false {
                    self.presenterView?.setPointsCountSuccess(response?.pointCount ?? 0)
                    self.presenterView?.setPointsSuccess(response?.data ?? [])
                }else {
                    self.presenterView?.setPointsFailure()
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
}
