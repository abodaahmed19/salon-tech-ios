//
//  SideMenuVC.swift
//  salon
//
//  Created by AL Badr  on 5/20/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//


import UIKit

class SideMenuVC: UITableViewController {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var userProfileBtn: UIButton!
    @IBOutlet weak var languageBtn: UIButton!
    
    @IBOutlet weak var verifiedImg: UIImageView!
    @IBOutlet weak var ordersLabel: UILabel!

    
    @IBOutlet weak var userImage: CircleImage!
    
    @IBOutlet weak var notificationsView: UIView!
    @IBOutlet weak var notificationsLabel: UILabel!
    
    @IBOutlet weak var ordersView: UIView!
    @IBOutlet weak var ordersTitleLabel: UILabel!
    
    var notificationCount: String = "0"
    
    var ordersCount: String = "0"
    
    var token: String = ""
    var userId: String = ""
    var name: String = ""
    var image: String = ""
    var type: String = ""
    var verified: String = ""
    
    private let api = AuthInteractors()

    override func viewWillAppear(_ animated: Bool) {
        let userColors = Helper.getObjectDefault(key: UserDefault.userColors) as? ColorsModel

        view.backgroundColor = Helper.hexStringToUIColor(hex: userColors?.side_menu ?? "#000000")
        
        getUserData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
 
        
    }
    
    func getUserData() {
        let userDate = Helper.getObjectDefault(key: UserDefault.userData) as? LoginData
        token = userDate?.api_token ?? ""
        userId = "\(userDate?.id ?? 0)"
        name = userDate?.name ?? ""
        image = SITE_URL + (userDate?.image ?? "")
        type = userDate?.type ?? ""
        
        notificationCount = Helper.getUserDefault(key: UserDefault.notificationsCount) as! String
        notificationsLabel.text = notificationCount
        
        ordersCount = Helper.getUserDefault(key: UserDefault.ordersCount) as! String
        ordersLabel.text = ordersCount
        
        verifiedImg.isHidden = true
        
        if notificationCount == "0" || notificationCount == "" {
            notificationsView.isHidden = true
        }
        
        if ordersCount == "0" || ordersCount == "" {
            ordersView.isHidden = true
        }
        
        if token == "" {
            userName.text = "Welcome".localiz()
            loginBtn.isHidden = false
            userProfileBtn.isHidden = true
            
        }else {
            userName.text = name
            loginBtn.isHidden = true
            userProfileBtn.isHidden = false
            
            userImage.sd_setImage(with: URL(string: image))
        }
                
        if type == "provider" {
            ordersView.isHidden = false
            ordersTitleLabel.text = "Orders".localiz()
        }else {
            ordersView.isHidden = true
            ordersTitleLabel.text = "My Orders".localiz()
        }

        if LanguageManger.shared.currentLanguage == .ar {
            languageBtn.setTitle("EN", for: .normal)
            loginBtn.contentHorizontalAlignment = .left

        }else {
            languageBtn.setTitle("AR", for: .normal)
            loginBtn.contentHorizontalAlignment = .right
        }
        
        api.checkVerification { [weak self] response, error in
            guard let self = self else { return }
            
            self.verified = response?.verified ?? ""
            
            if self.verified == "yes" {
                self.verifiedImg.isHidden = false
            }else {
                self.verifiedImg.isHidden = true
            }
            
            self.tableView.reloadData()
        }
    }
    
    @IBAction func loginBtn_tapped(_ sender: Any) {
        let storyBoard = UIStoryboard(name: Storyboards.authentication, bundle: nil)
        let editVC = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        editVC.title = "Login".localiz()
        //            editVC.fromRegistration = false
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    
    @IBAction func userProfileBtn_tapped(_ sender: Any) {
        let storyBoard = UIStoryboard(name: Storyboards.authentication, bundle: nil)
        let editVC = storyBoard.instantiateViewController(withIdentifier: "EditVC") as! EditVC
        editVC.title = "Profile".localiz()
        //            editVC.fromRegistration = false
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    @IBAction func languageBtn_tapped(_ sender: Any) {
        if LanguageManger.shared.currentLanguage == .ar {
            LanguageManger.shared.setLanguage(language: .en)
        }else {
            LanguageManger.shared.setLanguage(language: .ar)
        }
        
        print("Language", LanguageManger.shared.currentLanguage)
        
        UIApplication.shared.windows[0].rootViewController = UIStoryboard(
            name:Storyboards.main,
            bundle: nil
        ).instantiateViewController(withIdentifier: "mainNC")
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = CGFloat()
        
        switch indexPath.row {
            
        case 0:
            height = 120
            
        case 1,2,3,5,6,7,12:
            if token == "" {
                height = 0
            }else {
                height = 50
            }
            
        case 4:
            if token == "" {
                height = 0
            }else {
                if verified == "yes" {
                    height = 0
                }else {
                    height = 50
                }
            }
            
        case 8:
            if token == "" {
                height = 0
            }else {
                if type == "provider" {
                    height = 50
                }else {
                    height = 0
                }
            }
            
        default:
            height = 50
        }
        
        return height
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print ("Index", indexPath.row)
        
        if indexPath.row == 1 { //orders
            if type == "provider" {
                let storyBoard = UIStoryboard(name: Storyboards.provider, bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "ProviderOrdersVC") as! ProviderOrdersVC
                vc.title = "Orders".localiz()
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else {
                ordersView.isHidden = true

                let storyBoard = UIStoryboard(name: Storyboards.user, bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "MyOrdersVC") as! MyOrdersVC
                vc.title = "My Orders".localiz()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
            
        else if indexPath.row == 2 { // messages
            let storyBoard = UIStoryboard(name: Storyboards.user, bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "MessagesVC") as! MessagesVC
            vc.title = "Messages".localiz()
            self.navigationController?.pushViewController(vc, animated: true)
        }
            
        else if indexPath.row == 3 { // Notifications
            let storyBoard = UIStoryboard(name: Storyboards.user, bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "NotificationsVC") as! NotificationsVC
            vc.title = "Notifications".localiz()
            self.navigationController?.pushViewController(vc, animated: true)
        }
            
        else if indexPath.row == 4 { // request
            let storyBoard = UIStoryboard(name: Storyboards.main, bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "VerificationRequestVC") as! VerificationRequestVC
            vc.title = "Verification Request".localiz()
            self.navigationController?.pushViewController(vc, animated: true)
        }
            
        else if indexPath.row == 5 { // statement
            if type == "provider" {
                let storyBoard = UIStoryboard(name: Storyboards.provider, bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "ProviderStatementVC") as! ProviderStatementVC
                vc.title = "Account Statement".localiz()
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                let storyBoard = UIStoryboard(name: Storyboards.user, bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "AccountStatementVC") as! AccountStatementVC
                vc.title = "Account Statement".localiz()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
            
        else if indexPath.row == 6 { // Favourites
            let storyBoard = UIStoryboard(name: Storyboards.user, bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "FavouritesVC") as! FavouritesVC
            vc.title = "Favourites".localiz()
            self.navigationController?.pushViewController(vc, animated: true)
        }
            
        else if indexPath.row == 7 { // locations
            let storyBoard = UIStoryboard(name: Storyboards.user, bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "SavedLocationsVC") as! SavedLocationsVC
            vc.title = "Saved Locations".localiz()
            self.navigationController?.pushViewController(vc, animated: true)
        }
            
        else if indexPath.row == 8 { // discount request
            self.dismiss(animated: true, completion: nil)

            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "discountNotification"), object: nil, userInfo: nil)
        }
            
        else if indexPath.row == 9 { // terms
            let storyBoard = UIStoryboard(name: Storyboards.main, bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "PagesDetailsVC") as! PagesDetailsVC
            vc.title = "Terms and conditions".localiz()
            vc.pageId = 2
            self.navigationController?.pushViewController(vc, animated: true)
        }
            
        else if indexPath.row == 10 { // About
            let storyBoard = UIStoryboard(name: Storyboards.main, bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "PagesDetailsVC") as! PagesDetailsVC
            vc.title = "About us".localiz()
            vc.pageId = 1
            self.navigationController?.pushViewController(vc, animated: true)
        }
            
        else if indexPath.row == 11 { // contactus
            let storyBoard = UIStoryboard(name: Storyboards.main, bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ContactusVC") as! ContactusVC
            vc.title = "Contact us".localiz()
            self.navigationController?.pushViewController(vc, animated: true)
        }
            
        else if indexPath.row == 12 { // logout
            api.logout { response, error in }

            
            Helper.removeKeyUserDefault(key: UserDefault.userData)
            Helper.removeKeyUserDefault(key: UserDefault.userReservation)
            
            Helper.goToLoginScreen(controller: self)
        }
    }
    
}
