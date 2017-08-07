//
//  DragAnnotation.swift
//  WeatherBB
//
//  Created by Mustafa Saeed on 8/7/17.
//  Copyright © 2017 Mustafa Saeed. All rights reserved.
//

import UIKit
import MapKit

class DragAnnotation: NSObject, MKAnnotation {
    dynamic var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String? = nil, subtitle: String? = nil) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        super.init()
    }
}
