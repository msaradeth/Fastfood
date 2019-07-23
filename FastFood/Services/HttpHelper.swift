//
//  HttpHelper.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/18/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation
import Alamofire

enum ApiResult {
    case sucess
    case error
}


final class HttpHelper: NSObject {
    static var dataRequest: DataRequest?
    
    class func request(_ url: URLConvertible, method: HTTPMethod, success: @escaping (DataResponse<Any>) -> Void, failure:@escaping (Error) -> Void) {
        HttpHelper.dataRequest?.cancel()
        
        Alamofire.request(url, method: method).responseJSON { response in
            switch response.result {
            case .success:
                success(response)
                
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
    }
    
    deinit {
        print("deinit: HttpHelp")
    }
    
    
//    public func reqeust(url: URLConvertible, method: HTTPMethod, parameters: Parameters) {
//        Alamofire.request(url, method: method, parameters: Parameters, headers: <#T##HTTPHeaders?#>)
//    }
////
//
//    class func request(_ url: URLConvertible, method: HTTPMethod, params: Parameters?, isDealerServer: Bool = false, success: @escaping (DataResponse<Any>) -> Void, failure:@escaping (Error) -> Void) {
//        let httpHelper = HttpHelp()
//        httpHelper.request(url, method: method, params: params, isDealerServer: isDealerServer, success: { (response) in
//            success(response)
//        }) { (error) in
//            failure(error)
//        }
//    }
//
//
//    func request(_ url: URLConvertible, method: HTTPMethod, params: Parameters?, isDealerServer: Bool = false, success: @escaping (DataResponse<Any>) -> Void, failure:@escaping (Error) -> Void) {
//        let headers = (isDealerServer == true) ? Constant.shared.dealerApiuserHTTPHeaders() : Constant.shared.apiuserHTTPHeaders()
//
//        Alamofire.request(url, method: method, parameters: params, headers: headers ).responseJSON { response in
//            switch response.result {
//            case .success:
//                //                let resJSON = JSON(response.result.value!)
//                //                print(resJSON)
//                success(response)
//
//            case .failure(let error):
//                failure(error)
//            }
//        }
//    }
//
    
//    
//    
//    // MARK: - Define Constants - Helper functions
//    
//    func basicAuthBase64EncodedString(userId: String, password: String) -> String {
//        let authStr = String(format: "%@:%@", userId, password)
//        let authData = authStr.data(using: .utf8)
//        let authValue: String =  String(format: "Basic %@", (authData?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)))!)
//        let basicAuthBase64EncodedString: String = authValue
//        
//        return basicAuthBase64EncodedString
//    }
//    
//    
//    //Create HTTPHeaders with user and password
//    func apiuserHTTPHeaders() -> [String:String] {
//        let headers = [
//            "Authorization": Constant.shared.basicAuthBase64EncodedString(userId: Constant.shared.apiuser, password: Constant.shared.apiuserPasswd)
//        ]
//        return headers
//    }
//    
//    func dealerApiuserHTTPHeaders() -> [String:String] {
//        let headers = [
//            "Authorization": Constant.shared.basicAuthBase64EncodedString(userId: Constant.shared.dealerApiUser, password: Constant.shared.dealerApiPasswd)
//        ]
//        return headers
//    }

}


