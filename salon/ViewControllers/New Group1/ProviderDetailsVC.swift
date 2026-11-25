//
//  ProviderDetailsVC.swift
//  salon
//
//  Created by AL Badr  on 6/13/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import ImageSlideshow
import AVFoundation

class ProviderDetailsVC: UITableViewController {
    @IBOutlet var detailsTableView: UITableView!
    @IBOutlet weak var serviceImage: UIImageView!
    @IBOutlet weak var subServicesCV: UICollectionView!
    @IBOutlet weak var workPlacesCV: UICollectionView!

    @IBOutlet weak var providerBio: UITextView!

    @IBOutlet weak var providerImage: UIImageView!
    @IBOutlet weak var providerName: UILabel!
    @IBOutlet weak var providerNumber: UILabel!
    @IBOutlet weak var servicesEnded: UILabel!
    @IBOutlet weak var providerRate: FloatRatingView!
    
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var favView: RoundRectView!
    
    @IBOutlet weak var certificateImage: ImageSlideshow!
    @IBOutlet weak var certificateFrom: UILabel!
    
    @IBOutlet var fromViewWidth: NSLayoutConstraint!
    
    var userImagesList: [String] = []
    var certificateImagesList: [String] = []
    var subServicesList: [Sub_departments] = []
    var workPlacesList: [Work_places] = []
    
    fileprivate var presenter: ProviderDetailsPresenter?
    
    var detailsCellHight: CGFloat = 100
    var workPlacesCellHight: CGFloat = 100
    var certificateCellHight: CGFloat = 300
    var subServicesCellHight: CGFloat = 170

    var provider_id: Int = 0
    
    var inFav: Bool = false

    var token: String = ""
    var userId: String = ""
    var coverType: String = "image"
    var coverLink: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDate = Helper.getObjectDefault(key: UserDefault.userData) as? LoginData
        token = userDate?.api_token ?? ""
        userId = "\(userDate?.id ?? 0)"


        initView()
        ShowProviderDetails()
    }
    
    func initView() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        favView.layer.cornerRadius = favView.frame.height / 2
        providerImage.layer.cornerRadius = providerImage.frame.height / 2

        subServicesCV.dataSource = self
        subServicesCV.delegate = self
        subServicesCV.register(UINib(nibName: "ServicesCell", bundle: nil), forCellWithReuseIdentifier: "ServicesCell")
        
        workPlacesCV.dataSource = self
        workPlacesCV.delegate = self
        workPlacesCV.register(UINib(nibName: "WorkPlacesCell", bundle: nil), forCellWithReuseIdentifier: "WorkPlacesCell")
    }
    
    func ShowProviderDetails() {
        presenter = ProviderDetailsPresenter(self)
        presenter?.GetProviderDetails(provider_id: "\(provider_id)")
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = CGFloat()
        
        if indexPath.row == 0 {
            height = 225
        }else if indexPath.row == 1 {
            height = 140
        }else if indexPath.row == 3{
            height = detailsCellHight
        }else if indexPath.row == 5{
            height = workPlacesCellHight
        }else if indexPath.row == 6{
            height = certificateCellHight
        }else if indexPath.row == 8{
            height = subServicesCellHight
        }else {
            height = 30
        }
        
        return height
    }
    
    @IBAction func favouriteBtn_tapped(_ sender: Any) {
        if token == "" {
            Helper.showFloatAlert(title: "Please, Login first", type: .error)
        }else {
            let parameters = ["provider_id": provider_id] as [String : Any]
            
            if inFav {
                presenter?.removeFromFavourite(provider_id: String(provider_id))
            }else{
                presenter?.addToFavourite(parameters: parameters)
            }
        }
    }
    
    @IBAction func serviceImage_tapped(_ sender: Any) {
        let story = UIStoryboard(name: Storyboards.user, bundle: nil)
        let vc = story.instantiateViewController(withIdentifier:"ChatImagesVC") as! ChatImagesVC
        
        if coverType == "image" {
            vc.image = serviceImage.image
            vc.fileType = "image"
            
        }else {
            vc.fileType = "video"
            vc.fileLink = coverLink
        }
        
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.present(vc, animated: true)
    }
}

extension ProviderDetailsVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == subServicesCV {
            return CGSize(width: (UIScreen.main.bounds.width - 25) * 0.5, height: 160)
        }else {
            return CGSize(width: UIScreen.main.bounds.width - 16, height: 40)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == subServicesCV {
            return subServicesList.count
        }else {
            return workPlacesList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == subServicesCV {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServicesCell", for: indexPath) as?
                ServicesCell else {
                    return UICollectionViewCell()
            }
            
            cell.configureSubServiceCell(item: subServicesList[indexPath.row])
            
            return cell
            
        }else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WorkPlacesCell", for: indexPath) as?
                WorkPlacesCell else {
                    return UICollectionViewCell()
            }
            
            cell.configCell(item: workPlacesList[indexPath.row])
            
            return cell
        }

    }
}


extension ProviderDetailsVC: ProviderDetailsPresenterView {
    func getProvidersDetailsSuccess(_ response: ProviderDetailsData) {
        providerName.text = response.user_name ?? ""
        providerNumber.text = "#" + "\(response.user_id ?? 0)"
        servicesEnded.text = "\(response.reservations_ended_count ?? 0)"
        
        providerRate.rating = Double(response.rate ?? 0)

        providerBio.text = response.bio ?? ""
        
        providerImage.sd_setImage(with: URL(string: SITE_URL + (response.user_image ?? "")))
        
        coverType = response.cover_type ?? "image"
        coverLink = SITE_URL + (response.cover ?? "")
        
        if coverType == "image" {
            serviceImage.sd_setImage(with: URL(string: coverLink))

        }else {
            getThumbnail(videoUrl: coverLink)
        }
                
        if userId == String(provider_id) {
            favView.isHidden = true
        }else {
            favView.isHidden = false
        }
        
        if response.isFav ?? false {
            inFav = true
            favBtn.setImage(#imageLiteral(resourceName: "likepink"), for: .normal)
        }else {
            inFav = false
            favBtn.setImage(#imageLiteral(resourceName: "likeborderpink"), for: .normal)
        }
        
        if response.certified_status ?? false {
            certificateCellHight = 250
            
            certificateImagesList.append(response.certified_image ?? "")
            setupCertificateSlider()
            
            certificateFrom.text = response.certifiedFrom ?? ""
            
            let text = response.certifiedFrom ?? ""
            let textWidth = text.size(withAttributes:[.font: UIFont.systemFont(ofSize:16.0)]).width + 40.0
            fromViewWidth.constant = textWidth

        }else {
            certificateCellHight = 0
        }
        
        detailsCellHight = providerBio.getHeight() + 48
        detailsTableView.reloadData()
    }
    
    func getSubDepartmentsSuccess(_ response: [Sub_departments]) {
        subServicesList = response
        subServicesCV.reloadData()
        
        
        let listCount = subServicesList.count
        
        if listCount % 2 == 0 {
            subServicesCellHight = CGFloat((listCount/2) * 180)
        }else {
            subServicesCellHight = CGFloat(((listCount/2) + 1) * 180)
        }
        
        detailsTableView.reloadData()

    }
    
    func getWorkPlacesSuccess(_ response: [Work_places]) {
        workPlacesList = response
        workPlacesCV.reloadData()
        workPlacesCellHight = CGFloat((workPlacesList.count) * 60)
        detailsTableView.reloadData()
    }
    
    func AddToFavouriteSuccess(_ message: String) {
        Helper.showFloatAlert(title: message, type: .success)
        
        inFav = true
        favBtn.setImage(#imageLiteral(resourceName: "likepink"), for: .normal)
    }
    
    func AddToFavouriteFailure(_ message: String) {
        Helper.showFloatAlert(title: message, type: .error)
    }
    
    func removeFromFavouriteSuccess(_ message: String) {
        Helper.showFloatAlert(title: message, type: .success)
        
        inFav = false
        favBtn.setImage(#imageLiteral(resourceName: "likeborderpink"), for: .normal)
    }
    
    func removeFromFavouriteFailure(_ message: String) {
        Helper.showFloatAlert(title: message, type: .error)
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), type: .error)
    }
}

extension ProviderDetailsVC {
    func setupCertificateSlider() {
        var certificateSliderSource: [InputSource] = []
        
        if certificateImagesList.count != 0 {
            for i in 0 ..< certificateImagesList.count {
                certificateSliderSource.append(AlamofireSource(urlString: SITE_URL + (certificateImagesList[i]))!)
            }
            
            certificateImage.slideshowInterval = 3.0
            certificateImage.contentScaleMode = UIView.ContentMode.scaleAspectFit

            certificateImage.setImageInputs(certificateSliderSource)
            
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(certificateSliderDidTap))
            certificateImage.addGestureRecognizer(recognizer)
        }
    }
    
    @objc func certificateSliderDidTap() {
        certificateImage.presentFullScreenController(from: self)
    }
    
    func getThumbnail(videoUrl: String) {
        do {
            let asset = AVURLAsset(url: URL(string: videoUrl)! as URL , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            serviceImage.image = thumbnail
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
        }
    }
}

