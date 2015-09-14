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
 
     override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 4 {
            
            performSegueWithIdentifier("navbarLogin", sender: nil)
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
}
