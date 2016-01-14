//
//  PreviewViewController.swift
//  snapChatClone
//
//  Created by Shannon Armon on 1/7/16.
//  Copyright © 2016 RarefiedProudctions,LLC. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var previewImageView: UIImageView!
    
    @IBOutlet weak var secondsButton: UIButton!
    @IBAction func secondsPressed(sender: AnyObject) {
        print("showPickerView")
        print("\(picker.bounds.width) \(picker.bounds.height)")
        pickerContainer.frame = CGRectMake(0, UIScreen.mainScreen().bounds.height - picker.bounds.height, picker.bounds.width, picker.bounds.height)
            self.view.addSubview(pickerContainer)
    
    }
    
    var previewImage: UIImage?
    var picker = UIPickerView(frame: CGRectMake(0, 0, 0, 0))
    var pickerContainer = UIView(frame: CGRectMake(0, 0, 0, 0))
    var duration = 5
        
        

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        picker.showsSelectionIndicator = true
        picker.delegate = self
        picker.dataSource = self
        pickerContainer.backgroundColor = UIColor.grayColor()
        pickerContainer.addSubview(picker)
        
        secondsButton.setTitle("\(duration)", forState: .Normal)
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? 10 : 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 1 {
            return "seconds"
        
        } else {
        
            return "\(row+1)"
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            print("selected \(row+1) seconds")
            secondsButton.setTitle("\(row+1)", forState: .Normal)
            duration = row + 1
            pickerContainer.removeFromSuperview()
        
        }
    }
        
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        previewImageView.image = previewImage
        self.navigationController?.navigationBarHidden = true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as?    FriendsTableViewController  {
            destination.imageToUpload = previewImage!
            destination.duration = duration
            
        
        }
    }

}
