//
//  Constant.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/18/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation

final class Constant: NSObject {
    
    // MARK: - Shared Instance
    @objc static let shared: Constant = {
        let instance = Constant()
        // setup code
        return instance
    }()
    
    // MARK: - Initialization Method
    override init() {
        super.init()
        
        //        initBluetoothUtility()
    }
    
    
    

    // MARK: - Define Constants - Helper functions
    
    func basicAuthBase64EncodedString(userId: String, password: String) -> String {
        let authStr = String(format: "%@:%@", userId, password)
        let authData = authStr.data(using: .utf8)
        let authValue: String =  String(format: "Basic %@", (authData?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)))!)
        let basicAuthBase64EncodedString: String = authValue
        
        return basicAuthBase64EncodedString
    }
    
    
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
