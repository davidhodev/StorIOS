//
//  Annotations.swift
//  Stor
//
//  Created by David Ho on 5/28/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import MapKit
class Annotations: NSObject, MKAnnotation{
    var subtitle: String?
    var address: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, subtitle: String, address: String, coordinate: CLLocationCoordinate2D){
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
    
}
