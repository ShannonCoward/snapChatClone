//
//  LoginViewController.swift
//  snapChatClone
//
//  Created by Shannon Armon on 1/7/16.
//  Copyright © 2016 RarefiedProudctions,LLC. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var formActionControl: UISegmentedControl!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var actionButton: UIButton!
    
    var formAction: formActionType = .Register
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formAction = .Register
        changeFormAction()
        
        usernameField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self
        emailField.delegate = self
        
    }
    
    
    @IBAction func formActionSelected(sender: UISegmentedControl) {
        formAction = sender.selectedSegmentIndex == 0 ? .Register : .Login
        changeFormAction()
    }
    
    @IBAction func actionButtonPressed(sender: UIButton) {
        
        errorMessage.text = ""
        switch formAction {
        case .Register:
            if usernameField.text == "" ||
                emailField.text == "" ||
                passwordField.text == "" || confirmPasswordField.text == "" {
                
                let alertController = UIAlertController(title: "OOPS", message: "All Fields Must Be Filled", preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (ACTION) in
                
                }
                alertController.addAction(cancelAction)
                
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (ACTION) in
                
                }
                alertController.addAction(OKAction)
                
                self.presentViewController(alertController, animated: true) {
                }
                
                
               // errorMessage.text = "All fields must be filled in"
                return
            
            } else if passwordField.text != confirmPasswordField.text {
                
                
                let alertController = UIAlertController(title: "OOPS", message: "Passwords Must Match", preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (ACTION) in
                    
                }
                alertController.addAction(cancelAction)
                
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (ACTION) in
                    
                }
                alertController.addAction(OKAction)
                
                self.presentViewController(alertController, animated: true) {
                }
                
                
            } else {
                
                //  attempt to register user
            
                let user = PFUser()
                user.username = usernameField.text
                user.email = emailField.text
                user.password = passwordField.text
                user.signUpInBackgroundWithBlock { (suceeded: Bool, error: NSError?) -> Void in
                    if let error = error {
                        
                //  there was a problem
                    
                    print(error)
                        
                    } else {
                    
                // user registered successfully
                        print("user successfully created")
                        self.performSegueWithIdentifier("LoginSuccess", sender: self)
                        self.dismissViewControllerAnimated(true, completion: { () -> Void in
                            
                        })
                    }
            }
        
        }
        break
        case .Login:
            if usernameField.text == "" || passwordField.text == "" || emailField.text == "" {
                
                let alertController = UIAlertController(title: "OOPS", message: "All Fields Must Be Filled", preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (ACTION) in
                    
                }
                alertController.addAction(cancelAction)
                
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (ACTION) in
                }
                alertController.addAction(OKAction)
                
                self.presentViewController(alertController, animated: true) {
                }
                
                return
                
            } else {
                
                // attempt to log in user
            
                PFUser.logInWithUsernameInBackground(usernameField.text!, password: passwordField.text!) { (user: PFUser?, error: NSError?) -> Void in
                if user != nil {
                
                    print("user successfully logged in")
                    //self.performSegueWithIdentifier("LoginSuccess", sender: self)
                    self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                
                } else {
                    
                    if let errorMessage = error?.userInfo["error"] as? String {
                        self.errorMessage.text = errorMessage

                    }
                }
            }
            
         } 
            
            break
        }
    }
    
    enum formActionType: Int {
        case Register = 0, Login
    }
    

//    override func viewDidAppear(animated: Bool) {
//        
//        if let user = PFUser.currentUser() {
//            print("user has session")
//            performSegueWithIdentifier("LoginSuccess", sender: self)
//            
//        }
//        
//        print(PFUser.currentUser()?.email)
//        
//        if PFUser.currentUser()?.email == nil {
//            
//            let loginVC = storyboard?.instantiateViewControllerWithIdentifier("loginVC") as! LoginViewController
//            
//            self.presentViewController(loginVC, animated: false, completion: nil)
//    }
//}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func changeFormAction() {
        switch formAction {
        case .Register:
            formActionControl.selectedSegmentIndex = 0
            confirmPasswordField.alpha = 1
            actionButton.setTitle("Register", forState: .Normal)
            break
        case .Login:
            formActionControl.selectedSegmentIndex = 1
            confirmPasswordField.alpha = 0
            actionButton.setTitle("Login", forState: .Normal)
        
        }
    
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
