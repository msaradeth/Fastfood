//
//  StoreVC.swift
//  FastFood
//
//  Created by Mike Saradeth on 8/8/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit

//class StoreVC: UIViewController {


import UIKit
import MapKit
import RxSwift


class StoreVC: UIViewController {
    fileprivate var disposeBag = DisposeBag()
    var topInset: CGFloat = 170
    var bottomHeight: CGFloat = SearchCell.cellHeight + 8
    var layoutManager: LayoutManager!
    @IBOutlet weak var collectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!

    static func createWith(title: String, viewModel: SearchViewModel) -> StoreVC {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StoreVC") as! StoreVC
        vc.navigationItem.titleView = TitleView(title: title)
        vc.viewModel = viewModel
        return vc
    }
    
//    var viewModel: SearchViewModel!
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
//        collectionView.decelerationRate = .fast
        collectionView.bounces = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        collectionView.frame = CGRect(x: 0, y: view.frame.midY, width: collectionView.frame.width, height: view.frame.height - topInset)
        print("safeAreaInsets: ", view.safeAreaInsets)
        
        layoutManager = LayoutManager(collectionView: collectionView,                                      
                                      topInset: topInset,
                                      bottomHeight: bottomHeight,
                                      topConstraint: collectionViewTopConstraint)

    }
    
    //MARK:  viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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




extension StoreVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(viewModel.count)
        return viewModel.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RestaurantCell.cellIdentifier, for: indexPath) as! SearchCell
        cell.configure(indexPath: indexPath, item: viewModel[indexPath])
        return cell
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension StoreVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.getCellWidth(numberOfColumns: 1)
        return CGSize(width: cellWidth, height: RestaurantCell.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
        }
    }
    
}

extension StoreVC: UIScrollViewDelegate {
  
 
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translation(in: self.view)
        
//            if collectionView.isDragging || collectionView.isDecelerating {
//                print("collectionView is Dragging: ", scrollView.contentOffset.y, collectionView.frame.maxY)
//            }
        
        let contentOffsetY = scrollView.contentOffset.y
        print("translation.y: ", translation.y, "    contentOffsetY: ", contentOffsetY)
        
        
        let deltaY = abs(translation.y)
        if translation.y < 0 {
            // scroll up
            var y = collectionView.frame.minY - deltaY
            if y < topInset {
                y = topInset
            }
            
            
            if y >= topInset {
                self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
        }else {
            // pull down
            if collectionView.indexPathsForVisibleItems.contains(IndexPath(row: 0, section: 0)) {
                var y = collectionView.frame.minY + deltaY
//                var y = collectionView.frame.minY + contentOffsetY
                
                if y > layoutManager.bottomY {
                    y = layoutManager.bottomY
                }
                
                if y <= layoutManager.bottomY && y != layoutManager.currentY {
                    layoutManager.currentY = y
                }
            }

        }

    }
   
}
