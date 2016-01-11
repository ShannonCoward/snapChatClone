//
//  DisplaySnapViewController.swift
//  snapChatClone
//
//  Created by Shannon Armon on 1/7/16.
//  Copyright © 2016 RarefiedProudctions,LLC. All rights reserved.
//

import UIKit
import Parse

class DisplaySnapViewController: UIViewController {

    var snap: PFObject?
    
    @IBOutlet weak var displayImage: UIImageView!
    @IBOutlet weak var progressBar: UIProgressView!
    var progress: Float = 1.0
    var timer = NSTimer()
    var duration: Double = 0.1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        
        if snap != nil {
            print(snap)
        
        }
        
        if let image = snap!["snap"]["image"] as? PFFile {
            duration = (snap!["snap"]["duration"] as! Double) / 100
            image.getDataInBackgroundWithBlock({ (data, error) -> Void in
                if let imageData = data {
                    self.displayImage.image = UIImage(data: imageData)
                    self.animateProgress(self.duration)
                
                }
            })
        }
    }
    
    func animateProgress (interval: Double) {
        timer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: "updateProgress", userInfo: nil, repeats: true)
    
    }
    
    func updateProgress() {
        progress -= 0.01
        if progress <= 0.0 {
            timer.invalidate()
            displayDone()
        }
        progressBar.setProgress(progress, animated: true)
        
    }

    func displayDone () {
        print("DONE")
        performSegueWithIdentifier("backToSnapList", sender: self)
    
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
