//
//  LocationManager.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/24/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    override init() {
        super.init()
//        locationManager.requestAlwaysAuthorization()
//
//        locationManager.requestWhenInUseAuthorization()
//
//        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse) || (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways) {
//
//
//            let currentLocation = locationManager.location
//            print(currentLocation?.coordinate)
//        }else {
//            print("else ")
//        }
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        print(locValue)
    }
    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//
//        if status == .authorizedWhenInUse {
//            locationManager.requestLocation()
//            let currentLocation = locationManager.location
//            print(currentLocation?.coordinate)
////            print(currentLocation?.coordinate.longitude)
//            //Process location information and update.
//
//        }
//    }
}
