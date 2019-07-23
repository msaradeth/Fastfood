//
//  RestaurantCell.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/22/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit

class RestaurantCell: UICollectionViewCell {
    static let cellHeight: CGFloat = 120
    static let cellIdentifier = "RestaurantCell"
    @IBOutlet weak var titleLabel: UILabel!
        
    func configure(item: Store) {
        titleLabel.text = item.location.address1 + " " + item.location.city  + " " + item.location.state
    }

}
