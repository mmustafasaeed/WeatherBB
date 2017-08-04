//
//  WeatherCardCell.swift
//  WeatherBB
//
//  Created by Mustafa Saeed on 8/4/17.
//  Copyright © 2017 Mustafa Saeed. All rights reserved.
//

import UIKit

class WeatherCardCell: UICollectionViewCell {
    
    static let identifier = "weatherCard"
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var maxtemp: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var containerView: UIView!
    override func layoutSubviews() {
        super.layoutSubviews()
        
        containerView.layer.cornerRadius = 6
        contentView.layer.cornerRadius = 6
        
        // Add shadow
        contentView.layer.shadowColor = UIColor.black.withAlphaComponent(0.8).cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowOpacity = 1
        contentView.layer.shadowRadius = 1
        contentView.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 6).cgPath
    }
    
    func setupFromInvite() {
        
        let amountFormatter = NumberFormatter.WeatherBBAmountNumberFormatter()
        let dreamDetails = NSMutableAttributedString()
        let fontSize = CGFloat(14)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM YYYY"
        
        setNeedsLayout()
    }

    
}
