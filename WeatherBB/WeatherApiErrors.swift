//
//  WeatherApiErrors.swift
//  WeatherBB
//
//  Created by Mustafa Saeed on 8/12/17.
//  Copyright © 2017 Mustafa Saeed. All rights reserved.
//

import Foundation

enum WeatherApiErrors: Error {
    
    case requestFailed
    case responseUnsuccessful
    case invalidData
    case jsonConversionFailure
    case invalidUrl
    case jsonParsingFailure
}
