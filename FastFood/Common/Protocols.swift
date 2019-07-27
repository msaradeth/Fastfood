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
        DispatchQueue.global(qos: .userInteractive).async {
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


protocol MapViewControllerDelegate {
    //Define variables
    var prevIndexPath: IndexPath {get set}
    var currIndexPath: IndexPath {get set}
    
    //Define function
    func searchStore(location: String?, coordinate: CLLocationCoordinate2D?)
    func orderNow(indexPath: IndexPath)
    func storeDetail(indexPath: IndexPath)
}



protocol MapViewModelDelegate {
    //Define variables
    var locationService: LocationService {get set}
    var items: [Store] {get set}
    var count: Int {get}
    subscript(indexPath: IndexPath) -> Store {get}
    var annotations: [StoreAnnotation] {get set}
    
    //Define function
    func searchStore(location: String?, coordinate: CLLocationCoordinate2D?, completion: @escaping ()->Void)
    func loadStoreDetail(indexPath: IndexPath, completion: @escaping (StoreDetail)->Void)
    func loadImage(indexPath: IndexPath, completion: @escaping (UIImage?)->Void)
}




