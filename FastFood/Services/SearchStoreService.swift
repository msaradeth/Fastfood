//
//  BusinessSearch.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/18/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation
import Alamofire
import MapKit

class SearchStoreService: NSObject {
    private struct BusinessObject: Codable {
        var stores: [Store]
        
        enum CodingKeys: String, CodingKey {
            case stores = "businesses"
        }
    }

    func search(location: String = "Irvine,CA", completion: @escaping ([Store])->Void) {
        let searchLocation = location.replacingOccurrences(of: " ", with: "")
        let urlString = YelpApi.EndPoints.search + "&location=\(searchLocation)"
        
        HttpHelper.request(urlString, method: .get, success: { (response) in
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                var businessObject = try decoder.decode(BusinessObject.self, from: data)
                for index in 0..<businessObject.stores.count {
                    let coordinates = businessObject.stores[index].coordinates
                    businessObject.stores[index].coordinate = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
                }
                completion(businessObject.stores)
            }catch {
                print(error.localizedDescription)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
