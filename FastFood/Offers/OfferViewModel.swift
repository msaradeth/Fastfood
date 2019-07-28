//
//  OfferViewModel.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/22/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation
import MapKit

protocol OfferViewModelDelegate {
    func loadImage(indexPath: IndexPath, completion: @escaping (UIImage?)->Void)
}

class OfferViewModel: NSObject {
    private var searchStoreService: SearchStoreService
    var locationService: LocationService
    var items = [Store]()
    var count: Int {
        return items.count
    }
    subscript(indexPath: IndexPath) -> Store {
        return items[indexPath.row]
    }
    
    //MARK: Init
    init(items: [Store], searchStoreService: SearchStoreService, locationService: LocationService) {
        self.items = items
        self.searchStoreService = searchStoreService
        self.locationService = locationService
    }
    
    //Search Yelp Api to get Restaurants near current location
    func searchStore(term: String, coordinate: CLLocationCoordinate2D, completion: @escaping ()->Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            self.searchStoreService.search(term: term, coordinate: coordinate, completion: { [weak self] (stores, annotations) in
                self?.items = stores
                completion()
            })
        }
    }
}

extension OfferViewModel: OfferViewModelDelegate, LoadImageService {
    //MARK: Load and cache image
    func loadImage(indexPath: IndexPath, completion: @escaping (UIImage?)->Void) {
        loadImage(imageUrl: items[indexPath.row].imageUrlString) { [weak self] (image) in
            self?.items[indexPath.row].imageCached = image
            completion(image)
        }
    }
    
}
