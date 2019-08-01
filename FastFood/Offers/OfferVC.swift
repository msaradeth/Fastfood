//
//  OffersVC.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/17/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit
import MapKit
import RxSwift


protocol OfferVCDelegate: NSObject {
    func showInfo(indexPat: IndexPath)
    func paymentMethod()
    func subscriptionInfoButtonPressed()
    func scanButtonPressed()
}

class OfferVC: BaseViewController {
    var disposeBag = DisposeBag()
    lazy var collectionView: UICollectionView = {
        let offerDelegateFlowLayout = OfferDelegateFlowLayout(didSelectAction: { (indexPath) in
            self.showMobilOrRestaurantOrder(indexPath: indexPath)
        })
        //CollectionView
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: offerDelegateFlowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = offerDelegateFlowLayout
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        return collectionView
    }()
    var viewModel: OfferViewModel!
    
    //MARK: init
    init(title: String, viewModel: OfferViewModel) {
        self.viewModel = viewModel
        let tabBarItem = UITabBarItem(title: "Offers", image: #imageLiteral(resourceName: "OfferImage"), tag: 0)
        super.init(title: title, fontSize: .large, tabBarItem: tabBarItem, showSettings: true)
        //add collectionView
        self.view.addSubview(collectionView)
        self.collectionView.fillsuperView()
        
        //Register cells
        self.registerCollectionViewCells()
    }
    
    //MARK: Register CollectionViewCells
    private func registerCollectionViewCells() {
        collectionView.register(UINib(nibName: "OfferHeaderCell", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: OfferHeaderCell.cellIdentifier)
        collectionView.register(UINib(nibName: "OfferCell", bundle: nil), forCellWithReuseIdentifier: OfferCell.cellIdentifier)
    }
    
    
    //MARK:  viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //load if data array is empty
        if viewModel.count == 0 {
            //Load data with current location if available, otherwise load when current location becomes available
            if let currLocation = viewModel.locationService.currLocation {
                loadData(coordinate: currLocation.coordinate)
            }else {
                //Subscriber to get the latest current location when it becomes available, than load data
                viewModel.locationService.subject.take(1).subscribe(onNext: { [weak self] (coordinate) in
                    self?.loadData(coordinate: coordinate)
                })
                    .disposed(by: disposeBag)
            }
        }
    }
    

    //Search Yelp Api to get Restaurants near current location
    func loadData(coordinate: CLLocationCoordinate2D) {
        viewModel.searchStore(term: "Restaurant", coordinate: coordinate) { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }

    //MARK: Handle rotation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.invalidateLayout()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: UICollectionViewDataSource
extension OfferVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OfferCell.cellIdentifier, for: indexPath) as! OfferCell
        cell.configure(item: viewModel[indexPath], indexPath: indexPath, vcDelegate: self, viewModelDelegate: viewModel)
        return cell
    }
    
    // MARK: UICollectionView Header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: OfferHeaderCell.cellIdentifier, for: indexPath) as! OfferHeaderCell
        headerView.configure(delegate: self)

        return headerView
    }
}


//MARK: OfferVCDelegate
extension OfferVC: OfferVCDelegate {
    func showInfo(indexPat: IndexPath) {
        //Get information from ViewModel using indexPath and show it
        self.showAlert(title: "Coupon Info", message: "Coupon Detail Information", alertActionTitle: "OK")
    }
    
    func scanButtonPressed() {
        self.showAlert(title: "It's Time", message: "Your stranger summer starts now", alertActionTitle: "LET'S GO")
    }
    
    func paymentMethod() {
        //Handle Payment Methods
        self.showAlert(title: "Payment Methods", message: "Handle Payment Methods", alertActionTitle: "OK")
    }
    
    func subscriptionInfoButtonPressed() {
        self.showAlert(style: .actionSheet, title: "Subscription Info", message: "Subscription Detail Information", alertActionTitle: "OK")
    }
    
}

