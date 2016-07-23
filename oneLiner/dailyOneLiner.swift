//
//  dailyOneLiner.swift
//  oneLiner
//
//  Created by Karthik Kannan on 20/07/16.
//  Copyright © 2016 Karthik Kannan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import JDStatusBarNotification
import Social

class dailyOneLiner: UIViewController {
    
    @IBOutlet var topicChosen: UILabel!
    @IBOutlet var oneLinerContent: UITextView!
    @IBOutlet var source: UILabel!
    
    var olTopics:[String]!
    
    @IBOutlet var card: UIView!
    var cellClicked: Int!
    
    @IBAction func shareButton(sender: UIButton) {
        
        let defaultText = self.oneLinerContent.text + " #1Liner " + "#" + olTopics[cellClicked].stringByReplacingOccurrencesOfString(" ", withString: "")
        
        let activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
        self.presentViewController(activityController, animated: true, completion: nil)
        UIPasteboard.generalPasteboard().string = self.oneLinerContent.text
    }
    
    
  

    override func viewDidLoad() {
        super.viewDidLoad()
        print(olTopics)
        
        //configure card
        DataService.configureCard(card)
        
        //set title and tint color.
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
        
        //which topic was chosen?
        let chosenTopic = olTopics[cellClicked]
        print(chosenTopic)
        
        topicChosen.text = chosenTopic
        
        //FIR Database reference. 
        var postRef: FIRDatabaseReference!
        postRef =  FIRDatabase.database().reference()
        //check for a net connection, else inform user that he needs the internet for this. 
        
        if Reachability.isConnectedToNetwork() == true {
        postRef.child(chosenTopic).observeEventType(.Value, withBlock: { (snapshot) in
            print(snapshot.value)
            let postDict = snapshot.value as! [String:AnyObject]
            self.oneLinerContent.text = postDict["post"] as! String
            self.source.text = postDict["source"] as? String
            
        })
        }
        
        else {
            self.oneLinerContent.text = "You appear to be offline!😰"
            self.source.text = "😵"
            DataService.showAlert(self)
        }
        
        
//        postRef.child(observeEventType(.Value, withBlock: {(snapshot) in
//            
//        
//        })

    }

   }
