//
//  SuggestTimeVC.swift
//  salon
//
//  Created by AL Badr  on 7/6/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import DropDown
import SwiftyJSON

class SuggestTimeVC: UIViewController {

    @IBOutlet weak var hourBtn: UIButton!
    @IBOutlet weak var minuteBtn: UIButton!
    @IBOutlet weak var periodBtn: UIButton!
    
    @IBOutlet weak var dateTF: UITextField!
    
    @IBOutlet weak var datesCV: UICollectionView!
    
    var datesList: [NewDates] = []
    
    var hours:[String] = []
    let hoursDropDown = DropDown()
    var selectedHour: String = ""
    
    var minutes:[String] = []
    let minutesDropDown = DropDown()
    var selectedMinute: String = ""
    
    var periods:[String] = []
    let periodsDropDown = DropDown()
    var selectedPeriod: String = "AM".localiz()

    var dates:[String] = []
    var timesFrom:[String] = []
    var timedTo:[String] = []

    
    var reservationId: Int = 0
    
    var doneButton: UIBarButtonItem?

    var chooseDatePicker: UIDatePicker = UIDatePicker()
    
    var selectedDateString: String = ""
    
    fileprivate var presenter: SuggestTimePresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    func initView() {
        if LanguageManger.shared.currentLanguage == .ar {
            dateTF.placeholder = "اختر التاريخ"
            dateTF.textAlignment = .right
        }
    
        dateTF.delegate = self
        
        datesCV.delegate = self
        datesCV.dataSource = self
        datesCV.register(UINib(nibName: "DateCell", bundle: nil), forCellWithReuseIdentifier: "DateCell")
        
        presenter = SuggestTimePresenter(self)
    }

    func setupHoursDropDown() {
        hours.removeAll()
    
//        var startIndex: Int = 0
//
//        if selectedDateString == CalendarHelper().dateString(date: currentDate) {
//            startIndex = Int(CalendarHelper().hourString(date: currentDate)) ?? 1
//        }
//
//        for i in (startIndex + 1...12) {
//            hours.append(String(format: "%02d", i))
//        }
        
        for i in (1...12) {
            hours.append(String(format: "%02d", i))
        }
        
        if LanguageManger.shared.currentLanguage == .ar {
            hoursDropDown.anchorView = periodBtn
        }else {
            hoursDropDown.anchorView = hourBtn
        }
    
        hoursDropDown.bottomOffset = CGPoint(x: 0, y: hourBtn.bounds.height)
        hoursDropDown.dataSource = hours
        hoursDropDown.selectionAction = { [unowned self] (index, item) in
            self.hourBtn.setTitle(item, for: .normal)
            self.selectedHour = self.hours[index]
        }
    }
    
    func setupMinutesDropDown() {
        minutes.removeAll()
        for i in (0...59) {
            minutes.append(String(format: "%02d", i))
        }
        
        minutesDropDown.anchorView = minuteBtn
        minutesDropDown.bottomOffset = CGPoint(x: 0, y: 0)
        minutesDropDown.dataSource = minutes
        minutesDropDown.selectionAction = { [unowned self] (index, item) in
            self.minuteBtn.setTitle(item, for: .normal)
            self.selectedMinute = self.minutes[index]
        }
    }
    
    func setupPeriodsDropDown() {
        periods.removeAll()
        
//        if selectedDateString == CalendarHelper().dateString(date: currentDate) {
//            let currentPeriod = (CalendarHelper().timeString(date: currentDate)).localiz()
//            periods.append(currentPeriod)
//        }
//        else {
//            periods.append("AM".localiz())
//            periods.append("PM".localiz())
//        }
        
        periods.append("AM".localiz())
        periods.append("PM".localiz())
        
        if LanguageManger.shared.currentLanguage == .ar {
            periodsDropDown.anchorView = hourBtn
        }else {
            periodsDropDown.anchorView = periodBtn
        }
        
        periodsDropDown.bottomOffset = CGPoint(x: 0, y: periodBtn.bounds.height)
        periodsDropDown.dataSource = periods
        periodsDropDown.selectionAction = { [unowned self] (index, item) in
            self.periodBtn.setTitle(item, for: .normal)
            self.selectedPeriod = item
        }
    }
    
    @IBAction func backBtn_tapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dateBtn_tapped(_ sender: Any) {
        pickUpDate(dateTF)
        dateTF.becomeFirstResponder()
    }
    
    @IBAction func hourBtn_tapped(_ sender: Any) {
        if selectedDateString == "" {
            Helper.showFloatAlert(title: "Select date".localiz(), type: .error)
            return
        }
        
        hoursDropDown.show()
    }
    
    @IBAction func minuteBtn_tapped(_ sender: Any) {
        if selectedDateString == "" {
            Helper.showFloatAlert(title: "Select date".localiz(), type: .error)
            return
        }
        
        minutesDropDown.show()
    }
    
    @IBAction func periodBtn_tapped(_ sender: Any) {
        if selectedDateString == "" {
            Helper.showFloatAlert(title: "Select date".localiz(), type: .error)
            return
        }
        
        periodsDropDown.show()
    }
    
    @IBAction func addBtn_tapped(_ sender: Any) {
        if selectedDateString == "" {
            Helper.showFloatAlert(title: "Select date".localiz(), type: .error)
            return
        }
        
        if selectedHour == "" || selectedMinute == "" {
            Helper.showFloatAlert(title: "Select time".localiz(), type: .error)
            return
        }
        
        let newDate = NewDates()
        newDate.suggest_date = selectedDateString
        
        let selectedTime = selectedDateString + " " + selectedHour + ":" + selectedMinute + " " + selectedPeriod
        newDate.suggest_time = selectedTime
        
        if newDate.checkConvertTime() == false {
            Helper.showFloatAlert(title: "You can't select a previous date".localiz(), type: .error)
            return
        }
        
        datesList.append(newDate)
        datesCV.reloadData()
        
        resetDate()
    }
    
    @IBAction func sendBtn_tapped(_ sender: Any) {
        if datesList.isEmpty {
            Helper.showFloatAlert(title: "Select date".localiz(), type: .error)
        }else {
            
            guard datesList.allSatisfy({ $0.checkConvertTime() }) else {
                Helper.showFloatAlert(title: "You can't select a previous date".localiz(), type: .error)
                return
            }
            dates.removeAll()
            timesFrom.removeAll()
            for date in datesList {
                dates.append(date.suggest_date ?? "")
                timesFrom.append(date.suggestTimeAPI)
            }
            
            let parameters = ["id" : reservationId,
                              "date": dates,
                              "from" : timesFrom,
                              "to": timedTo] as [String : Any]
            
            print("parameters", JSON(parameters))
            
            presenter?.suggestTimes(parameters: parameters)
        }
    }
    
    func resetDate() {
        dateTF.text = ""
        selectedDateString = ""
        selectedHour = ""
        selectedMinute = ""
        selectedPeriod = "AM".localiz()

        hourBtn.setTitle("HH".localiz(), for: .normal)
        minuteBtn.setTitle("MM".localiz(), for: .normal)
        periodBtn.setTitle("AM".localiz(), for: .normal)
    }
}

extension SuggestTimeVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 16, height: 48)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as? DateCell else {
            return UICollectionViewCell()
        }
        
        cell.configCell(item: datesList[indexPath.row])
        
        cell.removeBtn.addTarget(self, action: #selector(removeDate_tapped), for: .touchUpInside)
        cell.removeBtn.tag = indexPath.row
        
        return cell
    }
    
    @objc func removeDate_tapped(_ sender: UIButton) {
        datesList.remove(at: sender.tag)
        datesCV.reloadData()
    }
}

extension SuggestTimeVC: SuggestTimePresenterView {
    func setSuggestTimesSuccess(_ message: String) {
        Helper.showFloatAlert(title: message, type: .success)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ordersNotification"), object: nil, userInfo: nil)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func setSuggestTimesFailure(_ message: String) {
        Helper.showFloatAlert(title: message, type: .error)
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), type: .error)
    }
}

extension SuggestTimeVC: UITextFieldDelegate {
    func pickUpDate(_ textField : UITextField){
        chooseDatePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))

        chooseDatePicker.backgroundColor = UIColor.white
        
        if #available(iOS 13.4, *) {
            chooseDatePicker.preferredDatePickerStyle = .wheels
        }

        chooseDatePicker.datePickerMode = UIDatePicker.Mode.date
        chooseDatePicker.locale = CalendarHelper.displayLocale
        chooseDatePicker.calendar = Calendar(identifier: .gregorian)

        dateTF.inputView = chooseDatePicker
        
        chooseDatePicker.minimumDate = Date()
        
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        doneButton = UIBarButtonItem(title: "Done".localiz(), style: .done, target: self, action: #selector(dateSelected))
        toolbar.setItems([flexSpace, doneButton!], animated: false)
        toolbar.sizeToFit()
        
        dateTF.inputAccessoryView = toolbar
    }

    
    @objc func dateSelected(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.calendar = Calendar(identifier: .gregorian)

        selectedDateString = dateFormatter.string(from: chooseDatePicker.date)
            
        dateTF.text = CalendarHelper.displayDate(selectedDateString)
        dateTF.resignFirstResponder()
        
        setupHoursDropDown()
        setupMinutesDropDown()
        setupPeriodsDropDown()
    }
}
