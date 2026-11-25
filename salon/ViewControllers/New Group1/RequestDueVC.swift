//
//  RequestDueVC.swift
//  salon
//
//  Created by AL Badr  on 7/7/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class RequestDueVC: UIViewController {
    @IBOutlet weak var balanceLabel: UILabel!
    
    @IBOutlet weak var dueCV: UICollectionView!
    @IBOutlet weak var noItemsView: UIView!
    
    fileprivate var presenter: DuePresenter?
    var dueList: [DueModel] = []
    
    var page: Int = 1
    var lastPage: Int = 1
    
    var refresher: UIRefreshControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(WalletNotifications), name: NSNotification.Name(rawValue: "dueNotification"), object: nil)
        
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(populate), for: UIControl.Event.valueChanged)
        dueCV.addSubview(refresher)
        
        initView()
        showWallet()
    }
    
    @objc func populate(){
        page = 1
        presenter?.requestDue(page: String(page))
        refresher.endRefreshing()
    }
    
    @objc func WalletNotifications(notification: NSNotification){
        if notification.name.rawValue == "dueNotification" {
            page = 1
            showWallet()
        }
    }
    
    func initView() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        dueCV.dataSource = self
        dueCV.delegate = self
        dueCV.register(UINib(nibName: "RequestDueCell", bundle: nil), forCellWithReuseIdentifier: "RequestDueCell")
        dueCV.register(UINib(nibName: "PayDueCell", bundle: nil), forCellWithReuseIdentifier: "PayDueCell")
        dueCV.alwaysBounceVertical = true

    }
    
    func showWallet() {
        presenter = DuePresenter(self)
        presenter?.requestDue(page: String(page))
    }
    
}

extension RequestDueVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if dueList[indexPath.row].admin_agree == "agree" {
            return CGSize(width: UIScreen.main.bounds.width - 16, height: 300)
        }else {
            return CGSize(width: UIScreen.main.bounds.width - 16, height: 250)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dueList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RequestDueCell", for: indexPath) as?
            RequestDueCell else {
                return UICollectionViewCell()
        }
        
        cell.configRequestCell(item: dueList[indexPath.row])
        
        if indexPath.row == dueList.count - 1 {
            if page < lastPage {
                page = page + 1
                showWallet()
            }
        }
        
        cell.requestBtn.addTarget(self, action: #selector(ShowRequestDialog), for: .touchUpInside)
        cell.requestBtn.tag = indexPath.row
        
        return cell
    }
    
    @objc func ShowRequestDialog(_ sender: UIButton) {
        guard dueList.indices.contains(sender.tag),
              (Double(dueList[sender.tag].payable_to_provider ?? "") ?? 0) > 0,
              dueList[sender.tag].status != "paid",
              !(dueList[sender.tag].admin_agree ?? "").isEmpty else { return }
        let storyboard = UIStoryboard(name: Storyboards.provider, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "ConfirmDueVC") as! ConfirmDueVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor  = UIColor(white: 1, alpha: 0.5)
        vc.reservationId = String(dueList[sender.tag].reservation_id ?? 0)
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
}

extension RequestDueVC: DuePresenterView {
    func getPaymentDataSuccess(_ response: PaymentDataModel) {}
    
    func getPaymentDataStatus(_ enabled: Bool) {}
    
    func getLievStatus(_ live: Bool) {}
    
    func getPaymentDataFailure(_ message: String) {}
    
    func setRequiredSuccess(_ required: String) {
        balanceLabel.text = required
    }
    
    func setLastPageSuccess(_ lPage: Int) {
        lastPage = lPage
    }
    
    func setRequestDueSuccess(_ response: [DueModel]) {
        if page == 1 {
            dueList.removeAll()
            dueList = response
        }else {
            dueList.append(contentsOf: response)
        }
        
        dueCV.reloadData()
    }
    
    func setDueFailure() {
        noItemsView.isHidden = false
    }
    
    func setPayDueSuccess(_ response: [DueModel]) {}
    
    func setPayableSuccess(_ payable: String) {}
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), type: .error)
    }
}
