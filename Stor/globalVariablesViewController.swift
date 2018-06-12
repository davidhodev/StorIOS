//
//  globalVariablesViewController.swift
//  Stor
//
//  Created by David Ho on 5/24/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit
import CoreLocation

class globalVariablesViewController: UIViewController {

    static var username = String()
    static var profilePicString = String()
    static var ratingNumber = NSNumber()
    static var profilePicData = Data()
    static var currentLocation: CLLocation?
    static var priceFilter: Float?
    static var buttonOn: Int?
}
