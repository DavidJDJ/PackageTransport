//
//  registrationViewController.swift
//  PackageTransport
//
//  Created by David Jimenez on 9/10/15.
//  Copyright © 2015 David Jimenez. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class registrationViewController: UITableViewController, UITextFieldDelegate {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var typeSegmentControl: UISegmentedControl!
    @IBOutlet weak var firstNameErrorLabel: UILabel!
    @IBOutlet weak var lastNameErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var confirmPasswordErrorLabel: UILabel!
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.firstNameTextField {
            self.lastNameTextField.becomeFirstResponder()
        } else if textField == self.lastNameTextField {
            self.emailTextField.becomeFirstResponder()
        } else if textField == self.emailTextField {
            self.passwordTextField.becomeFirstResponder()
        } else if textField == self.passwordTextField {
            self.confirmPasswordTextField.becomeFirstResponder()
        } else if textField == self.confirmPasswordTextField {
            self.confirmPasswordTextField.resignFirstResponder()
        }
        return true
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.parentViewController!.view.backgroundColor = UIColor.lightGrayColor()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == confirmPasswordTextField {
            if confirmPasswordTextField.text != passwordTextField.text {
                confirmPasswordErrorLabel.text = "Passwords don't match"
            } else {
                confirmPasswordErrorLabel.text = ""
            }
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    

    @IBAction func registerButtonPressed(sender: UIButton) {
        
        var error = false
        if firstNameTextField.text == "" {
            firstNameErrorLabel.text = "Can not be empty"
            error = true
        } else {
            firstNameErrorLabel.text = ""
        }
        if lastNameTextField.text == "" {
            lastNameErrorLabel.text = "Can not be empty"
            error = true
        } else {
            lastNameErrorLabel.text = ""
        }
        if !isValidEmail(emailTextField.text!) {
            emailErrorLabel.text = "Invalid email"
            error = true
        } else {
            emailErrorLabel.text = ""
        }
        if passwordTextField.text!.characters.count < 7 {
            passwordErrorLabel.text = "Password too short"
            error = true
        } else {
            passwordErrorLabel.text = ""
        }
        if passwordTextField.text != confirmPasswordTextField.text {
            confirmPasswordErrorLabel.text = "Passwords don't match"
            error = true
        } else {
            confirmPasswordErrorLabel.text = ""
        }
        
        if error == false {
            var type: String?
            if typeSegmentControl.selectedSegmentIndex == 0 {
                type = "user"
            } else {
                type = "driver"
            }
            
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

            if let urlToReq = NSURL(string: "http://169.233.170.182:8000/user/add") {
                let request: NSMutableURLRequest = NSMutableURLRequest(URL: urlToReq)
                let session = NSURLSession.sharedSession()
                request.HTTPMethod = "POST"
                
                let params = ["firstName": firstNameTextField.text, "lastName": lastNameTextField.text, "email": emailTextField.text?.lowercaseString, "password": passwordTextField.text, "confirmPassword": confirmPasswordTextField.text, "type": type] as Dictionary<String, String!>

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
                    if (answer["error"] != nil) {
                        dispatch_async(dispatch_get_main_queue(), {
                            let alert = UIAlertController(title: "Error", message: answer["error"]! as? String, preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                            self.presentViewController(alert, animated: true, completion: nil)
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
                                self.performSegueWithIdentifier("registerToWelcome", sender: nil)
                            }
                        }
                    }
                    
                })
                
                task.resume()
                
            }

        }
    }
    
}