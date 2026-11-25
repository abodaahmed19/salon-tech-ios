//
//  EditProviderProfileVC.swift
//  salon
//
//  Created by AL Badr  on 6/26/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//


import UIKit
import DropDown
import AVFoundation
import Photos

class EditProviderProfileVC: UITableViewController {
    @IBOutlet var providerTable: UITableView!
    
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
    
    var videoData: Data = Data()
    var videoString: String = ""
    var coverType: String = "image"

    fileprivate var presenter: EditProfilePresenter?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginNotifications), name: NSNotification.Name(rawValue: "loginNotification"), object: nil)
                

        setupKeyboard()
        initView()
    }

    @objc func LoginNotifications(notification: NSNotification){
        Helper.ShowMainScreen(controller: self)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = CGFloat()
        
        if indexPath.row == 0 {
            height = 200
        }else if indexPath.row == 8 {
            height = 190
        }else if indexPath.row == 9{
            height = 90
        }else if indexPath.row == 12{
            height = districtsCellHight
        }else if indexPath.row == 14{
            height = departmentsCellHight
        }else if indexPath.row == 15{
            height = 100
        }else if indexPath.row == 16{
            height = 100
        }else if indexPath.row == 19{
            height = 70
        }else if indexPath.row == 20{
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
        
        presenter = EditProfilePresenter(self)
        presenter?.getProviderData()
    }
    
    func setupKeyboard() {
        let toolbar = setupKeyboardToolbar()
        nameTF.inputAccessoryView = toolbar
        phoneTF.inputAccessoryView = toolbar
        emailTF.inputAccessoryView = toolbar
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
                self.selectedCityId = "\(self.citiesList[index].city_id ?? 0)"

            }else {
                self.serviceCityBtn.setTitle(item, for: .normal)
                self.selectedServiceCityId = "\(self.citiesList[index].city_id ?? 0)"
                self.presenter?.getDistricts(city_id: self.selectedServiceCityId)
            }
        }
    }
    
    func setDistrictsDropDown() {
        serviceDistrictsBtn.setTitle("Choose city".localiz(), for: .normal)
        districts.removeAll()
        
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
            self.selectedDistrictId = "\(self.districtsList[index].id ?? 0)"
            
            if self.districrsIDs.contains(Int(self.selectedDistrictId) ?? 0) {
                 Helper.showFloatAlert(title: "You have already added the city".localiz(), type: .error)
            }else {
                self.districrsIDs.append(self.districtsList[index].id ?? 0)
                
                var districtData = DistrictsData()
                districtData.id = self.districtsList[index-1].id ?? 0

                districtData.name_ar = self.districtsList[index].name_ar ?? ""
                districtData.name_en = self.districtsList[index].name_en ?? ""
                
                self.selectedDistrictsList.append(districtData)
                self.districtsCV.reloadData()
                
                self.districtsCellHight = 58
                self.providerTable.reloadData()
            }
        }
    }
    
    func setupDepartmentsDropDown() {
        servicesBtn.setTitle("The Services you provide".localiz(), for: .normal)
        departments.removeAll()
        
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
            self.selectedDepartmentId = "\(self.departmentsList[index].department_id ?? 0)"
            
            if self.itemsIDs.contains(Int(self.selectedDepartmentId) ?? 0) {
                Helper.showFloatAlert(title: "You have already added the service".localiz(), type: .error)
            }else {
                self.itemsIDs.append(self.departmentsList[index].department_id ?? 0)

                let departmentData = DepartmentsData()
                departmentData.department_id = self.departmentsList[index].department_id ?? 0

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
    
    @IBAction func editProviderBtn_tapped(_ sender: Any) {
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
                                if selectedCityId == "" || selectedCityId == "0" {
                                    Helper.showFloatAlert(title: "Choose your area".localiz(), type: .error)
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
                                                providerEdit()
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
    
    func providerEdit() {
        let player_id = Helper.getUserDefault(key: UserDefault.player_id) as! String
    
        let parameters = ["identity_id": identityTF.text ?? "",
                          "phone": (phoneTF.text ?? ""),
                          "city_id": selectedCityId,
                          "name": nameTF.text ?? "",
                          "address": addressTF.text ?? "",
                          "email": emailTF.text ?? "",
                          "player_id": player_id,
                          "certified_from": salonNameTF.text ?? "",
                          "place_name": salonNameTF.text ?? "",
                          "cover_type": coverType,
                          "bio": aboutServiceTF.text ?? ""] as [String : Any]
        
        presenter?.updateProvider(parameters: parameters,
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

extension EditProviderProfileVC: EditProfilePresenterView {
    func getProviderDataSuccess(_ response: LoginData) {
        serialNumber.text = "A\(response.id ?? 0)"
        identityTF.text = String(response.identity_id_Int ?? 0)
        nameTF.text = response.name ?? ""
        
        phoneTF.text = response.phone ?? ""
        
        emailTF.text = response.email ?? ""
        addressTF.text = response.address ?? ""
        
        aboutServiceTF.text = response.bio ?? ""
        salonNameTF.text = response.certified_from ?? ""
        
        profileImageBtn.sd_setImage(with: URL(string: SITE_URL + (response.image ?? "")), for: .normal, placeholderImage: #imageLiteral(resourceName: "girlgray"))
        identityImageBtn.sd_setImage(with: URL(string: SITE_URL + (response.image_identity ?? "")), for: .normal, placeholderImage: #imageLiteral(resourceName: "businessblack"))
        addCertificateBtn.sd_setImage(with: URL(string: SITE_URL + (response.certified_image ?? "")), for: .normal, placeholderImage: #imageLiteral(resourceName: "imagegray"))
    
        selectedCityId = String(response.city_id_Int ?? 0)
        selectedServiceCityId = String(response.city_id_Int ?? 0)
        selectedDistrictId = String(response.district_id ?? 0)
        
        
        selectedDepartmentsList = response.departments ?? []
        selectedDistrictsList = response.work_areas ?? []
        

        for depart in selectedDepartmentsList {
            itemsIDs.append(depart.department_id ?? 0)
        }
        
        for dist in selectedDistrictsList {
            districrsIDs.append(dist.id ?? 0)
        }
 
        print("itemsIDs", itemsIDs)
        print("districrsIDs", districrsIDs)

        if selectedDepartmentsList.isEmpty {
            departmentsCellHight = 0
        }else {
            departmentsCellHight = 58
        }
        
        if selectedDistrictsList.isEmpty {
            districtsCellHight = 0
        }else {
            districtsCellHight = 58
        }
        
        cityType = "userCity"
        
        coverType = response.cover_type ?? ""
        
        if let coverURL = URL(string: SITE_URL + (response.cover ?? "")) {
            if coverType == "video" {
                generatThumbnail(videoUrl: coverURL)
            }else {
                serviceImageBtn.sd_setImage(with: coverURL, for: .normal, placeholderImage: #imageLiteral(resourceName: "imagegray"))
            }
        }
        
        servicesCV.reloadData()
        districtsCV.reloadData()

        providerTable.reloadData()

        presenter?.getCities(areaId: "0")
        presenter?.getDistricts(city_id: selectedCityId)
        presenter?.getDepartments()
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
        
        guard let i = citiesList.firstIndex(where: { $0.city_id == Int(selectedCityId) ?? 0 }) else { return }
        
        if LanguageManger.shared.currentLanguage == .ar {
            citiesBtn.setTitle(citiesList[i].city_name ?? "", for: .normal)
            serviceCityBtn.setTitle(citiesList[i].city_name ?? "", for: .normal)
        }else {
            citiesBtn.setTitle(citiesList[i].city_name_en ?? "", for: .normal)
            serviceCityBtn.setTitle(citiesList[i].city_name_en ?? "", for: .normal)
        }
        
        if cityType == "userCity" {
            setupCitiesDropDown()
        }
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
    
    func getClientDataSuccess(_ response: LoginData) {}
    
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


extension EditProviderProfileVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case servicesCV:
            if LanguageManger.shared.currentLanguage == .ar {
                let text = selectedDepartmentsList[indexPath.row].department_name ?? ""
                let cellWidth = text.size(withAttributes:[.font: UIFont.systemFont(ofSize:16.0)]).width + 80
                return CGSize(width: cellWidth, height: 45)
            }else {
                let text = selectedDepartmentsList[indexPath.row].department_name_en ?? ""
                let cellWidth = text.size(withAttributes:[.font: UIFont.systemFont(ofSize:16.0)]).width + 80
                return CGSize(width: cellWidth, height: 45)
            }
            
        default:
            if LanguageManger.shared.currentLanguage == .ar {
                let text = selectedDistrictsList[indexPath.row].name_ar!
                let cellWidth = text.size(withAttributes:[.font: UIFont.systemFont(ofSize:16.0)]).width + 80
                return CGSize(width: cellWidth, height: 45)
            }else {
                let text = selectedDistrictsList[indexPath.row].name_en ?? ""
                let cellWidth = text.size(withAttributes:[.font: UIFont.systemFont(ofSize:16.0)]).width + 80
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


extension EditProviderProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
        
        if let videoUrl = info[.mediaURL] as? URL{
            self.videoString = "\(videoUrl)"
            
            print("videourl: ", self.videoString)
            
            serviceImageList.removeAll()

            coverType = "video"
            
            do {
                self.videoData = try Data(contentsOf: videoUrl as URL)
            }catch let error {
                print("*** Error generating Video Data: \(error.localizedDescription)")
            }
            
            generatThumbnail(videoUrl: videoUrl)
        }
        else {
            print("Something went wrong in  video")
        }
   
        picker.dismiss(animated: true)
    }
    
    func generatThumbnail(videoUrl: URL) {
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
    
}

extension EditProviderProfileVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if aboutServiceTF.text == "About services".localiz() {
            aboutServiceTF.text = ""
            aboutServiceTF.textColor = .black
        }
    }
}


