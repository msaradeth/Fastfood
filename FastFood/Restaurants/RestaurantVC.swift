//
//  RestaurantsVC.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/21/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//


import UIKit
import MapKit

protocol RestaurantVCDelegate {
    func updateSelectedLocation(indexPath: IndexPath)
    func searchStore(location: String)
    func orderNow(indexPath: IndexPath)
    func storeDetail(indexPath: IndexPath)
    
}

class RestaurantVC: UIViewController {
    fileprivate var viewModel: RestaurantViewModel!
    private var mTitle: String
    
    //MARK: init
    init(title: String, viewModel: RestaurantViewModel) {
        self.mTitle = title
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        self.setupVC()
        
    }
    //MARK:  setup VC
    func setupVC() {
        self.view.backgroundColor = .white
        self.view.addSubview(stackView)
        stackView.fillsuperView()
        self.tabBarItem = UITabBarItem(title: "Restaurants", image: #imageLiteral(resourceName: "locationTabBar"), tag: 1)
    }
    
    //MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UINavigationBar.setNormalTitleFont()
        self.title = mTitle
    }
    
    
    //MARK:  Define Views
    lazy var stackView: UIStackView = {
        var stackView: UIStackView!
        if UIDevice.current.userInterfaceIdiom == .phone {
            stackView = UIStackView(arrangedSubviews: [mapView, collectionView])
            stackView.axis = .vertical
            stackView.distribution = .fillEqually
        }else {
            stackView = UIStackView(arrangedSubviews: [collectionView, mapView])
            stackView.axis = .horizontal
            collectionView.widthAnchor.constraint(equalToConstant: 300).isActive = true
            collectionView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        }
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.minimumLineSpacing = 0.5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "RestaurantCell", bundle: nil), forCellWithReuseIdentifier: RestaurantCell.cellIdentifier)
        collectionView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        return collectionView
    }()
    lazy var mapView: StoreMapView = {
        let mapView = StoreMapView(delegate: self)
//         mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(BridgeAnnotation.self))
        return mapView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: UICollectionViewDataSource
extension RestaurantVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RestaurantCell.cellIdentifier, for: indexPath) as! RestaurantCell
        cell.configure(item: viewModel[indexPath], indexPath: indexPath, viewModelDelegate: viewModel, vcDelegate: self)
        return cell
    }
}

//MARK: UICollectionViewDelegate
extension RestaurantVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateSelectedLocation(indexPath: indexPath)
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
    
    //Scroll selected cell to top and update zoom in mapview on selected location
    func updateSelectedLocation(indexPath: IndexPath) {
        let previousSelectedIndexPath = viewModel.selectedIndexPath
        viewModel.selectedIndexPath = indexPath
        collectionView.reloadItems(at: [indexPath, previousSelectedIndexPath])
        collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
        mapView.updateRegion(coordinates: viewModel[indexPath].coordinates)
    }
    
    //Search new store location from query
    func searchStore(location: String) {
        viewModel.searchStore(location: location) { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                self?.mapView.updateLocation(stores: self?.viewModel.items ?? [])
                if let indexPath = self?.viewModel.selectedIndexPath, self?.viewModel.items.count ?? 0 > 0 {
                    self?.collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
                }
            }
        }
    }
    
    //Goto Store Detail screen
    func storeDetail(indexPath: IndexPath) {
        self.title = ""
        let storeDetailVC = RestaurantDetailVC(title: viewModel[indexPath].location.displayAddress[0], indexPath: indexPath, viewModel: viewModel)
        self.navigationController?.pushViewController(storeDetailVC, animated: true)
    }
    
    //Order Now Button Pressed
    func orderNow(indexPath: IndexPath) {
        let alertStyle: UIAlertController.Style = UIDevice.current.userInterfaceIdiom == .phone ? .actionSheet : .alert
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: alertStyle)
        //Alert Actions
        let driveThru = UIAlertAction(title: "Drive Thru", style: .default) { (alertAction) in
            print("Drive Thru")
        }
        let dineIn = UIAlertAction(title: "Dine In", style: .default) { (alertAction) in
            print("Dine In")
        }
        let takeOut = UIAlertAction(title: "Take Out", style: .default) { (alertAction) in
            print("Take Out")
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in
            print("Cancel")
        }
        // Add the alert actions
        alertController.addAction(driveThru)
        alertController.addAction(dineIn)
        alertController.addAction(takeOut)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
}

