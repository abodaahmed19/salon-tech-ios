//
//  NotificationsPresenter.swift
//  salon
//
//  Created by AL Badr  on 6/19/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation
import UIKit

protocol NotificationsPresenterView: NSObjectProtocol {
    func getMyNotificationsSuccess(_ response: [NotificationsModel])
    func getMyNotificationsFailure()
    
    func ReadNotificationsSuccess()

    func showConnectionErrorMessage()
}

class NotificationsPresenter {
    private weak var notificationsView: NotificationsPresenterView?
    private let getAPI = GetInteractors()
    private let postAPI = PostInteractors()


    init(_ lView: NotificationsPresenterView) {
        notificationsView = lView
    }
    
    init() {}
    
    func detachView() {
        notificationsView = nil
    }
    
    public func getMyNotifications() {
        getAPI.myNotifications(){ [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if(response?.status == true){
                    self.notificationsView?.getMyNotificationsSuccess(response?.data ?? [])
                }else{
                    self.notificationsView?.getMyNotificationsFailure()
                }
            }else {
                self.notificationsView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func NotificationsRead(notification: String) {
        postAPI.readNotification(notification: notification){ [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if(response?.status == true){
                    self.notificationsView?.ReadNotificationsSuccess()
                }else{
                    
                }
            }else {
                self.notificationsView?.showConnectionErrorMessage()
            }
        }
    }

}
