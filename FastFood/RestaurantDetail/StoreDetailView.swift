//
//  StoreDetailView.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/24/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit

class StoreDetailView: UIStackView {
    lazy var dineInHours: WeekOpen? = {
        let dineInHours = WeekOpen(title: "Dine In Hours", hours: self.storeDetail.hours)
        dineInHours?.translatesAutoresizingMaskIntoConstraints = false
        return dineInHours
    }()
    lazy var driveThruHours: WeekOpen? = {
        let driveThruHours = WeekOpen(title: "Dine In Hours", hours: self.storeDetail.hours)
        driveThruHours?.translatesAutoresizingMaskIntoConstraints = false
        return driveThruHours
    }()
    var storeDetail: StoreDetail
    
    init(storeDetail: StoreDetail) {
        self.storeDetail = storeDetail
        super.init(frame: .zero)
        if let dineInHours = self.dineInHours {
            addArrangedSubview(dineInHours)
        }
        if let driveThruHours = self.driveThruHours {
            addArrangedSubview(driveThruHours)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class WeekOpen: UIStackView {
    var titleLabel: UILabel = {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .left
        titleLabel.heightAnchor.constraint(equalToConstant: 60)
        return titleLabel
    }()
    var title: String
    var hours: [Hours]
    
    init?(title: String, hours: [Hours]?) {
        guard let hours = hours else { return nil }
        self.title = title
        self.hours = hours
        super.init(frame: .zero)
        
        titleLabel.text = title
        addArrangedSubview(titleLabel)
        for hour in hours {
            for open in hour.open {
                addArrangedSubview(DayOpen(open: open))
            }
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class DayOpen: UIStackView {
    lazy var dayOpenLabel: UILabel = {
        let dayOpenLabel = UILabel(frame: .zero)
        dayOpenLabel.translatesAutoresizingMaskIntoConstraints = false
        dayOpenLabel.textAlignment = .left
        dayOpenLabel.text = self.dayOfWeek
        return dayOpenLabel
    }()
    lazy var hoursOpenLabel: UILabel = {
        let hoursOpenLabel = UILabel(frame: .zero)
        hoursOpenLabel.translatesAutoresizingMaskIntoConstraints = false
        hoursOpenLabel.textAlignment = .right
        hoursOpenLabel.text = self.hoursOpen
        return hoursOpenLabel
    }()
    var dayOfWeek: String
    var hoursOpen: String
    
    init(open: Open) {
        self.dayOfWeek = String(open.day)
        self.hoursOpen = "\(open.start) - \(open.end)"
        super.init(frame: .zero)
        self.heightAnchor.constraint(equalToConstant: 40)
        self.axis = .horizontal
        addArrangedSubview(dayOpenLabel)
        addArrangedSubview(hoursOpenLabel)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
