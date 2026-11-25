//
//  DateLocationPresenter.swift
//  salon
//
//  Created by AL Badr  on 6/16/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation
import UIKit

protocol DateLocationPresenterView: NSObjectProtocol {
    func setCities(_ sections: [CitiesData])
    func setCitiesFailure()
    
    func showConnectionErrorMessage()
}

class DateLocationPresenter {
    private weak var providerView: DateLocationPresenterView?
    private let api = GetInteractors()
    
    init(_ lView: DateLocationPresenterView) {
        providerView = lView
    }
    
    init() {}

    func detachView() {
        providerView = nil
    }

    public func getCities(areaId: String) {
        api.getCities(){ [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if(response?.status == true){
                    self.providerView?.setCities(response?.data ?? [])
                }else{
                    self.providerView?.setCitiesFailure()
                }
            }else {
                self.providerView?.showConnectionErrorMessage()
            }
        }
    }
}

