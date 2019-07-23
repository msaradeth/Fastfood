//
//  ScanCanCell.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/22/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit

class ScanCanCell: UICollectionViewCell {
    static let cellHeight: CGFloat = 120
    static let cellIdentifier = "ScanCanCell"
    @IBOutlet weak var scancanImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            scancanImageView.contentMode = .scaleToFill
//        }else {
//            scancanImageView.contentMode = .scaleAspectFit            
//        }
    }

}
