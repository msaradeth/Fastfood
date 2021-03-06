//
//  StoreDetailService.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/24/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation
import Alamofire


class StoreDetailService: NSObject {
    func loadStoreDetail(storeId: String, completion: @escaping (StoreDetail)->Void) {
        let urlString = YelpApi.EndPoints.businessDetail + storeId        
        HttpHelper.request(urlString, method: .get, success: { (response) in
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let storeDetail = try decoder.decode(StoreDetail.self, from: data)
                completion(storeDetail)
            }catch {
                print(error.localizedDescription)
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
