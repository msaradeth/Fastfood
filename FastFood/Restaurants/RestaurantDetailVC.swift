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

    init(title: String, indexPath: IndexPath, viewModel: ViewModelDelegate?) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
        self.view.backgroundColor = .white
        
        //load and update store detail
        viewModel?.loadStoreDetail(indexPath: indexPath, completion: { (storeDetail) in
            DispatchQueue.main.async {
                print(storeDetail)
            }
        })
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
