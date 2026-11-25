//
//  ReservationDataVC.swift
//  salon
//
//  Created by AL Badr  on 6/16/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import DropDown

class ReservationDataVC: UIViewController {
    @IBOutlet weak var cityBtn: UIButton!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var timeTF: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var sensitiveBtn: CheckBox!
    
    var citiesList: [CitiesData] = []
    var cities:[String] = []
    let citiesDropDown = DropDown()
    var selectedCityId: String = ""
    
    var lon: String = "0"
    var lat: String = "0"
    
    var doneButton: UIBarButtonItem?

    var reserveDatePicker: UIDatePicker = UIDatePicker()
    var reserveTimePicker: UIDatePicker = UIDatePicker()
    
    var reserveDateString: String = ""
    var reserveTimeString: String = ""
    
    var reservationData: ReservationModel?
    
    fileprivate var presenter: DateLocationPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(GetLocationNotifications), name: NSNotification.Name(rawValue: "locationNotification"), object: nil)
        
        reservationData = Helper.getObjectDefault(key: UserDefault.userReservation) as? ReservationModel
        
        totalLabel.text = "\(reservationData?.services_total ?? 0)" + " " + ("SAR".localiz())
        
        setupKeyboard()
        
        if LanguageManger.shared.currentLanguage == .ar {
            addressTF.placeholder = "العنوان"
            addressTF.textAlignment = .right
            
            dateTF.placeholder = "اختر التاريخ"
            dateTF.textAlignment = .right
            
            timeTF.placeholder = "اخنر الوقت"
            timeTF.textAlignment = .right
        }
        
        presenter = DateLocationPresenter(self)
        presenter?.getCities(areaId: "0")
        buildAppointmentForm()
    }

    private func buildAppointmentForm() {
        // Reuse the connected controls so picker, location and validation behavior stays intact.
        let controls: [UIView] = [cityBtn, addressTF, dateTF, timeTF, totalLabel, sensitiveBtn]
        defer { withExtendedLifetime(controls) {} }
        controls.forEach {
            $0.removeFromSuperview()
            NSLayoutConstraint.deactivate($0.constraints)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        let canvas = UIView()
        canvas.backgroundColor = SalonDesign.canvas
        view = canvas
        navigationItem.title = SalonDesign.text("الموعد والمكان", "Time & location")
        let scroll = UIScrollView()
        scroll.keyboardDismissMode = .interactive
        scroll.translatesAutoresizingMaskIntoConstraints = false
        canvas.addSubview(scroll)
        let next = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        config.title = SalonDesign.text("متابعة الحجز", "Continue booking")
        config.baseBackgroundColor = SalonDesign.primary
        config.baseForegroundColor = .white
        config.cornerStyle = .medium
        next.configuration = config
        next.addTarget(self, action: #selector(nextBtn_tapped(_:)), for: .touchUpInside)
        next.translatesAutoresizingMaskIntoConstraints = false
        canvas.addSubview(next)

        func label(_ text: String, size: CGFloat = 14, title: Bool = false) -> UILabel {
            let result = UILabel()
            result.text = text
            result.numberOfLines = 0
            result.font = SalonDesign.font(size, bold: title)
            result.textColor = title ? SalonDesign.ink : SalonDesign.secondary
            return result
        }
        func fieldRow(_ field: UITextField, symbol: String, action: Selector) -> UIView {
            let row = UIView()
            row.backgroundColor = .white
            row.layer.cornerRadius = 14
            row.layer.cornerCurve = .continuous
            row.layer.borderWidth = 1
            row.layer.borderColor = SalonDesign.line.cgColor
            let icon = UIImageView(image: UIImage(systemName: symbol))
            icon.tintColor = SalonDesign.secondary
            icon.contentMode = .scaleAspectFit
            icon.translatesAutoresizingMaskIntoConstraints = false
            row.addSubview(icon)
            row.addSubview(field)
            field.font = SalonDesign.font(16)
            field.textColor = SalonDesign.ink
            field.borderStyle = .none
            field.backgroundColor = .clear
            field.attributedPlaceholder = NSAttributedString(string: field.placeholder ?? "", attributes: [.foregroundColor: SalonDesign.secondary])
            let hitArea = UIButton(type: .custom)
            hitArea.accessibilityLabel = field.placeholder
            hitArea.addTarget(self, action: action, for: .touchUpInside)
            hitArea.translatesAutoresizingMaskIntoConstraints = false
            row.addSubview(hitArea)
            NSLayoutConstraint.activate([
                row.heightAnchor.constraint(greaterThanOrEqualToConstant: 54),
                icon.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 16),
                icon.centerYAnchor.constraint(equalTo: row.centerYAnchor),
                icon.widthAnchor.constraint(equalToConstant: 22), icon.heightAnchor.constraint(equalToConstant: 22),
                field.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 12),
                field.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -16),
                field.topAnchor.constraint(equalTo: row.topAnchor, constant: 10),
                field.bottomAnchor.constraint(equalTo: row.bottomAnchor, constant: -10),
                hitArea.leadingAnchor.constraint(equalTo: row.leadingAnchor), hitArea.trailingAnchor.constraint(equalTo: row.trailingAnchor),
                hitArea.topAnchor.constraint(equalTo: row.topAnchor), hitArea.bottomAnchor.constraint(equalTo: row.bottomAnchor)
            ])
            return row
        }
        cityBtn.backgroundColor = .white
        cityBtn.layer.cornerRadius = 14
        cityBtn.layer.borderWidth = 1
        cityBtn.layer.borderColor = SalonDesign.line.cgColor
        cityBtn.setTitleColor(SalonDesign.ink, for: .normal)
        cityBtn.titleLabel?.font = SalonDesign.font(16)
        cityBtn.contentEdgeInsets = UIEdgeInsets(top: 14, left: 16, bottom: 14, right: 16)
        cityBtn.heightAnchor.constraint(greaterThanOrEqualToConstant: 54).isActive = true
        let sensitivityText = label(SalonDesign.text("أعاني من حساسية في البشرة أو تساقط الشعر", "I have sensitive skin or hair loss"))
        let sensitivity = UIStackView(arrangedSubviews: [sensitiveBtn, sensitivityText])
        sensitivity.alignment = .center
        sensitivity.spacing = 10
        sensitiveBtn.widthAnchor.constraint(equalToConstant: 44).isActive = true
        sensitiveBtn.heightAnchor.constraint(equalToConstant: 44).isActive = true
        sensitiveBtn.accessibilityLabel = sensitivityText.text
        totalLabel.font = SalonDesign.font(20, bold: true)
        totalLabel.textColor = SalonDesign.primary
        let summary = UIStackView(arrangedSubviews: [label(SalonDesign.text("إجمالي الخدمات", "Services total"), size: 16, title: true), totalLabel])
        summary.spacing = 12
        summary.alignment = .center
        summary.backgroundColor = SalonDesign.primarySoft
        summary.layer.cornerRadius = 16
        summary.isLayoutMarginsRelativeArrangement = true
        summary.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 18, leading: 18, bottom: 18, trailing: 18)
        let stack = UIStackView(arrangedSubviews: [
            label(SalonDesign.text("خطوتك القادمة للعناية", "YOUR NEXT MOMENT OF CARE"), size: 12),
            label(SalonDesign.text("نرتّب موعدك", "Let's plan your visit"), size: 28, title: true),
            label(SalonDesign.text("حدّد المكان والوقت المناسبين لك.", "Choose the place and time that suit you."), size: 16),
            label(SalonDesign.text("المنطقة", "Area")), cityBtn,
            label(SalonDesign.text("مكان تقديم الخدمة", "Service location")),
            fieldRow(addressTF, symbol: "mappin.and.ellipse", action: #selector(chooseLocationBtn_tapped(_:))),
            label(SalonDesign.text("التاريخ", "Date")),
            fieldRow(dateTF, symbol: "calendar", action: #selector(chooseDateBtn_tapped(_:))),
            label(SalonDesign.text("الوقت", "Time")),
            fieldRow(timeTF, symbol: "clock", action: #selector(chooseTime_tapped(_:))),
            sensitivity, summary,
            label(SalonDesign.text("هذه الخدمة مقدمة للنساء ويلزم تواجد سيدة بالمنزل. في حالة عدم وجود سيدة بالمنزل نعتذر عن تقديم الخدمة.", "This service is for women. A woman must be present at home for the service to be provided."), size: 13)
        ])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(stack)
        NSLayoutConstraint.activate([
            next.leadingAnchor.constraint(equalTo: canvas.leadingAnchor, constant: 20),
            next.trailingAnchor.constraint(equalTo: canvas.trailingAnchor, constant: -20),
            next.bottomAnchor.constraint(equalTo: canvas.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            next.heightAnchor.constraint(greaterThanOrEqualToConstant: 54),
            scroll.leadingAnchor.constraint(equalTo: canvas.leadingAnchor), scroll.trailingAnchor.constraint(equalTo: canvas.trailingAnchor),
            scroll.topAnchor.constraint(equalTo: canvas.safeAreaLayoutGuide.topAnchor),
            scroll.bottomAnchor.constraint(equalTo: next.topAnchor, constant: -12),
            stack.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 20),
            stack.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -20),
            stack.leadingAnchor.constraint(equalTo: scroll.contentLayoutGuide.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: scroll.contentLayoutGuide.trailingAnchor, constant: -20),
            stack.widthAnchor.constraint(equalTo: scroll.frameLayoutGuide.widthAnchor, constant: -40)
        ])
    }
    
    @objc func GetLocationNotifications(notification: NSNotification){
        if notification.name.rawValue == "locationNotification" {
            lat = notification.userInfo?["lat"] as? String ?? ""
            lon = notification.userInfo?["lon"] as? String ?? ""
            
            addressTF.text = notification.userInfo?["placeTitle"] as? String ?? ""
            
            print("latlon", lat + "---" + lon)
        }
    }

    func setupKeyboard() {
        let toolbar = setupKeyboardToolbar()
        self.addressTF.inputAccessoryView = toolbar
        
        dateTF.delegate = self
        timeTF.delegate = self
        
        dateTF.isEnabled = false
        timeTF.isEnabled = false
    }
    
    func setupCitiesDropDown() {
        cityBtn.setTitle("Choose area".localiz(), for: .normal)
        cities.removeAll()

        for city in citiesList{
            if LanguageManger.shared.currentLanguage == .ar {
                cities.append(city.city_name ?? "")
            }else {
                cities.append(city.city_name_en ?? "")
            }
        }
        
        citiesDropDown.anchorView = cityBtn
        citiesDropDown.bottomOffset = CGPoint(x: 0, y: 0)
        citiesDropDown.dataSource = cities
        citiesDropDown.selectionAction = { [unowned self](index, item) in
            self.cityBtn.setTitle(item, for: .normal)
            self.selectedCityId = "\(self.citiesList[index].city_id ?? 0)"
        }
    }
    
    @IBAction func chooseCityBtn_tapped(_ sender: Any) {
        citiesDropDown.show()
    }
    
    @IBAction func chooseLocationBtn_tapped(_ sender: Any) {
        let storyBoard = UIStoryboard(name: Storyboards.main, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ChooseLocationVC") as! ChooseLocationVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func chooseDateBtn_tapped(_ sender: Any) {
        dateTF.isEnabled = true
        pickUpDate(dateTF)
        dateTF.becomeFirstResponder()
    }
    
    @IBAction func chooseTime_tapped(_ sender: Any) {
        timeTF.isEnabled = true
        pickUpTime(timeTF)
        timeTF.becomeFirstResponder()
    }
        
    @IBAction func nextBtn_tapped(_ sender: Any) {
//        lat = "51.50998"
//        lon = "0.1337"

        if selectedCityId == "" {
            Helper.showFloatAlert(title: "Choose your area".localiz(), type: .error)
        }else {
            if lat == "0" && lon == "0"{
                Helper.showFloatAlert(title: "Select your address".localiz(), type: .error)
            }else {
                if addressTF.text == "" {
                    Helper.showFloatAlert(title: "Enter your address".localiz(), type: .error)
                }else {
                    if dateTF.text == "" {
                        Helper.showFloatAlert(title: "Select reservation date".localiz(), type: .error)
                    }else {
                        if timeTF.text == "" {
                            Helper.showFloatAlert(title: "Select reservation time".localiz(), type: .error)
                        }else {
                            reservationData?.lat = lat
                            reservationData?.lon = lon
                            reservationData?.date = reserveDateString
                            reservationData?.time = reserveTimeString
                            reservationData?.address = addressTF.text
                            reservationData?.city_id = selectedCityId
                            
                            if sensitiveBtn.isChecked {
                                reservationData?.sensitivity = 1
                            }else {
                                reservationData?.sensitivity = 0
                            }
                            
                            Helper.saveObjectDefault(key: UserDefault.userReservation, value: reservationData as Any)
                            
                            let storyBoard = UIStoryboard(name: Storyboards.reservation, bundle: nil)
                            let vc = storyBoard.instantiateViewController(withIdentifier: "ReservationProvidersVC") as! ReservationProvidersVC
                            vc.title = "Choose service provider".localiz()
                            navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            }
        }
    }
}

extension ReservationDataVC: DateLocationPresenterView {
    func setCities(_ sections: [CitiesData]) {
        citiesList = sections
        setupCitiesDropDown()
    }
    
    func setCitiesFailure() {
        citiesList.removeAll()
        cityBtn.setTitle("No Areas".localiz(), for: .normal)
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), type: .error)
    }
}

extension ReservationDataVC: UITextFieldDelegate {
    func pickUpDate(_ textField : UITextField){
        reserveDatePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        reserveDatePicker.backgroundColor = UIColor.white
        
        if #available(iOS 13.4, *) {
            reserveDatePicker.preferredDatePickerStyle = .wheels
        }
        
        reserveDatePicker.datePickerMode = UIDatePicker.Mode.date
        reserveDatePicker.locale = Locale(identifier: "en_GB")

        dateTF.inputView = reserveDatePicker
        
        reserveDatePicker.minimumDate = Date()
        
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        doneButton = UIBarButtonItem(title: "Done".localiz(), style: .done, target: self, action: #selector(dateSelected))
        toolbar.setItems([flexSpace, doneButton!], animated: false)
        toolbar.sizeToFit()
        
        dateTF.inputAccessoryView = toolbar
    }
    
    func pickUpTime(_ textField : UITextField){
        reserveTimePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        reserveTimePicker.backgroundColor = UIColor.white
        
        if #available(iOS 13.4, *) {
            reserveTimePicker.preferredDatePickerStyle = .wheels
        }
        
        reserveTimePicker.datePickerMode = UIDatePicker.Mode.time
        reserveTimePicker.locale = Locale(identifier: "en")
        
        timeTF.inputView = reserveTimePicker
        
        let selectedDate = Calendar.current.compare(Date(), to: reserveDatePicker.date, toGranularity: .day)

        switch selectedDate {
        case .orderedAscending:
            print("DAY NEXT")

        case .orderedSame:
            let calendar = Calendar.current
            var components = DateComponents()
            components.hour = 2
            
            components.calendar = calendar
            
            let newHours = calendar.date(byAdding: components, to: Date())
            reserveTimePicker.minimumDate = newHours
            
        case .orderedDescending:
            print("DAY BEFORE")
        }
        
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        doneButton = UIBarButtonItem(title: "Done".localiz(), style: .plain, target: self, action: #selector(timeSelected))
        toolbar.setItems([flexSpace, doneButton!], animated: false)
        toolbar.sizeToFit()
        
        timeTF.inputAccessoryView = toolbar
    }
    
    @objc func dateSelected(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_GB")

        reserveDateString = dateFormatter.string(from: reserveDatePicker.date)
                    
        let dateFor = DateFormatter()
        let hijriCalendar = Calendar.init(identifier: Calendar.Identifier.islamicUmmAlQura)
        dateFor.locale = Locale.init(identifier: "en") // or "ar" if you want to show arabic numbers
        dateFor.calendar = hijriCalendar
        dateFor.dateFormat = "yyyy-MM-dd"
        
        let islamicDateString = dateFor.string(from: reserveDatePicker.date)
        
        dateTF.text = reserveDateString + "   " + islamicDateString
        dateTF.resignFirstResponder()
        dateTF.isEnabled = false
    }
    
    @objc func timeSelected(){
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"
        timeFormatter.locale = Locale(identifier: "ar")
        
        let timeAPIFormatter = DateFormatter()
        timeAPIFormatter.dateFormat = "HH:mm:ss"
        timeAPIFormatter.locale = Locale(identifier: "en")

        reserveTimeString = timeAPIFormatter.string(from: reserveTimePicker.date)
                
        timeTF.text = timeFormatter.string(from: reserveTimePicker.date)
        timeTF.resignFirstResponder()
        timeTF.isEnabled = false
    }

}
