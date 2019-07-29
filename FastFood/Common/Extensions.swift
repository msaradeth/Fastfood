//
//  Extensions.swift
//  TheMovie
//
//  Created by Mike Saradeth on 6/15/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation
import UIKit

//MARK:  UIView extension
extension UIView {
    func fillsuperView(padding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) {
        guard let superview = superview else { return }
        topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: padding.top).isActive = true
        leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor, constant: padding.left).isActive = true
        trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor, constant: padding.right).isActive = true
        bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: padding.bottom).isActive = true
    }
    
    func pinTo(view: UIView, top: CGFloat? = nil, left: CGFloat? = nil, right: CGFloat? = nil, bottom: CGFloat? = nil) {
        if let top = top {
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: top).isActive = true
        }
        if let left = left {
            leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: left).isActive = true
        }
        if let right = right {
            trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -right).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -bottom).isActive = true
        }
    }
}


//MARK:  UICollectionView extension
extension UICollectionView {
    //MARK: Get cell Width base on number of columns
    func getCellWidth(numberOfColumns: Int) -> CGFloat {
        let availableWidth = getAvailableWidth(numberOfColumns: numberOfColumns)
        
        //available width divided by number of columns
        let cellWidth = availableWidth / CGFloat(numberOfColumns)
        
        return cellWidth > 0 ? cellWidth : 0
    }
    
    //Mark: Get available width
    func getAvailableWidth(numberOfColumns: Int) -> CGFloat {
        let numberOfColumns = CGFloat(numberOfColumns)
        
        //calc available width minus safeAreaInsets
        var availableWidth = self.bounds.width - (self.safeAreaInsets.left + self.safeAreaInsets.right)
        
        //available width minus FlowLayout settings
        if let flowLayout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            availableWidth = availableWidth - (flowLayout.minimumInteritemSpacing*numberOfColumns + flowLayout.sectionInset.left + flowLayout.sectionInset.right)
        }
        
        return availableWidth > 0 ? availableWidth : 0
    }
}


//MARK:  UITabBarController extension
extension UITabBarController {
    static func updateTheme() {
        let appearance = UITabBarItem.appearance()
        let attributes =  [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 13, weight: .bold)]
        appearance.setTitleTextAttributes(attributes, for: .normal)
        UITabBar.appearance().tintColor = UIColor.darkOrange()
    }
}

//MARK:  UIImageView extension
extension UIImageView {
    func rounded() {
        self.layer.borderWidth = 0.3 
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = self.frame.height/2 //This
        self.clipsToBounds = true
    }
}

//MARK:  UISearchBar extension
extension UISearchBar {
    func setDefaultAppearance() {
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.blue]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = attributes
    }
}


//MARK:  UINavigationBar extension
extension UIColor {
    static func darkRed() -> UIColor {
        return UIColor(red:248/255, green:20/255, blue:20/255, alpha:1.0)
    }
    static func darkOrange() -> UIColor {
        return UIColor(red:0.82, green:0.35, blue:0.09, alpha:1.0)
    }
}


//MARK:  UIViewController extension
extension UIViewController {
    //Add setting image to top left of Navigation Bar
    func addSettingsButton() {
        let settingButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Settings"), style: .plain, target: self, action: #selector(settingsPressed))
        settingButton.tintColor = .darkGray
        
        self.navigationItem.leftBarButtonItem = settingButton
    }
    
    @objc func settingsPressed() {
        self.showAlert(title: "Settings", message: "Not Implemented", alertActionTitle: "Continue")
    }
    
    //Helper function to show simple alert message
    func showAlert(style: UIAlertController.Style = .alert, title: String, message: String, alertActionTitle: String, alertHandler: ((UIAlertAction)->Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        //Alert Actions
        let alertAction = UIAlertAction(title: alertActionTitle, style: .cancel, handler: alertHandler)
        
        // Add the alert actions
        alertController.addAction(alertAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //Order Now Button Pressed
    func showOrderNow(indexPath: IndexPath) {
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
    
    func showMobilOrRestaurantOrder(indexPath: IndexPath) {
        let style: UIAlertController.Style = UIDevice.current.userInterfaceIdiom == .phone ? .actionSheet: .alert
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: style)
        
        //alert action
        let mobileOrder = UIAlertAction(title: "Mobile Order", style: .default, handler: nil)
        let restaurantOrder = UIAlertAction(title: "Restaurant Order", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        //add alert actions
        alertController.addAction(mobileOrder)
        alertController.addAction(restaurantOrder)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}


