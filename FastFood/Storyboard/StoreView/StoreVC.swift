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
        layoutManager = LayoutManager(collectionView: collectionView,
                topConstraint: collectionViewTopConstraint,
                minY: view.frame.minY + topInset + view.safeAreaInsets.top,
                midY: view.frame.midY,
                maxY: view.frame.maxY - bottomHeight - view.safeAreaInsets.bottom,
                height: view.bounds.height - topInset)
        
        print("safeAreaInsets: ", view.safeAreaInsets)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "SearchCell", bundle: nil), forCellWithReuseIdentifier: RestaurantCell.cellIdentifier)
        collectionView.register(UINib(nibName: "SearchHeaderCell", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchHeaderCell.cellIdentifier)
//        collectionView.isScrollEnabled = true
//        collectionView.decelerationRate = .fast
        collectionView.bounces = true

        
        //        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        //        collectionView.addGestureRecognizer(panGestureRecognizer)
        
        
        
        //        swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        //        swipeGestureRecognizer.numberOfTouchesRequired = 1
        ////        swipeGestureRecognizer.direction = .up
        //        swipeGestureRecognizer.direction = .down
        //        collectionView.addGestureRecognizer(swipeGestureRecognizer)
        
        //        self.collectionViewTopConstraint.constant = self.view.bounds.height / 2
        //        self.collectionViewHeightConstraint.constant = self.view.bounds.height - topInset
        
        //        self.collectionView.frame = CGRect(x: 0, y: self.mapView.frame.midY, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
        //        self.collectionViewButtomConstraint.constant = -(self.view.bounds.height/2 + collectionViewHeightConstraint.constant)
        //        self.collectionViewButtomConstraint.constant = collectionView.bounds.height
        
        //        print("setupVC: ", collectionViewTopConstraint.constant, collectionViewHeightConstraint.constant, collectionView.bounds.height, self.view.bounds.height)
        //        topInset = collectionView.bounds.height
        
        //        let collectionViewHeight = self.view.bounds.height - topInset
        //        topCenterY = self.view.center.y + topInset/2.0  //self.view.center.y + (self.view.bounds.height - topInset) / 2
        //        midCenterY = self.view.center.y + (collectionView.bounds.height/2)
        //        bottomCenterY = self.view.center.y + (collectionView.frame.height/2) - bottomHeight
        //        let y =  self.view.bounds.height / 2
        //        print(y, collectionViewHeight, collectionView.bounds.width, collectionView.bounds.height)
        
        //        collectionView.isScrollEnabled = true
        

        
        print("bounds: ", self.view.bounds, self.view.frame)
        
        print("collectionView.frame: ", collectionView.frame)
        print("Settings: ", layoutManager)
        print("view.safeAreaInsets: ", view.safeAreaInsets)
        
//        gestureManager.addSwipeGestures(view: collectionView)
//        collectionView.frame = CGRect(x: 0, y: self.mapView.frame.midY, width: collectionView.frame.width, height: mapView.frame.height - topInset)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        collectionView.frame = CGRect(x: 0, y: self.mapView.frame.midY, width: collectionView.frame.width, height: mapView.frame.height - topInset)
        collectionView.frame = CGRect(x: 0, y: view.frame.midY, width: collectionView.frame.width, height: view.frame.height - topInset)
        print("safeAreaInsets: ", view.safeAreaInsets)
        layoutManager.minY = view.frame.minY + topInset + view.safeAreaInsets.top
        layoutManager.maxY = view.frame.maxY - bottomHeight - view.safeAreaInsets.bottom

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
                
                if y > layoutManager.maxY {
                    y = layoutManager.maxY
                }
                
                if y <= layoutManager.maxY && y != layoutManager.currentY {
                    layoutManager.currentY = y
                }
            }

        }

    }
   
}
