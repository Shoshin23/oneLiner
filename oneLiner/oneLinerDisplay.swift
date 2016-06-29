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
    let dimLevel: CGFloat = 0.5
    let dimSpeed: Double = 0.5
    
    //Local methods
    @IBAction func showAlert() {
        let alertController = UIAlertController(title: "No Internet Connection", message: "Please make sure your device is connected to the Internet.", preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        dim(.In, alpha: dimLevel, speed: dimSpeed)
//    }
//    
//    @IBAction func unwindFromSecondary(segue: UIStoryboardSegue) {
//        dim(.Out, speed: dimSpeed)
//    }
//    
        // Animate table method.
        //  ref: Appcoda tutorial
    
 func animateTable() {
        self.tableView.reloadData()
        
        let cells = self.tableView.visibleCells
        let tableHeight: CGFloat = self.tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animateWithDuration(1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                }, completion: nil)
            
            index += 1
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        //print("In viewWillAppear:")
        //print(NSUserDefaults.standardUserDefaults().valueForKey("chosenOption"))
        animateTable()
       
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let hasViewedWalkthrough = defaults.boolForKey("hasViewedWalkthrough")
        if hasViewedWalkthrough {
            return
        }
        if let pageViewController =
            storyboard?.instantiateViewControllerWithIdentifier("WalkthroughController")
                as? WalkthroughPageViewController {
            presentViewController(pageViewController, animated: true, completion: nil)
        }
        //print("In viewDidAppear.")
    }
    
    
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.allowsMultipleSelection = false
        animateTable()
        
        let image = UIImage(named: "logo_small")
        self.navigationItem.titleView = UIImageView(image: image)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .ScaleAspectFit
        
//        self.navigationController!.popViewControllerAnimated(true)

        
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
        
        cell.textLabel?.font = UIFont(name: "Avenir-Light", size: 24.0)
        
        cell.textLabel?.text = oneLiners[indexPath.row]
        let getOption = NSUserDefaults.standardUserDefaults().valueForKey("chosenOption") as? Int
        
        if getOption == indexPath.row {
            cell.accessoryType = .Checkmark
            cell.textLabel?.font = UIFont.boldSystemFontOfSize(24.0)
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
        cell!.textLabel?.font = UIFont.boldSystemFontOfSize(24.0)

        
        let topic = oneLiners[optionChecked!].stringByReplacingOccurrencesOfString(" ", withString: "")
        //print(topic)
        
        FIRMessaging.messaging().subscribeToTopic("/topics/\(topic)")
        print("Subscribed to the \(topic). Send me PNs?")
        
        //fetch the previous topic from the existing NSUserDefaults
        
        if(NSUserDefaults.standardUserDefaults().valueForKey("chosenOption") != nil){
        let getOption = NSUserDefaults.standardUserDefaults().valueForKey("chosenOption") as? Int
        let previous_topic = self.oneLiners[getOption!].stringByReplacingOccurrencesOfString(" ", withString: "")
        
        //unsubcribe from the previous topic. 
        FIRMessaging.messaging().unsubscribeFromTopic("/topics/\(previous_topic)")
        print("Unsubscribed from \(self.oneLiners[getOption!])")
        }
    
         //shouldnt be here. Everytime i click on a topic, notifications are scheduled. Instead, it has to be done just once. When the app is loaded.
        NSUserDefaults.standardUserDefaults().setValue(optionChecked, forKey: "chosenOption")
        tableView.reloadData()
        
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .None
        }
}
