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
    var providerUID: String?
    var storageUID: String?
    init(title: Int, subtitle: String, address: String, coordinate: CLLocationCoordinate2D, providerUID: String?, storageUID: String?, price: String?){
        let priceInt = title
        var finalPriceRoundedString = "$ "
        finalPriceRoundedString += String(describing: priceInt)
            

        self.title = finalPriceRoundedString
        
//        self.title = title
        self.subtitle = subtitle
        self.address = address
        self.coordinate = coordinate
        self.providerUID = providerUID
        self.storageUID = storageUID
//        self.description = price!
    }
    
    
}
