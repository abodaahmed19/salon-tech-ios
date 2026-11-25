//
//  TrackProviderVC.swift
//  salon
//
//  Created by AL Badr  on 6/30/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import ObjectMapper
import SwiftyJSON

class TrackProviderVC: UIViewController {

    @IBOutlet weak var mapKit: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    var placeLat: String = ""
    var placeLon: String = ""
    var providerId: String = ""
        
    let locationManager = CLLocationManager()

    fileprivate var placeLoc:CLLocationCoordinate2D?
    fileprivate var userLoc:CLLocationCoordinate2D?
    
    var ref: DatabaseReference!
        
    override func viewWillAppear(_ animated: Bool) {
     
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference(withPath: databasePath)
        
        getLocation()

        mapKit.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        infoLabel.text = "track_info".localiz()
        
//        addAnnotation()
    }
    
    func addAnnotation() {
//        let allAnnotations = mapKit.annotations
//        self.mapKit.removeAnnotations(allAnnotations)
        
        let providerPlace = CLLocation(latitude: Double(placeLat) ?? 0, longitude: Double(placeLon) ?? 0)
        
        UIView.animate(withDuration: 1, animations: {
            let allAnnotations = self.mapKit.annotations
            self.mapKit.removeAnnotations(allAnnotations)
            
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = providerPlace.coordinate
            self.mapKit.addAnnotation(annotation)
        })

        placeLoc = providerPlace.coordinate

        if placeLoc != nil {
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: placeLoc!, span: span)
            mapKit.setRegion(region, animated: true)
        }
        
//        if userLoc != nil {
//            getDistance()
//        }
    }
 
    func getDistance() {
        let providerPlace = CLLocation(latitude: Double(placeLat) ?? 0, longitude: Double(placeLon) ?? 0)
        let userPlace = CLLocation(latitude: userLoc?.latitude ?? 0, longitude: userLoc?.longitude ?? 0)

        let distance = providerPlace.distance(from: userPlace)
        let kmDistance = (distance / 1000).rounded(toPlaces: 2)
        
        distanceLabel.text = "Away".localiz() + " " + String(kmDistance) + " " + "km".localiz()
    }
 
    func showNavigations() {
        let latitude: CLLocationDegrees = Double(placeLat) ?? 0.0
        let longitude: CLLocationDegrees = Double(placeLon) ?? 0.0
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = ""
        mapItem.openInMaps(launchOptions: options)
    }
    
    func openGoogleMap() {
        let latitude: CLLocationDegrees = Double(placeLat) ?? 0.0
        let longitude: CLLocationDegrees = Double(placeLon) ?? 0.0
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {  //if phone has an app
            if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(latitude),\(longitude)&directionsmode=driving") {
                UIApplication.shared.open(url, options: [:])
            }}
        else {
            //Open in browser
            if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(latitude),\(longitude)&directionsmode=driving") {
                UIApplication.shared.open(urlDestination)
            }
        }
    }
    
    func getLocation() {
        print("providerId", providerId)
        ref.child("\(providerId)").observe(.value, with: { [weak self] (snapshot) in
            guard let self = self else { return }
            guard let data = snapshot.value as? [String : AnyObject] else { return }
            print("snapshot", JSON(data))
            
            let value = Mapper<UserLiveLocation>().map(JSON: data)
            
            self.placeLat = String(value?.lat ?? 0.0)
            self.placeLon = String(value?.lon ?? 0.0)
            
            self.addAnnotation()
        })
    }
    
    func updateLocation() {
        ref.child("\(providerId)").setValue(["lat": Double(placeLat) ?? 0.0,
                                             "lon": Double(placeLon) ?? 0.0,
                                             "providerId": Int(providerId) ?? 0])
    }
    
    @IBAction func backBtn_tapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
 

}

extension TrackProviderVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        showNavigations()
        openGoogleMap()
    }
}

extension TrackProviderVC : CLLocationManagerDelegate {
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.last != nil {
            print("location: ", locations.last?.coordinate.latitude ?? 0.0)
            print("location: ", locations.last?.coordinate.longitude ?? 0.0)
            
            userLoc = locations.last?.coordinate
            
//            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//            let region = MKCoordinateRegion(center: userLoc!, span: span)
//            mapKit.setRegion(region, animated: true)
            
//            getDistance()
            
        }else{
            print("location:: (Not Defined)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: (error)")
    }
}
