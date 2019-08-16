//
//  LayoutManagerScrollScroll.swift
//  FastFood
//
//  Created by Mike Saradeth on 8/16/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//


import Foundation
import UIKit

class LayoutManagerScroll: NSObject {
    fileprivate let swipeGestureName = "swipeGestureName"
    fileprivate let panGestureName = "panGestureName"
    fileprivate var panGesture: UIPanGestureRecognizer?
    var availableHeight: CGFloat {
        guard let superview = collectionView?.superview else { return 0 }
        return superview.frame.height - (superview.safeAreaInsets.top + superview.safeAreaInsets.bottom)
    }
    var safeAreaInsets: UIEdgeInsets {
        return collectionView?.superview?.safeAreaInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    var topConstraintValue: CGFloat {
        return topInset
    }
    var centerConstraintValue: CGFloat {
        return availableHeight / 2.0
    }
    var bottomConstraintValue: CGFloat {
        return availableHeight - bottomHeight
    }
    var currentConstraintValue: CGFloat = 0 {
        didSet {
            updateUI()
        }
    }
    var minY: CGFloat {
        return safeAreaInsets.top + topInset
    }
    var midY: CGFloat {
        return safeAreaInsets.top + centerConstraintValue
    }
    var maxY: CGFloat {
        return safeAreaInsets.top + bottomConstraintValue
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
        
        print("LayoutManagerScroll  topConstraint?.constant: ", topConstraint?.constant)
    }
    
    func updateUI() {
        topConstraint?.constant = currentConstraintValue
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
        return currentConstraintValue == topInset || collectionView?.frame.minY == minY ? true : false
    }
    
    func isAtCenter() -> Bool {
        return currentConstraintValue == centerConstraintValue ? true : false
    }
    
    func isAtBottom() -> Bool {
        return currentConstraintValue == bottomConstraintValue ? true : false
    }
    
    func isInTopHalfOfScreen(y: CGFloat) -> Bool {
        return y <= midY ? true : false
    }
    func isInBottomHalfOfScreen(y: CGFloat) -> Bool {
        return y >= midY ? true : false
    }
    
    func isHalfWayUpFromCenter(y: CGFloat) -> Bool {
        let midPoint = minY + (midY - minY)/2.0
        //        print("isHalfWayUpFromCenter: ", y > midPoint,  y, " > ", midPoint, centerConstraintValue, topInset)
        return y < midPoint ? true : false
    }
    
    func isHalfWayUpFromBottom(y: CGFloat) -> Bool {
        let midPoint = midY + (maxY - midY)/2.0
        //        print("isHalfWayUpFromBottom: ", y, midPoint, centerConstraintValue, topInset)
        return y < midPoint ? true : false
    }
}

extension LayoutManagerScroll: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


//MARK: UISwipeGestureRecognizer
extension LayoutManagerScroll {
    
    public func addSwipeGestures(view: UIView) {
        let directions: [UISwipeGestureRecognizer.Direction] = [.down, .up]
        for direction in directions {
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
            swipeGesture.delegate = self
            //            if let panGesture = self.panGesture {
            //                panGesture.require(toFail: swipeGesture)
            ////                swipeGesture.require(toFail: panGesture)
            //            }
            swipeGesture.name = swipeGestureName
            swipeGesture.direction = direction
            view.addGestureRecognizer(swipeGesture)
        }
    }
    
    //MARK: handle swipe Gesture
    @objc private func handleSwipeGesture(_ sender: UISwipeGestureRecognizer) {
        print("SwipeGestureRecognizer")
        guard let collectionView = self.collectionView else { return }
        if isAtTop() {
            disableGestures()
            collectionView.isScrollEnabled = true
        }else {
            enableGestures()
            collectionView.isScrollEnabled = false
        }
        
        
        switch sender.direction {
        case .up:
            if isAtBottom() {
                currentConstraintValue = centerConstraintValue
            }else if isAtCenter() {
                currentConstraintValue = topInset
                disableGestures()
                collectionView.isScrollEnabled = true
            }
        case .down:
            if isAtTop() {
                currentConstraintValue = centerConstraintValue
            }else if isAtCenter() {
                currentConstraintValue = bottomConstraintValue
            }
        default:
            break
        }
    }
}


//MARK: UIPanGestureRecognizer
extension LayoutManagerScroll {
    
    public func addPanGesture(view: UIView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
        self.panGesture = panGesture
    }
    
    //handle PanGestureRecognizer
    @objc private func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        print("PanGestureRecognizer")
        guard let collectionView = self.collectionView else { return }
        if isAtTop() {
            disableGestures()
            collectionView.isScrollEnabled = true
            return
        }else {
            enableGestures()
            collectionView.isScrollEnabled = false
        }
        
        
        guard let view = sender.view else { return }
        // Get the changes in the X and Y directions relative to the superview's coordinate.
        let translation = sender.translation(in: view.superview)
        
        switch sender.state {
        case .changed:
            let y = view.center.y + translation.y
            view.center = CGPoint(x: view.center.x, y: y)
            sender.setTranslation(CGPoint.zero, in: view)
            
        case .ended:
//            if isInTopHalfOfScreen(y: view.frame.minY) {
//                if isHalfWayUpFromCenter(y: view.frame.minY) {
//                    updateUI(view: view, y: minY)
//                }else {
//                    updateUI(view: view, y: midY)
//                }
//            }else {
//                //bottom half of screen
//                if isHalfWayUpFromBottom(y: view.frame.minY) {
//                    //                    print("isHalfWayUpFromCenter")
//                    updateUI(view: view, y: midY)
//                }else {
//                    updateUI(view: view, y: maxY)
//                }
//            }
            sender.reset()
            
        default:
            break
        }
    }
    
    func updateUI(view: UIView, y: CGFloat) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            view.frame = CGRect(x: 0, y: y, width: view.frame.width, height: view.frame.height)
        })
    }
}

