//
//  GestureManager.swift
//  FastFood
//
//  Created by Mike Saradeth on 8/8/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation
import UIKit

class LayoutManager: NSObject {
    var topInset: CGFloat = 80
    var bottomHeight: CGFloat = SearchCell.cellHeight + 8
    
    fileprivate let swipeGestureName = "swipeGestureName"
    fileprivate let panGestureName = "panGestureName"
    weak var collectionView: UICollectionView?
    weak var topConstraint: NSLayoutConstraint?
    var availableHeight: CGFloat {
        guard let superview = collectionView?.superview else { return 0 }
        return superview.frame.height - (safeAreaInsets.top + safeAreaInsets.bottom)
    }
    var safeAreaInsets: UIEdgeInsets {
        let safeAreaInsets = collectionView?.superview?.safeAreaInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        return collectionView?.superview?.safeAreaInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        print("LayoutManager: safeAreaInsets: ", print(safeAreaInsets))
        return safeAreaInsets
    }
 
//    var topConstrantConstant: CGFloat {
//        return minY - (safeAreaInset?.top ?? 0)
//    }

    var minY: CGFloat {
        return topInset
    }
    var midY: CGFloat {
        return availableHeight / 2.0
//        guard let superview = collectionView?.superview else { return 0 }
//        return superview.frame.height / 2.0
    }
    var maxY: CGFloat {
//        guard let superview = collectionView?.superview else { return 0 }
        
        return availableHeight - bottomHeight
    }
    var height: CGFloat
    var width: CGFloat {
        return collectionView?.frame.width ?? 0
    }
    var currentY: CGFloat {
        didSet {
            guard let collectionView = self.collectionView else { return }
//            print("didSet currentY: ", currentY, "  safeAreaInsets: ", safeAreaInsets, "  collectionView.superview?.frame.height=", collectionView.superview?.frame.height)
//            collectionView.frame = CGRect(x: 0, y: self.currentY, width: collectionView.frame.width, height: collectionView.frame.height)
            
            updateUI(y: currentY)
            
//            if !atTop() && (topConstraint?.isActive ?? false) {
//                topConstraint?.isActive = false
//            }
//            UIView.updateUI(withDuration: 0.3) {
//                collectionView.frame = CGRect(x: 0, y: self.currentY, width: collectionView.frame.width, height: collectionView.frame.height)
//            }
//
//            UIView.updateUI(withDuration: 0.3, animations: {
//                collectionView.frame = CGRect(x: 0, y: self.currentY, width: self.width, height: self.height)
//            }) { (finished) in
//                if collectionView.alpha != 1 {
//                    self.collectionView?.alpha = 1
//                }
//            }
        }
    }
    
    //MARK: init
    init(collectionView: UICollectionView?, minY: CGFloat, midY: CGFloat, maxY: CGFloat, height: CGFloat, topConstraint: NSLayoutConstraint?) {
        self.collectionView = collectionView
//        self.minY = minY
//        self.midY = midY
//        self.maxY = maxY
        self.height = height
        self.topConstraint = topConstraint
        self.currentY = midY
        
        print("LayoutManager  topConstraint?.constant: ", topConstraint?.constant)
    }
    
    func updateUI(y: CGFloat) {
        topConstraint?.constant = self.currentY
//        UIView.updateUI(withDuration: 0.4) {
//            print("self.currentY: ", self.currentY)
//            self.collectionView?.superview?.layoutIfNeeded()
//        }
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
//            print("self.currentY: ", self.currentY)
            self.collectionView?.superview?.layoutIfNeeded()
        })
    }
    
    
    //MARK: enable and disable gestureRecognizers
    func enableGestures() {
        collectionView?.gestureRecognizers?.forEach({ (gesture) in
            if let gestureName = gesture.name, gestureName == swipeGestureName || gestureName == panGestureName {
                gesture.isEnabled = true
            }
        })
//        //Disable collectionView to scroll
//        collectionView?.isScrollEnabled = false
    }
    
    func disableGestures() {
        //Disable gestureRecognizers
        collectionView?.gestureRecognizers?.forEach({ (gesture) in
            if let gestureName = gesture.name, gestureName == swipeGestureName || gestureName == panGestureName {
                gesture.isEnabled = false
            }
        })
    }
}



//MARK: UISwipeGestureRecognizer
extension LayoutManager {
    
    public func addSwipeGestures(view: UIView) {
        let directions: [UISwipeGestureRecognizer.Direction] = [.down, .up]
        for direction in directions {
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
            swipeGesture.name = swipeGestureName
            swipeGesture.direction = direction
            view.addGestureRecognizer(swipeGesture)
        }
    }
    
    //MARK: handle swipe Gesture
    @objc private func handleSwipeGesture(_ sender: UISwipeGestureRecognizer) {
//        print(sender.direction)
        
        enableGestures()
        collectionView?.isScrollEnabled = false
//        topConstraint?.isActive = false
        
        
        switch sender.direction {
        case .up:
            if atBottom() {
                currentY = midY
            }else if atCenter() {
                currentY = minY
                disableGestures()
                collectionView?.isScrollEnabled = true
                
////                topConstraint?.constant = minY
//                topConstraint?.isActive = true
//                if let topConstraint = self.topConstraint {
////                    topConstraint.constant = minY
////                    topConstraint.isActive = true
//                }

//                currentY = minY
//                topConstraint?.isActive = true
            }
        case .down:
            if atTop() {
                currentY = midY
            }else if atCenter() {
                currentY = maxY
            }
        default:
            break
        }
        
    }
    
    
    //MARK: Helper function to determine current position
    func atTop() -> Bool {
//        print("atTop:", currentY, topY, topConstraint?.constant, safeAreaInset?.top)
//        let currentTopY = (topConstraint?.constant ?? 0) + (safeAreaInset?.top ?? 0)
        return currentY == minY ? true : false
//        if currentY == topY || topConstraint?.constant == topConstrantConstant {
//            return true
//        }else {
//            return false
//        }
    }
    func atCenter() -> Bool {
        return currentY == midY ? true : false
    }
    func atBottom() -> Bool {
        return currentY == maxY ? true : false
    }
    
    
    //MARK: Helper functions
    func halfWayUp(y: CGFloat) -> Bool {
        let midPoint = (midY - minY) / 2.0
        return y < midPoint ? true : false
    }
    
    func topHalf(y: CGFloat) -> Bool {
        return y == midY ? true : false
    }
    
}
