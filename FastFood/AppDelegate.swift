//
//  AppDelegate.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/17/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var locationService = LocationService()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //startUpdatingLocation
        locationService.locationManager.startUpdatingLocation()
        
        //offerVC
        let offerViewModel = OfferViewModel(items: [], searchStoreService: SearchStoreService(), locationService: locationService)
        let offerVC = UINavigationController(rootViewController: OfferVC(title: "Burger King", viewModel: offerViewModel))
        
        //Restaurant VC
        let restaurantViewModel = RestaurantViewModel(items: [], searchStoreService: SearchStoreService(), storeDetailService: StoreDetailService(), locationService: locationService)
        let restaurantVC = UINavigationController(rootViewController: RestaurantVC(title: "Find Restaurants", viewModel: restaurantViewModel))
        
        //Order VC
        let orderViewModel = RestaurantViewModel(items: [], searchStoreService: SearchStoreService(), storeDetailService: StoreDetailService(), locationService: locationService)
        let orderVC = UINavigationController(rootViewController: OrderVC(title: "Order", viewModel: orderViewModel))
        
        //TabBarController
        let viewControllers = [offerVC, restaurantVC, orderVC]
        let tabBarController = TabBarController(viewControllers: viewControllers)
        
        //Window
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = tabBarController   
        
        return true
    }
    
}

