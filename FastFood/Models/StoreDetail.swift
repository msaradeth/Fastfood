//
//  StoreDetail.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/25/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation


struct Hours: Codable {
    var open: [Open]
}

struct Open: Codable {
    var start: String
    var end: String
    var day: Int
}

struct StoreDetail: Codable {
    var id: String
    var name: String
    var location: Location
    var coordinates: Coordinates
    var photos: [String]
    var hours: [Hours]?
    
}
