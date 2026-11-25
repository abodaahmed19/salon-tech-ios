//
//  LoginVC.swift
//  salon
//
//  Created by AL Badr  on 5/20/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import SwiftyJSON
import FacebookCore
import FacebookLogin

class LoginVC: UITableViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!

    @IBOutlet weak var showPasswordBtn: UIButton!
    @IBOutlet weak var rememberBtn: UIButton!
    
    @IBOutlet weak var facebookView: UIView!
    @IBOutlet weak var socialLoginView: UIView!

    fileprivate var presenter: LoginPresenter?
    
    var isRemember: Bool = true
    var showPassword: Bool = false

    let player_id = Helper.getUserDefault(key: UserDefault.player_id) as! String

    override func viewDidLoad() {
        super.viewDidLoad()

        
//        let loginButton = FBLoginButton()
//        loginButton.permissions = ["public_profile", "email"]
//        let newCenter = CGPoint(x: view.frame.width / 2, y: (view.frame.height / 2) + 50)
//        loginButton.center = newCenter
//        view.addSubview(loginButton)

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginNotifications), name: NSNotification.Name(rawValue: "loginNotification"), object: nil)
        
        NotificationCenter.default.addObserver(forName: .AccessTokenDidChange, object: nil, queue: OperationQueue.main) { (notification) in
            
            // Print out access token
            print("FB Access Token: \(String(describing: AccessToken.current?.tokenString))")
            
            self.getFBUserData()
        }

        if LanguageManger.shared.currentLanguage == .ar {
            emailTF.placeholder = "البريد الإلكتروني أو رقم الجوال"
            emailTF.textAlignment = .right
            
            passwordTF.placeholder = "كلمة المرور"
            passwordTF.textAlignment = .right
            
            rememberBtn.setTitle("تذكرني", for: .normal)
        }
        
        let rememberMail = Helper.getUserDefault(key: "rememberMail") as! String
        let rememberPassword = Helper.getUserDefault(key: "rememberPassword") as! String
        
        if Helper.isKeyPresentInUserDefaults(key: "rememberMail"){
            rememberBtn.setImage(#imageLiteral(resourceName: "checkselected"), for: .normal)
        }else {
            rememberBtn.setImage(#imageLiteral(resourceName: "checkunselected"), for: .normal)
        }
        
        emailTF.text = rememberMail
        passwordTF.text = rememberPassword

        setupKeyboard()

        presenter = LoginPresenter(self)
        presenter?.LoginStatus()
        tableView.backgroundColor = SalonDesign.canvas
        tableView.separatorStyle = .none
        emailTF.font = SalonDesign.font(16)
        passwordTF.font = SalonDesign.font(16)
        emailTF.textColor = SalonDesign.ink
        passwordTF.textColor = SalonDesign.ink
        navigationItem.title = SalonDesign.text("تسجيل الدخول", "Sign in")
        for field in [emailTF, passwordTF].compactMap({ $0 }) {
            field.attributedPlaceholder = NSAttributedString(string: field.placeholder ?? "", attributes: [.foregroundColor: SalonDesign.secondary, .font: SalonDesign.font(16)])
        }
        rememberBtn.tintColor = SalonDesign.primary
        updateRememberImage()
        emailTF.textContentType = .username
        passwordTF.textContentType = .password
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        indexPath.row == 0 ? 185 : super.tableView(tableView, heightForRowAt: indexPath)
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
        if indexPath.row == 0, cell.contentView.viewWithTag(8201) == nil {
            cell.contentView.subviews.forEach { $0.isHidden = true }
            let brand = UILabel()
            brand.text = "SALONTECH"
            brand.textColor = SalonDesign.primary
            brand.font = SalonDesign.font(13, bold: true)
            let title = UILabel()
            title.text = SalonDesign.text("أهلًا بعودتك", "Welcome back")
            title.font = SalonDesign.font(32, bold: true)
            title.textColor = SalonDesign.ink
            let subtitle = UILabel()
            subtitle.text = SalonDesign.text("لحظتك القادمة من العناية تبدأ هنا", "Your next moment of care starts here")
            subtitle.font = SalonDesign.font(16)
            subtitle.textColor = SalonDesign.secondary
            subtitle.numberOfLines = 2
            let stack = UIStackView(arrangedSubviews: [brand, title, subtitle])
            stack.tag = 8201
            stack.axis = .vertical
            stack.spacing = 12
            stack.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(stack)
            NSLayoutConstraint.activate([
                stack.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 24),
                stack.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -24),
                stack.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
            ])
        }
        if indexPath.row == 4 || indexPath.row == 5 {
            styleActionButtons(in: cell.contentView, primary: indexPath.row == 4)
        }
    }

    private func styleActionButtons(in view: UIView, primary: Bool) {
        if let button = view as? UIButton {
            button.backgroundColor = primary ? SalonDesign.primary : .clear
            button.setTitleColor(primary ? .white : SalonDesign.primary, for: .normal)
            button.titleLabel?.font = SalonDesign.font(17, bold: true)
            button.layer.borderWidth = primary ? 0 : 1
            button.layer.borderColor = SalonDesign.primary.cgColor
            if let gradient = button as? GradientButton {
                gradient.topGradientColor = nil
                gradient.bottomGradientColor = nil
                gradient.borderWidth = primary ? 0 : 1
                gradient.borderColor = SalonDesign.primary
            }
            if let rounded = button as? RoundedButton {
                rounded.borderWidth = primary ? 0 : 1
                rounded.borderColor = SalonDesign.primary
            }
        }
        view.subviews.forEach { styleActionButtons(in: $0, primary: primary) }
    }

    private func updateRememberImage() {
        rememberBtn.setImage(UIImage(systemName: isRemember ? "checkmark.square.fill" : "square"), for: .normal)
        rememberBtn.accessibilityValue = isRemember ? SalonDesign.text("محدد", "Selected") : SalonDesign.text("غير محدد", "Not selected")
    }
   
    @objc func LoginNotifications(notification: NSNotification){
        Helper.ShowMainScreen(controller: self)
    }
    
    func setupKeyboard() {
        let toolbar = setupKeyboardToolbar()
        self.emailTF.inputAccessoryView = toolbar
        self.passwordTF.inputAccessoryView = toolbar
    }
    
    @IBAction func rememberBtn_tapped(_ sender: Any) {
        if isRemember {
            rememberBtn.setImage(#imageLiteral(resourceName: "checkunselected"), for: .normal)
            isRemember = false
        }else {
            rememberBtn.setImage(#imageLiteral(resourceName: "checkselected"), for: .normal)
            isRemember = true
        }
        updateRememberImage()
    }

    @IBAction func showPasswordBtn_tapped(_ sender: Any) {
        if showPassword {
            passwordTF.isSecureTextEntry = true
            showPasswordBtn.setImage(#imageLiteral(resourceName: "eyelined"), for: .normal)
            showPassword = false
        }else {
            passwordTF.isSecureTextEntry = false
            showPasswordBtn.setImage(#imageLiteral(resourceName: "eye"), for: .normal)
            showPassword = true
        }
    }
    
    @IBAction func forgetPassword_tapped(_ sender: Any) {
        let story = UIStoryboard(name: Storyboards.authentication, bundle: nil)
        let vc = story.instantiateViewController(withIdentifier:"ForgetPasswordVC") as! ForgetPasswordVC
        vc.title = "Forget Password".localiz()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func createAccount_tapped(_ sender: Any) {
        let story = UIStoryboard(name: Storyboards.authentication, bundle: nil)
        let vc = story.instantiateViewController(withIdentifier:"RegisterTypeVC") as! RegisterTypeVC
        vc.title = "Registration".localiz()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func loginBtn_tapped(_ sender: Any) {
        tableView.endEditing(true)

        if emailTF.text == "" {
            Helper.showFloatAlert(title: "Enter your email or phone number".localiz(), type: .error)
        }else{
            if passwordTF.text == "" {
                Helper.showFloatAlert(title: "Enter Password".localiz(), type: .error)
            }else{
                if isRemember {
                    Helper.saveUserDefault(key: "rememberMail", value: emailTF.text ?? "")
                    Helper.saveUserDefault(key: "rememberPassword", value: passwordTF.text ?? "")
                }else {
                    Helper.removeKeyUserDefault(key: "rememberMail")
                    Helper.removeKeyUserDefault(key: "rememberPassword")
                }
                
                login()
            }
        }
    }
    
    @IBAction func facebookLoginBtn_tap(_ sender: Any) {
        let fbLoginManager : LoginManager = LoginManager()

        fbLoginManager.logIn(permissions: ["email", "public_profile"], from: self) {
            (result, error) -> Void in
            if (error == nil) {
                let fbloginresult : LoginManagerLoginResult = result!
                if result!.isCancelled {
                    return
                }

                if(fbloginresult.grantedPermissions.contains("email")) {
                    self.getFBUserData()
                }
            }else {
                print("error: \(String(describing: error))")
            }
        }
    }
    
    func login() {
        print("player_id", player_id)
        
        let parameters = ["email": emailTF.text ?? "",
                          "player_id": player_id,
                          "password": passwordTF.text ?? ""] as [String : Any]
        presenter?.Login(parameters: parameters)
    }
    
    func getFBUserData(){
        if AccessToken.current != nil {
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil) {
                    
                    let json = JSON(result ?? "")
                    
                    print("result", json)
                    
                    let userName = json["name"].stringValue
                    let userMail = json["email"].stringValue
                    let userId = json["id"].intValue
                    let userImage = json["picture"]["data"]["url"].stringValue
                    
                    print("userName: \(userName)")
                    print("userMail: \(userMail)")
                    print("userId: \(userId)")
                    print("userImage: \(userImage)")
                    
                    let parameters = ["provider_name": "facebook",
                                      "provider_user_id": userId,
                                      "email": userMail,
                                      "name": userName,
                                      "image": userImage,
                                      "player_id": self.player_id] as [String : Any]
                    self.presenter?.SocialLogin(parameters: parameters)
                }else {
                    print("qwqwqwqwqwqwqwqwqwqwq")
                }
            })
        }else {
            print("hghghghghghgh")
        }
    }
  
}

extension LoginVC: LoginPresenterView {
    func getLoginStatus(_ response: Bool) {
        if response {
            socialLoginView.isHidden = false
            facebookView.isHidden = false
        }else {
            socialLoginView.isHidden = true
            facebookView.isHidden = true
        }
    }
    
    func getLoginSuccess(_ response: LoginData) {
        if response.block == "wait" {
            Helper.saveObjectDefault(key: UserDefault.userData, value: response)
            showActivationView()

        }else if response.block == "block" {
            Helper.showFloatAlert(title: "This account is blocked".localiz(), type: .error)

        }else {
            Helper.showFloatAlert(title: "Login Done Successfully".localiz(), type: .success)
            
            Helper.saveObjectDefault(key: UserDefault.userData, value: response)
            
            Helper.ShowMainScreen(controller: self)
        }
    }
    
    func getLoginFailure(_ message: String) {
        Helper.showFloatAlert(title: message, type: .error)
        
        if message == "لم يتم تفعيل الحساب  " {
            showActivationView()
        }
    }

    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), type: .error)
    }
    
    func showActivationView() {
        let story = UIStoryboard(name: Storyboards.authentication, bundle: nil)
        let vc = story.instantiateViewController(withIdentifier:"ActivateVC") as! ActivateVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor  = UIColor(white: 0.5, alpha: 0.5)
        vc.email = emailTF.text ?? ""
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
}
