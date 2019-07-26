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
    fileprivate var vcDelegate: VCDelegate?
    fileprivate var viewModelDelegate: ViewModelDelegate?
    
    //MARK: init
    init(vcDelegate: VCDelegate?, viewModelDelegate: ViewModelDelegate?) {
        self.vcDelegate = vcDelegate
        self.viewModelDelegate = viewModelDelegate
        super.init(frame: .zero)
        self.delegate = self
        self.addSubview(searchBarStackView)
        searchBarStackView.pinTo(view: self, top: 10, left: 10, right: 10)
    }

    //MARK:  update MapView location
    func setLocation(stores: [Store]) {
        self.removeAnnotations(self.annotations)
        
        for (index, store) in stores.enumerated() {
            //setup data for Annotations
            let coordinate = CLLocationCoordinate2D(latitude: store.coordinates.latitude, longitude: store.coordinates.longitude)
            let indexPath = IndexPath(row: index, section: 0)
            let address1 = store.location.displayAddress[0]
            let address2 = store.location.displayAddress[1]
            //create and add StoreAnnotation
            let annotation = StoreAnnotation(coordinate: coordinate, title: address1, subtitle: address2, indexPath: indexPath)
            self.addAnnotation(annotation)
            
            if index == 0 {
                setRegion(coordinate: coordinate)
            }
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
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        return StoreMapOverlayView(overlay: overlay, overlayImage: #imageLiteral(resourceName: "HomeDelivery2"))
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = StoreAnnotationView(annotation: annotation, reuseIdentifier: StoreAnnotationView.cellIdentifier, vcDelegate: vcDelegate)
        annotationView.canShowCallout = true
        
        //set image
        
        if let annotation = annotation as? StoreAnnotation {
            print("viewFor: ", vcDelegate?.prevIndexPath, vcDelegate?.currIndexPath, annotation.indexPath)
//            annotationView.image = #imageLiteral(resourceName: "OfferImage")
            if annotation.indexPath == vcDelegate?.currIndexPath {
                annotationView.image = #imageLiteral(resourceName: "OrderImage")
            }else {
                annotationView.image = #imageLiteral(resourceName: "location")
            }
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? StoreAnnotation,
            let viewModelDelegate = viewModelDelegate else { return }
        //update views with indexPath
        print("didSelect: ", annotation.indexPath, vcDelegate?.prevIndexPath, vcDelegate?.currIndexPath)
        vcDelegate?.currIndexPath = annotation.indexPath
        deselectAnnotation(annotation, animated: true)
//        self.setLocation(stores: viewModelDelegate.items)
    }
    
    override func deselectAnnotation(_ annotation: MKAnnotation?, animated: Bool) {
        guard let annotation = annotation as? StoreAnnotation else { return }
        print("deselectAnnotation: ", annotation.title, vcDelegate?.prevIndexPath, vcDelegate?.currIndexPath)
        self.showAnnotations([annotation], animated: true)
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
        vcDelegate?.searchStore(location: location)
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

