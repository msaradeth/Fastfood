//
//  SearchCell.swift
//  FastFood
//
//  Created by Mike Saradeth on 8/6/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit

class SearchCell: UICollectionViewCell {
    static let cellHeight: CGFloat = 140
    static let cellIdentifier = "SearchCell"
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
    weak var viewModelDelegate: RestaurantViewModelDelegate?
    weak var vcDelegate: RestaurantVCDelegate?
    var hideOrderButton: Bool = false {
        willSet {
            if newValue != hideOrderButton && orderNowButton != nil {
                orderNowButton.isHidden = newValue
            }
        }
    }
    
    
    func configure(indexPath: IndexPath, item: Store) {
//        guard let viewModelDelegate = viewModelDelegate else { return }
//        let item = viewModelDelegate[indexPath]
        
//        self.hideOrderButton = viewModelDelegate.hideOrderButton
        self.indexPath = indexPath
        updateData(item: item, indexPath: indexPath)
//        self.viewModelDelegate = viewModelDelegate
//        self.vcDelegate = vcDelegate
        
        //set image from cache if exist, otherwise get from server
//        if let image = item.imageCached {
//            imageFromServer.image = image
//        }else {
//            viewModelDelegate.loadImage(indexPath: indexPath, completion: { [weak self] (image) in
//                DispatchQueue.main.async {
//                    self?.imageFromServer.image = image
//                }
//            })
//        }
        
        //update data
//        updateData(item: item, indexPath: indexPath, currIndexPath: currIndexPath)
        
    }
    
    func updateData(item: Store, indexPath: IndexPath) {
        address1.text = item.location.displayAddress.count >= 1 ? item.location.displayAddress[0] : ""
        address2.text = item.location.displayAddress.count >= 2 ? "\(item.location.displayAddress[1])  (\(item.location.distance ?? 0.0) mi)" : ""
        restaurantHours.text = item.isClose ? "Closed" : "Open"
        locationNumber.text = String(indexPath.row)
        
//        thumbnailImage.image = #imageLiteral(resourceName: "location")
//        locationNumber.textColor = .darkGray
        
//        //update selected location RED
//        if indexPath == currIndexPath {
//            thumbnailImage.image = #imageLiteral(resourceName: "selectedLocation")
//            locationNumber.textColor = .white
//        }else {
//            thumbnailImage.image = #imageLiteral(resourceName: "location")
//            locationNumber.textColor = .darkGray
//        }
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
//        imageFromServer.rounded()
    }
}
