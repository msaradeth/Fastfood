//
//  OfferCell.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/22/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit

class OfferCell: UICollectionViewCell {
    static let cellHeight: CGFloat = 100
    static let cellIdentifier = "OfferCell"
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var address1Label: UILabel!
    @IBOutlet weak var address2Label: UILabel!
    @IBOutlet weak var infoImageView: UIImageView!
    @IBOutlet weak var foodImageView: UIImageView!
    
    var viewModelDelegate: OfferViewModelDelegate?
    var vcDelegate: OfferVCDelegate?
    var indexPath: IndexPath!
    
    func configure(item: Store, indexPath: IndexPath, vcDelegate: OfferVCDelegate?, viewModelDelegate: OfferViewModelDelegate?) {
        self.indexPath = indexPath
        self.vcDelegate = vcDelegate
        self.viewModelDelegate = viewModelDelegate
        nameLabel.text = item.name
        address1Label.text = item.location.displayAddress[0]
        address2Label.text = item.location.displayAddress[1]
        
        //set image from cache if exist, otherwise get from server
        if let image = item.imageCached {
            foodImageView.image = image
        }else {
            viewModelDelegate?.loadImage(indexPath: indexPath, completion: { [weak self] (image) in
                DispatchQueue.main.async {
                    self?.foodImageView.image = image
                }
            })
        }
    }
    
    @objc func showInfoPressed() {
        vcDelegate?.showInfo(indexPat: indexPath)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Add TapGestureRecognizer to Info ImageView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showInfoPressed))
        infoImageView.addGestureRecognizer(tapGesture)
    }
}
