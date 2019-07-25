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
    lazy var storeDetailView: StoreDetailView = {
        let storeDetailView = StoreDetailView(frame: UIScreen.main.bounds)
//        var storeDetailView = StoreDetailView.instanceFromNib()
        return storeDetailView
    }()
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    
    init(title: String, indexPath: IndexPath, viewModel: ViewModelDelegate?) {
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.titleView = TitleView(title: title)
        self.view.backgroundColor = .white
        self.setupviews()
        
        //load and update store detail
        viewModel?.loadStoreDetail(indexPath: indexPath, completion: { (storeDetail) in
            DispatchQueue.main.async {
                print(storeDetail)
            }
        })
    }
    
    private func setupviews() {
        DispatchQueue.main.async {
            var view = StoreDetailView.instanceFromNib()
            self.view.addSubview(view)
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

//            let view = Bundle.main.loadNibNamed("StoreDetailView", owner: self, options: nil)
////            let storeDetailView = StoreDetailView(frame: self.view.frame)
//            self.view.addSubview(view)
//            storeDetailView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        
//        self.view.addSubview(scrollView)
//        scrollView.fillsuperView()
//        scrollView.addSubview(stackView)
//        stackView.fillsuperView()
//        stackView.addSubview(storeDetailView)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
