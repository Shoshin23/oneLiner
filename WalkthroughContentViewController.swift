//
//  WalkthroughContentViewController.swift
//  oneLiner
//
//  Created by Karthik Kannan on 22/06/16.
//  Copyright © 2016 Karthik Kannan. All rights reserved.
//

import UIKit

class WalkthroughContentViewController: UIViewController {
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var contentImageView: UIImageView!
    @IBOutlet var pageControl:UIPageControl!
    @IBOutlet var forwardButton:UIButton!
    
    var index = 0
    var content = ""
    var imageFile = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentLabel.text = content
        contentImageView.image = UIImage(named: imageFile)
        pageControl.currentPage = index
        
        switch index {
        case 0...2: forwardButton.setTitle("", forState: UIControlState.Normal)
        case 3: forwardButton.setTitle("DONE", forState: UIControlState.Normal)
        default: break
        }

        
    }
    
    @IBAction func close(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(true, forKey: "hasViewedWalkthrough")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    

}
