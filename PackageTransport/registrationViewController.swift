//
//  registrationViewController.swift
//  PackageTransport
//
//  Created by David Jimenez on 9/10/15.
//  Copyright © 2015 David Jimenez. All rights reserved.
//

import Foundation
import UIKit

class registrationViewController: UIViewController {
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
}