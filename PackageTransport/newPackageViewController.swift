 //
//  newPackageController.swift
//  PackageTransport
//
//  Created by Parabsimran Litt on 9/11/15.
//  Copyright © 2015 David Jimenez. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
 
class newPackageViewController: UIViewController, CLLocationManagerDelegate {
    
    //variables for getting current location
    var locationManager = CLLocationManager()
    var myPosition = CLLocationCoordinate2D()
    var locCoord = CLLocationCoordinate2D()
    
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
    
    //package location map
    @IBOutlet weak var PackageLocationMapView: MKMapView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //request authorization and start updating location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        //making sure labels aren't empty
        if packageLocation != "" && packageDetails != "" {
            PackageLocationLabel.text = packageLocation
            PackageDetailsLabel.text = packageDetails
        }
        
    }
    //setting up segues
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
        
        //getting current location and stopping location update
        myPosition = newLocation.coordinate
        locationManager.stopUpdatingLocation()
        
        LocationLabel.text = " \(newLocation.coordinate.latitude) , \(newLocation.coordinate.longitude) "
        
        //setting the zoom on current location
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(newLocation.coordinate, span)
        PackageLocationMapView.setRegion(region, animated: true)
        
        //dropping a pin on current location
        let locCoord = myPosition
        let annotation = MKPointAnnotation()
        annotation.coordinate = locCoord
        annotation.title = "My Location"
        annotation.subtitle = "Pickup Location"
        PackageLocationMapView.addAnnotation(annotation)
        
    }
    
}
