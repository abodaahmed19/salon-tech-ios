//
//  InformManagementPresenter.swift
//  salon
//
//  Created by AL Badr  on 6/29/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation

protocol InformManagementPresenterView : NSObjectProtocol {
    func setReportSuccess(_ message: String)
    func setReportFailure(_ message: String)
    
    func showConnectionErrorMessage()
}

class InformManagementPresenter {
    private weak var presenterView : InformManagementPresenterView?
    private let api = OrdersInteractors()
    
    init(_ pView: InformManagementPresenterView){
        presenterView = pView
    }
    
    init() {}
    
    func detachView() {
        presenterView = nil
    }
    
    public func managementReport(parameters: [String : Any]) {
        api.managementReport(parameters: parameters) { [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if response?.status ?? false {
                    self.presenterView?.setReportSuccess(response?.message ?? "")
                }else {
                    self.presenterView?.setReportFailure(response?.message ?? "")
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
}
