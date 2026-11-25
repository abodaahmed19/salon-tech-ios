//
//  MyOrdersVC.swift
//  salon
//
//  Created by AL Badr  on 6/18/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class MyOrdersVC: UIViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var backBtn: UIBarButtonItem!

    var providerName: String = ""
    var providerId: Int = 0
    var reservation_id: String = ""
    var fromRemoteNotifications: Bool = false

    private lazy var currentOrdersVCVC: CurrentOrdersVC = {
        let storyboard = UIStoryboard(name: Storyboards.user, bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "CurrentOrdersVC") as! CurrentOrdersVC
        viewController.provider_id = providerId
        viewController.reservation_id = reservation_id
        return viewController
    }()
    
    private lazy var previousOrdersVC: PreviousOrdersVC = {
        let storyboard = UIStoryboard(name: Storyboards.user, bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "PreviousOrdersVC") as! PreviousOrdersVC
        return viewController
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Helper.setNavColor(nav: self.navigationController!)
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()

        let userColors = Helper.getObjectDefault(key: UserDefault.userColors) as? ColorsModel
        backBtn.tintColor = Helper.hexStringToUIColor(hex: userColors?.top_div_line ?? "#000000")
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        if LanguageManger.shared.currentLanguage == .ar {
            backBtn.image = #imageLiteral(resourceName: "forward")
        }
        
        navigationItem.title = "My Orders".localiz()
        
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        
        segmentedControl.setTitle("Current orders".localiz(), forSegmentAt: 0)
        segmentedControl.setTitle("Previous orders".localiz(), forSegmentAt: 1)

        add(childViewController: currentOrdersVCVC)
    }

    // MARK: - Switching Tabs Functions
    @IBAction func switchTabs(_ sender: UISegmentedControl) {
        let segmentIndex = segmentedControl.selectedSegmentIndex
        
        if segmentIndex == 0 {
            add(childViewController: currentOrdersVCVC)
        }else {
            add(childViewController: previousOrdersVC)
        }
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

}
