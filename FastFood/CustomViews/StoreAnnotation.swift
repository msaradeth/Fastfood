//
//  StoreAnnotation.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/23/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation
import MapKit

enum LocationImage {
    static func getImage(storeNumber: Int) -> UIImage {
        return #imageLiteral(resourceName: "locationTabBar")
    }
}

class StoreAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var storeNumber: Int
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, storeNumber: Int) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.storeNumber = storeNumber
    }

}
