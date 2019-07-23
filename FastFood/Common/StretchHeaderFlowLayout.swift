//
//  StretchHeaderFlowLayout.swift
//  TheMovie
//
//  Created by Mike Saradeth on 6/16/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit

class StretchHeaderFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect)
        
        layoutAttributes?.forEach { (attributes) in
            if attributes.representedElementKind == UICollectionView.elementKindSectionHeader && attributes.indexPath.section == 0 {
                guard let collectionView = collectionView else { return }
                
                let contentOffsetY = collectionView.contentOffset.y
                if contentOffsetY < 0 {
                    let width = attributes.frame.width - contentOffsetY
                    let height = attributes.frame.height - contentOffsetY
                    attributes.frame = CGRect(x: (contentOffsetY * 0.5), y: contentOffsetY, width: width, height: height)
                }
            }
        }
        return layoutAttributes
    }
    
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}



//class StretchHeaderFlowLayout: UICollectionViewFlowLayout {
//
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        let layoutAttributes = super.layoutAttributesForElements(in: rect)
//
//        layoutAttributes?.forEach({ (attributes) in
//            if attributes.representedElementKind == UICollectionView.elementKindSectionHeader && attributes.indexPath.section == 0 {
//                guard let collectionView = collectionView else { return }
//
//                let contentOffsetY = collectionView.contentOffset.y
//                if contentOffsetY < 0 {
//                    let width = collectionView.frame.width - (contentOffsetY*2)
//                    let height = attributes.frame.height - contentOffsetY
//                    attributes.frame = CGRect(x: contentOffsetY, y: contentOffsetY, width: width, height: height)
//                }
//            }
//        })
//        return layoutAttributes
//    }
//
//    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
//        return true
//    }
//}

