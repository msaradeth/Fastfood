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
    var gestureManager: GestureManager!
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
//        collectionView.alpha = 0
        
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
        
        gestureManager = GestureManager(collectionView: collectionView, topConstraint: collectionViewTopConstraint, minY: view.frame.minY + topInset, midY: view.frame.midY, maxY: view.frame.maxY - bottomHeight, height: view.bounds.height - topInset)
        collectionView.isScrollEnabled = true
        
        print("bounds: ", self.view.bounds, self.view.frame)
        
        print("collectionView.frame: ", collectionView.frame)
        print("Settings: ", gestureManager)
        print("view.safeAreaInsets: ", view.safeAreaInsets)
        
//        gestureManager.addSwipeGestures(view: collectionView)
//        collectionView.frame = CGRect(x: 0, y: self.mapView.frame.midY, width: collectionView.frame.width, height: mapView.frame.height - topInset)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        collectionView.frame = CGRect(x: 0, y: self.mapView.frame.midY, width: collectionView.frame.width, height: mapView.frame.height - topInset)
        collectionView.frame = CGRect(x: 0, y: view.frame.midY, width: collectionView.frame.width, height: view.frame.height - topInset)
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
    
    
    //
    //    @objc func handlePanGesture(_ sender: UIPanGestureRecognizer) {
    //        guard let view = sender.view else { return }
    //        let velocity = sender.velocity(in: view.superview)
    ////        let minY: CGFloat = mapView.center.y + (SearchCell.cellHeight / 2.0)
    ////        let maxY: CGFloat = mapView.center.y + collectionView.bounds.height - ((SearchCell.cellHeight - self.view.safeAreaInsets.bottom) / 2.0)
    ////
    //        // Get the changes in the X and Y directions relative to
    //        // the superview's coordinate space.
    //        let translation = sender.translation(in: view.superview)
    //
    //        switch sender.state {
    //        case .began:
    //            origin = view.center
    //            print("begin: ", origin)
    //
    //
    //        case .changed:
    ////            collectionView.center = view.center
    //            var y = view.center.y + translation.y
    ////            print("change", y, self.topCenterY, self.midCenterY, self.bottomCenterY)
    ////            guard y != topCenterY && y != bottomCenterY else { return }
    ////            if origin.y == topCenterY && y < topCenterY {
    ////                return
    ////            }
    ////
    ////            if origin.y == bottomCenterY && y > bottomCenterY {
    ////                return
    ////            }
    ////
    ////            if y < topCenterY {
    ////                y = topCenterY
    ////            }
    ////            if y > bottomCenterY {
    ////                y = bottomCenterY
    ////            }
    //
    ////            view.center = CGPoint(x: view.center.x, y: y)
    ////            sender.setTranslation(CGPoint.zero, in: view.superview)
    //
    //
    //
    //        case .ended:
    //            if velocity.y > 0 {
    //                print("panning down")
    //                if topHalf(minY: collectionView.frame.minY) {
    //                    if halfWayUp(minY: collectionView.frame.minY) {
    //                        collectionView.center.y = topCenterY
    //                    }else {
    //                        collectionView.center.y = midCenterY
    //                    }
    //                }else {
    //                    print("bottom half")
    //                }
    //            }else {
    //                print("panning up")
    //                if topHalf(minY: collectionView.frame.minY) {
    //                    if halfWayUp(minY: collectionView.frame.minY) {
    //                        collectionView.center.y = topCenterY
    //                    }else {
    //                        collectionView.center.y = midCenterY
    //                    }
    //                }else {
    //                    print("bottom half")
    //                }
    //            }
    //
    //            panGestureRecognizer.reset()
    //
    //
    //        default:
    //            print("default ")
    //        }
    //    }
    //
    //
    //    @objc func handleSwipeGesture(_ sender: UISwipeGestureRecognizer) {
    //        print("handleSwipeGesture", sender.direction)
    //        guard let view = sender.view else { return }
    //
    //    }
    
    
    //MARK: Helper functions
    func halfWayUp(minY: CGFloat) -> Bool {
        let midPoint = topInset +  ((self.view.frame.midY - topInset) / 2)
        return minY < midPoint ? true : false
        
        //        print("halfWayUp: ", minY, midPoint)
        //        if minY < midPoint {
        //            return true
        //        }
        //        return false
    }
    
    func topHalf(minY: CGFloat) -> Bool {
        return minY == collectionView.frame.midY ? true : false
        //        if minY < collectionView.frame.midY {
        //            return true
        //        }
        //        return false
    }
    
}


extension StoreVC {
    
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

extension StoreVC: UIScrollViewDelegate {
    
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        let contentOffsetY = scrollView.contentOffset.y
//        let translation = scrollView.panGestureRecognizer.translation(in: self.view)
//
//
//        let deltaY = translation.y
//        var y = collectionView.frame.minY + abs(deltaY)
//        let maxY = view.frame.height - bottomHeight - self.view.safeAreaInsets.bottom
//
//        print(deltaY, y, collectionView.frame.minY, topInset,  maxY, translation.y, contentOffsetY)
//
//        if deltaY > 0 && collectionView.frame.minY == topInset {
//            // pull down
//            if collectionView.indexPathsForVisibleItems.contains(IndexPath(row: 0, section: 0)) {
//                var y = collectionView.frame.minY + abs(deltaY)
//                let maxY = view.frame.height - bottomHeight - self.view.safeAreaInsets.bottom
//                if y > maxY {
////                    y = maxY
//                }
//                print("scrollViewWillBeginDragging: pull down: y=\(y),  maxY=\(maxY)  collectionView.frame.minY=\(collectionView.frame.minY),  topInset=\(topInset)   deltaY=\(deltaY)   view.safeAreaInsets.bottom=\(view.safeAreaInsets.bottom)")
//                collectionView.frame = CGRect(x: 0, y: topInset+1, width: collectionView.frame.width, height: collectionView.frame.height)
//
//
////                if y <= maxY {
////                    print("pull down: y=\(y), collectionView.frame.minY=\(collectionView.frame.minY),  topInset=\(topInset)   deltaY=\(deltaY)   view.safeAreaInsets.bottom=\(view.safeAreaInsets.bottom)")
////                    collectionView.frame = CGRect(x: 0, y: y, width: collectionView.frame.width, height: collectionView.frame.height)
////                }
//            }
//        }
//
//    }
//
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translation(in: self.view)
        
        //        if collectionView.isDragging || collectionView.isDecelerating {
        //            print("collectionView is Dragging: ", scrollView.contentOffset.y, collectionView.frame.maxY, minHeight, maxHeight)
        //        }
        
        let contentOffsetY = scrollView.contentOffset.y
        print(translation.y, contentOffsetY)
        let deltaY = translation.y
        if deltaY < 0 {
            // scroll up
            var y = collectionView.frame.minY - abs(deltaY)
            if y < topInset {
                y = topInset
            }
//            print("scroll up:  y=\(y), collectionView.frame.minY=\(collectionView.frame.minY),  topInset=\(topInset)   deltaY=\(deltaY)")
            if y >= topInset {
                print("scroll up:  y=\(y), collectionView.frame.minY=\(collectionView.frame.minY),  topInset=\(topInset)   deltaY=\(deltaY)")
                collectionView.frame = CGRect(x: 0, y: y, width: collectionView.frame.width, height: collectionView.frame.height)
            }
        }else {
            // pull down
//            print("pull down: ", collectionView.frame.minY, topInset, collectionView.indexPathsForVisibleItems.contains(IndexPath(row: 0, section: 0)))
//            if collectionView.frame.minY == topInset && collectionView.indexPathsForVisibleItems.contains(IndexPath(row: 0, section: 0)) {
            if collectionView.indexPathsForVisibleItems.contains(IndexPath(row: 0, section: 0)) {
//                UIView.animate(withDuration: 0.3) {
//                    self.collectionView.frame = CGRect(x: 0, y: self.gestureManager.midY, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
//                }
                
                var y = collectionView.frame.minY + abs(deltaY)
                let maxY = view.frame.height - bottomHeight - self.view.safeAreaInsets.bottom
                if y > maxY {
                    y = maxY
                }
//                print("y=\(y), collectionView.frame.minY=\(collectionView.frame.minY),  topInset=\(topInset)   deltaY=\(deltaY)   view.safeAreaInsets.bottom=\(view.safeAreaInsets.bottom)")
                if y <= maxY {
                    print("pull down: ", collectionView.frame.minY, topInset, collectionView.indexPathsForVisibleItems.contains(IndexPath(row: 0, section: 0)))
                    UIView.animate(withDuration: 0.5) {
                        self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
                        self.collectionView.layoutIfNeeded()
                    }
                }
            }

        }
      
        
    }
}
