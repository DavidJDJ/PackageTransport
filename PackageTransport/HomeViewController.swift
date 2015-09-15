//
//  HomeViewController.swift
//  PackageTransport
//
//  Created by David Jimenez on 9/10/15.
//  Copyright © 2015 David Jimenez. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class HomeViewController: UITableViewController, CancelButtonDelegate {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        let userRequest = NSFetchRequest(entityName: "User")
        do {
            let users = try managedObjectContext.executeFetchRequest(userRequest) as? [User]
            for user in users! {
                print("\(user.firstName) - \(user.email)")
            }
        } catch let error as NSError {
            print(error)
        }
        
    }
    //cancel button delegate requirement to dismiss the view controller
    func cancelButtonPressedFrom(controller: UIViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    //addnewpackage segue to cancel
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddNewPackage" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! newPackageViewController
            controller.cancelButtonDelegate = self
        }
    }
}