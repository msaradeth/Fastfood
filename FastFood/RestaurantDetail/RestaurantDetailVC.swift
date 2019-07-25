//
//  RestaurantDetailVC.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/24/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation
import UIKit

class RestaurantDetailVC: UIViewController {
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    var storeDetail: StoreDetail!
    
    init(title: String, indexPath: IndexPath, viewModel: ViewModelDelegate?) {
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.titleView = TitleView(title: title)
        self.view.backgroundColor = .white
        
        //load and update store detail
        viewModel?.loadStoreDetail(indexPath: indexPath, completion: { [weak self] (storeDetail) in
            guard let self = self else { return }
            self.storeDetail = storeDetail
            self.setupViews(storeDetail: storeDetail)
            DispatchQueue.main.async {
                print(storeDetail)
            }
        })
    }
    
    private func setupViews(storeDetail: StoreDetail) {
        self.view.addSubview(self.scrollView)
        self.scrollView.fillsuperView()
        
        let storeDetailView = StoreDetailView(storeDetail: storeDetail)
        storeDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        self.scrollView.addSubview(storeDetailView)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
}
