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
    var title: String?
    var image: UIImage?
    var uid: String?
    init(title: String, subtitle: String, address: String, coordinate: CLLocationCoordinate2D, uid: String?){
        self.title = title
        self.subtitle = subtitle
        self.address = address
        self.coordinate = coordinate
        self.uid = uid
    }
    
    
}
