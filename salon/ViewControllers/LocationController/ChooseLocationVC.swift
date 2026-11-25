//
//  ChooseLocationVC.swift
//  salon
//
//  Created by AL Badr  on 6/16/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps

class ChooseLocationVC: UIViewController {
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var locatedAddress: UILabel!
    @IBOutlet weak var locationsView: UIView!
    @IBOutlet weak var placesCV: UICollectionView!
    
    var placesList: [LocationsModel] = []
    
    fileprivate var presenter: PlacesPresenter?
    
    let locationManager = CLLocationManager()

    var placeTitle: String = ""
    var placeLat: Double = 0.0
    var placeLon: Double = 0.0
    
    var userLat: Double = 0.0
    var userLon: Double = 0.0

    var newPlace: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView?.isMyLocationEnabled = true
        mapView.settings.scrollGestures = true
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        mapView.settings.zoomGestures = true
    
        mapView.isBuildingsEnabled = false
        mapView.isIndoorEnabled = false
        mapView.isTrafficEnabled = false
        mapView.mapType = .normal
        mapView.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        if newPlace {
            locationsView.isHidden = true
        }else {
            locationsView.isHidden = false
            
            initView()
            showPlaces()
        }
    }
    
    func initView() {        
        placesCV.dataSource = self
        placesCV.delegate = self
        placesCV.register(UINib(nibName: "LocationsCell", bundle: nil), forCellWithReuseIdentifier: "LocationsCell")
    }
    
    func showPlaces() {
        presenter = PlacesPresenter(self)
        presenter?.getPlaces()
    }
    
    @IBAction func chooseLocation_tapped(_ sender: UIButton) {
        var objectInfo = [String: String]()

        objectInfo["lat"] = String(placeLat)
        objectInfo["lon"] = String(placeLon)
        objectInfo["placeTitle"] = placeTitle

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "locationNotification"), object: nil, userInfo: objectInfo)
        
        navigationController?.popViewController(animated: true)
    }

    func getPlaceName(place: CLLocation) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(place, completionHandler: { [weak self] (placemarks, error) -> Void in
            guard let self = self else {return }
            // Place details
            var placeMark: CLPlacemark?
            placeMark = placemarks?[0]
            // Address dictionary
            
            let name = (placeMark?.name ?? "")
            let thoroughfare = (placeMark?.thoroughfare ?? "")
            let subThoroughfare = (placeMark?.subThoroughfare ?? "")
            let locality = (placeMark?.locality ?? "")
            let subLocality = (placeMark?.subLocality ?? "")
            let administrativeArea = (placeMark?.administrativeArea ?? "")
            let subAdministrativeArea = (placeMark?.subAdministrativeArea ?? "")
            let country = (placeMark?.country ?? "")
            
            print("name", name)
            print("thoroughfare", thoroughfare)
            print("subThoroughfare", subThoroughfare)
            print("locality", locality)
            print("subLocality", subLocality)
            print("administrativeArea", administrativeArea)
            print("subAdministrativeArea", subAdministrativeArea)
            print("country", country)

            let address = "%@ %@ %@ %@ %@ %@ %@ %@"

            self.placeTitle = String(format: address, name, thoroughfare, subThoroughfare, locality, subLocality, administrativeArea, subAdministrativeArea, country)
            self.locatedAddress.text = self.placeTitle
        })
    }
    
    func showLocationAlert() {
        let alertController = UIAlertController(title: "Alert".localiz(), message: "Please go to Settings and turn on the location permissions".localiz(), preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings".localiz(), style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel".localiz(), style: .default, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

}

extension ChooseLocationVC: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        mapView.clear()
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.map = mapView
        
        placeLat = coordinate.latitude
        placeLon = coordinate.longitude
        
        print("annotation lat: ", placeLat)
        print("annotation lon: ", placeLon)
        
//        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 20.0)
//        let updateCamera = GMSCameraUpdate.setCamera(camera)
//        mapView.moveCamera(updateCamera)
        
        let place = CLLocation(latitude: placeLat, longitude: placeLon)
        getPlaceName(place: place)
    }
   
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        print("MY LOCATION +++", "nbnbnbnbnbnb")
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined, .restricted, .denied:
            showLocationAlert()

        case .authorizedAlways, .authorizedWhenInUse:
            let camera = GMSCameraPosition.camera(withLatitude: userLat,
                                                  longitude: userLon,
                                                  zoom: 17,
                                                  bearing: 90,
                                                  viewingAngle: 40)
            let updateCamera = GMSCameraUpdate.setCamera(camera)
            mapView.moveCamera(updateCamera)

        @unknown default:
            return false
        }
        
        return true
    }
}

extension ChooseLocationVC : CLLocationManagerDelegate {
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.first else { return }
        
        placeLat = loc.coordinate.latitude
        placeLon = loc.coordinate.longitude
        
        userLat = loc.coordinate.latitude
        userLon = loc.coordinate.longitude
        
        print("location: ", placeLat)
        print("location: ", placeLon)
        
        let camera = GMSCameraPosition.camera(withLatitude: placeLat,
                                              longitude: placeLon,
                                              zoom: 17,
                                              bearing: 90,
                                              viewingAngle: 40)
        let updateCamera = GMSCameraUpdate.setCamera(camera)
        mapView.moveCamera(updateCamera)
        
        let place = CLLocation(latitude: placeLat, longitude: placeLon)
        getPlaceName(place: place)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: (error)")
    }
}

extension ChooseLocationVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 16, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return placesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LocationsCell", for: indexPath) as?
            LocationsCell else {
                return UICollectionViewCell()
        }
        
        cell.configCell(item: placesList[indexPath.row])
        
        cell.deleteBtn.isHidden = true
        
        cell.chooseRadioBtn.addTarget(self, action: #selector(chooseRadioBtn_tapped(_:)), for: .touchUpInside)
        cell.chooseRadioBtn.tag = indexPath.row
        
        return cell
    }
    
    @objc func chooseRadioBtn_tapped(_ sender: UIButton) {
        for i in 0..<placesList.count {
            guard let cell = placesCV.cellForItem(at: IndexPath(row: i, section: 0)) as? LocationsCell else { return }
            i == sender.tag ? cell.setSelected(selected: true) : cell.setSelected(selected: false)
        }

        placeTitle = placesList[sender.tag].place_title ?? ""
        placeLat = Double(placesList[sender.tag].place_lat ?? "") ?? 0.0
        placeLon = Double(placesList[sender.tag].place_lon ?? "") ?? 0.0
        
        locatedAddress.text = placeTitle
   
        mapView.clear()

        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: placeLat, longitude: placeLon)
        marker.title = placeTitle
        marker.snippet = placeTitle
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.map = mapView
        
        let camera = GMSCameraPosition.camera(withLatitude: placeLat,
                                              longitude: placeLon,
                                              zoom: 17,
                                              bearing: 90,
                                              viewingAngle: 40)
        let updateCamera = GMSCameraUpdate.setCamera(camera)
        mapView.moveCamera(updateCamera)
    }
    
}

extension ChooseLocationVC: PlacesPresenterView {
    func getPlacesSuccess(_ response: [LocationsModel]) {
        placesList = response
        placesCV.reloadData()
    }
    
    func getPlacesFailure() {
        locationsView.isHidden = true
    }
    
    func getAddPlaceSuccess() {}
    
    func getAddPlaceFailure() {}
    
    func getRemovePlaceSuccess() {}
    
    func getRemovePlaceFailure() {}

    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), type: .error)
    }
}

