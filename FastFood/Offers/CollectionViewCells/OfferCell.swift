//
//  OfferCell.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/22/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit

class OfferCell: UICollectionViewCell {
    static let cellHeight: CGFloat = 120
    static let cellIdentifier = "OfferCell"

    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(item: Store) {
        titleLabel.text = item.location.address1 
    }

}
