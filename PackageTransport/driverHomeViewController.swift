//
//  driverHomeViewController.swift
//  PackageTransport
//
//  Created by David Jimenez on 9/14/15.
//  Copyright © 2015 David Jimenez. All rights reserved.
//

import Foundation
import UIKit

class driverHomeViewController: UIViewController {
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var StartTimeLabel: UILabel!
    @IBOutlet weak var EndTimeLabel: UILabel!
    
    @IBAction func startTimeTextField(sender: UITextField) {
    }
    
    @IBAction func endTimeTextField(sender: UITextField) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.parentViewController!.view.backgroundColor = UIColor.lightGrayColor()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
}