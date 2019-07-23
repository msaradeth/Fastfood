//
//  MonthlyDealCell.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/22/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit

class MonthlyDealCell: UICollectionViewCell {
    static let cellHeight: CGFloat = 150
    static let cellIdentifier = "MonthlyDealCell"
    @IBOutlet weak var monthDealImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            monthDealImageView.contentMode = .scaleToFill
//        }else {
//            monthDealImageView.contentMode = .scaleAspectFit
//        }
    }

}
