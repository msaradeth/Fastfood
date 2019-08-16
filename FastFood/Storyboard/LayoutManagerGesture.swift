//
//  LayoutManagerGestureGesture.swift
//  FastFood
//
//  Created by Mike Saradeth on 8/16/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation
import UIKit

class LayoutManagerGesture: NSObject {
    fileprivate let swipeGestureName = "swipeGestureName"
    fileprivate let panGestureName = "panGestureName"
    fileprivate var panGesture: UIPanGestureRecognizer?
    var origin: CGPoint!
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
    var startScrollFromTop: Bool = false
    var topInset: CGFloat
    var bottomHeight: CGFloat
    
    //MARK: init
    init(collectionView: UICollectionView?, topInset: CGFloat, bottomHeight: CGFloat, topConstraint: NSLayoutConstraint?) {
        self.collectionView = collectionView
        self.topInset = topInset
        self.bottomHeight = bottomHeight
        self.topConstraint = topConstraint
        
        print("LayoutManagerGesture  topConstraint?.constant: ", topConstraint?.constant)
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
extension LayoutManagerGesture {
    
    public func addSwipeGestures(view: UIView) {
        let directions: [UISwipeGestureRecognizer.Direction] = [.down, .up]
        for direction in directions {
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
            if let panGesture = self.panGesture {
                panGesture.require(toFail: swipeGesture)
                //                swipeGesture.require(toFail: panGesture)
            }
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


//MARK: UISwipeGestureRecognizer
extension LayoutManagerGesture {
    
    public func addPanGesture(view: UIView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGesture)
        self.panGesture = panGesture
    }
    
    //MARK: handle swipe Gesture
    @objc private func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        //        print("PanGestureRecognizer")
        guard let view = sender.view, let direction = sender.direction, let collectionView = self.collectionView else { return }
        // Get the changes in the X and Y directions relative to the superview's coordinate.
        let translation = sender.translation(in: view.superview)
        
        switch sender.state {
        case .began:
            origin = view.center
            
        case .changed:
            //            print("changed: ", view.center, translation.y, topConstraint.constant)
            let y = view.center.y + translation.y
            view.center = CGPoint(x: view.center.x, y: y)
            sender.setTranslation(CGPoint.zero, in: view.superview)
            
        case .ended:
            //            print("ended: ", collectionView.frame.minY)
            
            if direction == .up {
                print("handlePanGesture up")
                if isHalfWayUpFromCenter(y: collectionView.frame.minY) {
                    print("isHalfWayUpFromCenter")
                    self.currentY = topInset
                }else if isHalfWayUpFromBottom(y: collectionView.frame.minY) {
                    print("isHalfWayUpFromBottom")
                    self.currentY = bottomY
                }
            }else if direction == .down {
                print("handlePanGesture down")
            }
            sender.reset()
            
        default:
            break
        }
    }
}
