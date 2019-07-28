//
//  TestVC.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/28/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//


import UIKit
import MapKit

class TestVC: BaseViewController {
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
        super.init(title: title)
        self.viewModel = viewModel
        self.view.addSubview(restaurantView)
        restaurantView.fillsuperView()
        
        //Load data base on current location
        DispatchQueue.global().async {
            self.searchStore(location: nil, coordinate: self.restaurantView.mapView.userLocation.coordinate)
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
        print("deinit - TestVC")
    }
}



//MARK: UICollectionViewDataSource
extension TestVC: UICollectionViewDataSource {
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
extension TestVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        restaurantView.currIndexPath = indexPath
    }
}


//MARK: UICollectionViewDelegateFlowLayout
extension TestVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.getCellWidth(numberOfColumns: 1)
        return CGSize(width: cellWidth, height: RestaurantCell.cellHeight)
    }
}






//MARK: RestaurantVCDelegate
extension TestVC: RestaurantVCDelegate {
    
    //Goto Store Detail screen
    @objc func storeDetail(indexPath: IndexPath) {
        print("TestVC - storeDetail")
//        let testVC = TestVC(title: "TestVCs", viewModel: self.viewModel)
//        self.navigationController?.pushViewController(testVC, animated: true)
    }
    
    //Order Now Button Pressed
    @objc func orderNow(indexPath: IndexPath) {
        let alertStyle: UIAlertController.Style = UIDevice.current.userInterfaceIdiom == .phone ? .actionSheet : .alert
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: alertStyle)
        //Alert Actions
        let driveThru = UIAlertAction(title: "Drive Thru", style: .default, handler: nil)
        let dineIn = UIAlertAction(title: "Dine In", style: .default)
        let takeOut = UIAlertAction(title: "Take Out", style: .default)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        // Add the alert actions
        alertController.addAction(driveThru)
        alertController.addAction(dineIn)
        alertController.addAction(takeOut)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
}
