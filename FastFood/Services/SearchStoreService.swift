//
//  BusinessSearch.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/18/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation
import Alamofire

//let baseUrl = URL(string: "https://api.yelp.com/v3/")
//super.init(baseURL: baseUrl)
//requestSerializer.setValue("Bearer \(self.apiKey!)", forHTTPHeaderField: "Authorization")

//        let baseUrlString = "https://api.yelp.com/v3/businesses/search?"
////        let urlString = "https://api.yelp.com/v3/businesses/search?limit=20&location=Irvine,CA&term=BurgerKing"
//        let urlString = "https://api.yelp.com/v3/businesses/search?term=BurgerKing&limit=30&location=Irvine,CA"


class SearchStoreService: NSObject {
    private struct BusinessObject: Codable {
        var stores: [Store]
        
        enum CodingKeys: String, CodingKey {
            case stores = "businesses"
        }
    }
    
//    var dataTask: URLSessionDataTask?
    
    var dataTask: URLSessionDataTask?
    var dataRequest: DataRequest?
    
    func search(location: String = "Irvine,CA", completion: @escaping ([Store])->Void) {
        dataRequest?.cancel()
        let searchLocation = location.replacingOccurrences(of: " ", with: "")
        let urlString = Yelp.EndPoints.search + "&location=\(searchLocation)"
        
        dataRequest = Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Yelp.headers).responseJSON { response in
            guard let data = response.data else { return }
            
            switch response.result {
            case .success:
                do {
                    let decoder = JSONDecoder()
                    let businessObject = try decoder.decode(BusinessObject.self, from: data)
                    completion(businessObject.stores)
                }catch {
                    print(error.localizedDescription)
                }

            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
