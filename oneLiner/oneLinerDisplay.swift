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
import Armchair


class oneLinerDisplay: UITableViewController {
    
   //Declarations
    
    var chosenOption:Int!
    var oneLiners = ["Random"]
    var cellClicked:Int!
    var chosenTopics = [String]() //store all chosen topics here.
    var olRef: FIRDatabaseReference!
    var chosenTopic = NSUserDefaults.standardUserDefaults().valueForKey("chosenOption") as? Int
    

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
        
        Armchair.appID("1127228637")  //Ask for a review. Set it to default.
        //Check if chosenTopic is not nil. If not, then add it to the array of chosenTopics. Add some backwards compatability between 1.1 and 1.2
        
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
                        
                        //LOGIC: Add chosenTopic to the array. This ensures some kind of backward compatibility with previous versions. You check if chosenTopic is part of the existing array of 'ChosenTopics'. If not, you add it. Else you you let it be.
                        
                        
                        if(self.chosenTopic != nil) {
                            if (NSUserDefaults.standardUserDefaults().valueForKey("chosenTopics") != nil) {
                                //fetch existing chosen topics.
                                var ct2 = NSUserDefaults.standardUserDefaults().valueForKey("chosenTopics") as! [String] //there's already something here.
                                //check if chosenTopics is already there in the array.
                                if(ct2.contains(self.oneLiners[self.chosenTopic!]) == false) {
                                    ct2.append(self.oneLiners[self.chosenTopic!])
    
                                    NSUserDefaults.standardUserDefaults().setValue(ct2, forKey: "chosenTopics") //write to NSUSerDefaults.
                                    //print( NSUserDefaults.standardUserDefaults().valueForKey("chosenTopics"))
                                }
                            }
                            else {
                                self.chosenTopics.append(self.oneLiners[self.chosenTopic!])
                                NSUserDefaults.standardUserDefaults().setValue(self.chosenTopics, forKey: "chosenTopics")
                               // print(NSUserDefaults.standardUserDefaults().valueForKey("chosenTopics"))

                            }
                        }
                        else {
                            NSUserDefaults.standardUserDefaults().setValue(self.chosenTopics, forKey: "chosenTopics")
                        }
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
        
        
        print(NSUserDefaults.standardUserDefaults().valueForKey("chosenTopics"))
        
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
        
        let swipeToCard = MGSwipeButton(title: "",icon: DataService.resizeImage(UIImage(named: "swipeArrow")!, newWidth: 24),backgroundColor: UIColor.yellowColor(), callback: {
            (sender: MGSwipeTableCell!) -> Bool in
            
            let indexPath = self.tableView.indexPathForCell(sender)
            self.performSegueWithIdentifier("oneLinerShow", sender: indexPath)
            return true
        })
        
        swipeToCard.tintColor = UIColor.blackColor()
        
        cell.rightButtons = [swipeToCard]
        
        cell.textLabel?.text = oneLiners[indexPath.row]
       // let getOption = NSUserDefaults.standardUserDefaults().valueForKey("chosenOption") as? Int
//        print(getTopics)
        
        //LOGIC: Here. You fetch the latest and greatest array of ChosenTopics. You simply check if there's something in there from the oneLiners array and the chosenTopics array. And you rain in the check marks. else it's the tabs.
        if(NSUserDefaults.standardUserDefaults().valueForKey("chosenTopics") != nil) {
            let getTopics = NSUserDefaults.standardUserDefaults().valueForKey("chosenTopics") as! [String]
            print(getTopics)
            
            if getTopics.contains(oneLiners[indexPath.row]) {
                var imageView : UIImageView
                imageView  = UIImageView(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
                imageView.image = UIImage(named:"Tick")
                cell.accessoryView = imageView
                cell.textLabel?.font = UIFont.boldSystemFontOfSize(24.0)
            }
            else {
                var imageView : UIImageView
                imageView  = UIImageView(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
                imageView.image = UIImage(named:"tabsArrow")
                cell.accessoryView = imageView
                
            }

        }
        
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        FIRAnalytics.logEventWithName(kFIREventSelectContent, parameters: [kFIRParameterContentType: oneLiners[indexPath.row]])
        
        //Local Variables
        
        let indexPath = tableView.indexPathForSelectedRow
        let cell = tableView.cellForRowAtIndexPath(indexPath!)
        let optionChecked = indexPath?.row

        cell?.accessoryView?.superview?.backgroundColor = UIColor.init(hex: "#F4EC0E")

        //cell?.accessoryType = .Checkmark
        cell!.textLabel?.font = UIFont.boldSystemFontOfSize(24.0)

        
        let topic = oneLiners[optionChecked!] //topic is the cell I just chose.
        
        //LOG: Check if topic is already there in selected_topics. If it's there, remove it, save and reload table. Else, append, save and reload data.
        
        var selected_Topics = NSUserDefaults.standardUserDefaults().valueForKey("chosenTopics") as! [String]
        if(selected_Topics.contains(oneLiners[optionChecked!])) {
            FIRMessaging.messaging().unsubscribeFromTopic("/topics/\(topic.stringByReplacingOccurrencesOfString(" ", withString: ""))")
            let getIndex = selected_Topics.indexOf(oneLiners[optionChecked!]) //get index of the element within selected_Topics
            selected_Topics.removeAtIndex(getIndex!) //remove that element.
            
            NSUserDefaults.standardUserDefaults().setValue(selected_Topics, forKey: "chosenTopics")
            print("Unsubscribed from \(topic), here's the latest array: \(selected_Topics)")
            JDStatusBarNotification.showWithStatus("Succesfully unsubscribed from topic!", dismissAfter: 2.0, styleName: "JDStatusBarStyleDark")
            
            tableView.reloadData()
        }
        
        else {
        FIRMessaging.messaging().subscribeToTopic("/topics/\(topic.stringByReplacingOccurrencesOfString(" ", withString: ""))")
        print("Subscribed to the \(topic). Send me PNs?")
        JDStatusBarNotification.showWithStatus("Topic selected! You may now close the app. :)", dismissAfter: 4.0, styleName: "JDStatusBarStyleDark")
        selected_Topics.append(topic)
        NSUserDefaults.standardUserDefaults().setValue(selected_Topics, forKey: "chosenTopics")
        tableView.reloadData()
        }
        
        
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        let cell = tableView.cellForRowAtIndexPath(indexPath!)
        print("De-selected row \(cell?.textLabel?.text)")
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


//    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
//        let more = UITableViewRowAction(style: .Default, title: "➔") { action, index in
//
//        }
//
//        more.backgroundColor = UIColor.grayColor()
//
//        return [more]
//    }

//    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        // you need to implement this method too or you can't swipe to display the actions
//    }
    