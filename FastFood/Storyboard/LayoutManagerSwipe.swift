//
//  LayoutManagerSwipeSwipe.swift
//  FastFood
//
//  Created by Mike Saradeth on 8/14/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation


import Foundation
import UIKit

class LayoutManagerSwipe: NSObject {
    fileprivate let swipeGestureName = "swipeGestureName"
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
            let animate = oldValue == 0 ? false : true  //don't animate the first time.
            if UIDevice.current.userInterfaceIdiom == .phone {
                updateUI(animate: animate)
            }            
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
        
        print("LayoutManagerSwipe  topConstraint?.constant: ", topConstraint?.constant)
    }
    
    func updateUI(animate: Bool) {
        topConstraint?.constant = self.currentY
        if animate {
            UIView.animate(withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 0.7, //where higher values make the bouncing finish faster.
                initialSpringVelocity: 1.5,  //where higher values give the spring more initial momentum.
                options: .curveEaseIn,
                animations: {
                self.collectionView?.superview?.layoutIfNeeded()
            })
        }else {
            self.collectionView?.superview?.layoutIfNeeded()
        }
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
extension LayoutManagerSwipe {
    
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
        enableGestures()
        collectionView?.isScrollEnabled = false
        
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

