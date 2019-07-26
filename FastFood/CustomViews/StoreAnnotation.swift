//
//  StoreAnnotation.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/23/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation
import MapKit


class StoreAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var indexPath: IndexPath
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, indexPath: IndexPath) {
        self.coordinate = coordinate
        self.title = "Store #\(indexPath.row): \(title) "
        self.subtitle = "\(subtitle)"
        self.indexPath = indexPath
    }

}
