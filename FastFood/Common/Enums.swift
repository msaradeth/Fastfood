//
//  Enums.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/23/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation



enum YelpApi {
    static let baseURL = "https://api.yelp.com/v3/businesses/"
    static let apiKey = "mHsbP_tWAkUKvZ_Ov3MljG4tC545hbyyAQcB09y_UeqjTZUEKIplWTk5Lv53bMObakQ5rLK3kpFBcujmusipIK3wjG4sq-BfBgaxv664N7xYS546sKW7r9axFOEwXXYx"
    static let clientId = "Ziwec-rzNnC1a_OyUBr5Ng"
    static let headers = ["Authorization": "Bearer \(YelpApi.apiKey)"]
    
    enum EndPoints {
        static let search = YelpApi.baseURL + "search?term=BurgerKing&limit=30"
        static let businessDetail = YelpApi.baseURL
    }
}
