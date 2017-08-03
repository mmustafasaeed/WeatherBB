//
//  WeatherCell.swift
//  WeatherBB
//
//  Created by Mustafa Saeed on 8/3/17.
//  Copyright © 2017 Mustafa Saeed. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {

    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherDay: UILabel!
    @IBOutlet weak var weatherMainType: UILabel!
    @IBOutlet weak var weatherMinTemp: UILabel!
    @IBOutlet weak var weatherMaxTemp: UILabel!
    
    func configureCell(forecast: Forecast) {
        weatherMaxTemp.text = "\(forecast.lowTemp)"
        weatherMinTemp.text = "\(forecast.highTemp)"
        weatherMainType.text = forecast.weatherType
        weatherImage.image = UIImage(named: forecast.weatherType)
        weatherDay.text = forecast.date
    }

}
