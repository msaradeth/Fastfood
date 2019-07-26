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
    
    init(annotation: MKAnnotation?, reuseIdentifier: String?, vcDelegate: VCDelegate?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        guard let vcDelegate = vcDelegate else { return }
        
        //set image
        if let annotation = annotation as? StoreAnnotation {
            if annotation.indexPath == vcDelegate.currIndexPath {
                self.image = #imageLiteral(resourceName: "selectedLocation")
            }else {
                self.image = #imageLiteral(resourceName: "location")
            }
        }
    }

    //Required for MKAnnotationView
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
