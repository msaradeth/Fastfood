//
//  RestaurantsVC.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/21/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

//favoritesVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
//downloadsVC.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 1)
//historyVC.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 2)


import UIKit
import MapKit
//mapView: MKMapView!
class RestaurantVC: UIViewController {
    var viewModel: RestaurantViewModel!
    
    //MARK: init
    init(title: String, viewModel: RestaurantViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.title = title
        self.setupVC()
    }
    
    //MARK:  setup VC
    func setupVC() {
        self.view.backgroundColor = .white
        self.view.addSubview(stackView)
        stackView.fillsuperView()
        self.tabBarItem = UITabBarItem(title: "Restaurants", image: nil, tag: 1)
    }
    
    
    //MARK:  Define Views
    lazy var stackView: UIStackView = {
        var stackView: UIStackView!
        if UIDevice.current.userInterfaceIdiom == .phone {
            stackView = UIStackView(arrangedSubviews: [customMapView, collectionView])
            stackView.axis = .vertical
            stackView.distribution = .fillEqually
        }else {
            stackView = UIStackView(arrangedSubviews: [collectionView, customMapView])
            stackView.axis = .horizontal
            collectionView.widthAnchor.constraint(equalToConstant: 300).isActive = true
            collectionView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        }
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "RestaurantCell", bundle: nil), forCellWithReuseIdentifier: RestaurantCell.cellIdentifier)
        return collectionView
    }()
    lazy var customMapView: CustomMapView = {
        let customMapView = CustomMapView(frame: .zero)
        customMapView.translatesAutoresizingMaskIntoConstraints = false
        return customMapView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RestaurantVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RestaurantCell.cellIdentifier, for: indexPath) as! RestaurantCell
        cell.configure(title: viewModel[indexPath])
        return cell
    }
}



//MARK: UICollectionViewDelegateFlowLayout
extension RestaurantVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.getCellWidth(numberOfColumns: 1)
        return CGSize(width: cellWidth, height: RestaurantCell.cellHeight)
    }
}
