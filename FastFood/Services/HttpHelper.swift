//
//  HttpHelper.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/18/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation
import Alamofire


final class HttpHelper: NSObject {
    static var dataRequest: DataRequest?
    
    class func request(_ urlString: URLConvertible, method: HTTPMethod, success: @escaping (DataResponse<Any>) -> Void, failure:@escaping (Error) -> Void) {
        
        HttpHelper.dataRequest?.cancel()
        HttpHelper.dataRequest = Alamofire.request(urlString, method: method, encoding: JSONEncoding.default, headers: YelpApi.headers).responseJSON { response in
            switch response.result {
            case .success:
                success(response)
                
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    deinit {
        print("deinit: HttpHelp")
    }
    
}


