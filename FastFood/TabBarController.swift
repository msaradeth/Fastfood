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
        let appearance = UITabBarItem.appearance()
        let attributes =  [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 13, weight: .bold)]
        appearance.setTitleTextAttributes(attributes, for: .normal)
        UITabBar.appearance().tintColor = UIColor.orange
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
