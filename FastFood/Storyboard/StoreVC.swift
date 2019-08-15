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
    var bottomY: CGFloat {
        return view.frame.height - (view.safeAreaInsets.bottom + bottomHeight)
    }
    var isScrollingDownFromTop: Int = 0
    var isAtTop = false
    
    
    var layoutManager: LayoutManagerFrame!
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
        
//        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "SearchCell", bundle: nil), forCellWithReuseIdentifier: RestaurantCell.cellIdentifier)
        collectionView.register(UINib(nibName: "SearchHeaderCell", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchHeaderCell.cellIdentifier)
//        collectionView.decelerationRate = .fast
        collectionView.bounces = true
        

        
        layoutManager = LayoutManagerFrame(collectionView: collectionView,
                                      topInset: topInset,
                                      bottomHeight: bottomHeight,
                                      topConstraint: collectionViewTopConstraint)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
            collectionView.frame = CGRect(x: 0, y: view.frame.midY, width: collectionView.frame.width, height: view.frame.height - topInset)
//            print("safeAreaInsets: ", view.safeAreaInsets)
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
//extension StoreVC: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let cellWidth = collectionView.getCellWidth(numberOfColumns: 1)
//        return CGSize(width: cellWidth, height: RestaurantCell.cellHeight)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if indexPath.row == 0 {
//
//        }
//    }
//
//}


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
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translation(in: view)
//        print("scrollViewWillBeginDragging: ", translation.y, layoutManager.isAtTop(), collectionView.indexPathsForVisibleItems.contains(IndexPath(row: 0, section: 0)))
//        if (collectionView.frame.minY == topInset && collectionView.indexPathsForVisibleItems.contains(IndexPath(row: 0, section: 0))) {
//            layoutManager.startScrollFromTop = true
//        }else {
//            layoutManager.startScrollFromTop = false
//        }
        
        if ((collectionView.frame.minY > layoutManager.topInset - 2 || collectionView.frame.minY < layoutManager.topInset + 2) && collectionView.indexPathsForVisibleItems.contains(IndexPath(row: 0, section: 0))) {
            layoutManager.startScrollFromTop = true
        }else {
            layoutManager.startScrollFromTop = false
        }

    }

    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translation(in: view)

//        print("scrollViewDidScroll: ", translation.y, layoutManager.isAtTop(), collectionView.indexPathsForVisibleItems.contains(IndexPath(row: 0, section: 0)))
      
//        if translation.y > 0 && layoutManager.startScrollFromTop {
        let deltaY = translation.y * 0.10
//        updateUI(deltaY: deltaY, y: 0, scrollView: scrollView)
//        return
        
        if deltaY > 0 {
            //Pulling Down
//            print("pulling down: ", collectionView.frame.minY, topInset, layoutManager.startScrollFromTop)
//            if (collectionView.frame.minY == topInset && !layoutManager.startScrollFromTop) {
//                return
//            }
            
            if ((collectionView.frame.minY > layoutManager.topInset - 2 || collectionView.frame.minY < layoutManager.topInset + 2) && !layoutManager.startScrollFromTop) {
                return
            }
            
            var y = collectionView.frame.minY + deltaY
            if y <= layoutManager.bottomY {
                y = layoutManager.bottomY
            }
            
//            print("down scrollViewDidEndDecelerating: ", y, layoutManager.bottomY, collectionView.frame.minY, translation.y)
            if y <= layoutManager.bottomY && collectionView.frame.minY != layoutManager.bottomY {
                updateUI(deltaY: deltaY, y: y, scrollView: scrollView)
//                collectionView.isScrollEnabled = false
//                collectionView.frame = CGRect(x: 0, y: y, width: collectionView.frame.width, height: collectionView.frame.height)
//                collectionView.isScrollEnabled = true
            }
        }else {
            var y = collectionView.frame.minY + deltaY
            if y >= layoutManager.topInset {
                y = layoutManager.topInset
            }
            
//            print("up scrollViewDidEndDecelerating: ", y, layoutManager.topInset, collectionView.frame.minY, translation.y)
            if y >= layoutManager.topInset && collectionView.frame.minY != layoutManager.topInset {
                updateUI(deltaY: deltaY, y: y, scrollView: scrollView)
//                collectionView.isScrollEnabled = false
//                collectionView.frame = CGRect(x: 0, y: y, width: collectionView.frame.width, height: collectionView.frame.height)
//                collectionView.isScrollEnabled = true
            }
        }
        scrollView.panGestureRecognizer.reset()
        collectionView.panGestureRecognizer.reset()

    }
    
    
    func updateUI(deltaY: CGFloat, y: CGFloat, scrollView: UIScrollView) {
        guard let collectionView = self.collectionView else { return }
        var y = collectionView.frame.minY + deltaY
//        if y <= layoutManager.bottomY {
//            y = layoutManager.bottomY
//        }else if y >= layoutManager.topInset {
//            y = layoutManager.topInset
//        }
        
        let frame = CGRect(x: 0, y: y, width: collectionView.frame.width, height: collectionView.frame.height)
        
//        let frame = CGRect(x: 0, y: y, width: collectionView.frame.width, height: collectionView.frame.height)
        print("updateUI: deltaY=", deltaY, y, collectionView.frame.minY )
        
        UIView.animate(withDuration: 0.1,
            delay: 0,
            usingSpringWithDamping: 0.9, //where higher values make the bouncing finish faster.
            initialSpringVelocity: 5,  //where higher values give the spring more initial momentum.
            options: .curveEaseIn,
            animations: {
                self.collectionView?.frame = frame
        })
    }

}


//
//extension StoreVC: UIScrollViewDelegate {
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        let translation = scrollView.panGestureRecognizer.translation(in: scrollView)
//        print("scrollViewWillBeginDragging: ", collectionView.frame.minY, topInset, translation.y, layoutManager.isAtTop(), collectionView.indexPathsForVisibleItems.contains(IndexPath(row: 0, section: 0)))
//
////        isScrollingDownFromTop = 0
////        if (isAtTop && collectionView.indexPathsForVisibleItems.contains(IndexPath(row: 0, section: 0))) {
////            isScrollingDownFromTop = true
////        }else {
////            isScrollingDownFromTop = false
////        }
//
//
//    }
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let translation = scrollView.panGestureRecognizer.translation(in: view)
//        print("scrollViewDidEndDecelerating: ", translation.y)
//
//        if translation.y < 0 {
//            //Pulling up
//            let deltaY = abs(translation.y)
//            var y = collectionView.frame.minY - deltaY
////            if y <= self.bottomY {
////                self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
////            }
//
//
////            if (layoutManager.isAtTop() && collectionView.indexPathsForVisibleItems.contains(IndexPath(row: 0, section: 0))) {
////                print("scrollViewDidEndDecelerating: enableGestures: ", translation.y)
////                layoutManager.enableGestures()
////                collectionView.isScrollEnabled = false
////            }
//        }
//    }
//
//
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let translation = scrollView.panGestureRecognizer.translation(in: self.view)
//
//
////            if collectionView.isDragging || collectionView.isDecelerating {
////                print("collectionView is Dragging: ", scrollView.contentOffset.y, collectionView.frame.maxY)
////            }
//
//        let contentOffsetY = scrollView.contentOffset.y
////        print("translation.y: ", translation.y, "    contentOffsetY: ", contentOffsetY)
//
//
//        let deltaY = abs(translation.y)
//        if translation.y < 0 {
//            // scroll up
//            var y = collectionView.frame.minY - deltaY
//            if y < topInset {
//                y = topInset
//                isAtTop = true
//            }else {
//                isAtTop = false
//            }
//
//
//            if y >= topInset {
//                self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
//            }
//
//        }else {
//            // pull down
//            var y = collectionView.frame.minY + (deltaY * 0.08)
//            print("pull down: ", isScrollingDownFromTop, collectionView.indexPathsForVisibleItems.contains(IndexPath(row: 0, section: 0)), y, self.bottomY)
//
//            if !collectionView.indexPathsForVisibleItems.contains(IndexPath(row: 0, section: 0)) {
//                isScrollingDownFromTop = 0
//            }else {
//                isScrollingDownFromTop += 1
//            }
//            if isScrollingDownFromTop >= 1 {
//                collectionView.isScrollEnabled = false
//                let frame = CGRect(x: 0, y: topInset, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
//                self.collectionView.frame = frame
////                collectionView.scrollRectToVisible(frame, animated: true)
//
//                collectionView.isScrollEnabled = true
//                isScrollingDownFromTop = 0
//
//            }else {
//                if collectionView.indexPathsForVisibleItems.contains(IndexPath(row: 0, section: 0)) {
//
//                    //                var y = collectionView.frame.minY + contentOffsetY
//                    //                print("y= ", y, "  layoutManager.bottomY= ", self.bottomY)
//
//                    if y > self.bottomY {
//                        y = self.bottomY
//                    }
//
//                    if y <= self.bottomY {
//                        self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
//                    }
//
//                    //                self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
//                }
//            }
//
//
//
//        }
//
//    }
//
//}
