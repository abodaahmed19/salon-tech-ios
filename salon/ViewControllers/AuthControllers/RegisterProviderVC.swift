//
//  RegisterProviderVC.swift
//  salon
//
//  Created by AL Badr  on 5/20/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import DropDown
import AVFoundation
import Photos

class RegisterProviderVC: UITableViewController {
    @IBOutlet var providerTable: UITableView!
    
    
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
    
    @IBOutlet weak var aboutServiceTF: UITextView!
    @IBOutlet weak var salonNameTF: UITextField!
    
    @IBOutlet weak var serviceImageBtn: UIButton!
    @IBOutlet weak var serviceCityBtn: UIButton!
    @IBOutlet weak var serviceDistrictsBtn: UIButton!
    @IBOutlet weak var servicesBtn: UIButton!
    @IBOutlet weak var addCertificateBtn: UIButton!
    
    @IBOutlet weak var districtsCV: UICollectionView!
    @IBOutlet weak var servicesCV: UICollectionView!
    
    var selectedDepartmentsList: [DepartmentsData] = []
    var selectedDistrictsList: [DistrictsData] = []

    /*
     خلي بالك الcity بقت area وال district بقت city
     */
    
    var citiesList: [CitiesData] = []
    var cities:[String] = []
    let citiesDropDown = DropDown()
    var cityType: String = ""
    var selectedCityId: String = ""
    var selectedServiceCityId: String = ""
    
    var departmentsList: [DepartmentsData] = []
    var departments:[String] = []
    let departmentsDropDown = DropDown()
    var selectedDepartmentId: String = ""

    var districtsList: [DistrictsData] = []
    var districts:[String] = []
    let districtsDropDown = DropDown()
    var selectedDistrictId: String = ""
    
    var imageType: String = ""
    
    var profileImageList : [UIImage] = []
    var idImageList : [UIImage] = []
    var serviceImageList : [UIImage] = []
    var certificateImageList : [UIImage] = []
    
    var itemsIDs: [Int] = []
    var districrsIDs: [Int] = []
    
    var departmentsCellHight: CGFloat = 0
    var districtsCellHight: CGFloat = 0

    fileprivate var presenter: RegisterPresenter?
    
    var showPassword: Bool = false
    var showConfirmPassword: Bool = false
    
    var videoData: Data = Data()
    var videoString: String = ""
    var coverType: String = "image"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginNotifications), name: NSNotification.Name(rawValue: "homeNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginNotifications), name: NSNotification.Name(rawValue: "loginNotification"), object: nil)

                

        setupKeyboard()
        initView()
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = CGFloat()
        
        if indexPath.row == 0 {
            height = 200
        }else if indexPath.row == 7 {
            height = 190
        }else if indexPath.row == 8{
            height = 90
        }else if indexPath.row == 11{
            height = districtsCellHight
        }else if indexPath.row == 13{
            height = departmentsCellHight
        }else if indexPath.row == 14{
            height = 100
        }else if indexPath.row == 15{
            height = 100
        }else if indexPath.row == 18{
            height = 70
        }else if indexPath.row == 19{
            height = 80
        }else {
            height = 55
        }
        
        return height
    }
    
    func initView() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        if LanguageManger.shared.currentLanguage == .ar {
            nameTF.placeholder = "الاسم"
            phoneTF.placeholder = "الجوال"
            emailTF.placeholder = "البريد الإلكتروني"
            passwordTF.placeholder = "كلمة المرور"
            passwordConfirmTF.placeholder = "تأكيد كلمة المرور"
            identityTF.placeholder = "رقم الهوية أو رقم الإقامة (اختياري)"
            addressTF.placeholder = "العنوان"
            aboutServiceTF.text = "About services".localiz()
            salonNameTF.placeholder = "اسم المشغل أو المعهد"
        }
        
        districtsCV.dataSource = self
        districtsCV.delegate = self
        districtsCV.register(UINib(nibName: "DistrictsCell", bundle: nil), forCellWithReuseIdentifier: "DistrictsCell")
        
        servicesCV.dataSource = self
        servicesCV.delegate = self
        servicesCV.register(UINib(nibName: "DistrictsCell", bundle: nil), forCellWithReuseIdentifier: "DistrictsCell")
        
        presenter = RegisterPresenter(self)
        presenter?.getCities(areaId: "0")
        presenter?.getDepartments()
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
        aboutServiceTF.inputAccessoryView = toolbar
        salonNameTF.inputAccessoryView = toolbar
                
        aboutServiceTF.delegate = self
    }
    
    func setupCitiesDropDown() {
//        citiesBtn.setTitle("Choose city".localiz(), for: .normal)
//        serviceCityBtn.setTitle("Choose city".localiz(), for: .normal)

        cities.removeAll()
        cities.append("All".localiz())
        
        for city in citiesList{
            if LanguageManger.shared.currentLanguage == .ar {
                cities.append(city.city_name ?? "")
            }else {
                cities.append(city.city_name_en ?? "")
            }
        }
            
        if self.cityType == "userCity" {
            citiesDropDown.anchorView = citiesBtn
        }else {
            citiesDropDown.anchorView = serviceCityBtn
        }

        citiesDropDown.bottomOffset = CGPoint(x: 0, y: 0)
        citiesDropDown.dataSource = cities
        citiesDropDown.selectionAction = { [unowned self](index, item) in
            
            if self.cityType == "userCity" {
                self.citiesBtn.setTitle(item, for: .normal)
                
                if index == 0 {
                    self.selectedCityId = ""
                }else {
                    self.selectedCityId = "\(self.citiesList[index-1].city_id ?? 0)"
                }
            }else {
                self.serviceCityBtn.setTitle(item, for: .normal)
                
                if index == 0 {
                    self.selectedServiceCityId = ""
                }else {
                    self.selectedServiceCityId = "\(self.citiesList[index-1].city_id ?? 0)"
                    self.presenter?.getDistricts(city_id: self.selectedServiceCityId)
                }
            }
        }
    }
    
    func setDistrictsDropDown() {
        serviceDistrictsBtn.setTitle("Choose city".localiz(), for: .normal)
        districts.removeAll()
        districts.append("All".localiz())
        
        for dist in districtsList {
            if LanguageManger.shared.currentLanguage == .ar {
                districts.append(dist.name_ar ?? "")
            }else {
                districts.append(dist.name_en ?? "")
            }
        }
        
        districtsDropDown.anchorView = serviceDistrictsBtn
        districtsDropDown.bottomOffset = CGPoint(x: 0, y: 0)
        districtsDropDown.dataSource = districts
        districtsDropDown.selectionAction = { [unowned self](index, item) in
            self.serviceDistrictsBtn.setTitle(item, for: .normal)
            
            if index == 0 {
                self.selectedDistrictId = ""
            }else {
                self.selectedDistrictId = "\(self.districtsList[index-1].id ?? 0)"
                
                if self.districrsIDs.contains(Int(self.selectedDistrictId) ?? 0) {
                    Helper.showFloatAlert(title: "You have already added the city".localiz(), type: .error)
                }else {
                    self.districrsIDs.append(self.districtsList[index-1].id ?? 0)
                    
                    var districtData = DistrictsData()
                    districtData.id = self.districtsList[index-1].id ?? 0
                    
                    if LanguageManger.shared.currentLanguage == .ar {
                        districtData.name_ar = item
                    }else {
                        districtData.name_en = item
                    }
                    
                    self.selectedDistrictsList.append(districtData)
                    self.districtsCV.reloadData()
                    
                    self.districtsCellHight = 58
                    self.providerTable.reloadData()
                }
            }
        }
    }
    
    func setupDepartmentsDropDown() {
        servicesBtn.setTitle("The Services you provide".localiz(), for: .normal)
        departments.removeAll()
        departments.append("All".localiz())
        
        for depart in departmentsList {
            if LanguageManger.shared.currentLanguage == .ar {
                departments.append(depart.department_name ?? "")
            }else {
                departments.append(depart.department_name_en ?? "")
            }
        }
        
        departmentsDropDown.anchorView = servicesBtn
        departmentsDropDown.bottomOffset = CGPoint(x: 0, y: 0)
        departmentsDropDown.dataSource = departments
        departmentsDropDown.selectionAction = { [unowned self](index, item) in
            self.servicesBtn.setTitle(item, for: .normal)
            
            if index == 0 {
                self.selectedDepartmentId = ""
            }else {
                self.selectedDepartmentId = "\(self.departmentsList[index-1].department_id ?? 0)"
                
                if self.itemsIDs.contains(Int(self.selectedDepartmentId) ?? 0) {
                    Helper.showFloatAlert(title: "You have already added the service".localiz(), type: .error)
                }else {
                    self.itemsIDs.append(self.departmentsList[index-1].department_id ?? 0)
                    
                    let departmentData = DepartmentsData()
                    departmentData.department_id = self.departmentsList[index-1].department_id ?? 0
                    
                    if LanguageManger.shared.currentLanguage == .ar {
                        departmentData.department_name = item
                    }else {
                        departmentData.department_name_en = item
                    }
                    
                    self.selectedDepartmentsList.append(departmentData)
                    self.servicesCV.reloadData()
                    
                    self.departmentsCellHight = 58
                    self.providerTable.reloadData()
                }
            }
        }
    }
    
    func showAddImageAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let galaryImage = #imageLiteral(resourceName: "galaryblue")
        let galaryAction = UIAlertAction(title: "Library".localiz(), style: .default, handler: openGalary)
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
        
        if imageType == "service" {
            vc.mediaTypes = ["public.image", "public.movie"]
        }
        
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

            if imageType == "service" {
                vc.mediaTypes = ["public.image", "public.movie"]
                vc.cameraCaptureMode = .video
                
            }else {
                vc.cameraCaptureMode = .photo
            }
            
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
    
    @IBAction func serviceImageBtn_tapped(_ sender: Any) {
        imageType = "service"
        showAddImageAlert()
    }
    
    @IBAction func deleteServiceImage_tapped(_ sender: Any) {
        serviceImageList.removeAll()
        serviceImageBtn.setImage(#imageLiteral(resourceName: "imagegray"), for: .normal)
        videoString = ""
    }
    
    @IBAction func citiesBtn_tapped(_ sender: Any) {
        cityType = "userCity"
        setupCitiesDropDown()
        citiesDropDown.show()
    }
    
    @IBAction func serviceCityBtn_tapped(_ sender: Any) {
        cityType = "serviceCity"
        setupCitiesDropDown()
        citiesDropDown.show()
    }
    
    @IBAction func serviceDistrictsBtn_tapped(_ sender: Any) {
        districtsDropDown.show()
    }
    
    @IBAction func servicesBtn_tapped(_ sender: Any) {
        departmentsDropDown.show()
    }
    
    @IBAction func addCertificate_tapped(_ sender: Any) {
        imageType = "certificate"
        showAddImageAlert()
    }
    
    @IBAction func deleteCertificateBtn_tappes(_ sender: Any) {
        certificateImageList.removeAll()
        addCertificateBtn.setImage(#imageLiteral(resourceName: "imagegray"), for: .normal)
    }
    
    @IBAction func termsBtn_tapped(_ sender: Any) {
        let storyBoard = UIStoryboard(name: Storyboards.main, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PagesDetailsVC") as! PagesDetailsVC
        vc.title = "Terms and conditions".localiz()
        vc.pageId = 2
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func providerRegisterBtn_tapped(_ sender: Any) {
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
                                        Helper.showFloatAlert(title: "Choose your area".localiz(), type: .error)
                                    }else {
                                        if passwordTF.text == "" {
                                            Helper.showFloatAlert(title: "Enter Password".localiz(), type: .error)
                                        }else {
                                            if passwordTF.text != passwordConfirmTF.text  {
                                                Helper.showFloatAlert(title: "Password doesn't match".localiz(), type: .error)
                                            }else {
                                                if selectedServiceCityId == "" {
                                                    Helper.showFloatAlert(title: "Choose your service area".localiz(), type: .error)
                                                }else {
                                                    if districrsIDs.isEmpty {
                                                        Helper.showFloatAlert(title: "Choose your service city".localiz(), type: .error)
                                                    }else {
                                                        if itemsIDs.isEmpty {
                                                            Helper.showFloatAlert(title: "Choose services you provide".localiz(), type: .error)
                                                        }else {
                                                            providerRegister()
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
            }
        }
    }
    
    func providerRegister() {
        let player_id = Helper.getUserDefault(key: UserDefault.player_id) as! String

        
        if videoString == "" {
            coverType = "image"
        }else {
            coverType = "video"
        }
        
        let parameters = ["identity_id": identityTF.text ?? "",
                          "phone": (phoneTF.text ?? ""),
                          "city_id": selectedCityId,
                          "name": nameTF.text ?? "",
                          "address": addressTF.text ?? "",
                          "email": emailTF.text ?? "",
                          "password": passwordTF.text ?? "",
                          "password_confirmation": passwordConfirmTF.text ?? "",
                          "player_id": player_id,
                          "certified_from": salonNameTF.text ?? "",
                          "place_name": salonNameTF.text ?? "",
                          "cover_type": coverType,
                          "bio": aboutServiceTF.text ?? ""] as [String : Any]

        presenter?.ProviderSignup(parameters: parameters,
                                  profileImage: profileImageList,
                                  idImage: idImageList,
                                  serviceImage: serviceImageList,
                                  certificateImage: certificateImageList,
                                  itemsIDs: itemsIDs,
                                  districrsIDs: districrsIDs,
                                  videoString: videoString,
                                  videoData: videoData)
    }

}

extension RegisterProviderVC: RegisterPresenterView {
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
    }
    
    func setCitiesFailure() {
        citiesList.removeAll()
        citiesBtn.setTitle("No Areas".localiz(), for: .normal)
        serviceCityBtn.setTitle("No Areas".localiz(), for: .normal)
    }
    
    func setDistricts(_ sections: [DistrictsData]) {
        districtsList = sections
        setDistrictsDropDown()
    }
    
    func setDistrictsFailure() {
        districtsList.removeAll()
        serviceDistrictsBtn.setTitle("No Cities".localiz(), for: .normal)
    }
    
    func setDepartments(_ sections: [DepartmentsData]) {
        departmentsList = sections
        setupDepartmentsDropDown()
    }
    
    func setDepartmentsFailure() {
        departmentsList.removeAll()
        servicesBtn.setTitle("No Services".localiz(), for: .normal)
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), type: .error)
    }
}


extension RegisterProviderVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case servicesCV:
            if LanguageManger.shared.currentLanguage == .ar {
                let text = selectedDepartmentsList[indexPath.row].department_name ?? ""
                let cellWidth = text.size(withAttributes:[.font: UIFont.systemFont(ofSize:16.0)]).width + 72
                return CGSize(width: cellWidth, height: 45)
            }else {
                let text = selectedDepartmentsList[indexPath.row].department_name_en ?? ""
                let cellWidth = text.size(withAttributes:[.font: UIFont.systemFont(ofSize:16.0)]).width + 72
                return CGSize(width: cellWidth, height: 45)
            }
            
        default:
            if LanguageManger.shared.currentLanguage == .ar {
                let text = selectedDistrictsList[indexPath.row].name_ar ?? ""
                let cellWidth = text.size(withAttributes:[.font: UIFont.systemFont(ofSize:16.0)]).width + 72
                return CGSize(width: cellWidth, height: 45)
            }else {
                let text = selectedDistrictsList[indexPath.row].name_en ?? ""
                let cellWidth = text.size(withAttributes:[.font: UIFont.systemFont(ofSize:16.0)]).width + 72
                return CGSize(width: cellWidth, height: 45)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case servicesCV:
            return selectedDepartmentsList.count
        default:
            return selectedDistrictsList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case servicesCV:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DistrictsCell", for: indexPath) as?
                DistrictsCell else {
                    return UICollectionViewCell()
            }
            
            cell.configDepartmentsCell(item: selectedDepartmentsList[indexPath.row])
            
            cell.deleteBtn.addTarget(self, action: #selector(deleteDepartment_tapped(_:)), for: UIControl.Event.touchUpInside)
            cell.deleteBtn.tag = indexPath.row
            
            return cell
            
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DistrictsCell", for: indexPath) as?
                DistrictsCell else {
                    return UICollectionViewCell()
            }
            
            cell.configDistrictsCell(item: selectedDistrictsList[indexPath.row])
                        
            cell.deleteBtn.addTarget(self, action: #selector(deleteDistrict_tapped), for: UIControl.Event.touchUpInside)
            cell.deleteBtn.tag = indexPath.row
            
            return cell
        }
    }
    
    @objc func deleteDepartment_tapped(_ sender: UIButton) {
        selectedDepartmentsList.remove(at: sender.tag)
        itemsIDs.remove(at: sender.tag)
        
        servicesCV.reloadData()
        
        if selectedDepartmentsList.isEmpty {
            departmentsCellHight = 0
            providerTable.reloadData()
        }
    }
    
    @objc func deleteDistrict_tapped(_ sender: UIButton) {
        selectedDistrictsList.remove(at: sender.tag)
        districrsIDs.remove(at: sender.tag)
        
        districtsCV.reloadData()
        
        if selectedDistrictsList.isEmpty {
            districtsCellHight = 0
            providerTable.reloadData()
        }
    }
}


extension RegisterProviderVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            if imageType == "profile" {
                profileImageList.removeAll()
                profileImageList.append(image)
                profileImageBtn.setImage(image, for: .normal)
                
            }else if imageType == "id" {
                idImageList.removeAll()
                idImageList.append(image)
                identityImageBtn.setImage(image, for: .normal)
                
            }else if imageType == "service" {
                serviceImageList.removeAll()
                serviceImageList.append(image)
                serviceImageBtn.setImage(image, for: .normal)
                
                videoString = ""
                coverType = "image"
      
            }else {
                certificateImageList.removeAll()
                certificateImageList.append(image)
                addCertificateBtn.setImage(image, for: .normal)
            }
        }else {
            print("Video")
        }

        if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL{
            self.videoString = "\(videoUrl)"
            
            print("videourl: ", self.videoString)
            
            serviceImageList.removeAll()

            coverType = "video"
            
            do {
                self.videoData = try Data(contentsOf: videoUrl as URL)
            }catch let error {
                print("*** Error generating Video Data: \(error.localizedDescription)")
            }
            
            do {
                let asset = AVURLAsset(url: videoUrl as URL , options: nil)
                let imgGenerator = AVAssetImageGenerator(asset: asset)
                imgGenerator.appliesPreferredTrackTransform = true
                let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
                let thumbnail = UIImage(cgImage: cgImage)
                serviceImageBtn.setImage(thumbnail, for: .normal)
            } catch let error {
                print("*** Error generating thumbnail: \(error.localizedDescription)")
            }
        }
        else{
            print("Something went wrong in  video")
        }
        
        picker.dismiss(animated: true)
    }
}

extension RegisterProviderVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if aboutServiceTF.text == "About services".localiz() {
            aboutServiceTF.text = ""
            aboutServiceTF.textColor = .black
        }
    }
}
