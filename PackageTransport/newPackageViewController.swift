 //
//  newPackageController.swift
//  PackageTransport
//
//  Created by Parabsimran Litt on 9/11/15.
//  Copyright © 2015 David Jimenez. All rights reserved.
//

import UIKit
 
 protocol CancelButtonDelegate: class {
    func cancelButtonPressedFrom(controller: UIViewController)
 }
 
class newPackageViewController: UIViewController {
    
    weak var cancelButtonDelegate: CancelButtonDelegate?
    
    
    //cancel button action
    @IBAction func cancelBarButtonPressed(sender: UIBarButtonItem) {
        cancelButtonDelegate?.cancelButtonPressedFrom(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("testing")
    }
    
}
