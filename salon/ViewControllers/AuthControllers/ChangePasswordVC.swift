//
//  ChangePasswordVC.swift
//  salon
//
//  Created by AL Badr  on 5/20/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class ChangePasswordVC: UITableViewController {
    
    @IBOutlet weak var oldPasswordTF: UITextField!
    @IBOutlet weak var newPasswordTF: UITextField!
    @IBOutlet weak var newPasswrdConfirmTF: UITextField!
    
    @IBOutlet weak var showCurrentPasswordBtn: UIButton!
    @IBOutlet weak var showNewPasswordBtn: UIButton!
    @IBOutlet weak var showConfirmNewPasswordBtn: UIButton!
    
    

    var token: String = ""
    var userId: String = ""
    
    fileprivate var presenter: ChangePasswordPresenter?

    var showCurrentPassword: Bool = false
    var showNewPassword: Bool = false
    var showConfirmNewPassword: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let userDate = Helper.getObjectDefault(key: UserDefault.userData) as? LoginData
        token = userDate?.api_token ?? ""
        userId = "\(userDate?.id ?? 0)"
        
        if LanguageManger.shared.currentLanguage == .ar {
            oldPasswordTF.placeholder = "كلمة المرور القديمة"
            oldPasswordTF.textAlignment = .right
            
            newPasswordTF.placeholder = "كلمة المرور الجديدة"
            newPasswordTF.textAlignment = .right
            
            newPasswrdConfirmTF.placeholder = "تأكيد كلمة المرور الجديدة"
            newPasswrdConfirmTF.textAlignment = .right
        }
        
        
        setupKeyboard()

        presenter = ChangePasswordPresenter(self)
    }
    
    func setupKeyboard() {
        let toolbar = setupKeyboardToolbar()
        self.oldPasswordTF.inputAccessoryView = toolbar
        self.newPasswordTF.inputAccessoryView = toolbar
        self.newPasswrdConfirmTF.inputAccessoryView = toolbar
    }
    
    @IBAction func showCurrentPasswordBtn_tapped(_ sender: Any) {
        if showCurrentPassword {
            oldPasswordTF.isSecureTextEntry = true
            showCurrentPasswordBtn.setImage(#imageLiteral(resourceName: "eyelined"), for: .normal)
            showCurrentPassword = false
        }else {
            oldPasswordTF.isSecureTextEntry = false
            showCurrentPasswordBtn.setImage(#imageLiteral(resourceName: "eye"), for: .normal)
            showCurrentPassword = true
        }
    }
    
    @IBAction func showNewPasswordBtn_tapped(_ sender: Any) {
        if showNewPassword {
            newPasswordTF.isSecureTextEntry = true
            showNewPasswordBtn.setImage(#imageLiteral(resourceName: "eyelined"), for: .normal)
            showNewPassword = false
        }else {
            newPasswordTF.isSecureTextEntry = false
            showNewPasswordBtn.setImage(#imageLiteral(resourceName: "eye"), for: .normal)
            showNewPassword = true
        }
    }
    
    @IBAction func showConfirmNewPasswordBtn_tapped(_ sender: Any) {
        if showConfirmNewPassword {
            newPasswrdConfirmTF.isSecureTextEntry = true
            showConfirmNewPasswordBtn.setImage(#imageLiteral(resourceName: "eyelined"), for: .normal)
            showConfirmNewPassword = false
        }else {
            newPasswrdConfirmTF.isSecureTextEntry = false
            showConfirmNewPasswordBtn.setImage(#imageLiteral(resourceName: "eye"), for: .normal)
            showConfirmNewPassword = true
        }
    }
    
    @IBAction func updatePasswordBtn_tapped(_ sender: Any) {
        tableView.endEditing(true)

        if oldPasswordTF.text == "" {
            Helper.showFloatAlert(title: "Enter old password".localiz(), type: .error)
        }else{
            if newPasswordTF.text == ""{
                Helper.showFloatAlert(title: "Enter new password".localiz(), type: .error)
            }else {
                if (newPasswordTF.text ?? "").count < 6 {
                    Helper.showFloatAlert(title: "Password must be at least 6 digits".localiz(), type: .error)
                }else {
                    if newPasswrdConfirmTF.text == "" {
                        Helper.showFloatAlert(title: "Enter new password confirmation".localiz(), type: .error)
                    }else {
                        if newPasswordTF.text != newPasswrdConfirmTF.text  {
                            Helper.showFloatAlert(title: "Password doesn't match".localiz(), type: .error)
                        }else {
                            UpdatePassword()
                        }
                    }
                }
            }
        }
    }
    
    func UpdatePassword() {
        let parameters = ["api_token": token,
                          "current_password": oldPasswordTF.text ?? "",
                          "password": newPasswordTF.text ?? "",
                          "password_confirmation": newPasswrdConfirmTF.text ?? ""] as [String : Any]
        
        presenter?.ChangePassword(parameters: parameters)
    }
    
}

extension ChangePasswordVC: ChangePasswordPresenterView {
    func getChangePasswordSuccess(_ message: String) {
        Helper.showFloatAlert(title: message, type: .success)
        
        Helper.ShowMainScreen(controller: self)
    }
    
    func getChangePasswordFailure(_ message: String) {
        Helper.showFloatAlert(title: message, type: .error)
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), type: .error)
    }
}
