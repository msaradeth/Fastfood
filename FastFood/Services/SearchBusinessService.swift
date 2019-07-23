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


enum Yelp {
    static let baseURL = "https://api.yelp.com/v3/"
    static let apiKey = "mHsbP_tWAkUKvZ_Ov3MljG4tC545hbyyAQcB09y_UeqjTZUEKIplWTk5Lv53bMObakQ5rLK3kpFBcujmusipIK3wjG4sq-BfBgaxv664N7xYS546sKW7r9axFOEwXXYx"
    static let clientId = "Ziwec-rzNnC1a_OyUBr5Ng"
    enum EndPoints {
        static let search = Yelp.baseURL + "businesses/search?term=Burger King&location=Irvine, CA"
    }
}

class SearchBusinessService: NSObject {
    var dataTask: URLSessionDataTask?
    func loadData2() {
        guard let url = URL(string: Yelp.EndPoints.search) else { return }
        dataTask?.cancel()
        
        dataTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            }else if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                do {
                    let decoder = JSONDecoder()                                        
                }catch let error {
                    print(error.localizedDescription)
                }
            }
        })
    }
    
    func loadData() {
//        guard let url = URL(string: Yelp.EndPoints.search) else { return }
        
        let headers = [
            "Authorization": "Bearer \(Yelp.apiKey)"
        ]
//        params["location"] = "Irvine, CA"
        
        //Parameters
        var params: [String:String] = [:]
        params["location"] = "Irvine,CA"
        params["term"] = "BurgerKing"
        
        
////            "location": "Irvine"
//            "term": "Burger King",
//            "location": "Irvine, CA"
        
//        var params = [String:Any]()
//        params["term"] = "Burger King"
//        params["location"] = "Irvine, CA"
//        params["radius"] = 10000
//        params["limit"] = 20
        
//        let header = HTTPHeaders(dictionaryLiteral: <#T##(String, String)...##(String, String)#>)

//        let urlString = "https://api.yelp.com/v3/businesses/search?term=Burger&location=Irvine"
        let baseUrlString = "https://api.yelp.com/v3/businesses/search?"
//        let urlString = "https://api.yelp.com/v3/businesses/search?limit=20&location=Irvine,CA&term=BurgerKing"
        let urlString = "https://api.yelp.com/v3/businesses/search?term=BurgerKing&limit=30&location=Irvine,CA"
//        let urlString = "https://api.yelp.com/v3/businesses/search?limit=20&location=Roma&locale=it_IT&categories=indpak&term=restaurant"
        Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                print(response)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
