//
//  GetInteractors.swift
//  salon
//
//  Created by AL Badr  on 5/20/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class GetInteractors: NSObject {

    var lang = (LanguageManger.shared.currentLanguage.rawValue as String)
    var token = (Helper.getObjectDefault(key: UserDefault.userData) as? LoginData)?.api_token ?? ""
    
    func getHome(completion:  @escaping (_ :BaseModel<HomeData>?,_ :NSError?)->Void) {
        let url = Urls.HOME + "?language=" + lang  + "&api_token=" + token

        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil) { (response, error) in
            if error == nil {
                completion(BaseModel<HomeData>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func getColors(completion:  @escaping (_ :BaseModel<ColorsModel>?,_ :NSError?)->Void) {
        let url = Urls.APP_COLORS

        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil) { (response, error) in
            if error == nil {
                completion(BaseModel<ColorsModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func getSettings(completion:  @escaping (_ :BaseModel<SettingsModel>?,_ :NSError?)->Void) {
        let url = (Urls.ADDS_SETTING) + "?language=" + lang  + "&api_token=" + token

        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil) { (response, error) in
            if error == nil {
                completion(BaseModel<SettingsModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func getBankAccounts(completion:  @escaping (_ :BaseListModel<BankAccountsModel>?,_ :NSError?)->Void) {
        let url = (Urls.accounts) + "?api_token=" + token

        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil) { (response, error) in
            if error == nil {
                completion(BaseListModel<BankAccountsModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func getDepartments(completion:  @escaping (_ :DepartmentsModel?,_ :NSError?)->Void) {
        let url = Urls.DEPARTMENTS + "?language=" + lang

        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil) { (response, error) in
            if error == nil {
                completion(DepartmentsModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func getSubDepartments(department_id: String, completion:  @escaping (_ :BaseListModel<DepartmentsData>?,_ :NSError?)->Void) {
        let url = String(format: Urls.SUB_DEPARTMENT, department_id) + "?language=" + lang

        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil) { (response, error) in
            if error == nil {
                completion(BaseListModel<DepartmentsData>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func getCities(completion:  @escaping (_ :CitiesModel?,_ :NSError?)->Void) {
        let url = Urls.CITIES + "?language=" + lang

        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil) { (response, error) in
            if error == nil {
                completion(CitiesModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func getDistricts(city_id: String, completion:  @escaping (_ :BaseListModel<DistrictsData>?,_ :NSError?)->Void) {
        let url = String(format: Urls.DISTRICTS, city_id)

        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil) { (response, error) in
            if error == nil {
                completion(BaseListModel<DistrictsData>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func getProviderDetails(provider_id: String, completion:  @escaping (_ :BaseModel<ProviderDetailsData>?,_ :NSError?)->Void) {
        let url = String(format: Urls.PROVIDER_DETAILS, provider_id) + "?language=" + lang  + "&api_token=" + token

        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil) { (response, error) in
            if error == nil {
                completion(BaseModel<ProviderDetailsData>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func getArticles(completion:  @escaping (_ :BaseListModel<Articles>?,_ :NSError?)->Void) {
        let url = Urls.ARTICLES
        
        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil) { (response, error) in
            
            if error == nil {
                completion(BaseListModel<Articles>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func getSingleArticle(articleId: String, completion:  @escaping (_ :BaseModel<ArticlesModel>?,_ :NSError?)->Void) {
        let url = String(format: Urls.SINGLE_ARTICLE, articleId)

        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil) { (response, error) in
            
            if error == nil {
                completion(BaseModel<ArticlesModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func getClientComments(completion:  @escaping (_ :BaseListModel<CommentsModel>?,_ :NSError?)->Void) {
        let url = Urls.CLIENT_COMMENTS + "?api_token=" + token

        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil) { (response, error) in
            if error == nil {
                completion(BaseListModel<CommentsModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func getProviderComments(completion:  @escaping (_ :BaseListModel<CommentsModel>?,_ :NSError?)->Void) {
        let url = Urls.PROVIDER_COMMENTS + "?api_token=" + token

        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil) { (response, error) in
            if error == nil {
                completion(BaseListModel<CommentsModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func getProviderDetailsComments(provider_id: String, completion:  @escaping (_ :BaseListModel<CommentsModel>?,_ :NSError?)->Void) {
        let url = String(format: Urls.PROVIDER_DETAILS_COMMENTS, provider_id) + "?api_token=" + token

        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil) { (response, error) in
            if error == nil {
                completion(BaseListModel<CommentsModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
   
    func myFavourites(completion:  @escaping (_ :BaseListModel<FavouritesModel>?,_ :NSError?)->Void) {
        let url = Urls.FAVOURITES + "?api_token=" + token
        
        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil) { (response, error) in
            
            if error == nil {
                completion(BaseListModel<FavouritesModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func myNotifications(completion:  @escaping (_ :BaseListModel<NotificationsModel>?,_ :NSError?)->Void) {
        let url = Urls.NOTIFICATIONS_CALL + "?api_token=" + token
        
        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil) { (response, error) in
            
            if error == nil {
                completion(BaseListModel<NotificationsModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
        
    func getPlaces(completion:  @escaping (_ :BaseListModel<LocationsModel>?,_ :NSError?)->Void) {
        let url = Urls.GET_PLACES  + "?api_token=" + token
        
        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil) { (response, error) in
            
            if error == nil {
                completion(BaseListModel<LocationsModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func getPoints(completion:  @escaping (_ :BaseListModel<PointsModel>?,_ :NSError?)->Void) {
        let url = Urls.POINTS  + "?api_token=" + token
        
        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil) { (response, error) in
            
            if error == nil {
                completion(BaseListModel<PointsModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func payableData(page: String, completion:  @escaping (_ :BaseListModel<DueModel>?,_ :NSError?)->Void) {
        let url = Urls.PAYABLE   + "?api_token=" + token + "&page=" + page
        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil) { (response, error) in
            
            if error == nil {
                completion(BaseListModel<DueModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func paymentRequests(page: String, completion:  @escaping (_ :BaseListModel<DueModel>?,_ :NSError?)->Void) {
        let url = Urls.BALANCES  + "?api_token=" + token + "&page=" + page
        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil) { (response, error) in
            
            if error == nil {
                completion(BaseListModel<DueModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
        
    func siteInfo(completion:  @escaping (_ :BaseModel<InfoModel>?,_ :NSError?)->Void) {
        let url = Urls.CONTACT_INFO
        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil) { (response, error) in
            
            if error == nil {
                completion(BaseModel<InfoModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func getPolicy(completion:  @escaping (_ :PolicyModel?,_ :NSError?)->Void) {
        let url = Urls.POLICY
        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil) { (response, error) in
            
            if error == nil {
                completion(PolicyModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func paymentData(completion:  @escaping (_ :BaseModel<PaymentDataModel>?,_ :NSError?)->Void) {
        let url = Urls.PAYMENT_DATA + "?api_token=" + token
        ServiceProvider().sendUrl(showActivity: false, method: .get, URLString: url, withQueryStringParameters: nil) { (response, error) in
            
            if error == nil {
                completion(BaseModel<PaymentDataModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
}
