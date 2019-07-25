//
//  Store.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/25/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit


struct Store: Codable {
    var id: String
    var name: String
    var imageUrlString: String
    var isClose: Bool
    var transactions: [String]
    var coordinates: Coordinates
    var location: Location
    var imageCached: UIImage?
    var storeDetailCached: StoreDetail?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageUrlString = "image_url"
        case isClose = "is_closed"
        case transactions
        case coordinates
        case location
    }
}

struct Coordinates: Codable {
    var latitude: Double
    var longitude: Double
}

struct Location: Codable {
    var address1: String
    var address2: String
    var city: String
    var zip: String
    var state: String
    var displayAddress: [String]
    var phone: String?
    var displayPhone: String?
    var distance: Double?
    
    enum CodingKeys: String, CodingKey {
        case address1
        case address2
        case city
        case zip = "zip_code"
        case state
        case displayAddress = "display_address"
        case phone
        case displayPhone = "display_phone"
        case distance
    }
}

struct region: Codable {
    struct center: Codable {
        var longitude: Double
        var latitude: Double
    }
}

