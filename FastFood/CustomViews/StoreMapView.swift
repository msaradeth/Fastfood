//
//  RestaurantMapView.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/23/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation
import MapKit


class StoreMapView: MKMapView {
    fileprivate enum ButtonIs: String {
        case cancelButton = "Cancel"
        case filterButton = "Filters"
    }
    fileprivate var searchButtonIs = ButtonIs.filterButton {
        didSet {
            if searchButtonIs == .filterButton {
                searchButton.setTitle(ButtonIs.filterButton.rawValue, for: .normal)
            }else {
                searchButton.setTitle(ButtonIs.cancelButton.rawValue, for: .normal)
            }
        }
    }
    var selectedCoordinate:  CLLocationCoordinate2D? {
        didSet {
            if let coordinate = selectedCoordinate {
                let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15))
                self.setRegion(region, animated: true)
            }
        }
    }
    fileprivate var searchStoreDelegate: StoreDelegate?
    
    //MARK: init
    init(delegate: StoreDelegate?) {
        self.searchStoreDelegate = delegate
        super.init(frame: .zero)
        self.addSubview(searchBarStackView)
        searchBarStackView.pinTo(view: self, top: 10, left: 10, right: 10)
    }

    func updateLocation(stores: [Store]) {
        for (index, store) in stores.enumerated() {
            let coordinate = CLLocationCoordinate2D(latitude: store.coordinates.latitude, longitude: store.coordinates.longitude)
            let annotation = StoreAnnotation(coordinate: coordinate, title: String(index), subtitle: store.location.address1, storeNumber: index)
            self.addAnnotation(annotation)
            
            if index == 0 {
                self.selectedCoordinate = coordinate
            }
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


extension StoreMapView: MKMapViewDelegate {
    override func view(for annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "Annotation"
        
//        if let annotationView = self.dequeueReusableAnnotationView(withIdentifier: identifier) {
//            annotationView.annotation = annotation
//            return annotationView
//        }else {
//            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            annotationView.canShowCallout = true
//            return annotationView
//        }
        
        var annotationView = self.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
//        annotationView?.displayPriority = .required
        annotationView?.image = #imageLiteral(resourceName: "RestaurantImage")
        return annotationView
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
        searchStoreDelegate?.searchStore(location: location)
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

