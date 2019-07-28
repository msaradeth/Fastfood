//
//  OrderVCViewController.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/25/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit
import MapKit


class OrderVC: MapBaseViewController {
    
    //MARK: init
    init(title: String, viewModel: MapViewModelDelegate) {
        let tabBarItem = UITabBarItem(title: "Order", image: #imageLiteral(resourceName: "OrderImage"), tag: 2)
        super.init(title: title, tabBarItem: tabBarItem)
        self.viewModel = viewModel        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.addSettingsButton()
        self.setupViews()
    }
    
    
    //MARK:  viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewModel.items.count == 0 {
            self.searchStore(location: nil, coordinate: mapView.userLocation.coordinate)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print("deinit - OrderVC")
    }
}


//MARK: UICollectionViewDataSource
extension OrderVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RestaurantCell.cellIdentifier, for: indexPath) as! RestaurantCell
        cell.configure(hideOrderButton: true, item: viewModel[indexPath], indexPath: indexPath, viewModelDelegate: viewModel, vcDelegate: self)            
        return cell
    }
}

//MARK: UICollectionViewDelegate
extension OrderVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currIndexPath = indexPath
    }
}


//MARK: UICollectionViewDelegateFlowLayout
extension OrderVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.getCellWidth(numberOfColumns: 1)
        let cellHeight = RestaurantCell.cellHeight - 35 //minus order now button height
        return CGSize(width: cellWidth, height: cellHeight)
    }
}




