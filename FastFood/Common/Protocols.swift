//
//  Protocols.swift
//  TheMovie
//
//  Created by Mike Saradeth on 6/15/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation
import UIKit


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


protocol StoreDelegate {
    func updateSelectedLocation(indexPath: IndexPath)
    func searchStore(location: String)
    func orderNow(indexPath: IndexPath)
    func storeDetail(indexPath: IndexPath)
}

protocol ViewModelDelegate {
    var selectedIndexPath: IndexPath {get set}
    func loadStoreDetail(indexPath: IndexPath, completion: @escaping (StoreDetail)->Void)
    func loadImage(indexPath: IndexPath, completion: @escaping (UIImage?)->Void)
}
