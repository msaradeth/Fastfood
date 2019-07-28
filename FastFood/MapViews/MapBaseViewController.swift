//
//  MapBaseViewController.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/26/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit
import MapKit

class MapBaseViewController: UIViewController {
    var saveTitle: String?
    var viewModel: RestaurantViewModelDelegate?
    
    //MARK:  init
    init(title: String, tabBarItem: UITabBarItem? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.saveTitle = title
        self.navigationItem.titleView = TitleView(title: title)
        if let tabBarItem = tabBarItem {
            self.tabBarItem = tabBarItem
        }
    }
    
    //MARK:  setup VC
    func setupViews() {
        self.view.backgroundColor = .white
        self.view.addSubview(restaurantView)
        restaurantView.fillsuperView()
    }
    
    
    //MARK:  ViewController life cycles
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor.darkOrange()
        self.title = saveTitle
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.title = ""
    }
    
    
    //MARK:  Define Views
    lazy var restaurantView: RestaurantView = {
        let restaurantView = RestaurantView(frame: .zero, viewModelDelegate: viewModel)
        restaurantView.translatesAutoresizingMaskIntoConstraints = false
        restaurantView.collectionView.register(UINib(nibName: "RestaurantCell", bundle: nil), forCellWithReuseIdentifier: RestaurantCell.cellIdentifier)
        return restaurantView
    }()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print("deinit - MapBaseViewController")
    }
}



//MARK: RestaurantVCDelegate
extension MapBaseViewController: RestaurantVCDelegate {

    
    //Goto Store Detail screen
    @objc func storeDetail(indexPath: IndexPath) {
        print("storeDetail")
        
        let testViewModel = RestaurantViewModel(items: [], searchStoreService: SearchStoreService(), locationService: LocationService())        
//        let testVC = TestVC2(title: "TestVC 2", viewModel: testViewModel)
        let testVC = TestVC(title: "Test VC", viewModel: testViewModel)
        self.navigationController?.pushViewController(testVC, animated: true)
    }
    
    //Order Now Button Pressed
    @objc func orderNow(indexPath: IndexPath) {        
        let alertStyle: UIAlertController.Style = UIDevice.current.userInterfaceIdiom == .phone ? .actionSheet : .alert
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: alertStyle)
        //Alert Actions
        let driveThru = UIAlertAction(title: "Drive Thru", style: .default, handler: nil)
        let dineIn = UIAlertAction(title: "Dine In", style: .default)
        let takeOut = UIAlertAction(title: "Take Out", style: .default)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        // Add the alert actions
        alertController.addAction(driveThru)
        alertController.addAction(dineIn)
        alertController.addAction(takeOut)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
}
