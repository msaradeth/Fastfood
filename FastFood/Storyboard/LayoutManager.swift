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
        return y < midPoint ? true : false
    }
    
    func isHalfWayUpFromBottom(y: CGFloat) -> Bool {
        let midPoint = centerY / 2.0
        return y < midPoint ? true : false
    }
}



//MARK: UISwipeGestureRecognizer
extension LayoutManager {
    
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


//MARK: UISwipeGestureRecognizer
extension LayoutManager {
    
    public func addPanGesture(view: UIView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGesture)
        self.panGesture = panGesture
    }
    
    //MARK: handle swipe Gesture
    @objc private func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        print("PanGestureRecognizer")
        guard let view = sender.view, let direction = sender.direction, let collectionView = self.collectionView else { return }
        let velocity = sender.velocity(in: view.superview)  //move up or down direction
        // Get the changes in the X and Y directions relative to the superview's coordinate.
        let translation = sender.translation(in: view.superview)
        
        switch sender.state {
        case .began:
            origin = view.center
//            print("origin: ", origin)
            
        case .changed:
//            print("changed: ", view.center, translation.y, topConstraint.constant)
            var y = view.center.y + translation.y
            view.center = CGPoint(x: view.center.x, y: y)
            sender.setTranslation(CGPoint.zero, in: view.superview)
            
        case .ended:
            print("ended: ", collectionView.frame.minY)

            if direction == .up {
                print("up")
                if isHalfWayUpFromCenter(y: collectionView.frame.minY) {
                    self.currentY = topInset
                }else if isHalfWayUpFromBottom(y: collectionView.frame.minY) {
                    self.currentY = bottomY
                }
            }else if direction == .down {
                print("down")
            }
            sender.reset()
            
        default:
            break
        }
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
