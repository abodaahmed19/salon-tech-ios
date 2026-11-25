//
//  FavouritesPresenter.swift
//  salon
//
//  Created by AL Badr  on 6/19/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation
import UIKit

protocol FavouritesPresenterView: NSObjectProtocol {
    func getMyFavouritesSuccess(_ response: [FavouritesModel])
    func getMyFavouritesFailure()
    
    func removeFromFavouriteSuccess(_ message: String)
    func removeFromFavouriteFailure(_ message: String)
    
    func showConnectionErrorMessage()
}

class FavouritesPresenter {
    private weak var favView: FavouritesPresenterView?
    private let getAPI = GetInteractors()
    private let postAPI = PostInteractors()
    
    
    init(_ lView: FavouritesPresenterView) {
        favView = lView
    }
    
    init() {}
    
    func detachView() {
        favView = nil
    }
    
    public func getMyFavourites() {
        getAPI.myFavourites(){ [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if(response?.status == true){
                    self.favView?.getMyFavouritesSuccess(response?.data ?? [])
                }else{
                    self.favView?.getMyFavouritesFailure()
                }
            }else {
                self.favView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func removeFromFavourite(provider_id: String) {
        postAPI.removeFavourites(provider_id: provider_id) { [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if response?.status ?? false {
                    self.favView?.removeFromFavouriteSuccess(response?.message ?? "")
                }else {
                    self.favView?.removeFromFavouriteFailure(response?.message ?? "")
                }
            }else {
                self.favView?.showConnectionErrorMessage()
            }
        }
    }
    
    
}
