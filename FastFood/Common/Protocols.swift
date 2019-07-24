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

