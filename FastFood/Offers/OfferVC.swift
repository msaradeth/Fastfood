//
//  OffersVC.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/17/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit

class OfferVC: UIViewController {
    lazy var collectionView: StoreCollectionView = {
        let collectionnView = StoreCollectionView(collectionViewdataSource: self, collectionViewDelegate: self)
        collectionnView.translatesAutoresizingMaskIntoConstraints = false
        return collectionnView
    }()
    var viewModel: OfferViewModel!
    
    //MARK: init
    init(title: String, viewModel: OfferViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.titleView = TitleView(title: title, fontSize: .large)
        self.view.backgroundColor = .white
        self.view.addSubview(collectionView)
        self.collectionView.fillsuperView()
        self.tabBarItem = UITabBarItem(title: "Offers", image: #imageLiteral(resourceName: "OfferImage"), tag: 0)
        self.addSettingsButton()
        registerCollectionViewCells()
    }
    //MARK: Register CollectionViewCells
    private func registerCollectionViewCells() {
        //Register cells
        collectionView.register(UINib(nibName: "ScanCanCell", bundle: nil), forCellWithReuseIdentifier: ScanCanCell.cellIdentifier)
        collectionView.register(UINib(nibName: "MonthlyDealCell", bundle: nil), forCellWithReuseIdentifier: MonthlyDealCell.cellIdentifier)
        collectionView.register(UINib(nibName: "OfferCell", bundle: nil), forCellWithReuseIdentifier: OfferCell.cellIdentifier)

    }
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.searchStore { [weak self] in
            DispatchQueue.main.async {
                let locationManager = LocationManager()
                self?.collectionView.reloadData()
            }
        }
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

//MARK: UICollectionViewDataSource
extension OfferVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count + 2
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            return collectionView.dequeueReusableCell(withReuseIdentifier: ScanCanCell.cellIdentifier, for: indexPath) as! ScanCanCell
        case 1:
            return collectionView.dequeueReusableCell(withReuseIdentifier: MonthlyDealCell.cellIdentifier, for: indexPath) as! MonthlyDealCell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OfferCell.cellIdentifier, for: indexPath) as! OfferCell
            cell.configure(item: viewModel[indexPath])
            return cell
        }
    }
}

//MARK: UICollectionViewDelegate
extension OfferVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        //        collectionView.deselectItem(at: indexPath, animated: true)
    }
}


//MARK: UICollectionViewDelegateFlowLayout
extension OfferVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellHeight: CGFloat!
        var cellWidth: CGFloat!
        
        //determine number of columns base device
        let numberOfColumns = UIDevice.current.userInterfaceIdiom == .phone ? 1 : 2
        
        //calc cell Height and Width
        switch indexPath.row {
        case 0:
            //Calc cell Width base on number of columns
            cellWidth = collectionView.getCellWidth(numberOfColumns: numberOfColumns)
            cellHeight = UIDevice.current.userInterfaceIdiom == .phone ? ScanCanCell.cellHeight : MonthlyDealCell.cellHeight
        case 1:
            //Calc cell Width base on number of columns
            cellWidth = collectionView.getCellWidth(numberOfColumns: numberOfColumns)
            cellHeight = MonthlyDealCell.cellHeight
        default:
            //Calc cell Width base on minimum cell width
            cellHeight = OfferCell.cellHeight
            cellWidth = UIDevice.current.userInterfaceIdiom == .phone ? collectionView.getCellWidth(numberOfColumns: 1) : collectionView.getCellWidth(minCellWidth: 300)
        }
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}


