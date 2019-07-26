//
//  LocationService.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/26/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation
import CoreLocation


class LocationService: NSObject {
    var locationManager: CLLocationManager = CLLocationManager()
    var currLocation: CLLocation?
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
 
    private func activateLocationServices() {
        locationManager.startUpdatingLocation()
    }

}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            activateLocationServices()
        }else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currLocation = locations.first
        if let currLocation = currLocation {
//             print(currLocation)
        }
    }
    
}
