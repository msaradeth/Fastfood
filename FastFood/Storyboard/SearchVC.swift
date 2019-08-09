//
//  SearchVC.swift
//  FastFood
//
//  Created by Mike Saradeth on 8/5/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit
import MapKit
import RxSwift


class SearchVC: UIViewController {
    fileprivate var disposeBag = DisposeBag()
    var topInset: CGFloat = 170
    var bottomHeight: CGFloat = SearchCell.cellHeight + 8
    var layoutManager: LayoutManager!

    
    @IBOutlet weak var collectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    static func createWith(title: String, viewModel: SearchViewModel) -> SearchVC {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
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
        
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "SearchCell", bundle: nil), forCellWithReuseIdentifier: RestaurantCell.cellIdentifier)
        collectionView.register(UINib(nibName: "SearchHeaderCell", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchHeaderCell.cellIdentifier)
//        print("setupVC collectionViewTopConstraint.constant: ", self.collectionViewTopConstraint.constant)
        //
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
        
//        layoutManager = LayoutManager(collectionView: collectionView, topConstraint: collectionViewTopConstraint, minY: view.frame.minY + topInset, midY: view.frame.midY, maxY: view.frame.maxY - bottomHeight, height: view.bounds.height - topInset)
        
        print("bounds: ", self.view.bounds, self.view.frame)
        
        print("collectionView.frame: ", collectionView.frame)
        print("Settings: ", layoutManager)
        print("view.safeAreaInsets: ", view.safeAreaInsets)
        
//        layoutManager.addSwipeGestures(view: collectionView)

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("self.view.safeAreaInsets: ", self.view.safeAreaInsets)
//        layoutManager.safeAreaInset = view.safeAreaInsets
//        layoutManager.currentY = layoutManager.midY
//        collectionView.frame = CGRect(x: 0, y: view.frame.midY, width: collectionView.frame.width, height: view.frame.height - topInset)
//        layoutManager.midY = collectionView.frame.midY
//        layoutManager.currentY = layoutManager.midY
//        layoutManager = LayoutManager(collectionView: collectionView, topConstraint: collectionViewTopConstraint, minY: view.frame.minY + topInset, midY: view.frame.midY, maxY: view.frame.maxY - bottomHeight, height: view.bounds.height - topInset)
//
//        print("bounds: ", self.view.bounds, self.view.frame)
//
//        print("collectionView.frame: ", collectionView.frame)
//        print("Settings: ", layoutManager)
//        print("view.safeAreaInsets: ", view.safeAreaInsets)
//
//        layoutManager.addSwipeGestures(view: collectionView)
//        layoutManager.currentY = layoutManager.midY
        
        
//        layoutManager = LayoutManager(collectionView: collectionView, topConstraint: collectionViewTopConstraint, minY: view.frame.minY + topInset, midY: view.frame.midY, maxY: view.frame.maxY - bottomHeight, height: view.bounds.height - topInset)
//
//        print("bounds: ", self.view.bounds, self.view.frame)
//
//        print("collectionView.frame: ", collectionView.frame)
//        print("Settings: ", layoutManager)
//        print("view.safeAreaInsets: ", view.safeAreaInsets)
        
        layoutManager = LayoutManager(collectionView: collectionView,
                                      topConstraint: collectionViewTopConstraint,
                                      minY: view.frame.minY + topInset, // + view.safeAreaInsets.top,
                                      midY: view.frame.midY,
                                      maxY: view.frame.maxY - bottomHeight - view.safeAreaInsets.bottom,
                                      height: view.bounds.height - topInset)
        
        layoutManager.addSwipeGestures(view: collectionView)
//        layoutManager.currentY = layoutManager.midY

        collectionView.frame = CGRect(x: 0, y: view.frame.midY, width: collectionView.frame.width, height: view.frame.height - topInset)
        print("layoutManager.minY: ", layoutManager.minY)
        
//        print("viewDidLayoutSubviews collectionViewTopConstraint.constant: ", self.collectionViewTopConstraint)
//
        
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
    

//    //MARK: Helper functions
//    func halfWayUp(minY: CGFloat) -> Bool {
//        let midPoint = topInset +  ((self.view.frame.midY - topInset) / 2)
//        return minY < midPoint ? true : false
//        
////        print("halfWayUp: ", minY, midPoint)
////        if minY < midPoint {
////            return true
////        }
////        return false
//    }
//    
//    func topHalf(minY: CGFloat) -> Bool {
//        return minY == collectionView.frame.midY ? true : false
////        if minY < collectionView.frame.midY {
////            return true
////        }
////        return false
//    }
 
}


extension SearchVC {
    
}

extension SearchVC: UICollectionViewDataSource {
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
extension SearchVC: UICollectionViewDelegateFlowLayout {
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

extension SearchVC: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView)
        print("translation.y: ", translation.y)
        if translation.y <= 0 {
            print("Pulling down", layoutManager.atTop(), collectionView.indexPathsForVisibleItems.contains(IndexPath(row: 0, section: 0)))
             //Pulling Down
            if (layoutManager.atTop() && collectionView.indexPathsForVisibleItems.contains(IndexPath(row: 0, section: 0))) {
//                layoutManager.disableGestures()
//                layoutManager.enableGestures()
//                collectionView.isScrollEnabled = false
//                layoutManager.currentY = layoutManager.midY
            }
        }else {
//            layoutManager.enableGestures()
        }
        
////        if collectionView.isDragging || collectionView.isDecelerating {
////            print("collectionView is Dragging: ", scrollView.contentOffset.y, collectionView.frame.maxY, minHeight, maxHeight)
////        }
//
//        let contentOffsetY = abs(scrollView.contentOffset.y)
//        if translation.y < 0 {
//            //Dragging Down
//            guard scrollView.contentOffset.y <= 0 && collectionViewHeightConstraint.constant > minHeight else { return }
//            print("pulling Down: ", translation.y, collectionViewHeightConstraint.constant)
//            let y = collectionView.frame.midY + contentOffsetY
//            collectionView.frame = CGRect(x: 0, y: y, width: collectionView.bounds.width, height: collectionView.bounds.height)
//            //            collectionViewHeightConstraint.constant = translation.y
////            if collectionViewHeightConstraint.constant > minHeight {
////                UIView.animate(withDuration: 0.3) {
////                    self.collectionViewHeightConstraint.constant = minHeight
////                    self.collectionView.layoutIfNeeded()
////                }
////            }
//        }else {
//            //Dragging UP
//            print("Dragging UP: ", translation.y, collectionViewHeightConstraint.constant)
//            //            collectionViewHeightConstraint.constant += translation.y
//            if collectionViewHeightConstraint.constant < maxHeight {
//                UIView.animate(withDuration: 0.3) {
//                    self.collectionViewHeightConstraint.constant = maxHeight
//                    self.collectionView.layoutIfNeeded()
//                }
//            }
//        }
    
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let minHeight: CGFloat = SearchCell.cellHeight
        let maxHeight: CGFloat = view.bounds.height - (view.safeAreaInsets.top + SearchCell.cellHeight)
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView)

        //        if collectionView.isDragging || collectionView.isDecelerating {
        //            print("collectionView is Dragging: ", scrollView.contentOffset.y, collectionView.frame.maxY, minHeight, maxHeight)
        //        }
        
        let contentOffsetY = abs(scrollView.contentOffset.y)
//        if translation.y > 0 {
//            //Dragging Down
//            guard scrollView.contentOffset.y <= 0 && collectionViewHeightConstraint.constant > minHeight else { return }
//
//            let y = collectionView.frame.minY + contentOffsetY
//            guard y > minHeight else { return }
//
////            print("pulling Down: ", translation.y, collectionViewHeightConstraint.constant)
//
////            collectionView.frame = CGRect(x: 0, y: y, width: collectionView.bounds.width, height: collectionView.bounds.height)
//            //            collectionViewHeightConstraint.constant = translation.y
//            //            if collectionViewHeightConstraint.constant > minHeight {
//            //                UIView.animate(withDuration: 0.3) {
//            //                    self.collectionViewHeightConstraint.constant = minHeight
//            //                    self.collectionView.layoutIfNeeded()
//            //                }
//            //            }
//        }else {
//            //Dragging UP
//            let y = collectionView.frame.minY - contentOffsetY
//            guard y < maxHeight else { return }
//
//
////            collectionView.frame = CGRect(x: 0, y: y, width: collectionView.bounds.width, height: collectionView.bounds.height)
//
////            print("Dragging UP: ", translation.y, collectionViewHeightConstraint.constant)
//
//
//
//            //            collectionViewHeightConstraint.constant += translation.y
////            if collectionViewHeightConstraint.constant < maxHeight {
////                UIView.animate(withDuration: 0.3) {
////                    self.collectionViewHeightConstraint.constant = maxHeight
////                    self.collectionView.layoutIfNeeded()
////                }
////            }
//        }
//
        
//        if collectionView.isSpringLoaded {
//            print("collectionView.isSpringLoaded ")
//        }
//        if collectionView.isDragging || collectionView.isDecelerating {
//            print("collectionView is Dragging: ", translation.y, scrollView.contentOffset.y, minHeight, maxHeight)
//        }
//
//
////        print(view.safeAreaInsets)
//        if translation.y > 0 {
//            //Dragging Down
//            guard scrollView.contentOffset.y <= 0 && collectionViewHeightConstraint.constant > minHeight else { return }
//            print("Dragging Down: ", translation.y, collectionViewHeightConstraint.constant)
////            collectionViewHeightConstraint.constant = translation.y
//            if collectionViewHeightConstraint.constant > minHeight {
//                UIView.animate(withDuration: 0.3) {
//                    self.collectionViewHeightConstraint.constant = minHeight
//                    self.collectionView.layoutIfNeeded()
//                }
//
//            }
//        }else {
//            //Dragging UP
//            print("Dragging UP: ", translation.y, collectionViewHeightConstraint.constant)
////            collectionViewHeightConstraint.constant += translation.y
//            if collectionViewHeightConstraint.constant < maxHeight {
//                UIView.animate(withDuration: 0.3) {
//                    self.collectionViewHeightConstraint.constant = maxHeight
//                    self.collectionView.layoutIfNeeded()
//                }
//            }
//        }
        
    }
}
