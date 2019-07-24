//
//  RestaurantViewModel.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/21/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation
import UIKit

protocol ViewModelDelegate {
    var selectedIndexPath: IndexPath {get set}
    func loadStoreDetail(indexPath: IndexPath, completion: @escaping (StoreDetail)->Void)
    func loadImage(indexPath: IndexPath, completion: @escaping (UIImage?)->Void)
}

class RestaurantViewModel: NSObject {
    fileprivate var searchStoreService: SearchStoreService
    fileprivate var storeDetailService: StoreDetailService
    
    var items: [Store]
    var count: Int {
        return items.count
    }
    subscript(indexPath: IndexPath) -> Store {
        return items[indexPath.row]
    }
    var selectedIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    
    //MARK: init
    init(items: [Store], searchStoreService: SearchStoreService, storeDetailService: StoreDetailService) {
        self.items = items
        self.searchStoreService = searchStoreService
        self.storeDetailService = storeDetailService
    }
}


extension RestaurantViewModel: ViewModelDelegate, LoadImageService {
    
    //MARK: Query server to get store base on given location
    func searchStore(location: String, completion: @escaping ()->Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            self.searchStoreService.search(location: location, completion: { [weak self] (stores) in
                self?.selectedIndexPath = IndexPath(item: 0, section: 0)
                self?.items = stores
                completion()
            })
        }
    }
    
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

