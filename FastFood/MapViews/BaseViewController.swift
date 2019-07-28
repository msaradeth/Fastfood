//
//  BaseViewController.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/28/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    var saveTitle: String?
    
    //MARK:  init
    init(title: String? = nil, tabBarItem: UITabBarItem? = nil, showSettings: Bool = false) {
        self.saveTitle = title
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .white
        
        //update if not nil
        if let title = title {
            self.navigationItem.titleView = TitleView(title: title)
        }
        if let tabBarItem = tabBarItem {
            self.tabBarItem = tabBarItem
        }
        if showSettings {
            self.addSettingsButton()
        }
    }
    
    //MARK:  viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor.darkOrange()
        self.title = saveTitle
    }
    
    //MARK:  viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.title = ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
