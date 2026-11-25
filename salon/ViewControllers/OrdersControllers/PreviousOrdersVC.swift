//
//  PreviousOrdersVC.swift
//  salon
//
//  Created by AL Badr  on 6/18/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import MBProgressHUD

class PreviousOrdersVC: UIViewController {

    @IBOutlet weak var myOrdersCV: UICollectionView!
    @IBOutlet weak var noItemsView: UIView!
    
    fileprivate var presenter: PreviousOrdersPresenter?
    var ordersList: [OrdersModel] = []
    
    var provider_id: Int = 0
    
    var token: String = ""
    var userId: String = ""
    
    var refresher: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let userDate = Helper.getObjectDefault(key: UserDefault.userData) as? LoginData
        token = userDate?.api_token ?? ""
        userId = "\(userDate?.id ?? 0)"
        
        initView()
        showOrders()
        
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(populate), for: UIControl.Event.valueChanged)
        myOrdersCV.addSubview(refresher)
    }
    
    @objc func populate(){
        showOrders()
        refresher.endRefreshing()
    }
    
    func initView() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        myOrdersCV.dataSource = self
        myOrdersCV.delegate = self
        myOrdersCV.register(UINib(nibName: "CompletedProviderCell", bundle: nil), forCellWithReuseIdentifier: "CompletedProviderCell")
        myOrdersCV.alwaysBounceVertical = true
    }
    
    func showOrders() {
        presenter = PreviousOrdersPresenter(self)
        presenter?.getPreviousOrders(reservation_id: "")
    }
}

extension PreviousOrdersVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 16, height: 365)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ordersList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CompletedProviderCell", for: indexPath) as?
            CompletedProviderCell else {
                return UICollectionViewCell()
        }
        
        cell.configCell(item: ordersList[indexPath.row])
                      
        cell.completeBtn.isHidden = true

        return cell
    }
}

extension PreviousOrdersVC: PreviousOrdersPresenterView {
    func getMyOrdersSuccess(_ response: [OrdersModel]) {
        ordersList = response
        myOrdersCV.reloadData()
    }
    
    func getMyOrdersFailure() {
        noItemsView.isHidden = false
    }
    
    func removeOrderSuccess(_ message: String) {
        
    }
    
    func removeOrderFailure(_ message: String) {
        
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), type: .error)
    }
}
