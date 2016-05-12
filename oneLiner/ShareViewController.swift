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
    
    
    @IBOutlet var facebookButtonDesign: UIButton!
    
    @IBOutlet var twitterButtonDesign: UIButton!
    
    
    @IBAction func facebookShare(sender: UIButton) {
        
        guard
            SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) else {
                let alertMessage = UIAlertController(title: "Facebook Unavailable", message: "You havent registered your Facebook Account. Please go to settings > Facebook, to create one.", preferredStyle: .Alert)
                
                alertMessage.addAction(UIAlertAction(title: "Okay", style: .Default, handler: nil))
                self.presentViewController(alertMessage, animated: true, completion: nil)
                return
        }
        
        let tweetComposer = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        let tweetMessage = (postDict[0] as? String)! + " #oneLiner"
        tweetComposer.setInitialText(tweetMessage)
        self.presentViewController(tweetComposer, animated: true, completion: nil)
        
        
    }
    
    
    
    @IBAction func twitterShare(sender: UIButton) {
        
        guard
            SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) else {
                let alertMessage = UIAlertController(title: "Twitter Unavailable", message: "You havent registered your Twitter Account. Please go to settings > Twitter, to create one.", preferredStyle: .Alert)
                
                alertMessage.addAction(UIAlertAction(title: "Okay", style: .Default, handler: nil))
                self.presentViewController(alertMessage, animated: true, completion: nil)
                return
        }
        
        let tweetComposer = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        let tweetMessage = (postDict[0] as? String)! + "#oneLiner"
        tweetComposer.setInitialText(tweetMessage)
        self.presentViewController(tweetComposer, animated: true, completion: nil)
        
        
    }
    
    @IBOutlet var sourceName: UILabel!
    var postDict = [AnyObject]()
    
    @IBOutlet var shareContent: UITextView!
    //obtain selectedIndex here 
    var selectedIndex:Int!
    
    override func viewDidLoad() {
         super.viewDidLoad()
        print("In shareVC.")
        view.backgroundColor = UIColor(red:0.96, green:0.93, blue:0.05, alpha:1.0)
        
        self.selectedIndex = NSUserDefaults.standardUserDefaults().valueForKey("chosenOption") as? Int

        
        self.optionChosen.text = Topics.oneLiners[selectedIndex]
        
        
        let postRef = DataService.ds.REF_POSTS.childByAppendingPath(Topics.oneLiners[selectedIndex])
        
        postRef.observeEventType(.Value, withBlock: { snapshot in
            
//            print(snapshot.childrenCount)
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? FDataSnapshot {
//                print(rest.value)
                self.postDict.append(rest.value)
                
            }
            
            if self.postDict.count == 2 { // Wait for the data to be downloaded.
            
            self.sourceName.text = self.postDict[1] as? String
            self.shareContent.text = self.postDict[0] as? String
            }
            
            

            

//            let postKey = snapshot.key
//            let postValue = snapshot.value
//            
//            let post = [postKey:postValue]
//            self.postDict = (post[Topics.oneLiners[self.selectedIndex]]! as? Dictionary<String, AnyObject!>)!
        })

       
   
    
        
    }
    
    
    

}
