//
//  oneLinerDisplay.swift
//  oneLiner
//
//  Created by Karthik Kannan on 08/05/16.
//  Copyright © 2016 Karthik Kannan. All rights reserved.
//

import UIKit


class oneLinerDisplay: UITableViewController {
    
    
    var checked:Bool = false
    
   // func setupNotification() {
        
//        let NotificationSettings:UIUserNotificationType = UIUserNotificationType([.Alert, .Sound, .Badge])
//        
//        let justInform = UIMutableUserNotificationAction()
//        
//        justInform.identifier = "JustInform"
//        justInform.title = "Thanks, that was awesome!"
//        justInform.activationMode = UIUserNotificationActivationMode.Background
//        justInform.authenticationRequired = false
//        
//        let ShareAction = UIMutableUserNotificationAction()
//        ShareAction.identifier = "Share"
//        ShareAction.title = "Share this 1Liner."
//        ShareAction.activationMode = UIUserNotificationActivationMode.Foreground //ShareAction needs the app in the foreground.
//        ShareAction.authenticationRequired = false
//        
//        let actionsArry = NSArray(objects: ShareAction, justInform)
//        
//        
//        let shareActionCategory = UIMutableUserNotificationCategory()
//        
//        shareActionCategory.identifier = "ShareActionCategory"
//        shareActionCategory.setActions(actionsArry as? [UIUserNotificationAction], forContext: .Minimal)
//        let categoriesForSettings = NSSet(object: shareActionCategory)
//        
//        let newNotifcationSettings = UIUserNotificationSettings(forTypes: NotificationSettings, categories: categoriesForSettings as? Set<UIUserNotificationCategory>)
        //UIApplication.sharedApplication().registerUserNotificationSettings()
    //}
    
    var dateFire:NSDate = NSDate()
    
    func setTime() {
        
        
        var calendar:NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        var dateFire = NSDate()
        
        var fireComponents = calendar.components([NSCalendarUnit.Day, .Month, .Year, .Hour, .Minute],fromDate:dateFire)
        
        if (fireComponents.hour >= 12) {
            
            dateFire = dateFire.dateByAddingTimeInterval(86400)
            fireComponents = calendar.components([NSCalendarUnit.Day, .Month, .Year, .Hour, .Minute],fromDate:dateFire)
            
        }
        
        fireComponents.hour = 11
        fireComponents.minute = 9
        
        self.dateFire = calendar.dateFromComponents(fireComponents)!
        
        
        
        
    }
    
    
    
    func scheduleNotifications(alertTitle:String, alertBody:String) {
        
        let localNotification = UILocalNotification()
        localNotification.fireDate = self.dateFire
        localNotification.alertTitle = alertTitle
        localNotification.alertBody = alertBody
        localNotification.userInfo = ["TYPE":"SharePage"]
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    

    
    var chosenOption:Int!
    var deselectedIndexPath:NSIndexPath = NSIndexPath()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        
        self.tableView.allowsMultipleSelection = false

        
    }
    
    
    
    let oneLiners = ["Motivation", "Health Tips", "Fun Facts", "Startup Quotes", "Jokes", "Buddhist Quotes", "Shower Thoughts", "Pop Quiz", "Emojis", "Random"]
    
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
        let indexPath = tableView.indexPathForSelectedRow
        
        let cell = tableView.cellForRowAtIndexPath(indexPath!)
        cell?.accessoryType = .Checkmark
        print("Cell selected:\(indexPath?.row)")
        scheduleNotifications("click to share", alertBody: "Elaka!")
        self.chosenOption = indexPath?.row
        NSUserDefaults.standardUserDefaults().setValue(self.chosenOption, forKey: "chosenOption")
        tableView.reloadData()
        
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        cell?.accessoryType = .None
        print("Cell de-selected:\(indexPath.row)")
//        tableView.reloadData()

    }
    

    
    

}
