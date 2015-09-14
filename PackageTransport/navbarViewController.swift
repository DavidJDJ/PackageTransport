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

 
     override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 4 {
            
            let userRequest = NSFetchRequest(entityName: "User")
            do {
                let users = try managedObjectContext.executeFetchRequest(userRequest) as? [User]
                for user in users! {
                    print("\(user.firstName) - \(user.email)")
                    managedObjectContext.deleteObject(user)

                    do {
                        try managedObjectContext.save()
                    } catch let error as NSError {
                        print(error)
                    }
                    
                }
            } catch let error as NSError {
                print(error)
            }
            
            print("succesfully logged out")
            
            performSegueWithIdentifier("navbarLogin", sender: nil)
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
}
