//
//  RegisterClientVC.swift
//  salon
//
//  Created by AL Badr  on 5/20/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import DropDown

class RegisterClientVC: UITableViewController {
    @IBOutlet weak var profileImageBtn: UIButton!
    @IBOutlet weak var identityImageBtn: UIButton!
    @IBOutlet weak var profileView: RoundRectView!
    @IBOutlet weak var identityView: RoundRectView!

    @IBOutlet weak var identityTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var passwordConfirmTF: UITextField!
    
    @IBOutlet weak var citiesBtn: UIButton!
    @IBOutlet weak var checkBtn: CheckBox!
    
    @IBOutlet weak var showPasswordBtn: UIButton!
    @IBOutlet weak var showConfirmPasswordBtn: UIButton!
    
    var citiesList: [CitiesData] = []
    var cities:[String] = []
    let citiesDropDown = DropDown()
    var selectedCityId: String = ""
    
    var imageType: String = ""
    
    var profileImageList : [UIImage] = []
    var idImageList : [UIImage] = []

    fileprivate var presenter: RegisterPresenter?
    
    var showPassword: Bool = false
    var showConfirmPassword: Bool = false

    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginNotifications), name: NSNotification.Name(rawValue: "homeNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginNotifications), name: NSNotification.Name(rawValue: "loginNotification"), object: nil)
        
        if LanguageManger.shared.currentLanguage == .ar {
            nameTF.placeholder = "الاسم"
            phoneTF.placeholder = "الجوال"
            emailTF.placeholder = "البريد الإلكتروني"
            passwordTF.placeholder = "كلمة المرور"
            passwordConfirmTF.placeholder = "تأكيد كلمة المرور"
            identityTF.placeholder = "رقم الهوية أو رقم الإقامة (اختياري)"
            addressTF.placeholder = "العنوان"
        }
        
        setupKeyboard()
        
        presenter = RegisterPresenter(self)
        presenter?.getCities(areaId: "0")
    }

    @objc func LoginNotifications(notification: NSNotification){
        if notification.name.rawValue == "homeNotification" {
            Helper.ShowMainScreen(controller: self)
        }else {
            let storyBoard = UIStoryboard(name: Storyboards.authentication, bundle: nil)
            let editVC = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            editVC.title = "Login".localiz()
            self.navigationController?.pushViewController(editVC, animated: true)
        }
    }
    
    func setupKeyboard() {
        let toolbar = setupKeyboardToolbar()
        nameTF.inputAccessoryView = toolbar
        phoneTF.inputAccessoryView = toolbar
        emailTF.inputAccessoryView = toolbar
        passwordTF.inputAccessoryView = toolbar
        passwordConfirmTF.inputAccessoryView = toolbar
        identityTF.inputAccessoryView = toolbar
        addressTF.inputAccessoryView = toolbar
    }
    
    func setupCitiesDropDown() {
        citiesBtn.setTitle("Choose city".localiz(), for: .normal)
        cities.removeAll()
        cities.append("All".localiz())
        
        for city in citiesList{
            if LanguageManger.shared.currentLanguage == .ar {
                cities.append(city.city_name ?? "")
            }else {
                cities.append(city.city_name_en ?? "")
            }
        }
        
        citiesDropDown.anchorView = citiesBtn
        citiesDropDown.bottomOffset = CGPoint(x: 0, y: 0)
        citiesDropDown.dataSource = cities
        citiesDropDown.selectionAction = { [unowned self](index, item) in
            self.citiesBtn.setTitle(item, for: .normal)
            
            if index == 0 {
                self.selectedCityId = ""
            }else {
                self.selectedCityId = "\(self.citiesList[index-1].city_id ?? 0)"
            }
        }
    }
    
    func showAddImageAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let galaryImage = #imageLiteral(resourceName: "galaryblue")
        let galaryAction = UIAlertAction(title: "Photo Library".localiz(), style: .default, handler: openGalary)
        galaryAction.setValue(galaryImage, forKey: "image")
        
        let cameraImage = #imageLiteral(resourceName: "camerablue")
        let cameraAction = UIAlertAction(title: "Camera".localiz(), style: .default, handler: openCamera)
        cameraAction.setValue(cameraImage, forKey: "image")
        
        alert.addAction(galaryAction)
        alert.addAction(cameraAction)
        alert.addAction(UIAlertAction(title: "Cancel".localiz(), style: .cancel, handler: nil))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view //to set the source of your alert
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.maxY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alert, animated: true)
    }
    
    @objc func openGalary(alert: UIAlertAction!) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = false
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc func openCamera(alert: UIAlertAction!) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let vc = UIImagePickerController()
            vc.sourceType = .camera
            vc.cameraCaptureMode = .photo
            vc.modalPresentationStyle = .fullScreen
            vc.allowsEditing = false
            vc.delegate = self
            present(vc, animated: true)
        } else {
            Helper.showFloatAlert(title: "Camera is not Available".localiz(), type: .error)
        }
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
    
    @IBAction func showConfirmPasswordBtn_tapped(_ sender: Any) {
        if showConfirmPassword {
            passwordConfirmTF.isSecureTextEntry = true
            showConfirmPasswordBtn.setImage(#imageLiteral(resourceName: "eyelined"), for: .normal)
            showConfirmPassword = false
        }else {
            passwordConfirmTF.isSecureTextEntry = false
            showConfirmPasswordBtn.setImage(#imageLiteral(resourceName: "eye"), for: .normal)
            showConfirmPassword = true
        }
    }
    
    @IBAction func profileBtn_tapped(_ sender: Any) {
        imageType = "profile"
        showAddImageAlert()
    }
    
    @IBAction func identityBtn_tapped(_ sender: Any) {
        imageType = "id"
        showAddImageAlert()
    }
    
    @IBAction func deleteProfileBtn_tapped(_ sender: Any) {
        profileImageList.removeAll()
        profileImageBtn.setImage(#imageLiteral(resourceName: "girlgray"), for: .normal)
    }
    
    @IBAction func deleteIdentityBtn_tapped(_ sender: Any) {
        idImageList.removeAll()
        identityImageBtn.setImage(#imageLiteral(resourceName: "businessblack"), for: .normal)
    }
    
    @IBAction func citiesBtn_tapped(_ sender: Any) {
        citiesDropDown.show()
    }
    
    @IBAction func termsBtn_tapped(_ sender: Any) {
        let storyBoard = UIStoryboard(name: Storyboards.main, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PagesDetailsVC") as! PagesDetailsVC
        vc.title = "Terms and conditions".localiz()
        vc.pageId = 2
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clientRegisterBtn_tapped(_ sender: Any) {
        tableView.endEditing(true)
        
//        if identityTF.text == ""{
//            Helper.showFloatAlert(title: "Enter your national ID or residence number".localiz(), type: .error)
//        }else{
//            if identityTF.text?.count != 10 {
//                Helper.showFloatAlert(title: "Identity number must be 10 digits".localiz(), type: .error)
//            }else {
//                if idImageList.isEmpty {
//                    Helper.showFloatAlert(title: "Attach your national ID or residence image".localiz(), type: .error)
//                }else {
//                    if profileImageList.isEmpty {
//                        Helper.showFloatAlert(title: "Attach your profile photo".localiz(), type: .error)
//                    }else {
//
//                    }
//                }
//            }
//        }
        
        if checkBtn.isChecked == false {
            Helper.showFloatAlert(title: "You must agree to all terms and conditions".localiz(), type: .error)
        }else {
            if nameTF.text == ""{
                Helper.showFloatAlert(title: "Enter your name".localiz(), type: .error)
            }else{
                if phoneTF.text == "" {
                    Helper.showFloatAlert(title: "Enter your phone number".localiz(), type: .error)
                }else{
                    if phoneTF.text?.prefix(2) != "05" ||  phoneTF.text?.count != 10 {
                        Helper.showFloatAlert(title: "Phone number must be 10 digits and begin with 05".localiz(), type: .error)
                    }else {
                        if emailTF.text == "" {
                            Helper.showFloatAlert(title: "Enter your email".localiz(), type: .error)
                        }else{
                            if Helper.isValidEmail(mail_address: emailTF.text ?? "") == false {
                                Helper.showFloatAlert(title: "Enter valid email".localiz(), type: .error)
                            }else {
                                if addressTF.text == ""{
                                    Helper.showFloatAlert(title: "Enter your address".localiz(), type: .error)
                                }else{
                                    if selectedCityId == "" {
                                        Helper.showFloatAlert(title: "Choose your city".localiz(), type: .error)
                                    }else {
                                        if passwordTF.text == "" {
                                            Helper.showFloatAlert(title: "Enter Password".localiz(), type: .error)
                                        }else {
                                            if passwordTF.text != passwordConfirmTF.text  {
                                                Helper.showFloatAlert(title: "Password doesn't match".localiz(), type: .error)
                                            }else {
                                                clientRegister()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func clientRegister() {
        let player_id = Helper.getUserDefault(key: UserDefault.player_id) as! String

        let parameters = ["identity_id": identityTF.text ?? "",
                          "phone": (phoneTF.text ?? ""),
                          "city_id": selectedCityId,
                          "name": nameTF.text ?? "",
                          "address": addressTF.text ?? "",
                          "email": emailTF.text ?? "",
                          "password": passwordTF.text ?? "",
                          "player_id": player_id] as [String : Any]
        
        presenter?.ClientSignup(parameters: parameters, profile: profileImageList, identity: idImageList)
    }

}

extension RegisterClientVC: RegisterPresenterView {
    func getSignupSuccess(_ response: LoginData) {
        Helper.showFloatAlert(title: "Registration Done Successfully".localiz(), type: .success)

        Helper.saveObjectDefault(key: UserDefault.userData, value: response)
        
        let story = UIStoryboard(name: Storyboards.authentication, bundle: nil)
        let vc = story.instantiateViewController(withIdentifier:"ActivateVC") as! ActivateVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor  = UIColor(white: 0.5, alpha: 0.5)
        vc.email = emailTF.text ?? ""
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
 
    func getSignupFailure(_ message: String) {
        Helper.showFloatAlert(title: message, type: .error)
    }
    
    func setCities(_ sections: [CitiesData]) {
        citiesList = sections
        setupCitiesDropDown()
    }
    
    func setCitiesFailure() {
        citiesList.removeAll()
        citiesBtn.setTitle("No Cities".localiz(), for: .normal)
    }
    
    func setDistricts(_ sections: [DistrictsData]) {}
    
    func setDistrictsFailure() {}
    
    func setDepartments(_ sections: [DepartmentsData]) {}
    
    func setDepartmentsFailure() {}
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), type: .error)
    }
}

extension RegisterClientVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else { return }
        
        if imageType == "profile" {
            profileImageList.removeAll()
            profileImageList.append(image)
            profileImageBtn.setImage(image, for: .normal)
            
        }else {
            idImageList.removeAll()
            idImageList.append(image)
            identityImageBtn.setImage(image, for: .normal)
        }
        
        picker.dismiss(animated: true)
    }
}

