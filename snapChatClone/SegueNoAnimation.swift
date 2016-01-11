//
//  SegueNoAnimation.swift
//  snapChatClone
//
//  Created by Shannon Armon on 1/7/16.
//  Copyright © 2016 RarefiedProudctions,LLC. All rights reserved.
//

import UIKit

class SegueNoAnimation: UIStoryboardSegue {
    
    override func perform() {
        if let sourceVC = self.sourceViewController as? UIViewController {
            sourceVC.presentViewController(self.destinationViewController , animated: false, completion: nil)
        }
    }
}
