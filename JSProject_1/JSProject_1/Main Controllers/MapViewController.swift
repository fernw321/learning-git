//
//  MapViewController.swift
//  JSProject_1
//
//  Created by William Fernandez on 11/5/19.
//  Copyright © 2019 William Fernandez. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet var mapKit: MKMapView!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Set Dark or Light mode
        let defaults = UserDefaults.standard
        let prefersDarkMode = defaults.bool(forKey: "prefersDarkMode")
        if prefersDarkMode {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
        }
        
        checkLocationServices()
        

    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // We have to check if location services are enabled
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            // Set up our location manager
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            // Do map stuff
            mapKit.showsUserLocation = true
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // Show alert instructing how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case.authorizedAlways:
            break
        @unknown default:
            break
        }
    }

 
    
    
//    func addAnotations() {
//        let appleParkAnnotation = MKPointAnnotation()
//        appleParkAnnotation.title = "Apple Park"
//        appleParkAnnotation.coordinate = CLLocationCoordinate2D(latitude: 37.3327, longitude: -122.0053)
//
//        mapKit.addAnnotation(appleParkAnnotation)
//    }
    
    
    
        
//    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
//            if annotation.isEqual(mapView.userLocation) {
//            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "userLocation")
//            annotationView.image = UIImage(named: "3_Final-Fantasy-7-Remake")
//            return annotationView
//        }
//        return nil
//    }
    

}

class customPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(pinTitle: String, pinSubTitle: String, location: CLLocationCoordinate2D) {
        self.title = pinTitle
        self.subtitle = pinSubTitle
        self.coordinate = location
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapKit.setRegion(region, animated: true)
        
        locationManager.stopUpdatingLocation();
//        addAnotations()
       
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
}
