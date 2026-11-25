//
//  HomeVC.swift
//  salon
//
//  Created by AL Badr  on 5/17/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import ImageSlideshow

class HomeVC: UITableViewController {
    @IBOutlet weak var homeTable: UITableView!

    @IBOutlet weak var imageSlider: ImageSlideshow!
    @IBOutlet weak var servicesCV: UICollectionView!
    @IBOutlet weak var specialistsCV: UICollectionView!
    @IBOutlet weak var articlesCV: UICollectionView!
    
    var imagesList: [Slider] = []
    var servicesList: [DepartmentsData] = []
    var providersList: [Providers] = []
    var articlesList: [Articles] = []

    fileprivate var presenter: HomePresenter?
    
    var token: String = ""
    var userId: String = ""

    var refresher: UIRefreshControl!
    
    var subServicesCellHight: CGFloat = 160
        
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let userDate = Helper.getObjectDefault(key: UserDefault.userData) as? LoginData
        token = userDate?.api_token ?? ""
        userId = "\(userDate?.id ?? 0)"
        
        print("user token", token)
        print("user id", userId)
        
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(populate), for: UIControl.Event.valueChanged)
        homeTable.addSubview(refresher)
        
        presenter = HomePresenter(self)
        presenter?.GetHome()
        presenter?.getSettings()
        
        initView()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            if UIDevice.current.userInterfaceIdiom == .pad {
                return 500
            }else {
                return 180
            }

        case 2:
            return subServicesCellHight

        case 4:
            return 240
            
        case 6:
            return 160
            
        default:
            return 64
        }
    }
    
    @objc func populate(){
        presenter?.GetHome()
        presenter?.getSettings()
        
        refresher.endRefreshing()
    }
    
    func initView() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        tableView.backgroundColor = SalonDesign.canvas
        tableView.separatorStyle = .none
        tableView.tableHeaderView = makeWelcomeHeader()
        tableView.contentInset.bottom = 20
        imageSlider.layer.cornerRadius = 20
        imageSlider.clipsToBounds = true

        servicesCV.dataSource = self
        servicesCV.backgroundColor = .clear
        servicesCV.delegate = self
        servicesCV.register(UINib(nibName: "ServicesCell", bundle: nil), forCellWithReuseIdentifier: "ServicesCell")
        
        specialistsCV.dataSource = self
        specialistsCV.backgroundColor = .clear
        specialistsCV.delegate = self
        specialistsCV.register(UINib(nibName: "SpecialistCell", bundle: nil), forCellWithReuseIdentifier: "SpecialistCell")
        
        articlesCV.dataSource = self
        articlesCV.backgroundColor = .clear
        articlesCV.delegate = self
        articlesCV.register(UINib(nibName: "ArticlesCell", bundle: nil), forCellWithReuseIdentifier: "ArticlesCell")
    }

    private func makeWelcomeHeader() -> UIView {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 165))
        let eyebrow = UILabel()
        eyebrow.text = SalonDesign.text("مساحتك للعناية والجمال", "YOUR BEAUTY, YOUR MOMENT")
        eyebrow.font = SalonDesign.font(13)
        eyebrow.textColor = SalonDesign.secondary
        let heading = UILabel()
        heading.text = SalonDesign.text("عناية تليق بك", "A little care. All for you.")
        heading.font = SalonDesign.font(30, bold: true)
        heading.textColor = SalonDesign.ink
        heading.numberOfLines = 2
        let search = UIButton(type: .system)
        var configuration = UIButton.Configuration.filled()
        configuration.title = SalonDesign.text("ابحث عن خدمة أو أخصائي", "Find a service or specialist")
        configuration.image = UIImage(systemName: "magnifyingglass")
        configuration.imagePadding = 10
        configuration.baseForegroundColor = SalonDesign.secondary
        configuration.baseBackgroundColor = .white
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 18, bottom: 15, trailing: 18)
        search.configuration = configuration
        search.contentHorizontalAlignment = .leading
        search.layer.cornerRadius = 16
        search.layer.cornerCurve = .continuous
        search.layer.borderWidth = 1
        search.layer.borderColor = SalonDesign.line.cgColor
        search.clipsToBounds = true
        search.addTarget(self, action: #selector(openDiscovery), for: .touchUpInside)
        search.accessibilityLabel = configuration.title
        let stack = UIStackView(arrangedSubviews: [eyebrow, heading, search])
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -20),
            stack.topAnchor.constraint(equalTo: header.topAnchor, constant: 18),
            search.heightAnchor.constraint(greaterThanOrEqualToConstant: 52)
        ])
        return header
    }

    @objc private func openDiscovery() { shawServicesBtn_tapped(self) }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
        guard [1, 3, 5].contains(indexPath.row) else { return }
        guard cell.contentView.viewWithTag(8101) == nil else { return }
        cell.contentView.subviews.forEach { $0.isHidden = true }
        let label = UILabel()
        label.text = indexPath.row == 1 ? SalonDesign.text("خدمات تناسبك", "Made for your routine")
            : indexPath.row == 3 ? SalonDesign.text("أخصائيو التجميل", "Meet the specialists")
            : SalonDesign.text("نصائح وإلهام", "A little inspiration")
        label.font = SalonDesign.font(20, bold: true)
        label.textColor = SalonDesign.ink
        let button = UIButton(type: .system)
        button.setTitle(SalonDesign.text("عرض الكل", "See all"), for: .normal)
        button.titleLabel?.font = SalonDesign.font(14)
        button.tintColor = SalonDesign.primary
        button.widthAnchor.constraint(greaterThanOrEqualToConstant: 65).isActive = true
        button.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        let action = indexPath.row == 1 ? #selector(shawServicesBtn_tapped(_:))
            : indexPath.row == 3 ? #selector(shawSpecialistsBtn_tapped(_:)) : #selector(shawArticlesBtn_tapped(_:))
        button.addTarget(self, action: action, for: .touchUpInside)
        let row = UIStackView(arrangedSubviews: [label, button])
        row.tag = 8101
        row.spacing = 12
        row.alignment = .center
        row.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(row)
        NSLayoutConstraint.activate([
            row.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20),
            row.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -20),
            row.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 6),
            row.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -6)
        ])
    }
    
    @IBAction func shawServicesBtn_tapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: Storyboards.main, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "SearchServicesVC") as! SearchServicesVC
        vc.title = "Services".localiz()
        vc.servicesList = servicesList
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func shawSpecialistsBtn_tapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: Storyboards.main, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "SearchProvidersVC") as! SearchProvidersVC
        vc.title = "Provider".localiz()
        vc.providersList = providersList
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func shawArticlesBtn_tapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: Storyboards.main, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "ArticlesVC") as! ArticlesVC
        vc.title = "Articles".localiz()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case servicesCV:
            return CGSize(width: (UIScreen.main.bounds.width - 12) * 0.3, height: 150)
        case specialistsCV:
            return CGSize(width: 225, height: 225)            
        default:
            return CGSize(width: 150, height: 150)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case servicesCV:
            return min(6, servicesList.count)
        case specialistsCV:
            return providersList.count
        default:
            return articlesList.count
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
            
        case specialistsCV:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpecialistCell", for: indexPath) as?
                SpecialistCell else {
                    return UICollectionViewCell()
            }
            
            cell.configureCell(item: providersList[indexPath.row])
            
            return cell
            
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticlesCell", for: indexPath) as?
                ArticlesCell else {
                    return UICollectionViewCell()
            }
            
            cell.configureCell(item: articlesList[indexPath.row])
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case servicesCV:
            let storyboard = UIStoryboard(name: Storyboards.reservation, bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: "ServicesVC") as! ServicesVC
            
            if LanguageManger.shared.currentLanguage == .ar {
                vc.title = servicesList[indexPath.row].department_name ?? ""
            }else {
                vc.title = servicesList[indexPath.row].department_name_en ?? ""
            }
            
            vc.serviceId = servicesList[indexPath.row].department_id ?? 0
            vc.serviceListIndex = indexPath.row
            vc.servicesList = servicesList
            self.navigationController?.pushViewController(vc, animated: true)
            
        case specialistsCV:
            let storyboard = UIStoryboard(name: Storyboards.provider, bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: "ProviderDetailsSegmentVC") as! ProviderDetailsSegmentVC
            vc.providerName = providersList[indexPath.row].user_name ?? ""
            vc.providerId = providersList[indexPath.row].user_id ?? 0
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            let storyboard = UIStoryboard(name: Storyboards.main, bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: "ArticleDetailsVC") as! ArticleDetailsVC
            vc.articleId = articlesList[indexPath.row].id ?? 0
            vc.articleImage = articlesList[indexPath.row].image ?? ""
            
            if LanguageManger.shared.currentLanguage == .ar {
                vc.title = articlesList[indexPath.row].title ?? ""
                vc.articleDescription = articlesList[indexPath.row].description ?? ""
            }else {
                vc.title = articlesList[indexPath.row].title_en ?? ""
                vc.articleDescription = articlesList[indexPath.row].description_en ?? ""
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension HomeVC: HomePresenterView {
    func getSliderSuccess(_ response: [Slider]) {
        imagesList = response
        setupSlider()
    }
    
    func getDepartmentsSuccess(_ response: [DepartmentsData]) {
        servicesList = response
        
        if servicesList.isEmpty {
            return
        }
        
        let listCount = min(6, servicesList.count)
        
        if listCount % 3 == 0 {
            subServicesCellHight = CGFloat((listCount/3) * 160)
        }else {
            subServicesCellHight = CGFloat(((listCount/3) + 1) * 160)
        }
        
        servicesCV.reloadData()
        self.tableView.reloadData()
    }
    
    func getProvidersSuccess(_ response: [Providers]) {
        providersList = response
        specialistsCV.reloadData()
    }
    
    func getArticlesSuccess(_ response: [Articles]) {
        articlesList = response
        articlesCV.reloadData()
    }
    
    func getSettingsSuccess(_ response: SettingsModel) {
        Helper.saveObjectDefault(key: UserDefault.userSettings, value: response)
    }
    
    func getNotificationsCountSuccess(_ response: Int) {
        Helper.saveUserDefault(key: UserDefault.notificationsCount, value: "\(response)")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ContainerNotification"), object: nil)
    }
    
    func getOrdersCountSuccess(_ response: Int) {
        Helper.saveUserDefault(key: UserDefault.ordersCount, value: "\(response)")
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), type: .error)
    }
}

extension HomeVC {
    func setupSlider() {
        var sliderSource: [InputSource] = []
        
        if imagesList.count != 0 {
            for i in 0 ..< imagesList.count {
                sliderSource.append(AlamofireSource(urlString: SITE_URL + (imagesList[i].image ?? ""))!)
            }
            
            imageSlider.slideshowInterval = 3.0
            imageSlider.pageIndicatorPosition = .init(horizontal: .center, vertical: .bottom)
            imageSlider.contentScaleMode = UIView.ContentMode.scaleAspectFill
            
            let pageControl = UIPageControl()
            pageControl.currentPageIndicatorTintColor = SalonDesign.primary
            pageControl.pageIndicatorTintColor = UIColor.lightGray
            imageSlider.pageIndicator = pageControl
            imageSlider.activityIndicator = DefaultActivityIndicator()
            imageSlider.setImageInputs(sliderSource)
            
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.sliderDidTap))
            self.imageSlider.addGestureRecognizer(recognizer)
        }
    }
    
    @objc func sliderDidTap() {
        imageSlider.presentFullScreenController(from: self)
    }
}

//extension UICollectionViewFlowLayout {
//    open override var flipsHorizontallyInOppositeLayoutDirection: Bool {
//        if LanguageManger.shared.currentLanguage == .ar {
//            return true
//        }else {
//            return false
//        }
//    }
//}
//
