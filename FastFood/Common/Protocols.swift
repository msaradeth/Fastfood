//
//  Protocols.swift
//  TheMovie
//
//  Created by Mike Saradeth on 6/15/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation
import UIKit
import MapKit


protocol LoadImageService {
    func loadImage(imageUrl: String?, completion: @escaping (UIImage?) -> Void)
}
extension LoadImageService {
    func loadImage(imageUrl: String?, completion: @escaping (UIImage?) -> Void) {
        guard let imageUrlString = imageUrl, let url = URL(string: imageUrlString) else { return }
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let data = try Data(contentsOf: url)
                let image = UIImage(data: data)
                completion(image)
            }catch {
                print(error.localizedDescription)
            }
        }
    }
}



protocol RestaurantVCDelegate: NSObject {
    //Define function
    func orderNow(indexPath: IndexPath)
    func storeDetail(indexPath: IndexPath)
}


protocol RestaurantViewModelDelegate: NSObject {
    //Define variables
    var locationService: LocationService {get set}    
    var items: [Store] {get set}
    var count: Int {get}
    var hideOrderButton: Bool {get set}
    var annotations: [StoreAnnotation] {get set}
    subscript(indexPath: IndexPath) -> Store {get}
    
    //Define function
    func searchStore(location: String?, coordinate: CLLocationCoordinate2D?, completion: @escaping ()->Void)
    func loadImage(indexPath: IndexPath, completion: @escaping (UIImage?)->Void)
}




