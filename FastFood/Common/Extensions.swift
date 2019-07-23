//
//  Extensions.swift
//  TheMovie
//
//  Created by Mike Saradeth on 6/15/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation
import UIKit

//MARK:  UIView extension
extension UIView {
    func fillsuperView(padding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) {
        guard let superview = superview else { return }
        topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: padding.top).isActive = true
        leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor, constant: padding.left).isActive = true
        trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor, constant: padding.right).isActive = true
        bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: padding.bottom).isActive = true
    }
    
    func pinTo(view: UIView, top: CGFloat? = nil, left: CGFloat? = nil, right: CGFloat? = nil, bottom: CGFloat? = nil) {
        if let top = top {
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: top).isActive = true
        }
        if let left = left {
            leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: left).isActive = true
        }
        if let right = right {
            trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -right).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -bottom).isActive = true
        }
    }
}

//MARK:  UICollectionView extension
extension UICollectionView {
    //MARK: Get cell Width base on number of columns
    func getCellWidth(numberOfColumns: Int) -> CGFloat {
        let availableWidth = getAvailableWidth(numberOfColumns: numberOfColumns)
        
        //available width divided by number of columns
        let cellWidth = availableWidth / CGFloat(numberOfColumns)
        
        return cellWidth > 0 ? cellWidth : 0
    }
    
    
    //MARK: Get cell Width base on minimum cell width
    func getCellWidth(minCellWidth: CGFloat) -> CGFloat {
        
        let availableWidth = self.bounds.inset(by: self.layoutMargins).width
        let maxNumColumns = Int(availableWidth / minCellWidth)
        let cellWidth = (availableWidth / CGFloat(maxNumColumns)).rounded(.down)
        
        return cellWidth
    }
    

    
    //Mark: Get available width
    func getAvailableWidth(numberOfColumns: Int) -> CGFloat {
        let numberOfColumns = CGFloat(numberOfColumns)
        
        //calc available width minus safeAreaInsets
        var availableWidth = self.bounds.width - (self.safeAreaInsets.left + self.safeAreaInsets.right)
        
        //available width minus FlowLayout settings
        if let flowLayout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            availableWidth = availableWidth - (flowLayout.minimumInteritemSpacing*numberOfColumns + flowLayout.sectionInset.left + flowLayout.sectionInset.right)
        }
        
        return availableWidth > 0 ? availableWidth : 0
    }
}

extension UISearchBar {
    static func setSearchBarAppearance() {
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.white]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = attributes
    }
}


//
//extension UINavigationBar {
//    func setBackgroundImageTransparent() {
//        setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        shadowImage = UIImage()
//    }
//    func setBackgroundImageVisible() {
//        setBackgroundImage(nil, for: .default)
//        shadowImage = nil
//    }
//}
//

//
//extension UICollectionViewFlowLayout {
//    func availableHeight(collectionViewHeight: CGFloat, numberOfRows: CGFloat, navigationBarHeight: CGFloat) -> CGFloat {
//        let availableHeight = collectionViewHeight
//            - self.sectionInset.top - self.sectionInset.bottom
//            - (self.minimumInteritemSpacing * numberOfRows)
//            - navigationBarHeight
//        return availableHeight
//    }
//
//    func availableWidth(collectionViewWidth: CGFloat, numberOfColumns: CGFloat) -> CGFloat {
//        let availableWidth = collectionViewWidth
//            - self.sectionInset.left - self.sectionInset.right
//            - (self.minimumInteritemSpacing * numberOfColumns)
//        return availableWidth
//    }
//}
//
//extension UIView {
//    func fillSuperview() {
//        guard let superview = self.superview else { return }
//        self.topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor).isActive = true
//        self.leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor).isActive = true
//        self.trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor).isActive = true
//        self.bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor).isActive = true
//    }
//}

//extension UICollectionViewController {
//    func navigationBarHeight() -> CGFloat {
//        return self.navigationController?.navigationBar.bounds.height ?? 0
//    }
//}
