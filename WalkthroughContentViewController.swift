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
        case 0...2: forwardButton.setTitle("", for: UIControlState())
        case 3: forwardButton.setTitle("Let's Go!", for: UIControlState())
        default: break
        }

        
    }
    
    @IBAction func close(_ sender: AnyObject) {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "hasViewedWalkthrough")
        dismiss(animated: true, completion: nil)
    }
    
    
    

}
