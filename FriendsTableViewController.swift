//
//  FriendsTableViewController.swift
//  snapChatClone
//
//  Created by Shannon Armon on 1/7/16.
//  Copyright © 2016 RarefiedProudctions,LLC. All rights reserved.
//

import UIKit
import Parse

class FriendsTableViewController: UITableViewController {
    
    var imageToUpload = UIImage()
    var duration: Int = 0
    
    var users = [PFUser]()
    var selectedUsers = Set<PFUser>()
    
    var containerView = UIView()
    var spinner = UIActivityIndicatorView()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let screenRect = UIScreen.mainScreen().bounds
        
        let nextButton = UIButton(frame: CGRectMake(view.frame.width - 75, 2, 71, 56))
        nextButton.setImage(UIImage(named: "nextArrow.png"), forState: .Normal)
        nextButton.addTarget(self, action: "nextButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        containerView = UIView(frame: CGRectMake(0, screenRect.height - 160, view.frame.width, 60))
        containerView.backgroundColor = UIColor.cyanColor()
        containerView.alpha = 0
        
        containerView.addSubview(nextButton)
        self.view.addSubview(containerView)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        if let user = PFUser.currentUser() {
            var query = PFQuery(className: "Friends")
            query.includeKey("friend")
            query.whereKey("userId", equalTo: user.objectId!)
            query.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
                if error == nil {
                    print(results)
                    if let results = results as? [PFObject]! {
                        self.users.removeAll(keepCapacity: true)
                        print("\(results.count) friends found")
                        for result in results {
                            if let user = result["friend"] as? PFUser {
                                self.users.append(user)
                            
                            }
                        }
                        
                        self.tableView.reloadData()
                    }
                    
                } else {
                    print(error)
                }
            })
        
        }
        
    }
    
    func nextButtonPressed(sender: UIButton) {
        
        if let user = PFUser.currentUser() {
            print("button pressed")
            self.view.userInteractionEnabled = false
            spinner = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            spinner.hidesWhenStopped = true
            spinner.center = self.view.center
            view.addSubview(spinner)
            spinner.startAnimating()
            
            var snapPost = PFObject(className: "Snaps")
            snapPost["user"] = user
            snapPost["duration"] = duration
            
            let mi = UIImagePNGRepresentation(imageToUpload)
            let imageData = UIImageJPEGRepresentation(imageToUpload, 1.0)
            let imageFile = PFFile(name: "image.png", data: imageData!)
            snapPost["image"] = imageFile
            
            var friendEntries = [PFObject]()
            for friend in users {
                var friendEntry = PFObject(className: "SnapTargets")
                friendEntry["viewed"] = false
                friendEntry["user"] = friend
                friendEntry["snap"] = snapPost
                friendEntries.append(friendEntry)
            }
            
            PFObject.saveAllInBackground(friendEntries, block: { (success, error) -> Void in
                self.spinner.startAnimating()
                self.view.userInteractionEnabled = true
                if error != nil {
                    print(error)
                    self.displayAlertView("Snap Not Saved", message: "The Snap did not save properly")
                    
                } else {
                    print("success")
                    self.displayAlertView("Snap Saved", message: "The snap has saved successfuly")
                    self.containerView.removeFromSuperview()
                
                }
            
            })
        }
     
    }
    

    
    func displayAlertView(title:String, message: String) {
        let alert = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
        alert.show()
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

   
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("friendCell", forIndexPath: indexPath) 
        
        cell.textLabel!.text = users[indexPath.row].username!

        // Configure the cell...

        return cell
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            let user = users[indexPath.row]
            if cell.accessoryType == .Checkmark {
                selectedUsers.remove(user)
                cell.accessoryType = .None
                
            } else {
                selectedUsers.insert(user)
                cell.accessoryType = .Checkmark
            
            }
            
            if !selectedUsers.isEmpty {
                containerView.alpha = 1
            
            } else {
                containerView.alpha = 0
            
            }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
