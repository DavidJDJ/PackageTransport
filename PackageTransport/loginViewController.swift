//
//  loginViewController.swift
//  PackageTransport
//
//  Created by David Jimenez on 9/10/15.
//  Copyright © 2015 David Jimenez. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class loginViewController: UITableViewController {
    
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
//            print(users)
        } catch let error as NSError {
            print(error)
        }
    }
}