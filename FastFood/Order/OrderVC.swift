//
//  OrderVCViewController.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/25/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit



import UIKit
import MapKit


class OrderVC: UIViewController {
    fileprivate var viewModel: RestaurantViewModel!
    var prevIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    var currIndexPath: IndexPath = IndexPath(row: 0, section: 0) {
        willSet {
            prevIndexPath = currIndexPath
        }
        didSet {
            DispatchQueue.main.async {
                if self.prevIndexPath.row < self.viewModel.items.count {
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
    
    //MARK: init
    init(title: String, viewModel: RestaurantViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.titleView = TitleView(title: title)
        self.tabBarItem = UITabBarItem(title: "Order", image: #imageLiteral(resourceName: "OrderImage"), tag: 2)
        self.setupViews()
        self.addSettingsButton()      
    }
    //MARK:  setup VC
    private func setupViews() {
        self.view.backgroundColor = .white
        self.view.addSubview(stackView)
        stackView.fillsuperView()
    }
        
    //MARK:  viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.items.removeAll()
        collectionView.reloadData()
        mapView.removeAnnotations(mapView.annotations)
        self.searchStore(location: nil, coordinate: mapView.locationService.currLocation?.coordinate)
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
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "RestaurantCell", bundle: nil), forCellWithReuseIdentifier: RestaurantCell.cellIdentifier)
        collectionView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        return collectionView
    }()
    lazy var mapView: StoreMapView = {
        let mapView = StoreMapView(vcDelegate: self, viewModelDelegate: self.viewModel)
        return mapView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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




//MARK: RestaurantVCDelegate
extension OrderVC: VCDelegate {
    
    //Search new store location from search text
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
    func storeDetail(indexPath: IndexPath) {
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


