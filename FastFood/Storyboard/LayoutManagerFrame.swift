//
//  LayoutManagerFrame.swift
//  FastFood
//
//  Created by Mike Saradeth on 8/14/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation


import Foundation
import UIKit

class LayoutManagerFrame: NSObject {
    fileprivate let swipeGestureName = "swipeGestureName"
    var availableHeight: CGFloat {
        guard let superview = collectionView?.superview else { return 0 }
        return superview.frame.height - (superview.safeAreaInsets.top + superview.safeAreaInsets.bottom)
    }
    var centerY: CGFloat {
        return availableHeight / 2.0
    }
    var bottomY: CGFloat {
        guard let superview = collectionView?.superview else { return 0 }
        let bottomY = superview.safeAreaInsets.top + (availableHeight - bottomHeight)
//        print("bottomY: ", bottomY, superview.frame.height, bottomHeight)
        return bottomY
//        print(superview.frame.height - bottomHeight, superview.frame.height, superview.frame.minY, bottomHeight)
//        return superview.frame.height - (bottomHeight + superview.safeAreaInsets.bottom)
//        return availableHeight - bottomHeight
    }
    var currentY: CGFloat = 0 {
        didSet {
            updateUI(y: currentY)
        }
    }
    
    weak var collectionView: UICollectionView?
    weak var topConstraint: NSLayoutConstraint?
    var startScrollFromTop: Bool = false
    var topInset: CGFloat
    var bottomHeight: CGFloat
    
    //MARK: init
    init(collectionView: UICollectionView?, topInset: CGFloat, bottomHeight: CGFloat, topConstraint: NSLayoutConstraint?) {
        self.collectionView = collectionView
        self.topInset = topInset
        self.bottomHeight = bottomHeight
        self.topConstraint = topConstraint
        
        print("LayoutManagerFrame  topConstraint?.constant: ", topConstraint?.constant)
    }
    
    func updateUI(y: CGFloat) {
        topConstraint?.constant = self.currentY
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            self.collectionView?.superview?.layoutIfNeeded()
        })
    }
    
    
    //MARK: enable and disable gestureRecognizers
    func enableGestures() {
        collectionView?.gestureRecognizers?.forEach({ (gesture) in
            if let gestureName = gesture.name, gestureName == swipeGestureName {
                gesture.isEnabled = true
            }
        })
    }
    
    func disableGestures() {
        //Disable gestureRecognizers
        collectionView?.gestureRecognizers?.forEach({ (gesture) in
            if let gestureName = gesture.name, gestureName == swipeGestureName {
                gesture.isEnabled = false
            }
        })
    }
    
    
    
    //MARK: Helper function to determine current position
    func isAtTop() -> Bool {
        return currentY == topInset ? true : false
    }
    
    func isAtCenter() -> Bool {
        return currentY == centerY ? true : false
    }
    
    func isAtBottom() -> Bool {
        return currentY == bottomY ? true : false
    }
    
    func isHalfWayUpFromCenter(y: CGFloat) -> Bool {
        let midPoint = (centerY - topInset) / 2.0
        print("isHalfWayUpFromCenter: ", y, " > ", midPoint, centerY, topInset)
        return y > midPoint ? true : false
    }
    
    func isHalfWayUpFromBottom(y: CGFloat) -> Bool {
        let midPoint = centerY / 2.0
        print("isHalfWayUpFromBottom: ", y, midPoint, centerY, topInset)
        return y < midPoint ? true : false
    }
}



//MARK: UISwipeGestureRecognizer
extension LayoutManagerFrame {
    
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
        print("SwipeGestureRecognizer")
        if collectionView?.isScrollEnabled == false {
            enableGestures()
            collectionView?.isScrollEnabled = false
        }
        
        switch sender.direction {
        case .up:
            if isAtBottom() {
                currentY = centerY
            }else if isAtCenter() {
                currentY = topInset
                disableGestures()
                collectionView?.isScrollEnabled = true
            }
        case .down:
            if isAtTop() {
                currentY = centerY
            }else if isAtCenter() {
                currentY = bottomY
            }
        default:
            break
        }
    }
}

