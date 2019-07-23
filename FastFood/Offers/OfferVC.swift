//
//  OffersVC.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/17/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit

class OfferVC: UICollectionViewController {
    var viewModel: OfferViewModel!
    
    //MARK: init
    init(title: String, viewModel: OfferViewModel) {
        self.viewModel = viewModel
        
        //init CollectionView
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 2
        flowLayout.minimumLineSpacing = 4
        super.init(collectionViewLayout: flowLayout)
        self.title = title
        self.collectionView.backgroundColor = .white
        setupVC()
    }
    
    
    //MARK: setupVC
    func setupVC() {
        collectionView.register(UINib(nibName: "ScanCanCell", bundle: nil), forCellWithReuseIdentifier: ScanCanCell.cellIdentifier)
        collectionView.register(UINib(nibName: "MonthlyDealCell", bundle: nil), forCellWithReuseIdentifier: MonthlyDealCell.cellIdentifier)
        collectionView.register(UINib(nibName: "OfferCell", bundle: nil), forCellWithReuseIdentifier: OfferCell.cellIdentifier)
        self.tabBarItem = UITabBarItem(title: "Offers", image: nil, tag: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        let searchBusinessService = SearchBusinessService()
//        DispatchQueue.global().async {
//            searchBusinessService.loadData()
//        }
        
    }
    
    //MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count + 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            return collectionView.dequeueReusableCell(withReuseIdentifier: ScanCanCell.cellIdentifier, for: indexPath) as! ScanCanCell
        case 1:
            return collectionView.dequeueReusableCell(withReuseIdentifier: MonthlyDealCell.cellIdentifier, for: indexPath) as! MonthlyDealCell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OfferCell.cellIdentifier, for: indexPath) as! OfferCell
            cell.configure(title: viewModel[indexPath])
            return cell
        }
    }
    
    
    //MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    
    //MARK: Handle rotation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.invalidateLayout()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



//MARK: UICollectionViewDelegateFlowLayout
extension OfferVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellHeight: CGFloat!
        var cellWidth: CGFloat!
        
        //Number of columns
        let numberOfColumns = UIDevice.current.userInterfaceIdiom == .phone ? 1 : 2
        
        //calc cell Height and Width
        switch indexPath.row {
        case 0:
            cellHeight = ScanCanCell.cellHeight
            cellWidth = collectionView.getCellWidth(numberOfColumns: numberOfColumns)   //Calc cell Width base on number of columns
        case 1:
            cellHeight = MonthlyDealCell.cellHeight
            cellWidth = collectionView.getCellWidth(numberOfColumns: numberOfColumns)   //Calc cell Width base on number of columns
        default:
            //Calc cell Width base on minimum cell width
            cellHeight = OfferCell.cellHeight
            cellWidth = UIDevice.current.userInterfaceIdiom == .phone ? collectionView.getCellWidth(numberOfColumns: 1) : collectionView.getCellWidth(minCellWidth: 300)
        }
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}


