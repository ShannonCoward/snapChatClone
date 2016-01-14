//
//  CameraViewController.swift
//  snapChatClone
//
//  Created by Shannon Armon on 1/7/16.
//  Copyright © 2016 RarefiedProudctions,LLC. All rights reserved.
//

import UIKit
import AVFoundation
import Parse
import CoreGraphics

class CameraViewController: UIViewController {
    
    var snaps = [PFObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
       
    }
    
    var image: UIImage?
    
    @IBOutlet weak var cameraView: UIView!
    
    @IBOutlet weak var snapsWaitingButton: UIButton!
    
    @IBAction func takePhotoPressed(sender: UIButton) {
        
        
        if let videoConnection = stillImageOutput?.connectionWithMediaType(AVMediaTypeVideo) {
            videoConnection.videoOrientation = AVCaptureVideoOrientation.Portrait
            stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: { (sampleBuffer, error) -> Void in
                
                if sampleBuffer != nil {
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider = CGDataProviderCreateWithCFData(imageData)
                    let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, CGColorRenderingIntent.RenderingIntentDefault)
                    let image = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.Right)
                    self.image = image
                    self.captureSession.stopRunning()
                    self.performSegueWithIdentifier("Preview", sender: self)
                
                }
            })
        
        }
    
    }

    let captureSession = AVCaptureSession()
    var stillImageOutput: AVCaptureStillImageOutput? = nil
    var previewLayer = AVCaptureVideoPreviewLayer()

    
    override func viewDidAppear(animated: Bool) {
        snapsWaitingButton.alpha = 0
        
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        let error: NSError? = nil
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        var input: AVCaptureDeviceInput?
        do {
            input = try AVCaptureDeviceInput(device: captureDevice)
            
        } catch _ {
    
        }
        
        if error == nil && captureSession.canAddInput(input){
        
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput!.outputSettings = [AVVideoCodecJPEG:AVVideoCodecKey]
            if captureSession.canAddOutput(stillImageOutput) {
                captureSession.addOutput(stillImageOutput)
                captureSession.addInput(input)
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                previewLayer.connection.videoOrientation = AVCaptureVideoOrientation.Portrait
                cameraView.layer.addSublayer(previewLayer)
                cameraView.frame = self.view.frameForAlignmentRect(CGRect(origin: CGPointZero, size: cameraView.bounds.size))
                previewLayer.frame = self.view.frameForAlignmentRect(CGRect(origin: CGPointZero, size: cameraView.bounds.size))

                captureSession.startRunning()
                //self.view.layer.addSublayer(previewLayer)
                //self.view.sendSubviewToBack(cameraView)
            }
        }
        
        if let user = PFUser.currentUser() {
            print("current user: " + user.objectId!)
            let query = PFQuery(className: "SnapTargets")
            query.includeKey("user")
            query.includeKey("snap")
            query.whereKey("user", equalTo: user)
            query.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
                if error != nil {
                    print("error retrieving snaps")

                } else {
                    print(results)
                    if let results = results as? [PFObject]! {
                        if results.count > 0 {
                        
                        self.snaps = results
                        self.snapsWaitingButton.setTitle("\(results.count)", forState: .Normal)
                        self.snapsWaitingButton.alpha = 1
                            
                        }
                    
                    }
                
                }
            })
        
        }
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        
        super.viewDidDisappear(animated)
    }
    
    override func shouldAutorotate() -> Bool {
        if (UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeLeft ||
            UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeRight ||
            UIDevice.currentDevice().orientation == UIDeviceOrientation.Unknown) {
                return false
        }
        else {
            return true
        }
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.Portrait ,UIInterfaceOrientationMask.PortraitUpsideDown]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "Preview" {
            if let navigationController = segue.destinationViewController as? UINavigationController {
                if let previewController = navigationController.topViewController as? PreviewViewController {
                        previewController.previewImage = image
                    
                
                }
            
            }
        
        }
        
        if segue.identifier == "ShowSnaps" {
            if let navigationController = segue.destinationViewController as? UINavigationController, let destination = navigationController.topViewController as? SnapListTableViewController {
                destination.snaps = snaps
            
            }
        
        }
    }
 

}
