//
//  RestaurantsVC.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/21/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//


import UIKit

protocol SearchStoreDelegate {
    func searchStore(location: String)
}

class RestaurantVC: UIViewController {
    fileprivate var viewModel: RestaurantViewModel!
    
    //MARK: init
    init(title: String, viewModel: RestaurantViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.title = title
        self.setupVC()
    }
    //MARK:  setup VC
    func setupVC() {
        self.view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.9)
        self.view.addSubview(stackView)
        stackView.fillsuperView()
        self.tabBarItem = UITabBarItem(title: "Restaurants", image: #imageLiteral(resourceName: "RestaurantImage"), tag: 1)
    }
    
    
    //MARK:  Define Views
    lazy var stackView: UIStackView = {
        var stackView: UIStackView!
        if UIDevice.current.userInterfaceIdiom == .phone {
            stackView = UIStackView(arrangedSubviews: [storeMapView, collectionView])
            stackView.axis = .vertical
            stackView.distribution = .fillEqually
        }else {
            stackView = UIStackView(arrangedSubviews: [collectionView, storeMapView])
            stackView.axis = .horizontal
            collectionView.widthAnchor.constraint(equalToConstant: 300).isActive = true
            collectionView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        }
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    lazy var collectionView: UICollectionView = {
        let collectionView = StoreCollectionView(collectionViewdataSource: self, collectionViewDelegate: self)
        collectionView.register(UINib(nibName: "RestaurantCell", bundle: nil), forCellWithReuseIdentifier: RestaurantCell.cellIdentifier)
        return collectionView
    }()
    lazy var storeMapView: StoreMapView = {
        let customMapView = StoreMapView(delegate: self)
        return customMapView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: SearchStoreDelegate
extension RestaurantVC: SearchStoreDelegate {
    func searchStore(location: String) {
        viewModel.searchStore(location: location) { [weak self] in
            self?.collectionView.reloadData()
            self?.storeMapView.updateLocation(stores: self?.viewModel.items ?? [])
        }
    }
}


//MARK: UICollectionViewDataSource
extension RestaurantVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RestaurantCell.cellIdentifier, for: indexPath) as! RestaurantCell
        cell.configure(item: viewModel[indexPath])
        return cell
    }
}

//MARK: UICollectionViewDelegate
extension RestaurantVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(viewModel[indexPath].location.address1)
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension RestaurantVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.getCellWidth(numberOfColumns: 1)
        return CGSize(width: cellWidth, height: RestaurantCell.cellHeight)
    }
}
