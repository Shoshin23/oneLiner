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

extension UIView {
    func pb_takeSnapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.mainScreen().scale)
        
        drawViewHierarchyInRect(self.bounds, afterScreenUpdates: true)
        
        // old style: layer.renderInContext(UIGraphicsGetCurrentContext())
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

class dailyOneLiner: UIViewController {
    
    @IBOutlet var oneLinerContent: UITextView!
    @IBOutlet var source: UILabel!
    @IBOutlet var backgroundImg: UIImageView!
    
    @IBOutlet var shareBtn: UIButton!
    var olTopics:[String]!
    
    @IBOutlet var backBtn: UIButton!
    var cellClicked: Int!
    
    @IBAction func shareButton(sender: UIButton) {
        shareBtn.hidden = true
        backBtn.hidden = true
        let img = view.pb_takeSnapshot()
        share(shareText: "#1Liner", shareImage: img)
        shareBtn.hidden = false
        backBtn.hidden = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: animated);

    }
    
    
    func share(shareText shareText:String?,shareImage:UIImage?){
        
        var objectsToShare = [AnyObject]()
        
        if let shareTextObj = shareText{
            objectsToShare.append(shareTextObj)
        }
        
        if let shareImageObj = shareImage{
            objectsToShare.append(shareImageObj)
        }
        
        if objectsToShare.count > 0 {
            let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            presentViewController(activityViewController, animated: true, completion: nil)
        }else{
            print("There is nothing to share")
        }
    }

    @IBAction func back(sender: AnyObject) {
        navigationController!.popViewControllerAnimated(true)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(olTopics)
                
        //Hide Navigation bar bro!
        self.navigationController?.navigationBarHidden = true
        
        //which topic was chosen?
        let chosenTopic = olTopics[cellClicked]
        print(chosenTopic)
        
        backgroundImg.image = UIImage(named: chosenTopic)
                
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
