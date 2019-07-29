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
    var store: Store
    
    init(coordinate: CLLocationCoordinate2D, indexPath: IndexPath, store: Store) {
        self.coordinate = coordinate
        self.indexPath = indexPath
        self.store = store
        self.title = "\(store.name) Store #\(indexPath.row)"
        self.subtitle = store.location.displayAddress.count >= 1 ? "\(store.location.displayAddress[0])" : ""
    }

}
