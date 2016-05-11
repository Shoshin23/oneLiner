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
    
    @IBOutlet var sourceName: UILabel!
    var postDict = [AnyObject]()
    
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
            self.sourceName.text = self.postDict[1] as? String
            

//            let postKey = snapshot.key
//            let postValue = snapshot.value
//            
//            let post = [postKey:postValue]
//            self.postDict = (post[Topics.oneLiners[self.selectedIndex]]! as? Dictionary<String, AnyObject!>)!
        })

       
   
    
        
    }
    
    
    

}
