 //
//  newPackageController.swift
//  PackageTransport
//
//  Created by Parabsimran Litt on 9/11/15.
//  Copyright © 2015 David Jimenez. All rights reserved.
//

import UIKit
 
class newPackageViewController: UIViewController {
    var packageLocation: String = ""
    var packageDetails: String = ""
    
    @IBOutlet weak var PackageLocationTextField: UITextField!
    
    @IBOutlet weak var PackageDetailsTextField: UITextField!
    
    @IBOutlet weak var PackageLocationLabel: UILabel!
    @IBOutlet weak var PackageDetailsLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if packageLocation != "" && packageDetails != "" {
            PackageLocationLabel.text = packageLocation
            PackageDetailsLabel.text = packageDetails
        }
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PackageLocationNextButton" {
            var controller = segue.destinationViewController as! UINavigationController
            let addEventViewController = controller.topViewController as! newPackageViewController
            addEventViewController.packageLocation = PackageLocationTextField.text!
        } else if segue.identifier == "PackageDetailsNextButton" {
            var controller = segue.destinationViewController as! UINavigationController
            let addEventViewController = controller.topViewController as! newPackageViewController
            addEventViewController.packageLocation = packageLocation
            addEventViewController.packageDetails = PackageDetailsTextField.text!
        }
    }
    
}
