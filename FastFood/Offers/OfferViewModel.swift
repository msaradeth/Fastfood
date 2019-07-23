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
    var searchStoreService: SearchStoreService
    var count: Int {
        return items.count
    }
    subscript(indexPath: IndexPath) -> Store {
        let index = indexPath.row - 2
        return items[index]
    }
    
    
    init(items: [Store], searchStoreService: SearchStoreService) {
        self.items = items
        self.searchStoreService = searchStoreService
    }
    
    func searchStore(completion: @escaping ()->Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            self.searchStoreService.search { [weak self] (stores) in
                self?.items = stores
                completion()
            }
        }
    }
}
