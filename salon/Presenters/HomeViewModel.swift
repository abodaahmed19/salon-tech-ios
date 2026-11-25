//
//  HomeViewModel.swift
//  salon
//
//  Created by Mahmoud Elzaiady on 27/06/2022.
//  Copyright © 2022 ALBadr. All rights reserved.
//

import Foundation

class HomeViewModel {
    var needReloadCollectionView: (() -> Void)?
    var showConnectionErrorMessage: (() -> Void)?

    var imagesList: [Slider] = []
    var servicesList: [DepartmentsData] = []
    var providersList: [Providers] = []
    var articlesList: [Articles] = []
    
    var notificationCount: Int = 0
    var ordersCount: Int = 0
    
    var settingsModel = SettingsModel()
    
    private let api = GetInteractors()
    
    init() {}
    
    func getHome() {
        api.getHome(){ [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if response?.status == true {
                    self.imagesList = response?.data?.slider ?? []
                    self.servicesList = response?.data?.departments ?? []
                    self.providersList = response?.data?.providers ?? []
                    self.articlesList = response?.data?.articles ?? []
                    
                    self.notificationCount = response?.data?.notifications ?? 0
                    self.ordersCount = response?.data?.orders ?? 0
                    
                    self.needReloadCollectionView?()
                }
            }else {
                self.showConnectionErrorMessage?()
            }
        }
    }
    
    func getSettings() {
        api.getSettings(){ [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if(response?.status == true){
                    self.settingsModel = response?.data ?? SettingsModel()
                }
            }else {
                self.showConnectionErrorMessage?()
            }
        }
    }

}
