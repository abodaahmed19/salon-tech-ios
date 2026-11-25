//
//  ProviderOrdersVC.swift
//  salon
//
//  Created by AL Badr  on 6/30/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import SwiftyJSON
import MBProgressHUD

class ProviderOrdersVC: UIViewController {
    @IBOutlet weak var myOrdersCV: UICollectionView!
    @IBOutlet weak var noItemsView: UIView!
    @IBOutlet weak var backBtn: UIBarButtonItem!
    
    fileprivate var presenter: CurrentOrdersPresenter?
    var ordersList: [OrdersModel] = []
    var reservationDetailsList: [Reservation_details] = []
    var reservation_suggest_newTime : [NewDates] = []
    
    var fromRemoteNotifications: Bool = false
    
    var provider_id: Int = 0
    var reservation_id: String = ""
    var listIndex: Int = 0
    
    var token: String = ""
    var userId: String = ""
    var type: String = ""
    
    var page: Int = 1
    var lastPage: Int = 1
    
    var refresher: UIRefreshControl!
    
    // MARK: - View Controller Lifecycle
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            if fromRemoteNotifications {
                let main = UIStoryboard(name: Storyboards.main, bundle: nil)
                let mainvc = main.instantiateViewController(withIdentifier: "mainNC")
                mainvc.modalPresentationStyle = .fullScreen
                present(mainvc, animated: true, completion: nil)
            }else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Helper.setNavColor(nav: self.navigationController!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDate = Helper.getObjectDefault(key: UserDefault.userData) as? LoginData
        token = userDate?.api_token ?? ""
        userId = "\(userDate?.id ?? 0)"
        type = userDate?.type ?? ""
        
        presenter = CurrentOrdersPresenter(self)
        
        initView()
        showOrders()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(GoToOrdersNotifications), name: NSNotification.Name(rawValue: "ordersNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GoToOrdersNotifications), name: NSNotification.Name(rawValue: "rateNotification"), object: nil)
        
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(populate), for: UIControl.Event.valueChanged)
        myOrdersCV.addSubview(refresher)
        
    }
    
    @objc func populate(){
        page = 1
        ordersList.removeAll()
        myOrdersCV.reloadData()
        showOrders()
        refresher.endRefreshing()
    }
    
    @objc func GoToOrdersNotifications(notification: NSNotification){
        if notification.name.rawValue == "ordersNotification" {
            ordersList.removeAll()
            myOrdersCV.reloadData()
            showOrders()
            
        }else if notification.name.rawValue == "rateNotification" {
            
            let reservationId = notification.userInfo?["reservationId"] as? Int ?? 0
            
            guard let index = ordersList.firstIndex(where: { $0.reservation_id == reservationId }) else { return }
            listIndex = index
            ordersList[index].reservation_if_provider_end = true
            myOrdersCV.reloadData()

            let story = UIStoryboard(name: Storyboards.user, bundle: nil)
            let vc = story.instantiateViewController(withIdentifier:"RateServiceProviderVC") as! RateServiceProviderVC
            vc.reservationId = reservationId
            vc.id = String(ordersList[listIndex].reservation_client_id)
            vc.name = ordersList[listIndex].reservation_client_name
            vc.image = ordersList[listIndex].reservation_client_image
            vc.modalPresentationStyle = .overCurrentContext
            vc.view.backgroundColor  = UIColor(white: 1, alpha: 0.5)
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    
    func initView() {
        let userColors = Helper.getObjectDefault(key: UserDefault.userColors) as? ColorsModel
        backBtn.tintColor = Helper.hexStringToUIColor(hex: userColors?.top_div_line ?? "#000000")
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        if LanguageManger.shared.currentLanguage == .ar {
            backBtn.image = #imageLiteral(resourceName: "forward")
        }
        
        myOrdersCV.dataSource = self
        myOrdersCV.delegate = self
        
        myOrdersCV.register(UINib(nibName: "RequiredProviderCell", bundle: nil), forCellWithReuseIdentifier: "RequiredProviderCell")
        myOrdersCV.register(UINib(nibName: "ConfirmedProviderCell", bundle: nil), forCellWithReuseIdentifier: "ConfirmedProviderCell")
        myOrdersCV.register(UINib(nibName: "RejectedProviderCell", bundle: nil), forCellWithReuseIdentifier: "RejectedProviderCell")
        myOrdersCV.register(UINib(nibName: "WaitingProviderCell", bundle: nil), forCellWithReuseIdentifier: "WaitingProviderCell")
        myOrdersCV.register(UINib(nibName: "CompletedProviderCell", bundle: nil), forCellWithReuseIdentifier: "CompletedProviderCell")
        
        myOrdersCV.alwaysBounceVertical = true
    }
    
    @IBAction func backBtn_tap(_ sender: UIBarButtonItem) {
        if fromRemoteNotifications {
            let main = UIStoryboard(name: Storyboards.main, bundle: nil)
            let mainvc = main.instantiateViewController(withIdentifier: "mainNC")
            mainvc.modalPresentationStyle = .fullScreen
            present(mainvc, animated: true, completion: nil)
        }else  {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func showOrders() {
        if reservation_id == "0" {
            reservation_id = ""
        }
        
        //        presenter?.getProviderOrders(reservation_id: reservation_id)
        
        let Headers : HTTPHeaders = ["Content-Type":"application/json",
                                     "Accept":"application/json",
                                     "Accept-Language": (LanguageManger.shared.currentLanguage.rawValue as String)]
        
        var hud : MBProgressHUD = MBProgressHUD()
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = .indeterminate
        
        let url = Urls.PROVIDER_ORDERS + "?api_token=" + token  + "&reservation_id=" + reservation_id + "&page=" + "\(page)"
        print("request: ", url)
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Headers).responseJSON { [weak self] response in
            guard let self = self else { return }
            
            hud.show(animated: true)
            
            switch response.result {
            case .failure(_):
                hud.hide(animated: true)
                Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), type: .error)
                
            case .success(_):
                hud.hide(animated: true)
                
                let reData = JSON(response.value as Any)
                
                print("reData", reData)
                
                let status =  reData["status"].boolValue
                
                self.lastPage = reData["meta"]["last_page"].intValue
                
                if status == false {
                    self.noItemsView.isHidden = false
                }else {
                    
                    guard let newData = (reData["data"].arrayObject) else { return }
                    
                    for newD in newData {
                        let reDa = JSON(newD as Any)
                        let reservation_client_id = reDa["reservation_client_id"].intValue
                        let reservation_comment = reDa["reservation_comment"].stringValue
                        let reservation_suggest_newTime = reDa["reservation_suggest_newTime"].arrayValue
                        let reservation_addedValue = reDa["reservation_addedValue"].doubleValue
                        let reservation_paymentType = reDa["reservation_paymentType"].stringValue
                        let reservation_client_image = reDa["reservation_client_image"].stringValue
                        let reservation_provider_name = reDa["reservation_provider_name"].stringValue
                        let reservation_lat = reDa["reservation_lat"].stringValue
                        let reservation_net = reDa["reservation_net"].stringValue
                        let reservation_if_client_end = reDa["reservation_if_client_end"].boolValue
                        let reservation_rest = reDa["reservation_rest"].stringValue
                        let reservation_money_pay = reDa["reservation_money_pay"].stringValue
                        let reservation_id = reDa["reservation_id"].intValue
                        let reservation_status = reDa["reservation_status"].stringValue
                        let reservation_total = reDa["reservation_total"].stringValue
                        let reservation_client_name = reDa["reservation_client_name"].stringValue
                        let reservation_date = reDa["reservation_date"].stringValue
                        let reservation_provider_id = reDa["reservation_provider_id"].intValue
                        let reservation_lon = reDa["reservation_lon"].stringValue
                        let reservation_address = reDa["reservation_address"].stringValue
                        let reservation_addValue = reDa["reservation_addValue"].stringValue
                        let reservation_cancel_reason = reDa["reservation_cancel_reason"].stringValue
                        let reservation_provider_image = reDa["reservation_provider_image"].stringValue
                        let reservation_details = reDa["reservation_details"].arrayValue
                        let reservation_if_provider_end = reDa["reservation_if_provider_end"].boolValue
                        let reservation_time = reDa["reservation_time"].stringValue
                        let reservation_if_follow_open = reDa["reservation_if_follow_open"].boolValue
                        let reservation_who_cancel = reDa["reservation_who_cancel"].stringValue
                        let every_service_money = reDa["every_service_money"].doubleValue
                        let has_report = reDa["has_report"].boolValue
                        let sensitivity = reDa["sensitivity"].intValue
                        
                        for dates in reservation_suggest_newTime {
                            let newData = JSON(dates as Any)
                            
                            let suggest_id = newData["suggest_id"].intValue
                            let suggest_time = newData["suggest_time"].stringValue
                            let suggest_service_id = newData["suggest_service_id"].stringValue
                            let suggest_to = newData["suggest_to"].stringValue
                            let suggest_date = newData["suggest_date"].stringValue
                            let suggestTimeAPI = newData["suggestTimeAPI"].stringValue
                            
                            let newDateModel = NewDates()
                            newDateModel.suggest_id = suggest_id
                            newDateModel.suggest_time = suggest_time
                            newDateModel.suggest_service_id = suggest_service_id
                            newDateModel.suggest_to = suggest_to
                            newDateModel.suggest_date = suggest_date
                            newDateModel.suggestTimeAPI = suggestTimeAPI
                            
                            self.reservation_suggest_newTime.append(newDateModel)
                        }
                        
                        for details in reservation_details {
                            let newDetails = JSON(details as Any)
                            
                            let details_id = newDetails["details_id"].intValue
                            let details_price = newDetails["details_price"].stringValue
                            let details_department_name = newDetails["details_department_name"].stringValue
                            let details_department_name_en = newDetails["details_department_name_en"].stringValue
                            
                            var newDetailsModel = Reservation_details()
                            newDetailsModel.details_id = details_id
                            newDetailsModel.details_price = details_price
                            newDetailsModel.details_department_name = details_department_name
                            newDetailsModel.details_department_name_en = details_department_name_en
                            
                            self.reservationDetailsList.append(newDetailsModel)
                        }
                        
                        var newOrder = OrdersModel()
                        newOrder.reservation_client_id = reservation_client_id
                        newOrder.reservation_comment = reservation_comment
                        newOrder.reservation_suggest_newTime = self.reservation_suggest_newTime
                        newOrder.reservation_addedValue = reservation_addedValue
                        newOrder.reservation_paymentType = reservation_paymentType
                        newOrder.reservation_client_image = reservation_client_image
                        newOrder.reservation_provider_name = reservation_provider_name
                        newOrder.reservation_lat = reservation_lat
                        newOrder.reservation_net = reservation_net
                        newOrder.reservation_if_client_end = reservation_if_client_end
                        newOrder.reservation_rest = reservation_rest
                        newOrder.reservation_money_pay = reservation_money_pay
                        newOrder.reservation_id = reservation_id
                        newOrder.reservation_status = reservation_status
                        newOrder.reservation_total = reservation_total
                        newOrder.reservation_client_name = reservation_client_name
                        newOrder.reservation_date = reservation_date
                        newOrder.reservation_provider_id = reservation_provider_id
                        newOrder.reservation_lon = reservation_lon
                        newOrder.reservation_address = reservation_address
                        newOrder.reservation_addValue = reservation_addValue
                        newOrder.reservation_cancel_reason = reservation_cancel_reason
                        newOrder.reservation_provider_image = reservation_provider_image
                        newOrder.reservation_details = self.reservationDetailsList
                        newOrder.reservation_if_provider_end = reservation_if_provider_end
                        newOrder.reservation_time = reservation_time
                        newOrder.reservation_if_follow_open = reservation_if_follow_open
                        newOrder.reservation_who_cancel = reservation_who_cancel
                        newOrder.every_service_money = every_service_money
                        newOrder.has_report = has_report
                        newOrder.sensitivity = sensitivity
                        
                        if reservation_client_id != 0 {
                            self.ordersList.append(newOrder)
                        }
                    }
                    
                    self.myOrdersCV.reloadData()
                }
            }
        }
    }
    
    
}


extension ProviderOrdersVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let status = ordersList[indexPath.row].reservation_status
        if  status == "initial" || status ==  "done" {
            return CGSize(width: UIScreen.main.bounds.width - 16, height: 465)
        }else {
            return CGSize(width: UIScreen.main.bounds.width - 16, height: 415)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ordersList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = ordersList[indexPath.row]
        
        let status = item.reservation_status
        
        if status == OrderStatus.INITIAL {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RequiredProviderCell", for: indexPath) as?
                    RequiredProviderCell else {
                return UICollectionViewCell()
            }
            
            cell.configCell(item: ordersList[indexPath.row])
            
            cell.dateBtn.addTarget(self, action: #selector(ShowNewDatesDialog), for: .touchUpInside)
            cell.dateBtn.tag = indexPath.row
            
            cell.rejectBtn.addTarget(self, action: #selector(SendReasonsDialog), for: .touchUpInside)
            cell.rejectBtn.tag = indexPath.row
            
            cell.confirmBtn.addTarget(self, action: #selector(confirmOrder_tapped), for: .touchUpInside)
            cell.confirmBtn.tag = indexPath.row
            
            if indexPath.row == ordersList.count - 1 {
                if page < lastPage {
                    page = page + 1
                    showOrders()
                }
            }
            
            return cell
            
        }else if status == OrderStatus.DONE {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ConfirmedProviderCell", for: indexPath) as?
                    ConfirmedProviderCell else {
                return UICollectionViewCell()
            }
            
            cell.configCell(item: ordersList[indexPath.row])
            
            cell.chatBtn.addTarget(self, action: #selector(goToChat(_:)), for: .touchUpInside)
            cell.chatBtn.tag = indexPath.row
            
            cell.locationBtn.addTarget(self, action: #selector(ShowTrackDialog), for: .touchUpInside)
            cell.locationBtn.tag = indexPath.row
            
            cell.completeBtn.addTarget(self, action: #selector(ShowReceiveCashDialog), for: .touchUpInside)
            cell.completeBtn.tag = indexPath.row
            
            cell.finishBtn.addTarget(self, action: #selector(ShowRateDialog), for: .touchUpInside)
            cell.finishBtn.tag = indexPath.row
            
            if indexPath.row == ordersList.count - 1 {
                if page < lastPage {
                    page = page + 1
                    showOrders()
                }
            }
            
            return cell
            
        }else if status == OrderStatus.CHANGE_TIME {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WaitingProviderCell", for: indexPath) as?
                    WaitingProviderCell else {
                return UICollectionViewCell()
            }
            
            cell.configCell(item: ordersList[indexPath.row])
            
            cell.rejectBtn.addTarget(self, action: #selector(SendReasonsDialog), for: .touchUpInside)
            cell.rejectBtn.tag = indexPath.row
            
            cell.confirmBtn.addTarget(self, action: #selector(confirmOrder_tapped), for: .touchUpInside)
            cell.confirmBtn.tag = indexPath.row
            
            if indexPath.row == ordersList.count - 1 {
                if page < lastPage {
                    page = page + 1
                    showOrders()
                }
            }
            
            return cell
            
        }else if status == OrderStatus.END {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CompletedProviderCell", for: indexPath) as?
                    CompletedProviderCell else {
                return UICollectionViewCell()
            }
            
            cell.configCell(item: ordersList[indexPath.row])
            
            if indexPath.row == ordersList.count - 1 {
                if page < lastPage {
                    page = page + 1
                    showOrders()
                }
            }
            
            return cell
            
        }else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RejectedProviderCell", for: indexPath) as?
                    RejectedProviderCell else {
                return UICollectionViewCell()
            }
            
            cell.configCell(item: ordersList[indexPath.row])
            
            if indexPath.row == ordersList.count - 1 {
                if page < lastPage {
                    page = page + 1
                    showOrders()
                }
            }
            
            return cell
        }
    }
    
    @objc func ShowDeleteDialog(_ sender: UIButton) {
        listIndex = sender.tag
        let alert = UIAlertController(title: "Delete from orders?".localiz(), message:"", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes".localiz(), style: .default, handler: removeOrder))
        alert.addAction(UIAlertAction(title: "No".localiz(), style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func removeOrder(alert: UIAlertAction!) {
        let reservationId = ordersList[listIndex].reservation_id
        presenter?.deleteOrder(reservation_id: "\(reservationId)")
    }
    
    @objc func SendReasonsDialog(_ sender: UIButton) {
        let story = UIStoryboard(name: Storyboards.provider, bundle: nil)
        let vc = story.instantiateViewController(withIdentifier:"RejectionReasonsVC") as! RejectionReasonsVC
        vc.orderId = ordersList[sender.tag].reservation_id
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor  = UIColor(white: 1, alpha: 0.5)
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    @objc func ShowNewDatesDialog(_ sender: UIButton) {
        let story = UIStoryboard(name: Storyboards.provider, bundle: nil)
        let vc = story.instantiateViewController(withIdentifier:"SuggestTimeVC") as! SuggestTimeVC
        vc.reservationId = ordersList[sender.tag].reservation_id
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor  = UIColor(white: 1, alpha: 0.5)
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    @objc func ShowReceiveCashDialog(_ sender: UIButton) {
        listIndex = sender.tag
        
        if ordersList[sender.tag].reservation_if_provider_end == true {
            Helper.showFloatAlert(title: "Waiting for client Rate".localiz(), type: .error)
        }else {
            let story = UIStoryboard(name: Storyboards.provider, bundle: nil)
            let vc = story.instantiateViewController(withIdentifier:"ReceiveCashVC") as! ReceiveCashVC
            vc.reservationId = ordersList[sender.tag].reservation_id
            vc.total = ordersList[sender.tag].reservation_net
            vc.modalPresentationStyle = .overCurrentContext
            vc.view.backgroundColor  = UIColor(white: 1, alpha: 0.5)
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func ShowBankTransferDialog(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: Storyboards.reservation, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "BankTransferVC") as! BankTransferVC
        vc.reservationId = ordersList[sender.tag].reservation_id
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor  = UIColor(white: 1, alpha: 0.5)
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    @objc func ShowRateDialog(_ sender: UIButton) {
        listIndex = sender.tag
        
        if ordersList[sender.tag].reservation_if_provider_end == true {
            Helper.showFloatAlert(title: "Waiting for client Rate".localiz(), type: .error)
        }
        else {
            
            let parameters = ["id" : ordersList[listIndex].reservation_id,
                              "money_paid": ordersList[sender.tag].reservation_net] as [String : Any]
            
            presenter?.endCashOrder(parameters: parameters)
        }
    }
    
    @objc func ShowTrackDialog(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: Storyboards.user, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "TrackProviderVC") as! TrackProviderVC
        
        vc.providerId = String(ordersList[sender.tag].reservation_client_id)
        vc.placeLat = ordersList[sender.tag].reservation_lat
        vc.placeLon = ordersList[sender.tag].reservation_lon
        
        vc.modalPresentationStyle = .fullScreen
        vc.view.backgroundColor  = UIColor(white: 0.5, alpha: 0.5)
        
        present(vc, animated: true, completion: nil)
    }
    
    @objc func goToChat(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: Storyboards.user, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        vc.title = ordersList[sender.tag].reservation_client_name
        vc.clientId = String(ordersList[sender.tag].reservation_client_id)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func confirmOrder_tapped(_ sender: UIButton) {
        let reservationId = ordersList[sender.tag].reservation_id
        let parameters = ["id": reservationId] as [String:Any]
        presenter?.approveOrder(parameters: parameters)
    }
    
    
    
}

extension ProviderOrdersVC: CurrentOrdersPresenterView {
    func getPaymentDataSuccess(_ response: PaymentDataModel) {}
    
    func getPaymentDataStatus(_ enabled: Bool) {}
    
    func setCashSuccess(_ message: String) {
        guard ordersList.indices.contains(listIndex) else { return }
        ordersList[listIndex].reservation_if_provider_end = true
        myOrdersCV.reloadData()
        Helper.showFloatAlert(title: message, type: .success)
        
        let story = UIStoryboard(name: Storyboards.user, bundle: nil)
        let vc = story.instantiateViewController(withIdentifier:"RateServiceProviderVC") as! RateServiceProviderVC
        vc.reservationId = ordersList[listIndex].reservation_id
        vc.id = String(ordersList[listIndex].reservation_client_id)
        vc.name = ordersList[listIndex].reservation_client_name
        vc.image = ordersList[listIndex].reservation_client_image
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor  = UIColor(white: 1, alpha: 0.5)
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    func setCashFailure(_ message: String) {
        Helper.showFloatAlert(title: message, type: .error)
    }
    
    func getProviderOrdersSuccess(_ response: [OrdersModel]) {
        ordersList = response
        myOrdersCV.reloadData()
    }
    
    func getProviderOrdersFailure() {
        noItemsView.isHidden = false
        
    }
    
    func getApproveOrderSuccess(_ message: String) {
        Helper.showFloatAlert(title: message, type: .success)
        ordersList.removeAll()
        myOrdersCV.reloadData()
        showOrders()
    }
    
    func getApproveOrderFailure(_ message: String) {
        Helper.showFloatAlert(title: message, type: .error)
        
    }
    
    func getMyOrdersSuccess(_ response: [OrdersModel]) {
        
    }
    
    func getMyOrdersFailure() {
    }
    
    func removeOrderSuccess(_ message: String) {
        Helper.showFloatAlert(title: message, type: .success)
        
        ordersList.remove(at: listIndex)
        myOrdersCV.reloadData()
    }
    
    func removeOrderFailure(_ message: String) {
        Helper.showFloatAlert(title: message, type: .error)
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), type: .error)
    }
}
