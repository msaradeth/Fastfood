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


protocol OfferVCDelegate {
    func showInfo(indexPat: IndexPath)
    func paymentMethod()
    func subscriptionInfoButtonPressed()
    func scanButtonPressed()
}

class OfferVC: UIViewController {
    var disposeBag = DisposeBag()
    lazy var collectionView: UICollectionView = {
        //Flow layout
        let flowLayout = StretchHeader()
        //CollectionView
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        
        return collectionView
    }()
    var viewModel: OfferViewModel!
    
    //MARK: init
    init(title: String, viewModel: OfferViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .white
        self.navigationItem.titleView = TitleView(title: title, fontSize: .large)
        self.tabBarItem = UITabBarItem(title: "Offers", image: #imageLiteral(resourceName: "OfferImage"), tag: 0)
                
        //add collectionView
        self.view.addSubview(collectionView)
        self.collectionView.fillsuperView()
        
        //Add settings image
        self.addSettingsButton()
        
        //Register cells
        self.registerCollectionViewCells()
    }
    
    //MARK: Register CollectionViewCells
    private func registerCollectionViewCells() {
        //Register cells
        collectionView.register(UINib(nibName: "OfferHeaderCell", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: OfferHeaderCell.cellIdentifier)
        collectionView.register(UINib(nibName: "OfferCell", bundle: nil), forCellWithReuseIdentifier: OfferCell.cellIdentifier)
    }
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //Load data with current location if available, otherwise load when current location becomes available
        if let currLocation = viewModel.locationService.currLocation {
            loadData(coordinate: currLocation.coordinate)
        }else {
            //Subscriber to get the latest current location when it becomes available
            viewModel.locationService.subject.take(1).subscribe(onNext: { [weak self] (coordinate) in
                self?.loadData(coordinate: coordinate)
            })
            .disposed(by: disposeBag)
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

//MARK: UICollectionViewDelegate
extension OfferVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        handleItemSelected(indexPath: indexPath)
    }
        
    func handleItemSelected(indexPath: IndexPath) {
        let style: UIAlertController.Style = UIDevice.current.userInterfaceIdiom == .phone ? .actionSheet: .alert
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: style)
        
        //alert action
        let mobileOrder = UIAlertAction(title: "Mobile Order", style: .default, handler: nil)
        let restaurantOrder = UIAlertAction(title: "Restaurant Order", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        //add alert actions
        alertController.addAction(mobileOrder)
        alertController.addAction(restaurantOrder)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}


//MARK: UICollectionViewDelegateFlowLayout
extension OfferVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return .zero}
        //determine number of columns base device
        var numberOfColumns: Int!
        if UIDevice.current.userInterfaceIdiom == .phone {
            numberOfColumns = 1
            flowLayout.minimumInteritemSpacing = 1
            flowLayout.minimumLineSpacing = 1
        }else {
            numberOfColumns = UIDevice.current.orientation.isLandscape ? 3 : 2
            flowLayout.minimumInteritemSpacing = 4
            flowLayout.minimumLineSpacing = 8
            flowLayout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        }
        
        //Calc cell Width base on number of columnslet cellHeight =
        let cellWidth = collectionView.getCellWidth(numberOfColumns: numberOfColumns)
        
        return CGSize(width: cellWidth, height: OfferCell.cellHeight)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        //cell Height
        var cellHeight: CGFloat = 250
        if UIDevice.current.userInterfaceIdiom != .phone {
            cellHeight = UIDevice.current.orientation.isPortrait ? 150 : 170
        }
        
        return CGSize(width: collectionView.bounds.width, height: cellHeight)
    }
}



//MARK: OfferVCDelegate
extension OfferVC: OfferVCDelegate {
    func showInfo(indexPat: IndexPath) {
        //Get information from ViewModel using indexPath and show it
        self.showAlert(style: .alert, title: "Coupon Info", message: "Coupon Detail Information", alertActionTitle: "OK")
    }
    
    func scanButtonPressed() {
        self.showAlert(style: .alert, title: "It's Time", message: "Your stranger summer starts now", alertActionTitle: "LET'S GO")
    }
    
    func paymentMethod() {
        //Handle Payment Methods
        self.showAlert(style: .alert, title: "Payment Methods", message: "Handle Payment Methods", alertActionTitle: "OK")
    }
    
    func subscriptionInfoButtonPressed() {
        self.showAlert(style: .alert, title: "Subscription Info", message: "Subscription Detail Information", alertActionTitle: "OK")
    }
    
}

