//
//  OfferViewModel.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/22/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation

class OfferViewModel: NSObject {
    var items = [String]()
    var searchBusinessService: SearchBusinessService
    var count: Int {
        return items.count
    }
    subscript(indexPath: IndexPath) -> String {
        return items[indexPath.row]
    }
    
    
    init(items: [String], searchBusinessService: SearchBusinessService) {
        self.items = items
        self.searchBusinessService = searchBusinessService
    }
    
    func loadData() {

    }
}
