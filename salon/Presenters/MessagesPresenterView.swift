//
//  MessagesPresenterView.swift
//  salon
//
//  Created by AL Badr  on 6/19/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//


import Foundation
import UIKit

protocol MessagesPresenterView: NSObjectProtocol {
    func getMyMessagesSuccess(_ response: [MessagesModel])
    func getMyMessagesFailure()

    func showConnectionErrorMessage()
}

class MessagesPresenter {
    private weak var messagesView: MessagesPresenterView?
    private let api = ChatInteractors()


    init(_ lView: MessagesPresenterView) {
        messagesView = lView
    }
    
    init() {}
    
    func detachView() {
        messagesView = nil
    }
    
    public func getMyMessages() {
        api.myMessages(){ [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if(response?.status == true){
                    self.messagesView?.getMyMessagesSuccess(response?.data ?? [])
                }else{
                    self.messagesView?.getMyMessagesFailure()
                }
            }else {
                self.messagesView?.showConnectionErrorMessage()
            }
        }
    }

}
