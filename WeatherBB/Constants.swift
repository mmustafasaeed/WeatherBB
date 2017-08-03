//
//  Constants.swift
//  WeatherBB
//
//  Created by Mustafa Saeed on 8/3/17.
//  Copyright © 2017 Mustafa Saeed. All rights reserved.
//

import UIKit

import Foundation

let BASE_URL = "http://api.openweathermap.org/data/2.5/weather?"
let LATITUDE = "lat="
let LONGITUDE = "&lon="
let APP_ID = "&appid="
let API_KEY = "c6e381d8c7ff98f0fee43775817cf6ad"

typealias DownloadComplete = () -> ()

let CURRENT_WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather?lat=\(Location.sharedInstance.latitude!)&lon=\(Location.sharedInstance.longitude!)&appid=c6e381d8c7ff98f0fee43775817cf6ad"
let FORECAST_URL = "http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(Location.sharedInstance.latitude!)&lon=\(Location.sharedInstance.longitude!)&cnt=10&mode=json&appid=c6e381d8c7ff98f0fee43775817cf6ad"
