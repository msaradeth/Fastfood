//
//  StoreCollectionView.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/23/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit

class StoreCollectionView: UICollectionView {

    init(collectionViewdataSource: UICollectionViewDataSource? = nil, collectionViewDelegate: UICollectionViewDelegate? = nil) {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 4
        flowLayout.minimumLineSpacing = 8
        flowLayout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        if let dataSource = collectionViewdataSource {
            self.dataSource = dataSource
        }
        if let delegate = collectionViewDelegate {
            self.delegate = delegate
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.lightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
