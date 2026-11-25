//
//  EditProfileVC.swift
//  salon
//
//  Created by AL Badr  on 5/20/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import DropDown

class EditProfileVC: UITableViewController {
    
    @IBOutlet weak var profileImageBtn: UIButton!
    @IBOutlet weak var identityImageBtn: UIButton!
    @IBOutlet weak var profileView: RoundRectView!
    @IBOutlet weak var identityView: RoundRectView!
    
    @IBOutlet weak var serialNumber: UILabel!
    
    @IBOutlet weak var identityTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    
    @IBOutlet weak var citiesBtn: UIButton!
    
    fileprivate var presenter: EditProfilePresenter?
    
    var citiesList: [CitiesData] = []
    var cities:[String] = []
    let citiesDropDown = DropDown()
    var selectedCityId: String = ""
    
    var imageType: String = ""
    
    var profileImageList : [UIImage] = []
    var idImageList : [UIImage] = []
    
    var token: String = ""
    var userId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginNotifications), name: NSNotification.Name(rawValue: "loginNotification"), object: nil)
        
        let userDate = Helper.getObjectDefault(key: UserDefault.userData) as? LoginData
        token = userDate?.api_token ?? ""
        userId = "\(userDate?.id ?? 0)"
        
        if LanguageManger.shared.currentLanguage == .ar {
            nameTF.placeholder = "الاسم"
            phoneTF.placeholder = "الجوال"
            emailTF.placeholder = "البريد الإلكتروني"
            identityTF.placeholder = "رقم الهوية أو رقم الإقامة (اختياري)"
            addressTF.placeholder = "العنوان"
        }
        
        setupKeyboard()
        
        presenter = EditProfilePresenter(self)
        presenter?.getClientData()
    }
    
    @objc func LoginNotifications(notification: NSNotification){
        Helper.ShowMainScreen(controller: self)
    }
    
    func setupKeyboard() {
        let toolbar = setupKeyboardToolbar()
        nameTF.inputAccessoryView = toolbar
        phoneTF.inputAccessoryView = toolbar
        emailTF.inputAccessoryView = toolbar
        identityTF.inputAccessoryView = toolbar
        addressTF.inputAccessoryView = toolbar
    }
    
    func setupCitiesDropDown() {
        if let i = citiesList.firstIndex(where: { $0.city_id == Int(selectedCityId) }) {
            
            if LanguageManger.shared.currentLanguage == .ar {
                citiesBtn.setTitle(citiesList[i].city_name ?? "", for: .normal)
            }else {
                citiesBtn.setTitle(citiesList[i].city_name_en ?? "", for: .normal)
            }
            
        }else {
            citiesBtn.setTitle("Choose city".localiz(), for: .normal)
        }
                
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
    
    @IBAction func changePassword_tapped(_ sender: Any) {
        let storyBoard = UIStoryboard(name: Storyboards.authentication, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        vc.title = "Change Password".localiz()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func deleteAccountBtn_tapped(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Your Account?".localiz(), message: "delete_account".localiz(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes".localiz(), style: .default, handler: { [weak self] action in
            guard let self = self else { return }
            self.presenter?.deleteAccount()
        }))
        alert.addAction(UIAlertAction(title: "No".localiz(), style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }

    @IBAction func clientRegisterBtn_tapped(_ sender: Any) {
        tableView.endEditing(true)
        
//        if identityTF.text == ""{
//            Helper.showFloatAlert(title: "Enter your national ID or residence number".localiz(), type: .error)
//        }else{
//            if identityTF.text?.count != 10 {
//                Helper.showFloatAlert(title: "Identity number must be 10 digits".localiz(), type: .error)
//            }else {
//
//            }
//        }
        
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
                                    updateClientProfile()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func updateClientProfile() {
        let parameters = ["api_token": token,
                          "identity_id": identityTF.text ?? "",
                          "phone": (phoneTF.text ?? ""),
                          "city_id": selectedCityId,
                          "name": nameTF.text ?? "",
                          "address": addressTF.text ?? "",
                          "email": emailTF.text ?? ""] as [String : Any]
        
        presenter?.updateClient(parameters: parameters, profile: profileImageList, identity: idImageList)
    }
    
}

extension EditProfileVC: EditProfilePresenterView {
    func getProviderDataSuccess(_ response: LoginData) {}
    
    func setDistricts(_ sections: [DistrictsData]) {}
    
    func setDistrictsFailure() {}
    
    func getClientDataSuccess(_ response: LoginData) {
        serialNumber.text = "C\(response.id ?? 0)"
        identityTF.text = String(response.identity_id ?? "")
        nameTF.text = response.name ?? ""
        
        phoneTF.text = response.phone ?? ""
    
        emailTF.text = response.email ?? ""
        addressTF.text = response.address ?? ""
        
        profileImageBtn.sd_setImage(with: URL(string: SITE_URL + (response.image ?? "")), for: .normal, placeholderImage: #imageLiteral(resourceName: "girlgray"))
        identityImageBtn.sd_setImage(with: URL(string: SITE_URL + (response.image_identity ?? "")), for: .normal, placeholderImage: #imageLiteral(resourceName: "businessblack"))
        
        selectedCityId = String(response.city_id_Int ?? 0)

        presenter?.getCities(areaId: "0")
    }
    
    func getUpdateProfileSuccess(_ response: PostModel) {
        Helper.showFloatAlert(title: response.message ?? "", type: .success)
        
        let userDate = Helper.getObjectDefault(key: UserDefault.userData) as? LoginData
        userDate?.name = response.name ?? ""
        userDate?.image = response.image_url ?? ""
        Helper.saveObjectDefault(key: UserDefault.userData, value: userDate as Any)
        
        Helper.ShowMainScreen(controller: self)
    }
    
    func getUpdateProfileFailure(_ message: String) {
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
        
    func setDepartments(_ sections: [DepartmentsData]) {}
    
    func setDepartmentsFailure() {}
    
    func getDeleteAccountSuccess(_ message: String) {
        Helper.showFloatAlert(title: message, type: .success)
        
        Helper.removeKeyUserDefault(key: UserDefault.userData)
        Helper.removeKeyUserDefault(key: UserDefault.userReservation)
        
        Helper.goToLoginScreen(controller: self)
    }
    
    func getDeleteAccountFailure(_ message: String) {
        Helper.showFloatAlert(title: message, type: .error)
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), type: .error)
    }
}

extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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

