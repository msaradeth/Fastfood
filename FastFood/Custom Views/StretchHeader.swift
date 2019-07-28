//
//  StretchHeader.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/27/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit

class StretchHeader: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect),
            let contentOffset = collectionView?.contentOffset else { return nil }
        
        for attribute in attributes {
            guard attribute.representedElementKind == UICollectionView.elementKindSectionHeader
                && attribute.indexPath.section == 0 else { continue }
            
            //Stretch Header base on collectionview contentOffset.y
            if contentOffset.y < 0 {    //scrolling up
                let offset = abs(contentOffset.y)
                let y = -offset        //move down
                let height = attribute.frame.height + offset    //add height
                
                attribute.frame = CGRect(x: 0, y: y, width: attribute.frame.width, height: height)
            }
        }
        return attributes
    }
    
        
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
