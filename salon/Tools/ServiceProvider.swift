//
//  ServiceProvider.swift
//  Intercom
//
//  Created by Zeinab Reda on 3/11/17.
//  Copyright © 2017 Zeinab Reda. All rights reserved.
//

import Alamofire
import MBProgressHUD
import SwiftyJSON

class ServiceProvider {
    var Headers : HTTPHeaders = ["Content-Type": "application/json",
                                 "Accept": "application/json",
                                 "Accept-Language" :LanguageManger.shared.currentLanguage.rawValue]
    
    func sendUrl(showActivity: Bool, method: HTTPMethod, URLString: String,
                 withQueryStringParameters parameters: [String : Any]?,
                 completionHandler completion: @escaping (_ :NSObject?,_ : NSError?) -> Void) {
#if DEBUG
        if DesignReviewCapture.respond(to: URLString, completion: completion) { return }
#endif
        
        var hud : MBProgressHUD = MBProgressHUD()
        
        if showActivity {
            hud = MBProgressHUD.showAdded(to: (Helper.getTopViewController()?.view) ?? UIView(), animated: true)
            hud.mode = .indeterminate
            hud.show(animated: true)
        }
        
        AF.request(URLString, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: Headers).responseData { (response) in
            print("Request:", response.request ?? "")
            print("Headers:", JSON(response.request?.allHTTPHeaderFields as Any))
            print("parameters", JSON(parameters ?? ""))
            print("response", JSON(response.value as Any))
            print("Error:", JSON(response.error ?? ""))
            
            hud.hide(animated: true)
            
            switch response.result {
            case .success(let value):
                do {
                    let object = try JSONSerialization.jsonObject(with: value, options :[]) as? [String : Any]
                    completion(object as? NSObject ,nil)

                }catch {
                    completion(NSObject(), NSError(domain: "No Internet Connection", code: 0, userInfo: [:]))
                }
            case .failure(let error):
                print(error.errorDescription ?? "")
                completion(NSObject(), NSError(domain: "No Internet Connection", code: 0, userInfo: [:]))
            }
        }
    }
    
    func sendGetUrl(showActivity: Bool, method: HTTPMethod, URLString: String,
                    withQueryStringParameters parameters: [String : Any]?,
                    completionHandler completion: @escaping (_ :NSObject?,_ : NSError?) -> Void) {
#if DEBUG
        if DesignReviewCapture.respond(to: URLString, completion: completion) { return }
#endif
        
        var hud : MBProgressHUD = MBProgressHUD()
        
        if showActivity {
            hud = MBProgressHUD.showAdded(to: (Helper.getTopViewController()?.view) ?? UIView(), animated: true)
            hud.mode = .indeterminate
            hud.show(animated: true)
        }
    
        AF.request(URLString, method: method, parameters: parameters, encoding: URLEncoding.default, headers: Headers).responseData { (response) in
            print("Request:", response.request ?? "")
            print("Headers:", JSON(response.request?.allHTTPHeaderFields as Any))
            print("parameters", JSON(parameters ?? ""))
            print("response", JSON(response.value as Any))
            print("Error:", JSON(response.error ?? ""))
            
            hud.hide(animated: true)
            
            switch response.result {
            case .success(let value):
                do {
                    let object = try JSONSerialization.jsonObject(with: value, options :[]) as? [String : Any]
                    completion(object as? NSObject ,nil)

                }catch {
                    completion(NSObject(), NSError(domain: "No Internet Connection", code: 0, userInfo: [:]))
                }
            case .failure(let error):
                print(error.errorDescription ?? "")
                completion(NSObject(), NSError(domain: "No Internet Connection", code: 0, userInfo: [:]))
            }
        }
    }
}
