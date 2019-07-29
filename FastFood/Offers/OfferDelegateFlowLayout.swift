//
//  OfferCollectionViewDelegate.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/29/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation
import UIKit

//MARK: UICollectionViewDelegateFlowLayout
class OfferDelegateFlowLayout: StretchHeader, UICollectionViewDelegateFlowLayout {
    typealias DidSelectAction = ((IndexPath)->Void)
    fileprivate var didSelectAction: DidSelectAction?
    
    init(didSelectAction: DidSelectAction?) {
        self.didSelectAction = didSelectAction
        super.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return .zero}
        //determine number of columns base device
        var numberOfColumns: Int!
        if UIDevice.current.userInterfaceIdiom == .phone {
            numberOfColumns = 1
            flowLayout.minimumInteritemSpacing = 1
            flowLayout.minimumLineSpacing = 1
        }else {
            numberOfColumns = UIDevice.current.orientation.isLandscape ? 3 : 2
            flowLayout.minimumInteritemSpacing = 4
            flowLayout.minimumLineSpacing = 8
            flowLayout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        }
        
        //Calc cell Width base on number of columnslet cellHeight =
        let cellWidth = collectionView.getCellWidth(numberOfColumns: numberOfColumns)
        
        return CGSize(width: cellWidth, height: OfferCell.cellHeight)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        //cell Height
        var cellHeight: CGFloat = 250
        if UIDevice.current.userInterfaceIdiom != .phone {
            cellHeight = UIDevice.current.orientation.isPortrait ? 150 : 170
        }
        
        return CGSize(width: collectionView.bounds.width, height: cellHeight)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: UICollectionViewDelegate
extension OfferDelegateFlowLayout: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectAction?(indexPath)
    }
}

