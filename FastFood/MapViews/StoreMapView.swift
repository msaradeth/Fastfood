//
//  RestaurantMapView.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/23/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation
import MapKit

fileprivate enum ButtonIs: String {
    case cancelButton = "Cancel"
    case filterButton = "Filters"
}


class StoreMapView: MKMapView {
    fileprivate var searchButtonIs = ButtonIs.filterButton {
        didSet {
            if searchButtonIs == .filterButton {
                searchButton.setTitle(ButtonIs.filterButton.rawValue, for: .normal)
            }else {
                searchButton.setTitle(ButtonIs.cancelButton.rawValue, for: .normal)
            }
        }
    }
    var locationService = LocationService()
    fileprivate var vcDelegate: VCDelegate?
    fileprivate var viewModelDelegate: ViewModelDelegate?
    
    //MARK: init
    init(vcDelegate: VCDelegate?, viewModelDelegate: ViewModelDelegate?) {
        self.vcDelegate = vcDelegate
        self.viewModelDelegate = viewModelDelegate
        super.init(frame: .zero)
        self.showsUserLocation = true
        self.delegate = self
        self.addSubview(searchBarStackView)
        self.searchBarStackView.pinTo(view: self, top: 10, left: 10, right: 10)
        self.reloadData()
        self.locationService.locationManager.requestWhenInUseAuthorization()
    }
    
    //MARK:  reload mapview
    func reloadData() {
        guard let viewModelDelegate = self.viewModelDelegate else { return }
        self.removeAnnotations(self.annotations)
        if viewModelDelegate.annotations.count > 0 {
            self.showAnnotations(viewModelDelegate.annotations, animated: true)
            setRegion(coordinate: viewModelDelegate.annotations[0].coordinate)
        }
    }
    //MARK:  setRegion
    func setRegion(coordinate:  CLLocationCoordinate2D?) {
        if let coordinate = coordinate {
            let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
            self.setRegion(region, animated: true)
        }
    }
   
    
    //MARK: Define views
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
        searchBar.searchBarStyle = UISearchBar.Style.minimal
        searchBar.setDefaultAppearance()
        return searchBar
    }()
    lazy var searchButton: UIButton = {
        let searchButton = UIButton(type: .roundedRect)
        searchButton.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        searchButton.setTitle(ButtonIs.filterButton.rawValue, for: .normal)
        searchButton.setTitleColor(UIColor.darkOrange(), for: .normal)
        searchButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return searchButton
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: MKMapViewDelegate
extension StoreMapView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? StoreAnnotation else { return }
        //update views with indexPath
        vcDelegate?.currIndexPath = annotation.indexPath
    }
}

//MARK: UISearchBarDelegate
extension StoreMapView: UISearchBarDelegate {
    @objc func searchButtonPressed() {
        if searchButtonIs == .cancelButton {
            resetSearchBar()
        }else {
            print(ButtonIs.filterButton.rawValue)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let location = searchBar.text else { return }
        vcDelegate?.searchStore(location: location, coordinate: nil)
        resetSearchBar()
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchButtonIs = .cancelButton
        return true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resetSearchBar()
    }
    
    func resetSearchBar() {
        searchBar.endEditing(true)
        searchBar.text = ""
        searchButtonIs = .filterButton
    }
}

