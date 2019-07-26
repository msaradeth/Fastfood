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

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var address1Label: UILabel!
    @IBOutlet weak var address2Label: UILabel!
    @IBOutlet weak var infoImageView: UIImageView!
    
    func configure(item: Store) {
        nameLabel.text = item.name
        address1Label.text = item.location.displayAddress[0]
        address2Label.text = item.location.displayAddress[1]
    }
    
    @objc func showInfoPressed() {
        print("showInfoPressed")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Add TapGestureRecognizer to Info ImageView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showInfoPressed))
        infoImageView.addGestureRecognizer(tapGesture)
    }
}
