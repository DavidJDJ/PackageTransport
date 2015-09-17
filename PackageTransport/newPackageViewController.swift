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
 
class newPackageViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate {
    
    //variables for getting current location
    var locationManager = CLLocationManager()
    var myPosition = CLLocationCoordinate2D()
    var locCoord = CLLocationCoordinate2D()
    
    //variables for performing map searches
    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation = MKPointAnnotation()
    var pinAnnotationView:MKPinAnnotationView!
    
    @IBAction func addNewPackageNextButton(sender: UIBarButtonItem) {
        print(pointAnnotation.coordinate.longitude.hashValue)
        if pointAnnotation.coordinate.longitude.hashValue != 0 && PackageLocationTextField.text != "" {
            performSegueWithIdentifier("PackageLocationNextButton", sender: nil)
        }
    }
    //label and button for showing coordinates
    
    @IBOutlet weak var LocationLabel: UILabel!
    
    @IBAction func getLocationButtonPressed(sender: UIButton) {
        locationManager.startUpdatingLocation()
    }
    
    //variables for package location and details
    var packageLocation: String = ""
    @IBOutlet weak var PackageLocationTextField: UITextField!
    
    //package location map
    @IBOutlet weak var PackageLocationMapView: MKMapView!
    
    @IBAction func showSearchBar(sender: AnyObject) {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        presentViewController(searchController, animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //request authorization and start updating location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        
    }
    //setting up segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PackageLocationNextButton" {
           
            let controller = segue.destinationViewController as! UINavigationController
            
            let addEventViewController = controller.topViewController as! newPackageConfirmationViewController
            
            addEventViewController.pickup = myPosition
           
            addEventViewController.dropoff = pointAnnotation.coordinate
             print("testing")
//            print(myPosition)
//            print(pointAnnotation.coordinate)
            
            addEventViewController.packageLocation = PackageLocationTextField.text!
            
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
    
    //function to perform search using search bar
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        //if pin already exists remove current pin
        searchBar.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
        if self.PackageLocationMapView.annotations.count != 0{
            annotation = self.PackageLocationMapView.annotations[0] as! MKAnnotation
            self.PackageLocationMapView.removeAnnotation(annotation)
            print("testing remove")
        }
        //convert to natural language query
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                var alert = UIAlertView(title: nil, message: "Place not found", delegate: self, cancelButtonTitle: "Try again")
                alert.show()
                return
            }
            //if search is a vaild 2d point, drop a pin on that specific long and lat
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.PackageLocationMapView.centerCoordinate = self.pointAnnotation.coordinate
            self.PackageLocationMapView.addAnnotation(self.pinAnnotationView.annotation!)
            
        }
    }
}
