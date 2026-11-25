//
//  PostInteractors.swift
//  salon
//
//  Created by AL Badr  on 6/16/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper
import Alamofire
import SwiftyJSON
import MBProgressHUD

class PostInteractors: NSObject {
    
    var lang = (LanguageManger.shared.currentLanguage.rawValue as String)
    var token = (Helper.getObjectDefault(key: UserDefault.userData) as? LoginData)?.api_token ?? ""
    
    func checkCoupon(parameters: [String : Any] , completion:  @escaping (_ :BaseModel<CouponModel>?,_ :NSError?)->Void) {
        let url = Urls.CHECK_COUPON + "?api_token=" + token
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: parameters) { (response, error) in
            if error == nil {
                completion(BaseModel<CouponModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func getCityProviders(parameters: [String : Any] , completion:  @escaping (_ :BaseListModel<ChooseProviderModel>?,_ :NSError?)->Void) {
        let url = Urls.SPECIFIC_PROVIDERS + "?api_token=" + token
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: parameters) { (response, error) in
            if error == nil {
                completion(BaseListModel<ChooseProviderModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func addFavourites(parameters: [String : Any], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Urls.ADD_TO_FAVOURITE + "?api_token=" + token
        
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: parameters) { (response, error) in
            if error == nil {
                completion(PostModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func removeFavourites(provider_id: String, completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = String(format: Urls.REMOVE_FROM_FAVOURITE, provider_id) + "?api_token=" + token
        
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: nil) { (response, error) in
            if error == nil {
                completion(PostModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func readNotification(notification: String, completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Urls.READ_NOTIFICATION + "?api_token=" + token + "&notification=" + notification
        
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: nil) { (response, error) in
            if error == nil {
                completion(PostModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func getClientSheet(search: String, page: String, completion:  @escaping (_ :BaseListModel<StatementsModel>?,_ :NSError?)->Void) {
        let url = Urls.CLIENT_BALANCE  + "?api_token=" + token// + "&search=" + search + "&page=" + page
        
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: nil) { (response, error) in
            
            if error == nil {
                completion(BaseListModel<StatementsModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func getProviderSheet(search: String, page: String, completion:  @escaping (_ :BaseListModel<StatementsModel>?,_ :NSError?)->Void) {
        let url = Urls.PROVIDER_BALANCE  + "?api_token=" + token + "&search=" + search + "&page=" + page
        
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: nil) { (response, error) in
            
            if error == nil {
                completion(BaseListModel<StatementsModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func getWallet(page: String, completion:  @escaping (_ :BaseListModel<WalletModel>?,_ :NSError?)->Void) {
        let url = Urls.SHOW_WALLET  + "?api_token=" + token + "&page=" + page
        
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: nil) { (response, error) in
            
            if error == nil {
                completion(BaseListModel<WalletModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func getClientWalletTransactions(completion:  @escaping (_ :BaseListModel<WalletModel>?,_ :NSError?)->Void) {
        let url = Urls.CLIENT_WALLET_TRANSACTIONS  + "?api_token=" + token
        
        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil) { (response, error) in
            
            if error == nil {
                completion(BaseListModel<WalletModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func getProviderWalletTransactions(completion:  @escaping (_ :BaseListModel<WalletModel>?,_ :NSError?)->Void) {
        let url = Urls.PROVIDER_WALLET_TRANSACTIONS  + "?api_token=" + token
        
        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil) { (response, error) in
            
            if error == nil {
                completion(BaseListModel<WalletModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func savePlaces(parameters: [String : Any], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Urls.SAVE_PLACE + "?api_token=" + token
        
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: parameters) { (response, error) in
            if error == nil {
                completion(PostModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func removePlaces(place_id: String, completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = String(format: Urls.REMOVE_PLACE, place_id) + "?api_token=" + token
        
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: nil) { (response, error) in
            if error == nil {
                completion(PostModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func contactus(parameters: [String : Any], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Urls.CONTACT_US
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: parameters) { (response, error) in
            if error == nil {
                completion(PostModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func clientCommentObjection(comment_id: String, parameters: [String : Any], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = String(format: Urls.OBJECT_COMMENT_CLIENT, comment_id) + "?api_token=" + token
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: parameters) { (response, error) in
            if error == nil {
                completion(PostModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func providerCommentObjection(comment_id: String, parameters: [String : Any], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = String(format: Urls.OBJECT_COMMENT_PROVIDER, comment_id) + "?api_token=" + token
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: parameters) { (response, error) in
            if error == nil {
                completion(PostModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func makeReservation(parameters: [String : Any], dImage: [UIImage], serviceIDs: [Int], completion:  @escaping (_ :BaseModel<ReservationResponse>?,_ :NSError?)->Void) {
        let url = Urls.RESERVATION + "?api_token=" + token
        
        let Headers : HTTPHeaders = ["Content-Type":"application/json",
                                     "Accept":"application/json",
                                     "Accept-Language": (LanguageManger.shared.currentLanguage.rawValue as String)]
        
        var hud : MBProgressHUD = MBProgressHUD()
        hud = MBProgressHUD.showAdded(to: (Helper.getTopViewController()?.view) ?? UIView(), animated: true)
        hud.mode = .indeterminate
        
        AF.upload(multipartFormData: { (form: MultipartFormData) in
            for (key, value) in parameters {
                if value is String || value is Int {
                    form.append("\(value)".data(using: .utf8)!, withName: key)
                }
            }
            
            print("url", url)
            print("Headers", Headers)
            print("parameters", JSON(parameters))
            
            for i in 0 ..< dImage.count {
                let photo: UIImage = dImage[i]
                let dataPhoto = photo.jpegData(compressionQuality: 0.5)
                form.append(dataPhoto!, withName: "bank_convert_img", fileName: "uploads.jpeg", mimeType: "image/jpeg")
            }
            
            for i in 0 ..< serviceIDs.count {
                form.append("\(serviceIDs[i])".data(using: .utf8)!, withName: "service_ids["+"\(i)"+"]")
            }
            
        }, to: url, method: .post, headers: Headers).responseJSON { (response) in
            
            switch response.result {
            case .failure(let error):
                hud.hide(animated: true)
                print("failure response", error)
                
            case .success(_):
                hud.hide(animated: true)
                let json = JSON(response.value ?? "")
                print("success response", json)
                completion(BaseModel<ReservationResponse>(JSON:response.value as! [String:Any]), nil)
            }
            
        }
    }
    
    func payReservation(parameters: [String : Any], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Urls.RESERVATION_PAYMENT + "?api_token=" + token
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: parameters) { (response, error) in
            if error == nil {
                completion(PostModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func convertToPoints(parameters: [String : Any], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Urls.CONVERT_TO_POINTS + "?api_token=" + token
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: parameters) { (response, error) in
            if error == nil {
                completion(PostModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func suggestTimes(parameters: [String : Any], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Urls.SUGGEST_TIMES + "?api_token=" + token
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: parameters) { (response, error) in
            if error == nil {
                completion(PostModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func getRefund(parameters: [String : Any], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Urls.RECOVERY + "?api_token=" + token
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: parameters) { (response, error) in
            if error == nil {
                completion(PostModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func confirmPaymentFromAdmin(parameters: [String : Any], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Urls.CONFIRM_PAYMENT_ADMIN + "?api_token=" + token
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: parameters) { (response, error) in
            if error == nil {
                completion(PostModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func discountRequest(parameters: [String : Any], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Urls.COMMISSION_DISCOUNT_REQUEST + "?api_token=" + token
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: parameters) { (response, error) in
            if error == nil {
                completion(PostModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func payCommission(parameters: [String : Any], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Urls.PAID_COMMISSIONS + "?api_token=" + token
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: parameters) { (response, error) in
            if error == nil {
                completion(PostModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func ePayment(parameters: [String : Any], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Urls.E_PAYMENT + "?api_token=" + token
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: parameters) { (response, error) in
            if error == nil {
                completion(PostModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func sendBankTransfer(parameters: [String : Any], dImage: [UIImage], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        
        let url =  Urls.RESERVATION_PAYMENT + "?api_token=" + token
        
        let Headers : HTTPHeaders = ["Content-Type":"application/json",
                                     "Accept":"application/json",
                                     "Accept-Language": (LanguageManger.shared.currentLanguage.rawValue as String)]
        
        var hud : MBProgressHUD = MBProgressHUD()
        hud = MBProgressHUD.showAdded(to: (Helper.getTopViewController()?.view) ?? UIView(), animated: true)
        hud.mode = .indeterminate
        
        AF.upload(multipartFormData: { (form: MultipartFormData) in
            for (key, value) in parameters {
                if value is String || value is Int {
                    form.append("\(value)".data(using: .utf8)!, withName: key)
                }
            }
            
            print("url", url)
            print("Headers", Headers)
            print("parameters", parameters)
            
            for i in 0 ..< dImage.count {
                let photo: UIImage = dImage[i]
                let dataPhoto = photo.jpegData(compressionQuality: 0.5)
                form.append(dataPhoto!, withName: "bank_convert_img", fileName: "uploads.jpeg", mimeType: "image/jpeg")
            }
            
            
            
        }, to: url, method: .post, headers: Headers).responseJSON { (response) in
            
            switch response.result {
            case .failure(let error):
                hud.hide(animated: true)
                print("failure response", error)
                
            case .success(_):
                hud.hide(animated: true)
                let json = JSON(response.value ?? "")
                print("success response", json)
                completion(PostModel(JSON:response.value as! [String:Any]), nil)
            }
            
        }
    }
    
    func convertToBank(parameters: [String : Any], dImage: [UIImage], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        
        let url =  Urls.CONVERT_TO_BANK + "?api_token=" + token
        
        let Headers : HTTPHeaders = ["Content-Type":"application/json",
                                     "Accept":"application/json",
                                     "Accept-Language": (LanguageManger.shared.currentLanguage.rawValue as String)]
        
        var hud : MBProgressHUD = MBProgressHUD()
        hud = MBProgressHUD.showAdded(to: (Helper.getTopViewController()?.view) ?? UIView(), animated: true)
        hud.mode = .indeterminate
        
        AF.upload(multipartFormData: { (form: MultipartFormData) in
            for (key, value) in parameters {
                if value is String || value is Int {
                    form.append("\(value)".data(using: .utf8)!, withName: key)
                }
            }
            
            print("url", url)
            print("Headers", Headers)
            print("parameters", parameters)
            
            for i in 0 ..< dImage.count {
                let photo: UIImage = dImage[i]
                let dataPhoto = photo.jpegData(compressionQuality: 0.5)
                form.append(dataPhoto!, withName: "bank_convert_img", fileName: "uploads.jpeg", mimeType: "image/jpeg")
            }
            
        }, to: url, method: .post, headers: Headers).responseJSON { (response) in
            switch response.result {
            case .failure(let error):
                hud.hide(animated: true)
                print("failure response", error)
                
            case .success(_):
                hud.hide(animated: true)
                let json = JSON(response.value ?? "")
                print("success response", json)
                completion(PostModel(JSON:response.value as! [String:Any]), nil)
            }
        }
    }
    
    func payBankCommission(parameters: [String : Any], dImage: [UIImage], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        
        let url =  Urls.PAY_COMMISSION + "?api_token=" + token
        
        let Headers : HTTPHeaders = ["Content-Type":"application/json",
                                     "Accept":"application/json",
                                     "Accept-Language": (LanguageManger.shared.currentLanguage.rawValue as String)]
        
        var hud : MBProgressHUD = MBProgressHUD()
        hud = MBProgressHUD.showAdded(to: (Helper.getTopViewController()?.view) ?? UIView(), animated: true)
        hud.mode = .indeterminate
        
        AF.upload(multipartFormData: { (form: MultipartFormData) in
            for (key, value) in parameters {
                if value is String || value is Int {
                    form.append("\(value)".data(using: .utf8)!, withName: key)
                }
            }
            
            print("url", url)
            print("parameters", JSON(parameters))
            
            for i in 0 ..< dImage.count {
                let photo: UIImage = dImage[i]
                let dataPhoto = photo.jpegData(compressionQuality: 0.5)
                form.append(dataPhoto!, withName: "bank_convert_img", fileName: "uploads.jpeg", mimeType: "image/jpeg")
            }
            
            
            
        }, to: url, method: .post, headers: Headers).responseJSON { (response) in
            switch response.result {
            case .failure(let error):
                hud.hide(animated: true)
                print("failure response", error)
                
            case .success(_):
                hud.hide(animated: true)
                let json = JSON(response.value ?? "")
                print("success response", json)
                completion(PostModel(JSON:response.value as! [String:Any]), nil)
            }
        }
    }
    
    func sendVerificationRequest(parameters: [String : Any], dImage: [UIImage], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let Headers : HTTPHeaders = ["Content-Type":"application/json",
                                     "Accept":"application/json",
                                     "Accept-Language": (LanguageManger.shared.currentLanguage.rawValue as String)]
        
        let url =  Urls.SEND_VERFiCATION_REQUEST + "?api_token=" + token
        
        var hud : MBProgressHUD = MBProgressHUD()
        hud = MBProgressHUD.showAdded(to: (Helper.getTopViewController()?.view) ?? UIView(), animated: true)
        hud.mode = .indeterminate
        
        AF.upload(multipartFormData: { (form: MultipartFormData) in
            for (key, value) in parameters {
                if value is String || value is Int {
                    form.append("\(value)".data(using: .utf8)!, withName: key)
                }
            }
            
            print("url: ", url)
            print("parameters", parameters)
            
            for i in 0 ..< dImage.count {
                let photo: UIImage = dImage[i]
                let dataPhoto = photo.jpegData(compressionQuality: 0.5)
                form.append(dataPhoto!, withName: "image_identity", fileName: "uploads.jpeg", mimeType: "image/jpeg")
            }
            
            
        }, to: url, method: .post, headers: Headers).responseJSON { (response) in
            
            switch response.result {
            case .failure(let error):
                hud.hide(animated: true)
                print("failure response", error)
                
            case .success(_):
                hud.hide(animated: true)
                let json = JSON(response.value ?? "")
                print("success response", json)
                completion(PostModel(JSON:response.value as! [String:Any]), nil)
            }
            
        }
    }
    
}
