//
//  TabBarController.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/17/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    init(viewControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = viewControllers
        
        //set TabBar theme
        UITabBarController.updateTheme()
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
