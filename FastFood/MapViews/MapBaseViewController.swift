//
//  MapBaseViewController.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/26/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit
import MapKit

class MapBaseViewController: UIViewController {
    var saveTitle: String?
    var viewModel: MapViewModelDelegate!
    var locationService: LocationService
    var prevIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    var currIndexPath: IndexPath = IndexPath(row: 0, section: 0) {
        willSet {
            prevIndexPath = currIndexPath
        }
        didSet {
            DispatchQueue.main.async {
                if self.prevIndexPath.row < self.viewModel.items.count {
                    //Deselect views
                    self.collectionView.reloadItems(at: [self.prevIndexPath])
                    self.mapView.deselectAnnotation(self.viewModel.annotations[self.prevIndexPath.row], animated: true)
                }
                if self.prevIndexPath != self.currIndexPath && self.currIndexPath.row < self.viewModel.items.count {
                    //Update views
                    self.collectionView.reloadItems(at: [self.currIndexPath])
                    self.collectionView.scrollToItem(at: self.currIndexPath, at: .top, animated: true)
                    self.mapView.setRegion(coordinate: self.viewModel[self.currIndexPath].coordinate)
                }
            }
        }
    }
    
    //MARK:  init
    init(title: String, locationService: LocationService, tabBarItem: UITabBarItem? = nil) {
        self.locationService = locationService
        super.init(nibName: nil, bundle: nil)
        self.saveTitle = title
        self.navigationItem.titleView = TitleView(title: title)
        if let tabBarItem = tabBarItem {
            self.tabBarItem = tabBarItem
        }
    }
    
    //MARK:  setup VC
    func setupViews() {
        self.view.backgroundColor = .white
        self.view.addSubview(stackView)
        stackView.fillsuperView()
    }
    
    
    //MARK:  ViewController life cycles
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor.darkOrange()
        self.title = saveTitle
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.title = ""
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
            collectionView.widthAnchor.constraint(equalToConstant: 320).isActive = true
            collectionView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        }
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.minimumLineSpacing = 1
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UINib(nibName: "RestaurantCell", bundle: nil), forCellWithReuseIdentifier: RestaurantCell.cellIdentifier)
        collectionView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        return collectionView
    }()
    lazy var mapView: StoreMapView = {
        let mapView = StoreMapView(locationService: locationService, vcDelegate: self, viewModelDelegate: self.viewModel)
        return mapView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



//MARK: RestaurantVCDelegate
extension MapBaseViewController: MapViewControllerDelegate {
    
    //Search Yelp Api to get Burger King Locations using search criteria
    func searchStore(location: String?, coordinate: CLLocationCoordinate2D?) {
        viewModel.searchStore(location: location, coordinate: coordinate) { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                //reset data and views
                self.collectionView.reloadData()
                self.mapView.reloadData()
                self.currIndexPath = IndexPath(row: 0, section: 0)
            }
        }
    }
    
    //Goto Store Detail screen
    @objc func storeDetail(indexPath: IndexPath) {
        let storeDetailVC = RestaurantDetailVC(title: viewModel[indexPath].location.displayAddress[0], indexPath: indexPath, viewModel: viewModel)
        self.navigationController?.pushViewController(storeDetailVC, animated: true)
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
