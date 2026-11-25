//
//  ChatInteractors.swift
//  salon
//
//  Created by AL Badr  on 6/28/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//


import UIKit
import Foundation
import ObjectMapper
import Alamofire
import SwiftyJSON
import MBProgressHUD

class ChatInteractors: NSObject {
    var token = (Helper.getObjectDefault(key: UserDefault.userData) as? LoginData)?.api_token ?? ""

    func myMessages(completion:  @escaping (_ :BaseListModel<MessagesModel>?,_ :NSError?)->Void) {
        let url = Urls.ALL_CHATS + "?api_token=" + token
        
        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil) { (response, error) in
            
            if error == nil {
                completion(BaseListModel<MessagesModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func getChatMessages(client_id: String, page: String, completion:  @escaping (_ :ChatModel?,_ :NSError?)->Void) {
        let url = String(format: Urls.CHAT, client_id) + "?api_token=" + token + "&page=" + page

        ServiceProvider().sendUrl(showActivity: false, method: .get, URLString: url, withQueryStringParameters: nil) { (response, error) in
            
            if error == nil {
                completion(ChatModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func openChat(channel_id: String, completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = String(format: Urls.OPEN_CHAT, channel_id) + "?api_token=" + token

        ServiceProvider().sendUrl(showActivity: false, method: .get, URLString: url, withQueryStringParameters: nil) { (response, error) in
            
            if error == nil {
                completion(PostModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func sendChatMessage(client_id: String, parameters: [String : Any], dImage: [UIImage], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        
        let url = String(format: Urls.SEND_CHAT, client_id) + "?api_token=" + token
        
        let Headers : HTTPHeaders = ["Content-Type":"application/json",
                                    "Accept":"application/json",
                                    "Accept-Language": (LanguageManger.shared.currentLanguage.rawValue as String)]
        
        AF.upload(multipartFormData: { (form) in
            for (key, value) in parameters {
                if value is String || value is Int {
                    form.append("\(value)".data(using: .utf8)!, withName: key)
                }
            }
            
            print("url", url)
            print("parameters", parameters)

            for i in 0 ..< dImage.count {
                let photo: UIImage = dImage[i]
                let dataPhoto = photo.jpegData(compressionQuality: 0.5)
                form.append(dataPhoto!, withName: "image", fileName: "uploads.jpeg", mimeType: "image/jpeg")
            }

        }, to: url, method: .post, headers: Headers).responseJSON { (response) in
                switch response.result {
                case .failure(_):
                    let json = JSON(response.value ?? "")
                    print("failure response", json)
                case .success(_):
                    let json = JSON(response.value ?? "")
                    print("success response", json)
                    completion(PostModel(JSON:response.value as! [String:Any]), nil)
                }
        }
        
    }
    
}
