//
//  RestaurantView.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/28/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit
import MapKit

protocol RestaurantDelegate: NSObject {
    var currIndexPath: IndexPath {get set}
    func searchStore(location: String?, coordinate: CLLocationCoordinate2D?)
}

class RestaurantView: UIView {
    weak var viewModelDelegate: RestaurantViewModelDelegate?
    var prevIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    var currIndexPath: IndexPath = IndexPath(row: 0, section: 0) {
        willSet {
            prevIndexPath = currIndexPath
        }
        didSet {
            guard let viewModel = self.viewModelDelegate else { return }
            if self.prevIndexPath.row < viewModel.items.count {
                deSelectItem(indexPath: prevIndexPath)
            }
            if prevIndexPath != currIndexPath && currIndexPath.row < viewModel.count {
                selectItem(indexPath: self.currIndexPath)
            }
        }
    }
    var flowLayout: UICollectionViewFlowLayout?
    
    //MARK: Init
    init(frame: CGRect, viewModelDelegate: RestaurantViewModelDelegate? = nil, flowLayout: UICollectionViewFlowLayout? = nil) {
        self.viewModelDelegate = viewModelDelegate
        self.flowLayout = flowLayout
        super.init(frame: frame)
        self.addSubview(stackView)
        stackView.fillsuperView()
    }

    
    //MARK: help functions
    public func reloadViews() {
        collectionView.reloadData()
        mapView.reloadData()
    }
    
    //Deselect Resturant location
    public func deSelectItem(indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.collectionView.reloadItems(at: [indexPath])
            if let viewModel = self.viewModelDelegate {
                self.mapView.deselectAnnotation(viewModel.annotations[indexPath.row], animated: true)
            }
        }
    }
    
    //Select Resturant location
    public func selectItem(indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.collectionView.reloadItems(at: [indexPath])
            self.collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
            if let viewModel = self.viewModelDelegate {
                self.mapView.setRegion(coordinate: viewModel[indexPath].coordinate)
            }
        }
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
        }
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var collectionView: UICollectionView = {
        var collectionView: UICollectionView!
        //flowlayout
        if let flowLayout = self.flowLayout {
            collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        }else {
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.minimumInteritemSpacing = 1
            flowLayout.minimumLineSpacing = 1
            collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        }
        //collectionView
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        collectionView.widthAnchor.constraint(equalToConstant: 320).isActive = true
        collectionView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return collectionView
    }()
    
    lazy var mapView: SearchMapView = {
        let mapView = SearchMapView(restaurantDelegate: self, viewModelDelegate: viewModelDelegate)
        return mapView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension RestaurantView: RestaurantDelegate {
    
    //Search Yelp Api to get Burger King Locations using search criteria
    func searchStore(location: String?, coordinate: CLLocationCoordinate2D?) {
        viewModelDelegate?.searchStore(location: location, coordinate: coordinate) { [weak self] in
            DispatchQueue.main.async {
                //reset data and views
                self?.reloadViews()
                self?.currIndexPath = IndexPath(row: 0, section: 0)
            }
        }
    }
}
