//
//  oneLinerDisplay.swift
//  oneLiner
//
//  Created by Karthik Kannan on 08/05/16.
//  Copyright © 2016 Karthik Kannan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import FirebaseInstanceID


class oneLinerDisplay: UITableViewController {
    
   //Declarations
    
    var checked:Bool = false
    var chosenOption:Int!
    var deselectedIndexPath:NSIndexPath = NSIndexPath()
    let oneLiners = Topics.oneLiners
    
    //Local methods
    @IBAction func showAlert() {
        let alertController = UIAlertController(title: "No Internet Connection", message: "Please make sure your device is connected to the Internet.", preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        print("ChosenOption at viewWillAppear:")
        print(NSUserDefaults.standardUserDefaults().valueForKey("chosenOption"))
       
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.allowsMultipleSelection = false
        
        //check for network connection. Else throw an error. 
        if Reachability.isConnectedToNetwork() == false {
           showAlert()
        }
        
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return oneLiners.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = oneLiners[indexPath.row]
        let getOption = NSUserDefaults.standardUserDefaults().valueForKey("chosenOption") as? Int
        
        if getOption == indexPath.row {
            cell.accessoryType = .Checkmark
        }
        else {
            cell.accessoryType = .None
        }
       

        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //Local Variables
        
        let indexPath = tableView.indexPathForSelectedRow
        let cell = tableView.cellForRowAtIndexPath(indexPath!)
        let optionChecked = indexPath?.row

        
        cell?.accessoryType = .Checkmark
        
        let topic = oneLiners[optionChecked!].stringByReplacingOccurrencesOfString(" ", withString: "")
        //print(topic)
        
        FIRMessaging.messaging().subscribeToTopic("/topics/\(topic)")
        print("Subscribed to the \(topic). Send me PNs?")
        
        //fetch the previous topic from the existing NSUserDefaults
        
        let getOption = NSUserDefaults.standardUserDefaults().valueForKey("chosenOption") as? Int
        let previous_topic = self.oneLiners[getOption!].stringByReplacingOccurrencesOfString(" ", withString: "")
        
        //unsubcribe from the previous topic. 
        FIRMessaging.messaging().unsubscribeFromTopic("/topics/\(previous_topic)")
        print("Unsubscribed from \(self.oneLiners[getOption!])")
        
    
         //shouldnt be here. Everytime i click on a topic, notifications are scheduled. Instead, it has to be done just once. When the app is loaded.
        NSUserDefaults.standardUserDefaults().setValue(optionChecked, forKey: "chosenOption")
        tableView.reloadData()
        
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .None
        }
}
