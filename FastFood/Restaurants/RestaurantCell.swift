//
//  RestaurantCell.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/22/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit

class RestaurantCell: UICollectionViewCell {
    static let cellHeight: CGFloat = 140
    static let cellIdentifier = "RestaurantCell"
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var address1: UILabel!
    @IBOutlet weak var address2: UILabel!
    @IBOutlet weak var restaurantHours: UILabel!
    @IBOutlet weak var restaurantServiceImage: UIImageView!
    
    @IBOutlet weak var orderNowButton: UIButton!
    func configure(item: Store) {
        address1.text = item.location.displayAddress[0]
        address2.text = item.location.displayAddress[1] + "  (\(item.location.distance ?? 0.0) mi)"
        restaurantHours.text = item.isClose ? "Closed" : "Open"
//        restaurantServiceImage.image = item.imageUrlString
    }

    @IBAction func orderNowButtonAction(_ sender: Any) {
    }
}
