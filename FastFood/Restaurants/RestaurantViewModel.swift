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
    var items: [Store] {
        didSet {
            updateAnnotations()
        }
    }
    var annotations: [StoreAnnotation] = []    
    var count: Int {
        return items.count
    }
    subscript(indexPath: IndexPath) -> Store {
        return items[indexPath.row]
    }

    //MARK: init
    init(items: [Store], searchStoreService: SearchStoreService, locationService: LocationService) {
        self.items = items
        self.searchStoreService = searchStoreService
        self.locationService = locationService
        super.init()
    }
    
    //init annotations array
    func updateAnnotations() {
        annotations.removeAll()
        for (index, store) in items.enumerated() {
            if let coordinate = store.coordinate {
                annotations.append(StoreAnnotation(coordinate: coordinate, indexPath: IndexPath(row: index, section: 0), store: store))
            }
        }
    }
}


extension RestaurantViewModel: MapViewModelDelegate, LoadImageService {
    
    //MARK: Query server to get store base on given location
    func searchStore(location: String?, coordinate: CLLocationCoordinate2D?, completion: @escaping ()->Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.searchStoreService.search(location: location, coordinate: coordinate, completion: { [weak self] (stores) in
                self?.items = stores
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

