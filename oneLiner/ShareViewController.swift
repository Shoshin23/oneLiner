//
//  ShareViewController.swift
//  oneLiner
//
//  Created by Karthik Kannan on 09/05/16.
//  Copyright © 2016 Karthik Kannan. All rights reserved.
//
// This file contains all the 


import UIKit
import Firebase
import Social
import Spring

class ShareViewController: UIViewController {
    
    
    
    @IBOutlet var backgroundImg: UIImageView!
    @IBOutlet var sourceName: UILabel!
    var postDict = [AnyObject]()
    
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var shareBtn: UIButton!
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
        }
        else{
            print("There is nothing to share")
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
        
    }

    
    @IBAction func back(sender: AnyObject) {
        navigationController!.popViewControllerAnimated(true)
        
    }
    
    @IBAction func shareButton(sender: UIButton) {
        
        FIRAnalytics.logEventWithName(kFIREventShare, parameters: [kFIRParameterContentType:"share"]) //Log share event.
        if appDel.payloadTopic != nil {
            backgroundImg.image = UIImage(named: appDel.payloadTopic as! String)
            
            
        } else {
            backgroundImg.image = UIImage(named: "Motivation")
        }
        
        shareBtn.hidden = true
        backBtn.hidden = true
        let img = view.pb_takeSnapshot()
        share(shareText: "#1Liner", shareImage: img)
        shareBtn.hidden = false
        backBtn.hidden = false
    
            }
    
  
    
    override func viewDidLoad() {
         super.viewDidLoad()
        //print("In shareVC.")
       // print("From shareVC, we can read the payload now! \(appDel.payload!)")
       // view.backgroundColor = UIColor(red:0.96, green:0.93, blue:0.05, alpha:1.0)
        self.navigationController?.navigationBarHidden = true

        
        FIRAnalytics.logEventWithName(kFIREventViewItem, parameters: [kFIRParameterContentType:"cardView"]) //log when someone comes into the shareVC.
        
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
