//
//   RestaurantVC.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/21/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit
import MapKit


class RestaurantVC: BaseViewController {
    //MARK:  Define Views
    lazy var restaurantView: RestaurantView = {
        let restaurantView = RestaurantView(frame: .zero, viewModelDelegate: viewModel)
        restaurantView.translatesAutoresizingMaskIntoConstraints = false
        restaurantView.collectionView.dataSource = self
        restaurantView.collectionView.delegate = self
        restaurantView.collectionView.register(UINib(nibName: "RestaurantCell", bundle: nil), forCellWithReuseIdentifier: RestaurantCell.cellIdentifier)
        return restaurantView
    }()
    
    var viewModel: RestaurantViewModel!
    
    //MARK: init
    init(title: String, viewModel: RestaurantViewModel) {
        let tabBarItem = UITabBarItem(title: "Restaurants", image: #imageLiteral(resourceName: "locationTabBar"), tag: 1)
        super.init(title: title, tabBarItem: tabBarItem, showSettings: true)
        self.viewModel = viewModel
        self.view.addSubview(restaurantView)
        restaurantView.fillsuperView()
    }
    
    //MARK:  viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Load data base on current location
        if viewModel.count == 0 {
            self.searchStore(location: nil, coordinate: restaurantView.mapView.userLocation.coordinate)
        }
    }
    
    //Search Yelp Api to get Burger King Locations using search criteria
    func searchStore(location: String?, coordinate: CLLocationCoordinate2D?) {
        viewModel.searchStore(location: location, coordinate: coordinate) { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                //reset data and views
                self.restaurantView.reloadViews()
                self.restaurantView.currIndexPath = IndexPath(row: 0, section: 0)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print("deinit - RestaurantVC")
    }
}


//MARK: UICollectionViewDataSource
extension RestaurantVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RestaurantCell.cellIdentifier, for: indexPath) as! RestaurantCell
        
        cell.configure(indexPath: indexPath, currIndexPath: restaurantView.currIndexPath, viewModelDelegate: viewModel, vcDelegate: self)
        return cell
    }
}

//MARK: UICollectionViewDelegate
extension RestaurantVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        restaurantView.currIndexPath = indexPath
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension RestaurantVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.getCellWidth(numberOfColumns: 1)
        return CGSize(width: cellWidth, height: RestaurantCell.cellHeight)
    }
}


//MARK: RestaurantVCDelegate
extension RestaurantVC: RestaurantVCDelegate {
    
    //Goto Store Detail screen
    func storeDetail(indexPath: IndexPath) {
        print("RestaurantVC - storeDetail")
    }
    
    //Order Now Button Pressed
    func orderNow(indexPath: IndexPath) {
        self.showOrderNow(indexPath: indexPath)
    }
}

