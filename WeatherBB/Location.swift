//
//  Location.swift
//  WeatherBB
//
//  Created by Mustafa Saeed on 8/3/17.
//  Copyright © 2017 Mustafa Saeed. All rights reserved.
//

import CoreLocation

class Location {
    static var sharedInstance = Location()
    private init() {}
    
    var latitude: Double!
    var longitude: Double!
}
