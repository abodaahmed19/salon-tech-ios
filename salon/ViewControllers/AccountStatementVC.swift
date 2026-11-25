//
//  AccountStatementVC.swift
//  salon
//
//  Created by AL Badr  on 6/18/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import MBProgressHUD

class AccountStatementVC: UIViewController {
    
    @IBOutlet weak var sheetCV: UICollectionView!
    @IBOutlet weak var noItemsView: UIView!
    @IBOutlet weak var balanceLabel: UILabel!

    fileprivate var presenter: BalanceSheetPresenter?
    var sheetList: [StatementsModel] = []
    
    var provider_id: Int = 0
    
    var token: String = ""
    var userId: String = ""
    
    var page: Int = 1
    var lastPage: Int = 1
    
    var hud : MBProgressHUD = MBProgressHUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = .indeterminate
        
        let userDate = Helper.getObjectDefault(key: UserDefault.userData) as? LoginData
        token = userDate?.api_token ?? ""
        userId = "\(userDate?.id ?? 0)"
        
        initView()
        showBalanceSheet()
    }
    
    func initView() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        sheetCV.dataSource = self
        sheetCV.delegate = self
        sheetCV.register(UINib(nibName: "PaymentStatementCell", bundle: nil), forCellWithReuseIdentifier: "PaymentStatementCell")
    }
    
    func showBalanceSheet() {
        hud.show(animated: true)
        presenter = BalanceSheetPresenter(self)
        presenter?.getClientBalace(search: "", page: "\(page)")
    }
    
}

extension AccountStatementVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 16, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sheetList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PaymentStatementCell", for: indexPath) as?
            PaymentStatementCell else {
                return UICollectionViewCell()
        }
        
        cell.configCell(item: sheetList[indexPath.row])
        
        if indexPath.row == sheetList.count - 1 {
            if page < lastPage {
                page = page + 1
                showBalanceSheet()
            }
        }
        
        return cell
    }
}

extension AccountStatementVC: BalanceSheetPresenterView {
    func getClientSheetSuccess(_ response: [StatementsModel]) {
        sheetList = response
        sheetCV.reloadData()
        hud.hide(animated: true)
    }
    
    func getClientSheetFailure() {
        noItemsView.isHidden = false
        sheetList.removeAll()
        sheetCV.reloadData()
        hud.hide(animated: true)
    }
    
    func getProviderSheetSuccess(_ response: [StatementsModel]) {
        sheetList = response
        sheetCV.reloadData()
        hud.hide(animated: true)
    }
    
    func getProviderSheetFailure() {
        noItemsView.isHidden = false
        sheetList.removeAll()
        sheetCV.reloadData()
        hud.hide(animated: true)
    }
    
    func setBalanceSuccess(_ balance: String) {
        balanceLabel.text = balance
    }
    
    func setLastPageSuccess(_ lPage: Int) {
        lastPage = lPage
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), type: .error)
        hud.hide(animated: true)
    }
}
