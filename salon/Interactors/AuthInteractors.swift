//
//  AuthInteractors.swift
//  salon
//
//  Created by AL Badr  on 5/20/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper
import Alamofire
import SwiftyJSON
import MBProgressHUD


class AuthInteractors: NSObject {
    
    var lang = (LanguageManger.shared.currentLanguage.rawValue as String)
    var token = (Helper.getObjectDefault(key: UserDefault.userData) as? LoginData)?.api_token ?? ""
    
    func checkVerification(completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Urls.CHECK_VERIFICATION + "?api_token=" + token
        
        ServiceProvider().sendUrl(showActivity: false, method: .get, URLString: url, withQueryStringParameters: nil) { (response, error) in
            if error == nil {
                completion(PostModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func logout(completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Urls.LOGOUT + "?api_token=" + token
        
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: nil) { (response, error) in
            if error == nil {
                completion(PostModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func loginStatus(completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Urls.loginStatus
        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil) { (response, error) in
            if error == nil {
                completion(PostModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }

    func login(parameters: [String : Any], completion:  @escaping (_ :BaseModel<LoginData>?,_ :NSError?)->Void) {
        let url = Urls.LOGIN
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: parameters) { (response, error) in
            if error == nil {
                completion(BaseModel<LoginData>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func socialLogin(parameters: [String : Any], completion:  @escaping (_ :BaseModel<LoginData>?,_ :NSError?)->Void) {
        let url = Urls.SOCIAL_LOGIN
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: parameters) { (response, error) in
            if error == nil {
                completion(BaseModel<LoginData>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func deleteAccount(completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Urls.DELETE_ACCOUNT + "?api_token=" + token
        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil) { (response, error) in
            if error == nil {
                completion(PostModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func activate(parameters: [String : Any] , completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Urls.ACTIVATE_ACCOUNT
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: parameters) { (response, error) in
            if error == nil {
                completion(PostModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func sendResetCode(parameters: [String : Any] , completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Urls.FORGET_PASSWORD + "?language=" + lang
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: parameters) { (response, error) in
            if error == nil {
                completion(PostModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
        
    func getNewPassword(parameters: [String : Any] , completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Urls.RESET_PASSWORD
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: parameters) { (response, error) in
            if error == nil {
                completion(PostModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func changePassword(parameters: [String : Any] , completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Urls.CHANGE_PASSWORD
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: parameters) { (response, error) in
            if error == nil {
                completion(PostModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func getClientProfile(completion:  @escaping (_ :BaseModel<LoginData>?,_ :NSError?)->Void) {
        let url = Urls.EDIT_CLIENT_PROFILE + "?api_token=" + token
        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil) { (response, error) in
            if error == nil {
                completion(BaseModel<LoginData>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func getProviderProfile(completion:  @escaping (_ :BaseModel<LoginData>?,_ :NSError?)->Void) {
          let url = Urls.EDIT_PROVIDER_PROFILE + "?api_token=" + token
          ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil) { (response, error) in
              if error == nil {
                  completion(BaseModel<LoginData>(JSON:response as! [String:Any]), error)
              }else {
                  completion(nil, error)
              }
          }
      }
    
    func signAsClient(parameters: [String : Any], profileImage: [UIImage], idImage: [UIImage], completion:  @escaping (_ :BaseModel<LoginData>?,_ :NSError?)->Void) {
        let url = Urls.CLIENT_REGISTER + "?language=" + lang
        
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
            
            print("url: ", url)
            print("parameters", JSON(parameters))

            
            for i in 0 ..< profileImage.count {
                let photo: UIImage = profileImage[i]
                let dataPhoto = photo.jpegData(compressionQuality: 0.5)
                form.append(dataPhoto!, withName: "image", fileName: "uploads.jpeg", mimeType: "image/jpeg")
            }
            
            for i in 0 ..< idImage.count {
                let photo: UIImage = idImage[i]
                let dataPhoto = photo.jpegData(compressionQuality: 0.5)
                form.append(dataPhoto!, withName: "image_identity", fileName: "uploads.jpeg", mimeType: "image/jpeg")
            }

            
        }, to: url, method: .post, headers: Headers).responseJSON { (response) in
            switch response.result {
            case .failure(_):
                hud.hide(animated: true)
                let json = JSON(response.value ?? "")
                print("failure response", json)
                
            case .success(_):
                hud.hide(animated: true)
                let json = JSON(response.value ?? "")
                print("success response", json)
                completion(BaseModel<LoginData>(JSON:response.value as! [String:Any]), nil)
            }
        }
    }
    
    func signAsProvider(parameters: [String : Any],
                        profileImage: [UIImage],
                        idImage: [UIImage],
                        serviceImage: [UIImage],
                        certificateImage: [UIImage],
                        itemsIDs: [Int],
                        districrsIDs: [Int],
                        videoString: String,
                        videoData: Data,
                        completion:  @escaping (_ :BaseModel<LoginData>?,_ :NSError?)->Void) {
        
        let url = Urls.PROVIDER_REGISTER

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
            
            print("url: ", url)
            print("parameters", JSON(parameters))

            for i in 0 ..< profileImage.count {
                let photo: UIImage = profileImage[i]
                let dataPhoto = photo.jpegData(compressionQuality: 0.7)
                form.append(dataPhoto!, withName: "image", fileName: "uploads.jpeg", mimeType: "image/jpeg")
            }
            
            for i in 0 ..< idImage.count {
                let photo: UIImage = idImage[i]
                let dataPhoto = photo.jpegData(compressionQuality: 0.7)
                form.append(dataPhoto!, withName: "image_identity", fileName: "uploads.jpeg", mimeType: "image/jpeg")
            }
            
            for i in 0 ..< serviceImage.count {
                let photo: UIImage = serviceImage[i]
                let dataPhoto = photo.jpegData(compressionQuality: 0.7)
                form.append(dataPhoto!, withName: "cover_img", fileName: "uploads.jpeg", mimeType: "image/jpeg")
            }
            
            if videoString != "" {
                form.append(videoData, withName: "cover_img", fileName: "file.mp4", mimeType: "video/mp4")
            }
            
            for i in 0 ..< certificateImage.count {
                let photo: UIImage = certificateImage[i]
                let dataPhoto = photo.jpegData(compressionQuality: 0.7)
                form.append(dataPhoto!, withName: "certified_image", fileName: "uploads.jpeg", mimeType: "image/jpeg")
            }
            
            for i in 0 ..< itemsIDs.count {
                form.append("\(itemsIDs[i])".data(using: .utf8)!, withName: "items["+"\(i)"+"]")
            }
            
            for i in 0 ..< districrsIDs.count {
                form.append("\(districrsIDs[i])".data(using: .utf8)!, withName: "districts["+"\(i)"+"]")
            }
            
        }, to: url, method: .post, headers: Headers).responseJSON { (response) in
            switch response.result {
            case .failure(_):
                hud.hide(animated: true)
                let json = JSON(response.value ?? "")
                print("failure response", json)
                
            case .success(_):
                hud.hide(animated: true)
                let json = JSON(response.value ?? "")
                print("success response", json)
                completion(BaseModel<LoginData>(JSON:response.value as! [String:Any]), nil)
            }
        }
    }
    
    func updateProfileClient(parameters: [String : Any], profileImage: [UIImage], idImage: [UIImage], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        
        let url = Urls.UPDATE_CLIENT_PROFILE + "?api_token=" + token

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
            
            print("url: ", url)
            print("parameters", JSON(parameters))

            for i in 0 ..< profileImage.count {
                let photo: UIImage = profileImage[i]
                let dataPhoto = photo.jpegData(compressionQuality: 0.5)
                form.append(dataPhoto!, withName: "image", fileName: "uploads.jpeg", mimeType: "image/jpeg")
            }
            
            for i in 0 ..< idImage.count {
                let photo: UIImage = idImage[i]
                let dataPhoto = photo.jpegData(compressionQuality: 0.5)
                form.append(dataPhoto!, withName: "image_identity", fileName: "uploads.jpeg", mimeType: "image/jpeg")
            }

            
        }, to: url, method: .post, headers: Headers).responseJSON { (response) in
            switch response.result {
            case .failure(_):
                hud.hide(animated: true)
                let json = JSON(response.value ?? "")
                print("failure response", json)
                
            case .success(_):
                hud.hide(animated: true)
                let json = JSON(response.value ?? "")
                print("success response", json)
                completion(PostModel(JSON:response.value as! [String:Any]), nil)
            }
        }
    }
    
    func updateProfileProvider(parameters: [String : Any],
                        profileImage: [UIImage],
                        idImage: [UIImage],
                        serviceImage: [UIImage],
                        certificateImage: [UIImage],
                        itemsIDs: [Int],
                        districrsIDs: [Int],
                        videoString: String,
                        videoData: Data,
                        completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
                
        let url = Urls.UPDATE_PROVIDER_PROFILE + "?api_token=" + token
        
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
            
            print("url: ", url)
            print("parameters", JSON(parameters))
            
            for i in 0 ..< profileImage.count {
                let photo: UIImage = profileImage[i]
                let dataPhoto = photo.jpegData(compressionQuality: 0.7)
                form.append(dataPhoto!, withName: "image", fileName: "uploads.jpeg", mimeType: "image/jpeg")
            }
            
            for i in 0 ..< idImage.count {
                let photo: UIImage = idImage[i]
                let dataPhoto = photo.jpegData(compressionQuality: 0.7)
                form.append(dataPhoto!, withName: "image_identity", fileName: "uploads.jpeg", mimeType: "image/jpeg")
            }
            
            for i in 0 ..< serviceImage.count {
                let photo: UIImage = serviceImage[i]
                let dataPhoto = photo.jpegData(compressionQuality: 0.7)
                form.append(dataPhoto!, withName: "cover_img", fileName: "uploads.jpeg", mimeType: "image/jpeg")
            }
            
            if videoString != "" {
                form.append(videoData, withName: "cover_img", fileName: "file.mp4", mimeType: "video/mp4")
            }
            
            for i in 0 ..< certificateImage.count {
                let photo: UIImage = certificateImage[i]
                let dataPhoto = photo.jpegData(compressionQuality: 0.7)
                form.append(dataPhoto!, withName: "certified_image", fileName: "uploads.jpeg", mimeType: "image/jpeg")
            }
            
            for i in 0 ..< itemsIDs.count {
                form.append("\(itemsIDs[i])".data(using: .utf8)!, withName: "items["+"\(i)"+"]")
            }
            
            for i in 0 ..< districrsIDs.count {
                form.append("\(districrsIDs[i])".data(using: .utf8)!, withName: "districts["+"\(i)"+"]")
            }
            
        }, to: url, method: .post, headers: Headers).responseJSON { (response) in
            switch response.result {
            case .failure(_):
                hud.hide(animated: true)
                let json = JSON(response.value ?? "")
                print("failure response", json)
                
            case .success(_):
                hud.hide(animated: true)
                let json = JSON(response.value ?? "")
                print("success response", json)
                completion(PostModel(JSON:response.value as! [String:Any]), nil)
            }
        }
    }

}
