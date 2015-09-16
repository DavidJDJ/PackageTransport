 //
//  newPackageController.swift
//  PackageTransport
//
//  Created by Parabsimran Litt on 9/11/15.
//  Copyright © 2015 David Jimenez. All rights reserved.
//

import UIKit
import CoreLocation
 
class newPackageViewController: UIViewController, CLLocationManagerDelegate {
    
    //variables for getting current location
    var locationManager = CLLocationManager()
    var myPosition = CLLocationCoordinate2D()
    
    //label and button for showing coordinates
    
    @IBOutlet weak var LocationLabel: UILabel!
    
    @IBAction func getLocationButtonPressed(sender: UIButton) {
        
        locationManager.startUpdatingLocation()
    }
    
    //variables for package location and details
    var packageLocation: String = ""
    var packageDetails: String = ""
    @IBOutlet weak var PackageLocationTextField: UITextField!
    @IBOutlet weak var PackageDetailsTextField: UITextField!
    @IBOutlet weak var PackageLocationLabel: UILabel!
    @IBOutlet weak var PackageDetailsLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        if packageLocation != "" && packageDetails != "" {
            PackageLocationLabel.text = packageLocation
            PackageDetailsLabel.text = packageDetails
        }
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PackageLocationNextButton" {
            let controller = segue.destinationViewController as! UINavigationController
            let addEventViewController = controller.topViewController as! newPackageViewController
            addEventViewController.packageLocation = PackageLocationTextField.text!
        } else if segue.identifier == "PackageDetailsNextButton" {
            let controller = segue.destinationViewController as! UINavigationController
            let addEventViewController = controller.topViewController as! newPackageViewController
            addEventViewController.packageLocation = packageLocation
            addEventViewController.packageDetails = PackageDetailsTextField.text!
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        myPosition = newLocation.coordinate
        locationManager.stopUpdatingLocation()
        
        LocationLabel.text = " \(newLocation.coordinate.latitude) , \(newLocation.coordinate.longitude) "
        
        
    }
    
}
