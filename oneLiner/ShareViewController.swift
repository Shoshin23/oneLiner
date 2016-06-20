//
//  ShareViewController.swift
//  oneLiner
//
//  Created by Karthik Kannan on 09/05/16.
//  Copyright © 2016 Karthik Kannan. All rights reserved.
//

import UIKit
import Firebase
import Social


class ShareViewController: UIViewController {
    
    
    @IBOutlet var optionChosen: UILabel!
    
    @IBOutlet var sourceName: UILabel!
    var postDict = [AnyObject]()
    
    @IBOutlet var shareContent: UITextView!
    //obtain selectedIndex here 
    var selectedIndex:Int!
    var appDel : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    @IBAction func shareButton(sender: UIButton) {
        
        let defaultText = "Hello world! #1Liner"
        
        let activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
        self.presentViewController(activityController, animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        

    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(true)
        

    }
    
    override func viewDidLoad() {
         super.viewDidLoad()
        print("In shareVC.")
        print("From shareVC, we can read the payload now! \(appDel.Massage!)")
        view.backgroundColor = UIColor(red:0.96, green:0.93, blue:0.05, alpha:1.0)
        
        self.selectedIndex = NSUserDefaults.standardUserDefaults().valueForKey("chosenOption") as? Int
        self.optionChosen.text = Topics.oneLiners[selectedIndex]
    
        
    }
    
    
    

}
