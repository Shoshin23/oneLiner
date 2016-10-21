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
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        // old style: layer.renderInContext(UIGraphicsGetCurrentContext())
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
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
    
    @IBAction func shareButton(_ sender: UIButton) {
        shareBtn.isHidden = true
        backBtn.isHidden = true
        let img = view.pb_takeSnapshot()
        share(shareText: "#1Liner", shareImage: img)
        shareBtn.isHidden = false
        backBtn.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: animated);

    }
    
    
    func share(shareText:String?,shareImage:UIImage?){
        
        var objectsToShare = [AnyObject]()
        
        if let shareTextObj = shareText{
            objectsToShare.append(shareTextObj as AnyObject)
        }
        
        if let shareImageObj = shareImage{
            objectsToShare.append(shareImageObj)
        }
        
        if objectsToShare.count > 0 {
            let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            present(activityViewController, animated: true, completion: nil)
        }else{
            print("There is nothing to share")
        }
    }

    @IBAction func back(_ sender: AnyObject) {
        navigationController!.popViewController(animated: true)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(olTopics)
                
        //Hide Navigation bar bro!
        self.navigationController?.isNavigationBarHidden = true
        
        //which topic was chosen?
        let chosenTopic = olTopics[cellClicked]
        print(chosenTopic)
        
        backgroundImg.image = UIImage(named: chosenTopic)
        //FIR Database reference. 
        var postRef: FIRDatabaseReference!
        postRef =  FIRDatabase.database().reference()
        //check for a net connection, else inform user that he needs the internet for this. 
        
        if Reachability.isConnectedToNetwork() == true {
        postRef.child(chosenTopic).observe(.value, with: { (snapshot) in
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
