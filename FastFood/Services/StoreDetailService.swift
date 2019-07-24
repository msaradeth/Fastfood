//
//  StoreDetailService.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/24/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

//https://api.yelp.com/v3/businesses/zbTHFC7Sf7FajB5mx8IPRA
import Foundation
import Alamofire


class StoreDetailService: NSObject {
//    private struct BusinessDetalObject: Codable {
//        var stores: [Store]
//
//        enum CodingKeys: String, CodingKey {
//            case stores = "businesses"
//        }
//    }
    
    //    var dataTask: URLSessionDataTask?
    
    var dataTask: URLSessionDataTask?
    var dataRequest: DataRequest?
    
    func loadStoreDetail(storeId: String, completion: @escaping (StoreDetail)->Void) {
        dataRequest?.cancel()
        let urlString = Yelp.EndPoints.businessDetail + storeId
        dataRequest = Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Yelp.headers).responseJSON { response in
            guard let data = response.data else { return }
            
            switch response.result {
            case .success:
                do {
                    let decoder = JSONDecoder()
                    let storeDetail = try decoder.decode(StoreDetail.self, from: data)
                    completion(storeDetail)
                }catch {
                    print(error.localizedDescription)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
