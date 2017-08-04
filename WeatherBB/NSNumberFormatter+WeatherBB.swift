//
//  NSNumberFormatter+WeatherBB.swift
//  WeatherBB
//
//  Created by Mustafa Saeed on 8/4/17.
//  Copyright © 2017 Mustafa Saeed. All rights reserved.
//

import UIKit

extension NumberFormatter {
    
    class func WeatherBBAmountNumberFormatter() -> NumberFormatter {
        
        let nf = NumberFormatter()
        nf.groupingSeparator = " "
        nf.groupingSize = 3
        nf.usesGroupingSeparator = true
        nf.minimumIntegerDigits = 1
        return nf
    }
}
