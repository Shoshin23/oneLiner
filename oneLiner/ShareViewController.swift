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
import Spring



class ShareViewController: UIViewController {
    
    
    @IBOutlet var optionChosen: UILabel!
    
    @IBOutlet var shareView: UIView!
    @IBOutlet var sourceName: UILabel!
    var postDict = [AnyObject]()
    
    @IBOutlet var shareContent: UITextView!
    //obtain selectedIndex here 
    var selectedIndex:Int!
    var appDel : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBAction func showAlert() {
        let alertController = UIAlertController(title: "", message: "Your 1Liner is copied to the clipboard!", preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func shareButton(sender: UIButton) {
    
        let defaultText = appDel.payload! as String + " #1Liner " + "#" + Topics.oneLiners[selectedIndex].stringByReplacingOccurrencesOfString(" ", withString: "")
        
        let activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
        self.presentViewController(activityController, animated: true, completion: nil)
        UIPasteboard.generalPasteboard().string = appDel.payload as? String
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        

    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(true)
        

    }
    
    override func viewDidLoad() {
         super.viewDidLoad()
        //print("In shareVC.")
       // print("From shareVC, we can read the payload now! \(appDel.payload!)")
       // view.backgroundColor = UIColor(red:0.96, green:0.93, blue:0.05, alpha:1.0)
        shareView.layer.cornerRadius = 10
        shareView.layer.borderColor = UIColor.blackColor().CGColor
        shareView.layer.borderWidth = 0.25
        shareView.layer.shadowColor = UIColor.blackColor().CGColor
        shareView.layer.shadowOpacity = 0.8
        shareView.layer.shadowRadius = 25
        shareView.layer.shadowOffset = CGSize(width: 5, height: 5)
        shareView.layer.masksToBounds = false

        
        
        
        self.selectedIndex = NSUserDefaults.standardUserDefaults().valueForKey("chosenOption") as? Int
        self.optionChosen.text = Topics.oneLiners[selectedIndex]
        if appDel.payload != nil {
        self.shareContent.text = appDel.payload! as String
        } else {
            self.shareContent.text = " "
        }
        if appDel.payloadSource != nil {
        self.sourceName.text = appDel.payloadSource! as String
        } else {
            self.sourceName.text = " "
        }
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
    }
    
    
    

}
