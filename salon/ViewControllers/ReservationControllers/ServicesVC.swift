//
//  ServicesVC.swift
//  salon
//
//  Created by AL Badr  on 6/13/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class ServicesVC: UIViewController {
    @IBOutlet weak var servicesCV: UICollectionView!
    @IBOutlet weak var subServicesCV: UICollectionView!
    
    @IBOutlet weak var reservationView: RoundRectView!
    @IBOutlet weak var reservationBtn: UIButton!
    @IBOutlet weak var reservationTotal: UILabel!
    
    var servicesList: [DepartmentsData] = []
    var subServicesList: [DepartmentsData] = []
    var selectedServicesList: [DepartmentsData] = []

    fileprivate var presenter: ServicesPresenter?
    
    var serviceListIndex: Int = 0
    var serviceId: Int = 0
    var main_service_ids: [Int] = []
    var service_ids: [Int] = []
    var service_Prices: [Double] = []

    var totalPrice: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    func initView() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        servicesCV.dataSource = self
        servicesCV.delegate = self
        servicesCV.register(UINib(nibName: "ServicesCell", bundle: nil), forCellWithReuseIdentifier: "ServicesCell")
        
        subServicesCV.dataSource = self
        subServicesCV.delegate = self
        subServicesCV.register(UINib(nibName: "SubServiceCell", bundle: nil), forCellWithReuseIdentifier: "SubServiceCell")
        
        presenter = ServicesPresenter(self)
        presenter?.GetSubServices(department_id: "\(serviceId)")
   
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            guard let self = self else { return }
            if self.servicesList.isEmpty == false {
                for i in 0..<self.servicesList.count {
                    self.servicesList[i].selectedState = false
                }

                self.servicesList[self.serviceListIndex].selectedState = true
                self.servicesCV.reloadData()
                self.servicesCV.scrollToItem(at: IndexPath(row: self.serviceListIndex, section: 0), at: .centeredHorizontally, animated: true)
            }
        }
    }
    
    @IBAction func reservationBtn_tapped(_ sender: Any) {
        let reservData = ReservationModel()
        reservData.services_total = totalPrice
        reservData.subDepartments = selectedServicesList
        reservData.main_service_ids = main_service_ids
        reservData.service_ids = service_ids
        
        Helper.saveObjectDefault(key: UserDefault.userReservation, value: reservData)

        let storyboard = UIStoryboard(name: Storyboards.reservation, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "ServiceReservationVC") as! ServiceReservationVC
        vc.title = "Services Reservation".localiz()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension ServicesVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case servicesCV:
            return CGSize(width: 130, height: 150)
        default:
            return CGSize(width: UIScreen.main.bounds.width - 16, height: 120)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case servicesCV:
            return servicesList.count
        default:
            return subServicesList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case servicesCV:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServicesCell", for: indexPath) as?
                ServicesCell else {
                    return UICollectionViewCell()
            }
            
            cell.configureCell(item: servicesList[indexPath.row])
            
            return cell
            
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubServiceCell", for: indexPath) as?
                SubServiceCell else {
                    return UICollectionViewCell()
            }
            
            cell.configureCell(item: subServicesList[indexPath.row])
            
            if service_ids.contains(where: { $0 == (subServicesList[indexPath.row].department_id ?? 0) }) {
                cell.check.isChecked = true
            }else {
                cell.check.isChecked = false
            }
                        
            cell.check.addTarget(self, action: #selector(selectSubService_tapped(_:)), for: UIControl.Event.touchUpInside)
            cell.check.tag = indexPath.row
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == servicesCV {
            serviceId = servicesList[indexPath.row].department_id ?? 0
            presenter?.GetSubServices(department_id: "\(serviceId)")

            let currentLang = LanguageManger.shared.currentLanguage
            let serviceNameAR = servicesList[indexPath.row].department_name ?? ""
            let serviceNameEN = servicesList[indexPath.row].department_name_en ?? ""
            
            self.navigationItem.title = currentLang == .ar ? serviceNameAR : serviceNameEN
            
            for i in 0..<servicesList.count {
                servicesList[i].selectedState = false
            }

            servicesList[indexPath.item].selectedState = true
            servicesCV.reloadData()
            servicesCV.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        else {
            var description: String = ""
            if LanguageManger.shared.currentLanguage == .ar {
                description = subServicesList[indexPath.row].description_ar ?? ""
            }else {
                description = subServicesList[indexPath.row].description_en ?? ""
            }
            
            let alert = UIAlertController(title: "Salon Tech".localiz(), message: description, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK".localiz(), style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
  
    @objc func selectSubService_tapped(_ sender: UIButton) {
        guard let cell = subServicesCV.cellForItem(at: IndexPath(row: sender.tag, section: 0)) as? SubServiceCell else { return }
        
        if cell.check.isChecked {
            let sPrice = subServicesList[sender.tag].afterDiscount ?? 0
            service_Prices.append(Double(sPrice))
            service_ids.append(subServicesList[sender.tag].department_id ?? 0)
            selectedServicesList.append(subServicesList[sender.tag])
            main_service_ids.append(serviceId)

            reservationView.isHidden = false
            
            totalPrice = 0
            
            for price in service_Prices {
                totalPrice += price
            }
            
            reservationTotal.text = "\(totalPrice)" + " " + ("SAR".localiz())
            
        }else {
            if let i = service_ids.firstIndex(of: subServicesList[sender.tag].department_id ?? 0) {
                service_ids.remove(at: i)
                service_Prices.remove(at: i)
                selectedServicesList.remove(at: i)
                
                guard let j = main_service_ids.firstIndex(of: serviceId) else { return }
                main_service_ids.remove(at: j)
                
                totalPrice = 0

                for price in service_Prices {
                    totalPrice += price
                }
                
                reservationTotal.text = "\(totalPrice)" + " " + ("SAR".localiz())
                
                if service_ids.isEmpty {
                    reservationView.isHidden = true
                }
                
            }else {
                print("Index Not Found")
            }
        }
        
        
    }

}

extension ServicesVC: ServicesPresenterView {
    func getSubDepartmentsSuccess(_ response: [DepartmentsData]) {
        subServicesList = response
        subServicesCV.reloadData()
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), type: .error)
    }
    
    
}
