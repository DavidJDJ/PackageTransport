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

class loginViewController: UITableViewController, UITextFieldDelegate {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    
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
                print("\(user.firstName) - \(user.email) - \(user.type)")
            }
//            print(users)
        } catch let error as NSError {
            print(error)
        }
        
        emailLabel.delegate = self
        passwordLabel.delegate = self
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.emailLabel {
            self.passwordLabel.becomeFirstResponder()
        } else if textField == self.passwordLabel {
            self.passwordLabel.resignFirstResponder()
        }
        return true
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    @IBAction func loginButtonPressed(sender: UIButton) {
        
        if !isValidEmail(emailLabel.text!) {
            emailErrorLabel.text = "Invalid email"
            print("incorrect")
        } else {
            
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
            
            emailErrorLabel.text = ""
            if let urlToReq = NSURL(string: "http://192.168.1.165:8000/user/find") {
                let request : NSMutableURLRequest = NSMutableURLRequest(URL: urlToReq)
                let session = NSURLSession.sharedSession()
                request.HTTPMethod = "POST"
                
                 let params = ["email": emailLabel.text?.lowercaseString, "password": passwordLabel.text] as Dictionary<String, String!>
                
                do {
                    request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
                } catch let error as NSError {
                    print(error)
                }
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                
                let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in

                 
                    func parseJSON(inputData: NSData) -> NSDictionary {
                        var arrOfObjects: NSDictionary?
                        do {
                            arrOfObjects = try NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                        } catch let error as NSError {
                            print(error)
                        }
                        return arrOfObjects!
                    }
                    
                    let answer = parseJSON(data!)
                    
                    if answer["error"] != nil {
                        dispatch_async(dispatch_get_main_queue(), {
                            let alert = UIAlertController(title: "Error", message: answer["error"]! as? String, preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                            self.presentViewController(alert, animated: true, completion: nil)
                            self.passwordLabel.text = ""
                        })
                    } else {
                        let entity = NSEntityDescription.entityForName("User", inManagedObjectContext: self.managedObjectContext)
                        let user = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: self.managedObjectContext)
                        
                        user.setValue(answer["_id"]!, forKey: "id")
                        user.setValue(answer["email"]!, forKey: "email")
                        user.setValue(answer["firstName"]!, forKey: "firstName")
                        user.setValue(answer["lastName"]!, forKey: "lastName")
                        user.setValue(answer["type"]!, forKey: "type")
                        
                        var succesfullSave = true
                        
                        do {
                            try self.managedObjectContext.save()
                        } catch let saveError as NSError {
                            print(saveError)
                            succesfullSave = false
                        }
                        
                        print(answer)
                        
                        if succesfullSave == true {
                            dispatch_async(dispatch_get_main_queue()) {
                                self.performSegueWithIdentifier("loginToHome", sender: nil)

                            }
                            
                        }
                    }
                    
                    
                })
                
                task.resume()
                
                
            }
        }
        
    }
    
}