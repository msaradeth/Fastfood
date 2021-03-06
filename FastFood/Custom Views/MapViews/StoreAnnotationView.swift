//
//  StoreAnnotationView.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/25/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation
import MapKit

class StoreAnnotationView: MKAnnotationView {
    static let cellIdentifier = "StoreAnnotationViews"
    
    init(annotation: MKAnnotation?, reuseIdentifier: String?, isSelected: Bool) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.canShowCallout = true
        //set image
        if isSelected {
            self.image = #imageLiteral(resourceName: "selectedLocation")
        }else {
            self.image = #imageLiteral(resourceName: "location")
        }
    }

    //Required for MKAnnotationView
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
