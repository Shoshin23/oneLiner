//
//  ShareViewController.swift
//  oneLiner
//
//  Created by Karthik Kannan on 09/05/16.
//  Copyright © 2016 Karthik Kannan. All rights reserved.
//

import UIKit
import Firebase


class ShareViewController: UIViewController {
    
    
    @IBOutlet var optionChosen: UILabel!
    var chosenOption:AnyObject = ""
    override func viewDidLoad() {
         super.viewDidLoad()
        print("In shareVC.")
        view.backgroundColor = UIColor(red:0.96, green:0.93, blue:0.05, alpha:1.0)


        self.chosenOption = NSUserDefaults.standardUserDefaults().valueForKey("chosenOption")!
        
        self.optionChosen.text = chosenOption as? String
        
        let postRef = DataService.ds.REF_POSTS.childByAppendingPath(chosenOption as? String)
        
        postRef.observeEventType(.Value, withBlock: { snapshot in
        
            print(snapshot)
        })
        
    }

}
