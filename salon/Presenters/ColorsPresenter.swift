//
//  ColorsPresenter.swift
//  salon
//
//  Created by AL Badr  on 7/16/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//


import Foundation

protocol ColorsPresenterView: NSObjectProtocol {
    func getColorsSuccess(_ response: ColorsModel)
}

class ColorsPresenter {
    private weak var presenterView: ColorsPresenterView?
    private let api = GetInteractors()
    
    init(_ lView: ColorsPresenterView) {
        presenterView = lView
    }
    
    init() {}
    
    func detachView() {
        presenterView = nil
    }

    public func getColors() {
        api.getColors(){ [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if(response?.status == true){
                    self.presenterView?.getColorsSuccess((response?.data)!)
                }
            }
        }
    }

}
