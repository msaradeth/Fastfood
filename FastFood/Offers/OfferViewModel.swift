//
//  OfferViewModel.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/22/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation

class OfferViewModel: NSObject {
    var items = [Store]()
    private var searchStoreService: SearchStoreService
    var locationService: LocationService
    var count: Int {
        return items.count
    }
    subscript(indexPath: IndexPath) -> Store {
        let index = indexPath.row - 2
        return items[index]
    }
        
    init(items: [Store], searchStoreService: SearchStoreService, locationService: LocationService) {
        locationService.locationManager.requestWhenInUseAuthorization()
        self.items = items
        self.searchStoreService = searchStoreService
        self.locationService = locationService        
    }
    
    func searchStore(term: String, completion: @escaping ()->Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            print("searchStore", self.locationService.currLocation?.coordinate)
            self.searchStoreService.search(term: term, coordinate: self.locationService.currLocation?.coordinate, completion: { [weak self] (stores) in
                self?.items = stores
                completion()
            })
        }
    }
}
