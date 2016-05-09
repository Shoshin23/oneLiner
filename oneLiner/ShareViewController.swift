//
//  ShareViewController.swift
//  oneLiner
//
//  Created by Karthik Kannan on 09/05/16.
//  Copyright © 2016 Karthik Kannan. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {
    
    @IBOutlet var ping: UILabel!
    
    var chosenOption:AnyObject = ""
    override func viewDidLoad() {
         super.viewDidLoad()
        print("In shareVC.")
self.chosenOption = NSUserDefaults.standardUserDefaults().valueForKey("chosenOption")!
        
        print(chosenOption)
    }

}
