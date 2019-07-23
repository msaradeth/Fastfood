//
//  RestaurantMapView.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/23/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation
import MapKit

class CustomMapView: UIView {
    fileprivate enum ButtonIs: String {
        case cancelButton = "Cancel"
        case filterButton = "Filters"
    }
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView(frame: .zero)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.addSubview(searchBarStackView)
        searchBarStackView.pinTo(view: mapView, top: 10, left: 10, right: 10)
        return mapView
    }()
    lazy var searchBarStackView: UIStackView = {
        let searchBarStackView = UIStackView(arrangedSubviews: [searchBar, searchButton])
        searchBarStackView.translatesAutoresizingMaskIntoConstraints = false
        searchBarStackView.axis = .horizontal
        return searchBarStackView
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
        return searchBar
    }()
    
    lazy var searchButton: UIButton = {
        let searchButton = UIButton(type: .roundedRect)
        searchButton.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        searchButton.setTitle(ButtonIs.filterButton.rawValue, for: .normal)
        searchButton.setTitleColor(.blue, for: .normal)
        return searchButton
    }()
    
    fileprivate var searchButtonIs = ButtonIs.filterButton {
        didSet {
            if searchButtonIs == .filterButton {
                searchButton.setTitle(ButtonIs.filterButton.rawValue, for: .normal)
                searchButton.setTitleColor(.blue, for: .normal)
            }else {
                searchButton.setTitle(ButtonIs.cancelButton.rawValue, for: .normal)
                searchButton.setTitleColor(.red, for: .normal)
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(mapView)
        mapView.fillsuperView()        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


//MARK: UISearchBarDelegate - search for movies
extension CustomMapView: UISearchBarDelegate {
    @objc func searchButtonPressed() {
        print("cancelFilterButtonPressed")
        if searchButtonIs == .cancelButton {
            resetSearchBar()
        }else {
            print(ButtonIs.filterButton.rawValue)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        print("searchBarSearchButtonClicked")
        resetSearchBar()
        //        viewModel.search(query: query) { [weak self] in
        //            DispatchQueue.main.async {
        //                self?.collectionView.reloadData()
        //            }
        //        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let query = searchBar.text else { return }
        print("textDidChange: ", query)
        //        viewModel.search(query: query) { [weak self] in
        //            DispatchQueue.main.async {
        //                self?.collectionView.reloadData()
        //            }
        //        }
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchButtonIs = .cancelButton
        print("searchBarShouldBeginEditing: ")
        return true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarCancelButtonClicked: ")
        resetSearchBar()
    }
    func resetSearchBar() {
        searchBar.endEditing(true)
        searchBar.text = ""
        searchButtonIs = .filterButton
    }
}

