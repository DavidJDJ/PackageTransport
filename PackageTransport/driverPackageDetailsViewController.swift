//
//  driverPackageDetails.swift
//  PackageTransport
//
//  Created by Parabsimran Litt on 9/18/15.
//  Copyright © 2015 David Jimenez. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class driverPackageDetailsViewController: UIViewController {
    
    @IBOutlet weak var DriverPickupLabel: UILabel!
    @IBOutlet weak var DriverDropoffLabel: UILabel!
    
    @IBOutlet weak var DriverPackageDetailsMap: MKMapView!
    
    @IBOutlet weak var DriverPackageDetailsLabel: UILabel!
    
    override func viewDidLoad() {
        
    }
}