//
//  ContactsPresenter.swift
//  salon
//
//  Created by Mahmoud Elzaiady on 15/03/2021.
//  Copyright © 2021 ALBadr. All rights reserved.
//


import Foundation

protocol ContactsPresenterView: NSObjectProtocol {
    func setContactsInfoSuccess(_ contacts: InfoModel)

    func setContactUsSuccess(_ message: String)
    func setContactUsFailure(_ message: String)

    
    func showConnectionErrorMessage()
}

class ContactsPresenter {
    private weak var contactsView : ContactsPresenterView?
    private let getAPI = GetInteractors()
    private let postAPI = PostInteractors()
    
    init(_ hView: ContactsPresenterView ){
        contactsView = hView
    }
    
    init() {}
    
    func detachView() {
        contactsView = nil
    }
    
    public func GetContacts() {
        getAPI.siteInfo() { [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if response?.status ?? false {
                    self.contactsView?.setContactsInfoSuccess((response?.data)!)
                }
            }else {
                self.contactsView?.showConnectionErrorMessage()
            }
        }
    }
    

    
    public func SetContactUs(parameters: [String : Any]) {
        postAPI.contactus(parameters: parameters) { [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if response?.status ?? false {
                    self.contactsView?.setContactUsSuccess(response?.message ?? "")
                }else {
                    self.contactsView?.setContactUsFailure(response?.message ?? "")
                }
            }else {
                self.contactsView?.showConnectionErrorMessage()
            }
        }
    }
}
