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
    fileprivate let swipeGestureName = "swipeGestureName"
    fileprivate let panGestureName = "panGestureName"
    weak var collectionView: UICollectionView?
    weak var topConstraint: NSLayoutConstraint?
    var safeAreaInset: UIEdgeInsets? {
        didSet {
//            self.topY = (self.safeAreaInset?.top ?? 0) + (self.topConstraint?.constant ?? 0)
        }
    }
    var topConstrantConstant: CGFloat {
        return minY - (safeAreaInset?.top ?? 0)
    }

    var minY: CGFloat
    var midY: CGFloat
    var maxY: CGFloat
    var height: CGFloat
    var width: CGFloat {
        return collectionView?.frame.width ?? 0
    }
    var currentY: CGFloat = 0 {
        didSet {
//            guard let collectionView = self.collectionView else { return }
            print("didSet currentY: ", currentY)
            animate(y: currentY)
            
//            if !atTop() && (topConstraint?.isActive ?? false) {
//                topConstraint?.isActive = false
//            }
//            UIView.animate(withDuration: 0.3) {
//                collectionView.frame = CGRect(x: 0, y: self.currentY, width: collectionView.frame.width, height: collectionView.frame.height)
//            }
//
//            UIView.animate(withDuration: 0.3, animations: {
//                collectionView.frame = CGRect(x: 0, y: self.currentY, width: self.width, height: self.height)
//            }) { (finished) in
//                if collectionView.alpha != 1 {
//                    self.collectionView?.alpha = 1
//                }
//            }
        }
    }
    
    //MARK: init
    init(collectionView: UICollectionView?, topConstraint: NSLayoutConstraint?, minY: CGFloat, midY: CGFloat, maxY: CGFloat, height: CGFloat) {
        self.collectionView = collectionView
        self.topConstraint = topConstraint
        self.minY = minY
        self.midY = midY
        self.maxY = maxY
        self.height = height
    }
    
    func animate(y: CGFloat) {
        UIView.animate(withDuration: 0.5) {
            guard let collectionView = self.collectionView else { return }
            collectionView.frame = CGRect(x: 0, y: y, width: collectionView.frame.width, height: collectionView.frame.height)
            collectionView.layoutIfNeeded()
        }
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
        print(sender.direction)
        switch sender.direction {
        case .up:
            if atBottom() {
                currentY = midY
            }else if atCenter() {
                currentY = minY
                disableGestures()
                collectionView?.isScrollEnabled = true
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
