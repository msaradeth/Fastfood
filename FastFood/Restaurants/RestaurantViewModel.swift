//
//  RestaurantViewModel.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/21/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation
import UIKit
import MapKit



class RestaurantViewModel: NSObject {
    fileprivate var searchStoreService: SearchStoreService
    var locationService: LocationService
    var hideOrderButton: Bool
    var annotations: [StoreAnnotation] = []
    var items: [Store]
    var count: Int {
        return items.count
    }
    subscript(indexPath: IndexPath) -> Store {
        return items[indexPath.row]
    }

    //MARK: init
    init(items: [Store], searchStoreService: SearchStoreService, locationService: LocationService, hideOrderButton: Bool = false) {
        self.items = items
        self.searchStoreService = searchStoreService
        self.locationService = locationService
        self.hideOrderButton = hideOrderButton
        super.init()
    }
    
}


extension RestaurantViewModel: RestaurantViewModelDelegate, LoadImageService {    
    //MARK: Query server to get store base on given location
    func searchStore(location: String?, coordinate: CLLocationCoordinate2D?, completion: @escaping ()->Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.searchStoreService.search(location: location, coordinate: coordinate, completion: { [weak self] (stores, annotations) in
                self?.items = stores
                self?.annotations = annotations
                completion()
            })
        }
    }
    
    
    //MARK: Load and cache image
    func loadImage(indexPath: IndexPath, completion: @escaping (UIImage?)->Void) {
        loadImage(imageUrl: items[indexPath.row].imageUrlString) { [weak self] (image) in
            self?.items[indexPath.row].imageCached = image
            completion(image)
        }
    }    
}

