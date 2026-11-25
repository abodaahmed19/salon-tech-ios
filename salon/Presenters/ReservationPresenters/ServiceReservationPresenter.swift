//
//  ServiceReservationPresenter.swift
//  salon
//
//  Created by AL Badr  on 6/17/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation

protocol ServiceReservationPresenterView: NSObjectProtocol {
    func getCouponSuccess(_ response: CouponModel)
    func getCouponFailure(_ response: String)


    func showConnectionErrorMessage()
}

class ServiceReservationPresenter {
    private weak var serviceView: ServiceReservationPresenterView?
    private let postAPI = PostInteractors()
    private let getAPI = GetInteractors()

    init(_ lView: ServiceReservationPresenterView) {
        serviceView = lView
    }
    
    init() {}
    
    func detachView() {
        serviceView = nil
    }

    public func getCoupon(parameters: [String:Any]) {
        postAPI.checkCoupon(parameters: parameters){ [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if(response?.status == true){
                    self.serviceView?.getCouponSuccess((response?.data)!)
                }else{
                    self.serviceView?.getCouponFailure(response?.message ?? "")
                }
            }else {
                self.serviceView?.showConnectionErrorMessage()
            }
        }
    }
    
}
