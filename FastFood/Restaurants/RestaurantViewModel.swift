//
//  RestaurantViewModel.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/21/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation

class RestaurantViewModel: NSObject {
    var items: [String]
    var count: Int {
        return items.count
    }
    subscript(indexPath: IndexPath) -> String {
        return items[indexPath.row]
    }
    
    init(items: [String]) {
        self.items = items
    }
    
}
