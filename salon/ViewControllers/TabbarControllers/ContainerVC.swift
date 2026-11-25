//
//  ContainerVC.swift
//  salon
//
//  Created by AL Badr  on 5/20/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import SideMenu
import FirebaseDatabase
import CoreLocation

class ContainerVC: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var tabsView: UIView!
    
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var articlesBtn: UIButton!
    @IBOutlet weak var notificationsBtn: UIButton!
    @IBOutlet weak var balancesBtn: UIButton!
    @IBOutlet weak var homeBtn: UIButton!
    
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var articlesLabel: UILabel!
    @IBOutlet weak var notificationsLabel: UILabel!
    @IBOutlet weak var balancesLabel: UILabel!
    @IBOutlet weak var homeLabel: UILabel!
    
    @IBOutlet weak var notificationsCountLabel: UILabel!
    @IBOutlet weak var notificationsCountView: UIView!
    
    let locationManager = CLLocationManager()

    private var userLoc: CLLocationCoordinate2D?
    
    var ref: DatabaseReference!

    private var presenter: ColorsPresenter?

    var notificationCount: String = "0"
    
    var isProfileOpen: Bool = false
    var isArticlesOpen: Bool = false
    var isNotificationsOpen: Bool = false
    var isBalancesOpen: Bool = false
    var isHomeOpen: Bool = false
    
    private var activeTab = 0
    var type: String = ""
    var userId: Int = 0

    // MARK: - Declare Viewcontrollers

    private lazy var HomeViewController: HomeVC = {
        let storyboard = UIStoryboard(name: Storyboards.main, bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        return viewController
    }()

    private lazy var walletVC: WalletVC = {
        let storyboard = UIStoryboard(name: Storyboards.main, bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "WalletVC") as! WalletVC
        return viewController
    }()
    
    private lazy var providerWalletVC: ProviderWalletVC = {
        let storyboard = UIStoryboard(name: Storyboards.provider, bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "ProviderWalletVC") as! ProviderWalletVC
        return viewController
    }()

    private lazy var notificationsVC: NotificationsVC = {
        let storyboard = UIStoryboard(name: Storyboards.user, bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "NotificationsVC") as! NotificationsVC
        return viewController
    }()

    private lazy var articlesVC: ArticlesVC = {
        let storyboard = UIStoryboard(name: Storyboards.main, bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "ArticlesVC") as! ArticlesVC
        return viewController
    }()
    
    private lazy var editVC: EditVC = {
        let storyboard = UIStoryboard(name: Storyboards.authentication, bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "EditVC") as! EditVC
        return viewController
    }()

    private lazy var ordersVC: UIViewController = {
        let board = UIStoryboard(name: type == "provider" ? Storyboards.provider : Storyboards.user, bundle: nil)
        return board.instantiateViewController(withIdentifier: type == "provider" ? "ProviderOrdersVC" : "MyOrdersVC")
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(GetContainerNotifications), name: NSNotification.Name(rawValue: "ContainerNotification"), object: nil)        
        NotificationCenter.default.addObserver(self, selector: #selector(GetContainerNotifications), name: NSNotification.Name(rawValue: "discountNotification"), object: nil)

        ref = Database.database().reference(withPath: databasePath)
        
        getUserData()
        
        presenter = ColorsPresenter(self)
        presenter?.getColors()

        Helper.setupSideMenue(nav: self.navigationController!)
        
        notificationCount = Helper.getUserDefault(key: UserDefault.notificationsCount) as! String
        notificationsCountLabel.text = notificationCount
                
        homeBtn.setImage(#imageLiteral(resourceName: "homewhite") , for: .normal)
        homeLabel.textColor = .white
        
        if type == "provider" {
            requestLocation()
            balancesLabel.text = "Balances".localiz()
        }else {
            balancesLabel.text = "Wallet".localiz()
        }
        
        add(childViewController: HomeViewController)
        navigationItem.title = SalonDesign.text("صالون تك", "SalonTech")
        navigationItem.rightBarButtonItems = nil
        navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .plain, target: self, action: #selector(menuBtn_tapped(_:)))]
        SalonDesign.navigation(navigationController!.navigationBar)
        styleTabs(active: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUserData()
        updateCount()
    }
    
    @objc func GetContainerNotifications(notification: NSNotification){
        if notification.name.rawValue == "ContainerNotification" {
            updateCount()
        }
        else if notification.name.rawValue == "discountNotification" {
            let storyBoard = UIStoryboard(name: Storyboards.reservation, bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "DiscountRequestVC") as! DiscountRequestVC
            vc.modalPresentationStyle = .overCurrentContext
            vc.view.backgroundColor  = UIColor(white: 1, alpha: 0.5)
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    
    func requestLocation() {
#if DEBUG
        // Visual review must never enqueue a provider location update.
        if ProcessInfo.processInfo.arguments.contains("--design-review") { return }
#endif
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
    }
    
    func updateCount() {
        notificationCount = Helper.getUserDefault(key: UserDefault.notificationsCount) as! String
        notificationsCountLabel.text = notificationCount
        
        if notificationCount == "0" ||  notificationCount == "" {
            notificationsCountView.isHidden = true
        }
    }
    
    func getUserData() {
        let userDate = Helper.getObjectDefault(key: UserDefault.userData) as? LoginData
        type = userDate?.type ?? ""
        userId = userDate?.id ?? 0
    }
    
    private func add(childViewController: UIViewController) {
        guard children.first !== childViewController else { return }
        children.forEach { remove(childViewController: $0) }
        addChild(childViewController)
        childViewController.view.frame = containerView.bounds
        childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView.addSubview(childViewController.view)
        childViewController.didMove(toParent: self)
    }
    
    private func remove(childViewController: UIViewController) {
        childViewController.willMove(toParent: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParent()
    }
    
    @IBAction func menuBtn_tapped(_ sender: Any) {
        if(LanguageManger.shared.currentLanguage == .ar){
            SideMenuManager.default.menuRightNavigationController =  self.storyboard?.instantiateViewController(withIdentifier: "SideMenuNV") as? UISideMenuNavigationController
            self.navigationController?.present(SideMenuManager.default.menuRightNavigationController!, animated: true, completion: nil)
            
        }else {
            SideMenuManager.default.menuLeftNavigationController =  self.storyboard?.instantiateViewController(withIdentifier: "SideMenuNV") as? UISideMenuNavigationController
            self.navigationController?.present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
        }
    }
    
    @IBAction func homeBtn_tapped(_ sender: Any) {
        resetTabsToDefaults()
        homeBtn.setImage(#imageLiteral(resourceName: "homewhite") , for: .normal)
        homeLabel.textColor = .white
        add(childViewController: HomeViewController)
        styleTabs(active: 0)
    }
    
    @IBAction func balancesBtn_tapped(_ sender: Any) {
        resetTabsToDefaults()
        balancesBtn.setImage(#imageLiteral(resourceName: "waletwhite") , for: .normal)
        balancesLabel.textColor = .white
        
        if type == "provider" {
            add(childViewController: providerWalletVC)
        }else {
            add(childViewController: walletVC)
        }
        styleTabs(active: 1)
    }
    
    @IBAction func notificationsBtn_tapped(_ sender: Any) {
        resetTabsToDefaults()
        notificationsBtn.setImage(#imageLiteral(resourceName: "ringwhite") , for: .normal)
        notificationsLabel.textColor = .white
        add(childViewController: notificationsVC)
        styleTabs(active: 2)
    }
    
    @IBAction func articlesBtn_tapped(_ sender: Any) {
        resetTabsToDefaults()
        articlesBtn.setImage(#imageLiteral(resourceName: "bookwhite") , for: .normal)
        articlesLabel.textColor = .white
        add(childViewController: ordersVC)
        styleTabs(active: 3)
    }
    
    @IBAction func profileBtn_tapped(_ sender: Any) {
        resetTabsToDefaults()
        profileBtn.setImage(#imageLiteral(resourceName: "girlwhite") , for: .normal)
        profileLabel.textColor = .white

        add(childViewController: editVC)
        styleTabs(active: 4)
    }

    private func styleTabs(active: Int) {
        activeTab = active
        tabsView.backgroundColor = .white
        view.backgroundColor = SalonDesign.canvas
        tabsView.layer.shadowColor = SalonDesign.ink.cgColor
        tabsView.layer.shadowOpacity = 0.05
        tabsView.layer.shadowRadius = 12
        tabsView.layer.shadowOffset = CGSize(width: 0, height: -3)
        let buttons = [homeBtn, balancesBtn, notificationsBtn, articlesBtn, profileBtn]
        let labels = [homeLabel, balancesLabel, notificationsLabel, articlesLabel, profileLabel]
        let symbols = ["house", "wallet.pass", "bell", "calendar", "person.crop.circle"]
        let titles = [SalonDesign.text("الرئيسية", "Home"), SalonDesign.text("المحفظة", "Wallet"), SalonDesign.text("الإشعارات", "Alerts"), SalonDesign.text("حجوزاتي", "Bookings"), SalonDesign.text("حسابي", "Account")]
        for index in 0..<buttons.count {
            guard let button = buttons[index], let label = labels[index] else { continue }
            let color = index == active ? SalonDesign.primary : SalonDesign.secondary
            let symbol = symbols[index] + (index == active ? ".fill" : "")
            button.setImage(UIImage(systemName: symbol) ?? UIImage(systemName: symbols[index]), for: .normal)
            button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 23, weight: .regular), forImageIn: .normal)
            button.tintColor = color
            button.backgroundColor = .clear
            button.superview?.backgroundColor = .clear
            button.superview?.layer.cornerRadius = 0
            button.superview?.layer.borderWidth = 0
            button.accessibilityLabel = titles[index]
            button.accessibilityTraits = index == active ? [.button, .selected] : [.button]
            label.text = titles[index]
            label.textColor = color
            label.font = SalonDesign.font(12, bold: index == active)
        }
        notificationsCountView.backgroundColor = SalonDesign.primary
    }

    func resetTabsToDefaults() {
        homeBtn.setImage(#imageLiteral(resourceName: "homegray") , for: .normal)
        balancesBtn.setImage(#imageLiteral(resourceName: "waletgray") , for: .normal)
        notificationsBtn.setImage(#imageLiteral(resourceName: "ringgray") , for: .normal)
        articlesBtn.setImage(#imageLiteral(resourceName: "bookgray") , for: .normal)
        profileBtn.setImage(#imageLiteral(resourceName: "girlgray") , for: .normal)
        
        homeLabel.textColor = .lightGray
        balancesLabel.textColor = .lightGray
        notificationsLabel.textColor = .lightGray
        articlesLabel.textColor = .lightGray
        profileLabel.textColor = .lightGray
    }
    
}

extension ContainerVC: ColorsPresenterView {
    func getColorsSuccess(_ response: ColorsModel) {
        Helper.saveObjectDefault(key: UserDefault.userColors, value: response)

        Helper.setNavColor(nav: self.navigationController!)
        styleTabs(active: activeTab)
    }
}

extension ContainerVC : CLLocationManagerDelegate {
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.requestLocation()
        }else if status == .notDetermined {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.last != nil {
            print("location: ", locations.last?.coordinate.latitude ?? 0.0)
            print("location: ", locations.last?.coordinate.longitude ?? 0.0)
            
            userLoc = locations.last?.coordinate
            
            ref.child("\(userId)").setValue(["lat": userLoc?.latitude ?? 0.0,
                                             "lon": userLoc?.longitude ?? 0.0,
                                             "providerId": userId])
            
            
        }else{
            print("location:: (Not Defined)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: (error)")
    }
}
