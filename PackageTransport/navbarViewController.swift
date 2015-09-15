//
//  navbarViewController.swift
//  PackageTransport
//
//  Created by David Jimenez on 9/14/15.
//  Copyright © 2015 David Jimenez. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class navbarViewController: UITableViewController {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var users: [User]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userRequest = NSFetchRequest(entityName: "User")

        do {
            users = try managedObjectContext.executeFetchRequest(userRequest) as? [User]
        } catch let error as NSError {
            print(error)
        }
    }

 
     override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 1 {
            if users?.first?.type == "user" {
                performSegueWithIdentifier("navbarToHome", sender: nil)
            } else if users?.first?.type == "driver" {
                performSegueWithIdentifier("navbarToDriverHome", sender: nil)
            } else if users?.first?.type == nil {
                performSegueWithIdentifier("navbarLogin", sender: nil)
            }
        }
        
        
        if indexPath.row == 4 {
            
            for user in users! {
                    print("\(user.firstName) - \(user.email)")
                    managedObjectContext.deleteObject(user)

                    do {
                        try managedObjectContext.save()
                    } catch let error as NSError {
                        print(error)
                    }
                    
                }

            
            print("succesfully logged out")
            
            performSegueWithIdentifier("navbarLogin", sender: nil)
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
}
