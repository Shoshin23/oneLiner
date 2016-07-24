//
//  oneLinerDisplay.swift
//  oneLiner
//
//  Created by Karthik Kannan on 08/05/16.
//  Copyright © 2016 Karthik Kannan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseMessaging
import FirebaseInstanceID
import JDStatusBarNotification
import MGSwipeTableCell


class oneLinerDisplay: UITableViewController {
    
   //Declarations
    
    var chosenOption:Int!
    var oneLiners = ["Random"]
    var cellClicked:Int!
    var olRef: FIRDatabaseReference!
    
    

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
        self.animateTable() // call each time the view(coming from the cardView back to the listView.)
        
        //print("In viewWillAppear:")
        //print(NSUserDefaults.standardUserDefaults().valueForKey("chosenOption"))
       
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
        
        if Reachability.isConnectedToNetwork() == true {
            //fetch 1Liners from Firebase.
            olRef = FIRDatabase.database().reference()
            olRef.child("topics").observeEventType(.Value, withBlock: { (snapshot) in
                if snapshot.exists(){
                    let postDict = snapshot.value as! [String: AnyObject]
                    
                    let olTopicString = postDict["topic"] as! String
                    if olTopicString != "" {
                        self.oneLiners = olTopicString.componentsSeparatedByString(",")
                    }
                    print(snapshot.childrenCount)
                    
                    if self.oneLiners.count >= Int(snapshot.childrenCount)  {
                        print(self.oneLiners.count)
                self.tableView.delegate = self
                self.tableView.dataSource = self
                        self.tableView.reloadData()
                        self.animateTable()
                        JDStatusBarNotification.showWithStatus("Done.",dismissAfter: 2.0)

                    }
                }
            })
            
        }
            
        else {
            DataService.showAlert(self)
            
        }
        self.view.backgroundColor = UIColor.init(hex: "#F4EC0E")
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
        self.tableView.allowsMultipleSelection = false
        JDStatusBarNotification.showWithStatus("Fetching topics.",dismissAfter: 2.0)
        
        
        
        
        let image = UIImage(named: "logo_small")
        self.navigationItem.titleView = UIImageView(image: image)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .ScaleAspectFit

    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
      
        return self.oneLiners.count
    }
    
   
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! MGSwipeTableCell
        
        cell.contentView.backgroundColor = UIColor.init(hex: "#F4EC0E")
        cell.accessoryView?.backgroundColor = UIColor.yellowColor()
        cell.textLabel?.font = UIFont(name: "Avenir-Light", size: 24.0)
        
        
        //configure right buttons
        cell.rightSwipeSettings.transition = .Drag
        cell.rightExpansion.animationDuration = 2
        cell.rightExpansion.fillOnTrigger = true
        cell.rightExpansion.expansionColor = UIColor.yellowColor()
        cell.rightExpansion.buttonIndex = 0
        
        let swipeToCard = MGSwipeButton(title: "⬅︎", backgroundColor: UIColor.init(hex: "#F4EC0E"), callback: {
            (sender: MGSwipeTableCell!) -> Bool in
            
            let indexPath = self.tableView.indexPathForCell(sender)
            self.performSegueWithIdentifier("oneLinerShow", sender: indexPath)
            return true
        })
        
        cell.rightButtons = [swipeToCard]
        
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

    
//    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
//        let more = UITableViewRowAction(style: .Default, title: "➔") { action, index in
//            
//        }
//        
//        more.backgroundColor = UIColor.grayColor()
//        
//        return [more]
//    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // you need to implement this method too or you can't swipe to display the actions
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //Local Variables
        
        let indexPath = tableView.indexPathForSelectedRow
        let cell = tableView.cellForRowAtIndexPath(indexPath!)
        let optionChecked = indexPath?.row

        cell?.accessoryView?.superview?.backgroundColor = UIColor.init(hex: "#F4EC0E")

        cell?.accessoryType = .Checkmark
        cell!.textLabel?.font = UIFont.boldSystemFontOfSize(24.0)

        
        let topic = oneLiners[optionChecked!] //topic is the cell I just chose.

        //subscribe to the topic and display a notification to close the app.
        
        FIRMessaging.messaging().subscribeToTopic("/topics/\(topic.stringByReplacingOccurrencesOfString(" ", withString: ""))")
        print("Subscribed to the \(topic). Send me PNs?")
        JDStatusBarNotification.showWithStatus("Topic selected! You may now close the app. :)", dismissAfter: 4.0, styleName: "JDStatusBarStyleDark")
        
        //fetch the previous topic from the existing NSUserDefaults
        
        if(NSUserDefaults.standardUserDefaults().valueForKey("chosenOption") != nil){
        let getOption = NSUserDefaults.standardUserDefaults().valueForKey("chosenOption") as? Int
        let previous_topic = self.oneLiners[getOption!].stringByReplacingOccurrencesOfString(" ", withString: "")
        
        //unsubcribe from the previous topic. 
        FIRMessaging.messaging().unsubscribeFromTopic("/topics/\(previous_topic)")
        print("Unsubscribed from \(self.oneLiners[getOption!])")
        }
    
        NSUserDefaults.standardUserDefaults().setValue(optionChecked, forKey: "chosenOption")
        tableView.reloadData()
        
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .None
        }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "oneLinerShow" {
                let indexPath = sender! //this is how you send indexPath!
                let destinationViewController = segue.destinationViewController as! dailyOneLiner
                destinationViewController.cellClicked = indexPath.row
                destinationViewController.olTopics = oneLiners
            
        }
    }
    
}





// CODE WASTELAND. STUFF I TRIED BUT DIDNT WORKOUT BUT COULD BE USEFUL FOR LATER.


//    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        cell.backgroundColor = UIColor.init(hex: "#F4EC0E")
//        cell.accessoryView?.backgroundColor = UIColor.init(hex: "#F4EC0E")
//        cell.contentView.superview?.backgroundColor = UIColor.init(hex: "#F4EC0E")
//        cell.contentView.backgroundColor = UIColor.init(hex: "#F4EC0E")
//    }
