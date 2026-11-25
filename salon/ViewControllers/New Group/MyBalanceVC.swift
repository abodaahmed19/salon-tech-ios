//
//  MyBalanceVC.swift
//  salon
//
//  Created by AL Badr  on 6/22/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class MyBalanceVC: UIViewController {
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var balanceCV: UICollectionView!
    @IBOutlet weak var noItemsView: UIView!
    
    fileprivate var presenter: MyBalancePresenter?
    var balanceList: [WalletModel] = []
    
    var page: Int = 1
    var lastPage: Int = 1
    
    var refresher: UIRefreshControl!
    
    @IBOutlet weak var balanceText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(WalletNotifications), name: NSNotification.Name(rawValue: "walletNotification"), object: nil)
        
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(populate), for: UIControl.Event.valueChanged)
        balanceCV.addSubview(refresher)
        
        print("klj.jbnklbjklbhjk")
        balanceText.text = "SAR".localiz()
        
        initView()
        showBalance()
    }
    
    @objc func populate(){
        page = 1
        presenter?.getWalletBalance(page: "\(page)")
        refresher.endRefreshing()
    }
    
    @objc func WalletNotifications(notification: NSNotification){
        if notification.name.rawValue == "walletNotification" {
            showBalance()
        }
    }
    
    func initView() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        balanceCV.dataSource = self
        balanceCV.delegate = self
        balanceCV.register(UINib(nibName: "ClientWalletCell", bundle: nil), forCellWithReuseIdentifier: "ClientWalletCell")
        balanceCV.alwaysBounceVertical = true
    }
    
    func showBalance() {
        presenter = MyBalancePresenter(self)
        presenter?.getWalletBalance(page: "\(page)")
    }
    
}

extension MyBalanceVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let transaction_status = balanceList[indexPath.row].transaction_status ?? ""
        if transaction_status == "wait" {
            return CGSize(width: UIScreen.main.bounds.width - 16, height: 220)
        }else {
            return CGSize(width: UIScreen.main.bounds.width - 16, height: 145)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return balanceList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClientWalletCell", for: indexPath) as?
                ClientWalletCell else {
            return UICollectionViewCell()
        }
        
        cell.configCell(item: balanceList[indexPath.row])
        
        cell.refundBtn.addTarget(self, action: #selector(ShowRefundDialog), for: .touchUpInside)
        cell.refundBtn.tag = indexPath.row
        
        cell.convertBtn.addTarget(self, action: #selector(ShowConvertDialog), for: .touchUpInside)
        cell.convertBtn.tag = indexPath.row
        
        if indexPath.row == balanceList.count - 1 {
            if page < lastPage {
                page = page + 1
                showBalance()
            }
        }
        
        return cell
    }
    
    @objc func ShowRefundDialog(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: Storyboards.user, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "RefundVC") as! RefundVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor  = UIColor(white: 1, alpha: 0.5)
        vc.transactionId = balanceList[sender.tag].transaction_id ?? 0
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    @objc func ShowConvertDialog(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: Storyboards.user, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "ConvertToPointsVC") as! ConvertToPointsVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor  = UIColor(white: 1, alpha: 0.5)
        vc.transactionId = balanceList[sender.tag].transaction_id ?? 0
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
}

extension MyBalanceVC: MyBalancePresenterView {
    func setWalletSuccess(_ response: [WalletModel]) {
        if page == 1{
            balanceList.removeAll()
            balanceList = response
            
        }else {
            balanceList.append(contentsOf: response)
        }
        
        balanceCV.reloadData()
    }
    
    func setWalletFailure() {
        noItemsView.isHidden = false
    }
    
    func setBalanceSuccess(_ balance: String) {
        balanceLabel.text = balance
    }
    
    func setLastPageSuccess(_ lPage: Int) {
        lastPage = lPage
    }
    
    func setClientWalletSuccess(_ response: [WalletModel]) {}
    
    func setProviderWalletSuccess(_ response: [WalletModel]) {}
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), type: .error)
    }
}
