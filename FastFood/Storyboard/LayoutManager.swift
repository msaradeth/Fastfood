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
//    var topInset: CGFloat = 80
//    var bottomHeight: CGFloat = SearchCell.cellHeight + 8
    
    fileprivate let swipeGestureName = "swipeGestureName"
    fileprivate let panGestureName = "panGestureName"

    var availableHeight: CGFloat {
        guard let superview = collectionView?.superview else { return 0 }
        return superview.frame.height - (superview.safeAreaInsets.top + superview.safeAreaInsets.bottom)
    }
    var centerY: CGFloat {
        return availableHeight / 2.0
    }
    var bottomY: CGFloat {
        return availableHeight - bottomHeight
    }
    var currentY: CGFloat = 0 {
        didSet {
            updateUI(y: currentY)
        }
    }
    
    weak var collectionView: UICollectionView?
    weak var topConstraint: NSLayoutConstraint?
    var topInset: CGFloat
    var bottomHeight: CGFloat
    
    //MARK: init
    init(collectionView: UICollectionView?, topInset: CGFloat, bottomHeight: CGFloat, topConstraint: NSLayoutConstraint?) {
        self.collectionView = collectionView
        self.topInset = topInset
        self.bottomHeight = bottomHeight
        self.topConstraint = topConstraint
        
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
        enableGestures()
        collectionView?.isScrollEnabled = false
        
        switch sender.direction {
        case .up:
            if atBottom() {
                currentY = centerY
            }else if atCenter() {
                currentY = topInset
                disableGestures()
                collectionView?.isScrollEnabled = true
            }
        case .down:
            if atTop() {
                currentY = centerY
            }else if atCenter() {
                currentY = bottomY
            }
        default:
            break
        }
        
    }
    
    
    //MARK: Helper function to determine current position
    func atTop() -> Bool {
        return currentY == topInset ? true : false
    }
    func atCenter() -> Bool {
        return currentY == centerY ? true : false
    }
    func atBottom() -> Bool {
        return currentY == bottomY ? true : false
    }
    
    
    //MARK: Helper functions
    func halfWayUp(y: CGFloat) -> Bool {
        let midPoint = (centerY - topInset) / 2.0
        return y < midPoint ? true : false
    }
    
    func topHalf(y: CGFloat) -> Bool {
        return y == centerY ? true : false
    }
    
}
