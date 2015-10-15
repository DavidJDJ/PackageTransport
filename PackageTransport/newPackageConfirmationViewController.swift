//
//  newPackageConfirmationViewController.swift
//  PackageTransport
//
//  Created by Parabsimran Litt on 9/16/15.
//  Copyright © 2015 David Jimenez. All rights reserved.
//

import UIKit
import CoreLocation

class newPackageConfirmationViewController: UIViewController {
    
    @IBOutlet weak var PickupLabel: UILabel!
    @IBOutlet weak var DropoffLabel: UILabel!
    @IBOutlet weak var PackageLocationLabel: UILabel!
    
    
    var pickup = CLLocationCoordinate2D()
    var dropoff = CLLocationCoordinate2D()
    var packageLocation: String = ""
    
    override func viewDidLoad() {
        print(pickup)
        PickupLabel.text = String(format: "pickup: %.2f, %.2f", pickup.longitude, pickup.latitude)
        print(dropoff)
        DropoffLabel.text = String(format: "dropoff: %.2f, %.2f", dropoff.longitude, dropoff.latitude)
        print(packageLocation)
        PackageLocationLabel.text = packageLocation
    }
    
    
    
}
