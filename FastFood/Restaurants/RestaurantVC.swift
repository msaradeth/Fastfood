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
    var isSearching: Bool = false {
        didSet {
            if isSearching {
                searchBar.setValue("Cancel", forKey: "cancelButtonText")
            }else {
                searchBar.setValue("Filters", forKey: "cancelButtonText")
            }
        }
    }
    
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
        self.isSearching = false
    
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
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .yellow
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "RestaurantCell", bundle: nil), forCellWithReuseIdentifier: RestaurantCell.cellIdentifier)
        return collectionView
    }()
    lazy var mapView: MKMapView = {
        let mapView = MKMapView(frame: .zero)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.addSubview(searchBar)
        searchBar.pinTo(view: mapView, top: 10, left: 10, right: 10)
        return mapView
    }()
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        searchBar.delegate = self
        searchBar.placeholder = "Enter city, state, or zip"
        searchBar.barStyle = UIBarStyle.black
        searchBar.searchBarStyle = UISearchBar.Style.minimal
        searchBar.showsCancelButton = false
        searchBar.setValue("Filters", forKey: "cancelButtonText")
        
//        searchBar.tintColor = .blue
        return searchBar
    }()
    lazy var cancelFilterButton: UIButton = {
        let cancelFilterButton = UIButton(type: .roundedRect)
        cancelFilterButton.addTarget(self, action: #selector(cancelFilterButtonPressed), for: .touchUpInside)
        cancelFilterButton.setTitle("Filters", for: .normal)
        return cancelFilterButton
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


//MARK: UISearchBarDelegate - search for movies
extension RestaurantVC: UISearchBarDelegate {
    @objc func cancelFilterButtonPressed() {
    
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        resetSearchBar()
        //        viewModel.search(query: query) { [weak self] in
        //            DispatchQueue.main.async {
        //                self?.collectionView.reloadData()
        //            }
        //        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let query = searchBar.text else { return }
        //        viewModel.search(query: query) { [weak self] in
        //            DispatchQueue.main.async {
        //                self?.collectionView.reloadData()
        //            }
        //        }
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
//        searchBar.showsCancelButton = true
        return true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resetSearchBar()
//        if isSearching {
//            print("Cancel")
//        }else {
//            print("Filter")
//        }
    }
    func resetSearchBar() {
        searchBar.endEditing(true)
//        isSearching = false
        searchBar.setValue("Filters", forKey: "cancelButtonText")
//        searchBar.showsCancelButton = false
    }
}

