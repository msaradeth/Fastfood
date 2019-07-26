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

enum YelpApi {
    static let baseURL = "https://api.yelp.com/v3/businesses/"
    static let apiKey = "mHsbP_tWAkUKvZ_Ov3MljG4tC545hbyyAQcB09y_UeqjTZUEKIplWTk5Lv53bMObakQ5rLK3kpFBcujmusipIK3wjG4sq-BfBgaxv664N7xYS546sKW7r9axFOEwXXYx"
    static let clientId = "Ziwec-rzNnC1a_OyUBr5Ng"
    static let headers = ["Authorization": "Bearer \(YelpApi.apiKey)"]
    
    enum EndPoints {
        static let search = YelpApi.baseURL + "search?"
        static let businessDetail = YelpApi.baseURL
    }
}



class SearchStoreService: NSObject {
    private struct BusinessObject: Codable {
        var stores: [Store]
        
        enum CodingKeys: String, CodingKey {
            case stores = "businesses"
        }
    }

    func search(term: String = "BurgerKing", location: String? = nil, coordinate: CLLocationCoordinate2D? = nil, completion: @escaping ([Store])->Void) {
        if location == nil && coordinate == nil { return }
        
        var urlString = YelpApi.EndPoints.search + "term=\(term)&limit=30"
        if let location = location {
            let searchLocation = location.replacingOccurrences(of: " ", with: "")
            urlString = urlString + "&location=\(searchLocation)"
        }
        if let coordinate = coordinate {
            urlString = urlString + "&latitude=\(coordinate.latitude)" + "&longitude=\(coordinate.longitude)"
        }
        
        HttpHelper.request(urlString, method: .get, success: { (response) in
            guard let data = response.data else { return }            
            do {
                let decoder = JSONDecoder()
                var businessObject = try decoder.decode(BusinessObject.self, from: data)
                for index in 0..<businessObject.stores.count {
                    let coordinates = businessObject.stores[index].coordinates
                    businessObject.stores[index].coordinate = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
                }
                print(businessObject.stores)
                completion(businessObject.stores)
            }catch {
                print(error.localizedDescription)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
