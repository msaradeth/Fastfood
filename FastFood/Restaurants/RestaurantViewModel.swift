//
//  RestaurantViewModel.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/21/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation

class RestaurantViewModel: NSObject {
    var items: [Store]
    var searchStoreService: SearchStoreService
    var count: Int {
        return items.count
    }
    subscript(indexPath: IndexPath) -> Store {
        return items[indexPath.row]
    }
    
    init(items: [Store], searchStoreService: SearchStoreService) {
        self.items = items
        self.searchStoreService = searchStoreService
    }
    
    func searchStore(location: String, completion: @escaping ()->Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            self.searchStoreService.search(location: location, completion: { [weak self] (stores) in
                self?.items = stores
                completion()
            })
        }
    }
}
