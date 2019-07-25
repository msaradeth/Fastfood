//
//  StoreDetailView.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/24/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit

class StoreDetailView: UIView {

    @IBOutlet weak var dineInMonday: UILabel!
    @IBOutlet weak var dineTuesday: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        loadViewFromNib ()
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "StoreDetailView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    func loadViewFromNib() {
//        let bundle = Bundle(forClass: type(of: self))
//        let nib = UINib(nibName: "SimpleCustomView", bundle: bundle)
//        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
//        view.frame = bounds
//        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
//        self.addSubview(view);
        
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
////        Bundle.main.loadNibNamed("StoreDetailView", owner: self, options: nil)
////        self.addSubview(view);    // adding the top level view to the view hierarchy
//    }
//
//    required init?(coder aDecoder: NSCoder) {
////        fatalError("init(coder:) has not been implemented")
//    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
