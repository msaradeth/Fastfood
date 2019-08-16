//
//  GestureVC.swift
//  FastFood
//
//  Created by Mike Saradeth on 8/16/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit
import MapKit
import RxSwift


class GestureVC: UIViewController {
    fileprivate var disposeBag = DisposeBag()
    var topInset: CGFloat = 80
    var bottomHeight: CGFloat = SearchCell.cellHeight + 8
    var layoutManager: LayoutManagerSwipe!
    
    @IBOutlet weak var collectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    static func createWith(title: String, viewModel: SearchViewModel) -> GestureVC {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GestureVC") as! GestureVC
        vc.navigationItem.titleView = TitleView(title: title)
        vc.viewModel = viewModel
        return vc
    }
    
    var viewModel: SearchViewModel = SearchViewModel(items: [], searchStoreService: SearchStoreService(), locationService: LocationService())
    var firstTime = true
    var origin: CGPoint!
    var panGestureRecognizer: UIPanGestureRecognizer!
    //    var swipeGestureRecognizer: UISwipeGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
        
        //Load data
        searchStore(location: "LA", coordinate: nil)
    }
    
    
    func setupVC() {
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "SearchCell", bundle: nil), forCellWithReuseIdentifier: RestaurantCell.cellIdentifier)
        collectionView.register(UINib(nibName: "SearchHeaderCell", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchHeaderCell.cellIdentifier)
        
        
        layoutManager = LayoutManagerSwipe(collectionView: collectionView,
                                           topInset: topInset,
                                           bottomHeight: bottomHeight,
                                           topConstraint: collectionViewTopConstraint)
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            collectionView.isScrollEnabled = false
            layoutManager.addSwipeGestures(view: collectionView)
            
            DispatchQueue.main.async {
                self.layoutManager.currentY = self.layoutManager.centerY
            }
        }
    }
    
    
    //MARK:  viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        print("viewWillAppear  collectionViewTopConstraint.constant: ", self.collectionViewTopConstraint.constant)
        //Load data base on current location
        if viewModel.count == 0 {
            self.searchStore(location: nil, coordinate: self.mapView.userLocation.coordinate)
        }
        
    }
    
    
    
    //Search Yelp Api to get Burger King Locations using search criteria
    func searchStore(location: String?, coordinate: CLLocationCoordinate2D?) {
        viewModel.searchStore(location: location, coordinate: coordinate) { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                //Reload data
                self.collectionView.reloadData()
                self.mapView.addAnnotations(self.viewModel.annotations)
                if let annotation = self.viewModel.annotations.first {
                    self.setRegion(coordinate: annotation.coordinate)
                }
            }
        }
    }
    
    //MARK:  setRegion
    func setRegion(coordinate:  CLLocationCoordinate2D?) {
        if let coordinate = coordinate {
            let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
            mapView.setRegion(region, animated: true)
        }
    }
    
    
}


extension GestureVC {
    
}

extension GestureVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RestaurantCell.cellIdentifier, for: indexPath) as! SearchCell
        cell.configure(indexPath: indexPath, item: viewModel[indexPath])
        return cell
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension GestureVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }
        //        print(collectionView.contentOffset, collectionView.contentSize)
        
        let cellWidth = collectionView.getCellWidth(numberOfColumns: 1)
        return CGSize(width: cellWidth, height: RestaurantCell.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
        }
    }
    
}

extension GestureVC: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translation(in: view)
        print("scrollViewWillBeginDragging: ", translation.y, layoutManager.isAtTop(), collectionView.indexPathsForVisibleItems.contains(IndexPath(row: 0, section: 0)))
        if (layoutManager.isAtTop() && collectionView.indexPathsForVisibleItems.contains(IndexPath(row: 0, section: 0))) {
            layoutManager.startScrollFromTop = true
        }else {
            layoutManager.startScrollFromTop = false
        }
        
        
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translation(in: view)
        print("scrollViewDidEndDecelerating: ", translation.y)
        if translation.y > 0 {
            //Pulling Down
            if (layoutManager.isAtTop() && collectionView.indexPathsForVisibleItems.contains(IndexPath(row: 0, section: 0))) {
                print("scrollViewDidEndDecelerating: enableGestures: ", translation.y)
                layoutManager.enableGestures()
                collectionView.isScrollEnabled = false
            }
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translation(in: view)
        print("scrollViewDidScroll: ", translation.y, layoutManager.isAtTop(), collectionView.indexPathsForVisibleItems.contains(IndexPath(row: 0, section: 0)))
        if translation.y > 0 && layoutManager.startScrollFromTop {
            //Pulling Down
            if (layoutManager.isAtTop() && collectionView.indexPathsForVisibleItems.contains(IndexPath(row: 0, section: 0))) {
                print("scrollViewDidScroll: enableGestures: ", translation.y)
                layoutManager.enableGestures()
                collectionView.isScrollEnabled = false
                layoutManager.currentY = layoutManager.centerY
            }
        }
    }
    
    //    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    //        let translation = scrollView.panGestureRecognizer.translation(in: view)
    //        print("scrollViewDidEndDragging: ", translation.y)
    //        if translation.y > 0 {
    //            //Pulling Down
    //            if (layoutManager.atTop() && collectionView.indexPathsForVisibleItems.contains(IndexPath(row: 0, section: 0))) {
    //                print("scrollViewDidEndDragging: enableGestures: ", translation.y)
    //                layoutManager.enableGestures()
    //                collectionView.isScrollEnabled = false
    //            }
    //        }
    //    }
}
