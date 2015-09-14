//
//  welcomeViewController.swift
//  PackageTransport
//
//  Created by David Jimenez on 9/14/15.
//  Copyright © 2015 David Jimenez. All rights reserved.
//

import Foundation

class welcomeViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var beginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.welcomeLabel.alpha = 0
        self.messageLabel.alpha = 0
        self.messageLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
        self.beginButton.alpha = 0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animateWithDuration(1.5, animations: {
            self.welcomeLabel.alpha = 1.0
            return
        }, completion: nil)
        
        UIView.animateWithDuration(1.5, delay: 2, options: [], animations: {
            self.welcomeLabel.frame = CGRectMake(self.welcomeLabel.frame.minX, self.welcomeLabel.frame.minY - 50, self.welcomeLabel.frame.width, self.welcomeLabel.frame.height)
            self.beginButton.alpha = 1.0
        }, completion: nil)
        UIView.animateWithDuration(1.5, delay: 3.5, options: [], animations: {
            self.messageLabel.alpha = 1.0
        }, completion: nil)
    }
    

}