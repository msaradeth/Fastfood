//
//  TitleView.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/24/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit

enum TitleFonTSize {
    case normal
    case large
    case xLarge
    
    func getFont() -> UIFont {
        switch self {
        case .large:
            return UIFont.systemFont(ofSize: 23, weight: .bold)
        case .xLarge:
            return UIFont.systemFont(ofSize: 25, weight: .bold)
        default:
            return UIFont.systemFont(ofSize: 17, weight: .bold)
        }
    }
}

class TitleView: UIView {
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    init(title: String, fontSize: TitleFonTSize = .normal, textColor: UIColor = UIColor.darkOrange()) {
        super.init(frame: .zero)
        self.addSubview(titleLabel)
        titleLabel.fillsuperView()
        titleLabel.text = title
        titleLabel.textColor = textColor
        titleLabel.font = fontSize.getFont()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
