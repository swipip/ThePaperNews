//
//  MapViewController.swift
//  ThePaper
//
//  Created by Gautier Billard on 22/03/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

let countryObserverKey = "co.gautierBillard.countryKey"

class MapViewController: UIViewController {

    private var mapView: MKMapView!
    private let locationManager = CLLocationManager()
    private var previousLocation: CLLocation!
    private var locationLabel: UILabel!
    private var countryCode = "fr"
    private var dismissButton: UIButton!
    private let k = K()
    
    private var availableCountryCodes = ["mx", "br", "nl", "de", "se", "us", "ua", "bg", "za", "th", "id", "fr", "co", "jp", "cu", "lv", "sa", "kr", "au", "eg", "sk", "gr", "lt", "cz", "ae", "sa", "in", "rs", "ch", "ie", "cn", "nl", "be", "hk", "ar", "nz", "ve", "it", "il", "ma", "pl", "sk", "se", "no", "ng", "hu", "tw", "gb", "pl", "at", "ca"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBlur()
        
        addDismissButton()
        addLocationLabel()
        addMapView()
        addPin()
        
        checkLocationAvailable()
  
    }

    fileprivate func checkLocationAvailable() {
        if CLLocationManager.locationServicesEnabled() {
            setUpLocationManager()
            checkLocationAuthorization()
        }else{
            // alert
        }
    }
    fileprivate func setUpLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.delegate = self
    }
    func checkLocationAuthorization() {
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            previousLocation = getCenterLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways:
            break
        case .denied:
            //give permission
            break
        case .restricted:
            break
        @unknown default:
            break
        }
        
    }
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 1000000, longitudinalMeters: 1000000)
            mapView.setRegion(region, animated: true)
        }
    }
    func addBlur() {
        
        let blur = UIBlurEffect(style: .regular)
        
        let effectView = UIVisualEffectView(effect: blur)
        
        self.view.addSubview(effectView)
        
        //view
        let fromView = effectView
        //relative to
        let toView = self.view!
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 0),
                                     fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: 0),
                                     fromView.topAnchor.constraint(equalTo: toView.topAnchor, constant: 0),
                                     fromView.bottomAnchor.constraint(equalTo: toView.bottomAnchor, constant: 0)])
        
    }
    func addLocationLabel() {
        
        let background = UIView()
        background.backgroundColor = .white
        background.alpha = 0.6
        background.layer.cornerRadius = 20
        
        self.view.addSubview(background)
            
        background.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([background.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
                                     background.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
                                     background.bottomAnchor.constraint(equalTo: dismissButton.topAnchor, constant: -10),
                                     background.heightAnchor.constraint(equalToConstant: 40)])
        
        locationLabel = UILabel()
        locationLabel.text = "France"
        locationLabel.textColor = .lightGray
        
        background.addSubview(locationLabel)
        //view
        let fromView = locationLabel!
        //relative to
        let toView2 = background
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.centerYAnchor.constraint(equalTo: toView2.centerYAnchor, constant: 0),
                                     fromView.centerXAnchor.constraint(equalTo: toView2.centerXAnchor, constant: 0)])
        
        
        
        
        
    }
    func addMapView() {
        
        mapView = MKMapView()
        mapView.delegate = self
        mapView.layer.cornerRadius = 8
        
        self.view.addSubview(mapView)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        //view
        let fromView = mapView!
        //relative to
        let toView = self.view!
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 10),
                                     fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: -10),
                                     fromView.topAnchor.constraint(equalTo: toView.topAnchor, constant: 10),
                                     fromView.bottomAnchor.constraint(equalTo: self.locationLabel.topAnchor ,constant: -20)])
    }
    func addPin() {
        
        let imageView = UIImageView()
        imageView.tintColor = .systemRed
        imageView.image = UIImage(named: "pin")
        
        self.view.addSubview(imageView)
        
        //view
        let fromView = imageView
        //relative to
        let toView = mapView!
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.centerXAnchor.constraint(equalTo: toView.centerXAnchor, constant: 0),
                                     fromView.heightAnchor.constraint(equalToConstant: 30),
                                     fromView.centerYAnchor.constraint(equalTo: toView.centerYAnchor, constant: -33),
                                     fromView.widthAnchor.constraint(equalToConstant: 30)])
        
    }
    func addDismissButton() {
        
        dismissButton = UIButton()
        dismissButton.setTitle("Dismiss", for: .normal)
        dismissButton.backgroundColor = k.mainColorTheme
        dismissButton.layer.cornerRadius = 20
        
        self.view.addSubview(dismissButton)
        
        //view
        let fromView = dismissButton!
        //relative to
        let toView = self.view!
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 10),
                                     fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: -10),
                                     fromView.bottomAnchor.constraint(equalTo: toView.bottomAnchor, constant: -30),
                                     fromView.heightAnchor.constraint(equalToConstant: 40)])
        
        dismissButton.addTarget(self, action: #selector(dismissButtonPressed), for: .touchUpInside)
        
    }
    @IBAction func dismissButtonPressed(_ sender: UIButton!) {
        
        let notificationName = Notification.Name(countryObserverKey)
        
        let userInfo:[String: String] = ["country":countryCode]
        
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: userInfo)
        
        self.dismiss(animated: true, completion: nil)
    }
    func getCenterLocation() -> CLLocation {
        
        let lattitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: lattitude, longitude: longitude)
        
    }

}
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else {return}
//
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: 10000, longitudinalMeters: 10000)
//        mapView.setRegion(region, animated: true)
//    }
    
}
extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation()
        let geoCoder = CLGeocoder()
        
        guard center.distance(from: previousLocation) > 20000 else {return}
        
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            guard self != nil else {return}
            
            if let _ = error {
                return
            }
            guard let placemark = placemarks?.first else {
                return
            }
                    
            DispatchQueue.main.async {
                
                let country = placemark.country
                self?.countryCode = placemark.isoCountryCode?.lowercased() ?? "fr"
                
                for (_,ctry) in (self?.availableCountryCodes.enumerated())! {

                    if ctry == placemark.isoCountryCode?.lowercased() {
                        self?.locationLabel?.text = country
                        break
                    }else{
                        self?.locationLabel?.text = "Country not available"
                    }
                }

            }
        }
    }
}

