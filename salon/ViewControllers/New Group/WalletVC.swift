//
//  WalletVC.swift
//  salon
//
//  Created by AL Badr  on 6/22/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class WalletVC: UIViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var walletBtn: RoundedButton!
    
    
    var providerName: String = ""
    var providerId: Int = 0
    
    private lazy var myBalanceVC: MyBalanceVC = {
        let storyboard = UIStoryboard(name: Storyboards.main, bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "MyBalanceVC") as! MyBalanceVC
        //        viewController.provider_id = providerId
        return viewController
    }()
    
    private lazy var myPointsVC: MyPointsVC = {
        let storyboard = UIStoryboard(name: Storyboards.main, bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "MyPointsVC") as! MyPointsVC
        return viewController
    }()
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = "Wallet".localiz()
        
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        
        segmentedControl.setTitle("My Wallet".localiz(), forSegmentAt: 0)
        segmentedControl.setTitle("My Points".localiz(), forSegmentAt: 1)
        
        add(childViewController: myBalanceVC)
    }
    
    // MARK: - Switching Tabs Functions
    @IBAction func switchTabs(_ sender: UISegmentedControl) {
        let segmentIndex = segmentedControl.selectedSegmentIndex
        
        if segmentIndex == 0 {
            add(childViewController: myBalanceVC)
        }else {
            add(childViewController: myPointsVC)
        }
    }
    
    private func add(childViewController: UIViewController) {
        addChild(childViewController)
        childViewController.didMove(toParent: self)
        childViewController.view.frame = contentView.bounds
        contentView.addSubview(childViewController.view)
    }
    
    private func remove(childViewController: UIViewController) {
        childViewController.willMove(toParent: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParent()
    }
    
    @IBAction func walletBtn_tapped(_ sender: Any) {
        let storyBoard = UIStoryboard(name: Storyboards.main, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PagesDetailsVC") as! PagesDetailsVC
        vc.title = "How to use the wallet?".localiz()
        vc.pageId = 3
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
