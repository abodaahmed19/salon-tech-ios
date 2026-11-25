//
//  HomePresenter.swift
//  salon
//
//  Created by AL Badr  on 6/11/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation

protocol HomePresenterView: NSObjectProtocol {
    func getSliderSuccess(_ response: [Slider])
    func getDepartmentsSuccess(_ response: [DepartmentsData])
    func getProvidersSuccess(_ response: [Providers])
    func getArticlesSuccess(_ response: [Articles])
    func getNotificationsCountSuccess(_ response: Int)
    func getOrdersCountSuccess(_ response: Int)

    func getSettingsSuccess(_ response: SettingsModel)

    func showConnectionErrorMessage()
}

class HomePresenter {
    private weak var homeView: HomePresenterView?
    private let api = GetInteractors()
    
    init(_ lView: HomePresenterView) {
        homeView = lView
    }
    
    init() {}
    
    func detachView() {
        homeView = nil
    }

    public func GetHome() {
        api.getHome(){ [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if response?.status == true {
                    self.homeView?.getSliderSuccess(response?.data?.slider ?? [])
                    self.homeView?.getDepartmentsSuccess(response?.data?.departments ?? [])
                    self.homeView?.getProvidersSuccess(response?.data?.providers ?? [])
                    self.homeView?.getArticlesSuccess(response?.data?.articles ?? [])
                    self.homeView?.getNotificationsCountSuccess(response?.data?.notifications ?? 0)
                    self.homeView?.getOrdersCountSuccess(response?.data?.orders ?? 0)
                }
            }else {
                self.homeView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func getSettings() {
        api.getSettings(){ [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if(response?.status == true){
                    self.homeView?.getSettingsSuccess((response?.data)!)
                }
            }else {
                self.homeView?.showConnectionErrorMessage()
            }
        }
    }
}
