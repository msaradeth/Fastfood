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
    @IBOutlet weak var locationNumber: UILabel!
    @IBOutlet weak var rightArrowImage: UIImageView!
    @IBOutlet weak var imageFromServer: UIImageView!
    
    var indexPath: IndexPath?
    var viewModelDelegate: ViewModelDelegate?
    var vcDelegate: VCDelegate?
    var hideOrderButton: Bool = false {
        willSet {
            if newValue != hideOrderButton && orderNowButton != nil {
                orderNowButton.isHidden = newValue
            }
        }
    }
    
    func configure(hideOrderButton: Bool = false, item: Store, indexPath: IndexPath, viewModelDelegate: ViewModelDelegate?, vcDelegate: VCDelegate?) {
        self.hideOrderButton = hideOrderButton
        self.indexPath = indexPath
        self.viewModelDelegate = viewModelDelegate
        self.vcDelegate = vcDelegate
        
        //set image from cache if exist, otherwise get from server
        if let image = item.imageCached {
            imageFromServer.image = image
        }else {
            viewModelDelegate?.loadImage(indexPath: indexPath, completion: { [weak self] (image) in
                DispatchQueue.main.async {
                    self?.imageFromServer.image = image
                }
            })
        }
        
        //update data
        updateData(item: item, indexPath: indexPath)
        
    }
    
    func updateData(item: Store, indexPath: IndexPath) {
        address1.text = item.location.displayAddress[0]
        address2.text = "\(item.location.displayAddress[1])  (\(item.location.distance ?? 0.0) mi)"
        restaurantHours.text = item.isClose ? "Closed" : "Open"
        locationNumber.text = String(indexPath.row)
        
        //update selected location RED
        if vcDelegate != nil && vcDelegate!.currIndexPath == indexPath {
            thumbnailImage.image = #imageLiteral(resourceName: "selectedLocation")
            locationNumber.textColor = .white
        }else {
            thumbnailImage.image = #imageLiteral(resourceName: "location")
            locationNumber.textColor = .darkGray
        }
    }

    @IBAction func orderNowButtonAction(_ sender: Any) {
        if let indexPath = self.indexPath {
            vcDelegate?.orderNow(indexPath: indexPath)
        }
    }
    
    @objc func rightArrowPressed() {
        if let indexPath = self.indexPath {
            vcDelegate?.storeDetail(indexPath: indexPath)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Add UITapGestureRecognizer to right arrow to go to detail screen
        let tapGestureRecognize = UITapGestureRecognizer(target: self, action: #selector(rightArrowPressed))
        rightArrowImage.addGestureRecognizer(tapGestureRecognize)
        
        //update button color
        orderNowButton.backgroundColor = UIColor.darkRed()
        imageFromServer.rounded()
    }
}
