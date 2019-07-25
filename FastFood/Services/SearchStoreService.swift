//
//  BusinessSearch.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/18/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation
import Alamofire

class SearchStoreService: NSObject {
    private struct BusinessObject: Codable {
        var stores: [Store]
        
        enum CodingKeys: String, CodingKey {
            case stores = "businesses"
        }
    }

    func search(location: String = "Irvine,CA", completion: @escaping ([Store])->Void) {
        let searchLocation = location.replacingOccurrences(of: " ", with: "")
        let urlString = Yelp.EndPoints.search + "&location=\(searchLocation)"
        
        HttpHelper.request(urlString, method: .get, success: { (response) in
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let businessObject = try decoder.decode(BusinessObject.self, from: data)
                completion(businessObject.stores)
            }catch {
                print(error.localizedDescription)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
