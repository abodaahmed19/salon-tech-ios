//
//  ReservationProvidersVC.swift
//  salon
//
//  Created by AL Badr  on 6/16/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import DropDown

class ReservationProvidersVC: UIViewController {
    @IBOutlet weak var providersCV: UICollectionView!
    @IBOutlet weak var filterBtn: UIBarButtonItem!
    
    var providersList: [ChooseProviderModel] = []
    
    var reservationData: ReservationModel?
    
    fileprivate var presenter: ReservationProvidersPresenter?
    
    var filterList:[String] = []
    let filterDropDown = DropDown()
    var nearestFilter: String = ""
    var bestFilter: String = ""
    var favoutiteFilter: String = ""

    var main_service_ids: [Int] = []
    var service_ids: [Int] = []
    var city_id: String = ""
        
    var selectedProviderId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        reservationData = Helper.getObjectDefault(key: UserDefault.userReservation) as? ReservationModel
        main_service_ids = reservationData?.main_service_ids ?? []
        service_ids = reservationData?.service_ids ?? []
        city_id = reservationData?.city_id ?? ""
        
        main_service_ids.removeDuplicates()
        
        initView()
    }
    
    func initView() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        providersCV.dataSource = self
        providersCV.delegate = self
        providersCV.register(UINib(nibName: "ReservationProvidersCell", bundle: nil), forCellWithReuseIdentifier: "ReservationProvidersCell")
        
        setupFilterDropDown()
        ShowProviders()
    }
    
    func setupFilterDropDown() {
        filterList.append("Nearest".localiz())
        filterList.append("Favourites".localiz())
        filterList.append("Heighest rate".localiz())

        filterDropDown.anchorView = filterBtn
        filterDropDown.bottomOffset = CGPoint(x: 0, y: 0)
        filterDropDown.dataSource = filterList
        filterDropDown.selectionAction = { [unowned self](index, item) in
            if index == 0 {
                self.nearestFilter = self.city_id
                self.favoutiteFilter = ""
                self.bestFilter = ""
                
            }else if index == 1 {
                self.nearestFilter = ""
                self.favoutiteFilter = "true"
                self.bestFilter = ""
                
            }else if index == 2 {
                self.nearestFilter = ""
                self.favoutiteFilter = ""
                self.bestFilter = "true"
            }
            
            self.ShowProviders()
        }
    }
    
    func ShowProviders() {
        presenter = ReservationProvidersPresenter(self)
        
        let parameters = ["service_id": main_service_ids,
                          "city_id": city_id,
                          "my_fav" : favoutiteFilter,
                          "heighest_rate_filter": bestFilter] as [String : Any]
        
        presenter?.getProviders(parameters: parameters)
    }
    
    @IBAction func filterBtn_tapped(_ sender: Any) {
        filterDropDown.show()
    }
    
    @IBAction func chooseBtn_tapped(_ sender: Any) {
        if selectedProviderId == 0 {
            Helper.showFloatAlert(title: "Choose service provider".localiz(), type: .error)
        }else {
            reservationData?.provider_id = selectedProviderId
            Helper.saveObjectDefault(key: UserDefault.userReservation, value: reservationData as Any)
            
            let storyboard = UIStoryboard(name: Storyboards.reservation, bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: "PaymentMethodsVC") as! PaymentMethodsVC
            self.navigationController?.pushViewController(vc, animated: true)
            
//            let parameters = ["provider_id": selectedProviderId,
//                              "address": reservationData?.address ?? "",
//                              "lat": reservationData?.lat ?? "",
//                              "lon": reservationData?.lon ?? "",
//                              "comment": "Comment",
//                              "time": reservationData?.time ?? "",
//                              "date": reservationData?.date ?? "",
//                              "coupon_id": reservationData?.coupon_id ?? "",
//                              "coupon_percentage": reservationData?.coupon_percentage ?? "",
//                              "service_ids": reservationData?.service_ids ?? "",] as [String:Any]
//
//            presenter?.makeReservation(parameters: parameters)
        }
    }

}

extension ReservationProvidersVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 16, height: 125)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return providersList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReservationProvidersCell", for: indexPath) as?
            ReservationProvidersCell else {
                return UICollectionViewCell()
        }
        
        cell.configCell(item: providersList[indexPath.row])
        cell.radioBtn.isChecked = false
        
        cell.radioBtn.addTarget(self, action: #selector(selectProvider_tapped(_:)), for: UIControl.Event.touchUpInside)
        cell.radioBtn.tag = indexPath.row
        
        cell.chatBtn.addTarget(self, action: #selector(goToChat), for: UIControl.Event.touchUpInside)
        cell.chatBtn.tag = indexPath.row
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: Storyboards.provider, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProviderDetailsSegmentVC") as! ProviderDetailsSegmentVC
        vc.providerName = providersList[indexPath.row].user_name ?? ""
        vc.providerId = providersList[indexPath.row].user_id ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    @objc func selectProvider_tapped(_ sender: UIButton) {
        selectedProviderId = providersList[sender.tag].user_id ?? 0
        
        for i in 0..<providersList.count {
            guard let cell = providersCV.cellForItem(at: IndexPath(row: i, section: 0)) as? ReservationProvidersCell else { return }
            i == sender.tag ? cell.setSelected(selected: true) : cell.setSelected(selected: false)
        }
    }
    
    @objc func goToChat(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: Storyboards.user, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        vc.title = providersList[sender.tag].user_name ?? ""
        vc.clientId = String(providersList[sender.tag].user_id ?? 0)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ReservationProvidersVC: ReservationProvidersPresenterView {
    func getReservationSuccess(_ response: ReservationResponse) {
//        Helper.showFloatAlert(title: response.message ?? "", type: .success)
        
        reservationData?.reservation_id = response.reservation_id ?? 0
        Helper.saveObjectDefault(key: UserDefault.userReservation, value: reservationData as Any)

        let storyboard = UIStoryboard(name: Storyboards.reservation, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "PaymentMethodsVC") as! PaymentMethodsVC
        vc.reservationId = response.reservation_id ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getReservationFailure(_ message: String) {
        Helper.showFloatAlert(title: message, type: .error)
    }
    
    func getProvidersSuccess(_ response: [ChooseProviderModel]) {
        providersList = response
        providersCV.reloadData()
    }
    
    func getProviderFailure() {
        providersList.removeAll()
        providersCV.reloadData()
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), type: .error)
    }
}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
