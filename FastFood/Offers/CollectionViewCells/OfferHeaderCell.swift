//
//  OfferHeaderCell.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/27/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit

class OfferHeaderCell: UICollectionReusableView {
    static let cellIdentifier = "OfferHeaderCell"
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scanCanImageView: UIImageView!
    @IBOutlet weak var subscribeImageView: UIImageView!
    
    weak var delegate: OfferVCDelegate?
    
    //Configure cell
    func configure(delegate: OfferVCDelegate?) {
        self.delegate = delegate
        stackView.axis = UIDevice.current.userInterfaceIdiom == .phone ? .vertical : .horizontal
        
        //Add tap gesture to imageviews
        let scanCanTapGesture = UITapGestureRecognizer(target: self, action: #selector(scanButtonPressed))
        scanCanImageView.addGestureRecognizer(scanCanTapGesture)
        
        let subscribeTabGesture = UITapGestureRecognizer(target: self, action: #selector(subscribeButtonPressed))
        subscribeImageView.addGestureRecognizer(subscribeTabGesture)
                
    }
    
    
    //Buttion Actions
    @objc func scanButtonPressed() {
        delegate?.scanButtonPressed()
    }
    
    @objc func subscribeButtonPressed() {
        delegate?.paymentMethod()
    }
    
    @objc func subscriptionInfoButtonPressed() {
        delegate?.subscriptionInfoButtonPressed()
    }
    

}
