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
    fileprivate var storeDetailService: StoreDetailService
    var items: [Store]
    var annotations: [StoreAnnotation] = []    
    var count: Int {
        return items.count
    }
    subscript(indexPath: IndexPath) -> Store {
        return items[indexPath.row]
    }

    //MARK: init
    init(items: [Store], searchStoreService: SearchStoreService, storeDetailService: StoreDetailService) {
        self.items = items
        self.searchStoreService = searchStoreService
        self.storeDetailService = storeDetailService
        super.init()
        self.setAnnotations()
    }
    
    //init annotations array
    func setAnnotations() {
        annotations.removeAll()
        for (index, store) in items.enumerated() {
            if let coordinate = store.coordinate {
                annotations.append(StoreAnnotation(coordinate: coordinate, indexPath: IndexPath(row: index, section: 0), store: store))
            }
        }
    }
}


extension RestaurantViewModel: ViewModelDelegate, LoadImageService {
    
    //MARK: Query server to get store base on given location
    func searchStore(location: String?, coordinate: CLLocationCoordinate2D?, completion: @escaping ()->Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            self.searchStoreService.search(location: location, coordinate: coordinate, completion: { [weak self] (stores) in
                self?.items = stores
                self?.setAnnotations()
                completion()
            })
        }
    }
    
    //MARK: Load Store detail information from cached if exist, otherwise load from server
    func loadStoreDetail(indexPath: IndexPath, completion: @escaping (StoreDetail)->Void) {
        let store = items[indexPath.row]
        if let storeDetail = store.storeDetailCached {
            completion(storeDetail)
        }else {
            DispatchQueue.global(qos: .userInteractive).async {
                self.storeDetailService.loadStoreDetail(storeId: store.id) { [weak self] (storeDetail) in
                    self?.items[indexPath.row].storeDetailCached = storeDetail
                    completion(storeDetail)
                }
            }
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

