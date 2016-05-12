//
//  oneLinerDisplay.swift
//  oneLiner
//
//  Created by Karthik Kannan on 08/05/16.
//  Copyright © 2016 Karthik Kannan. All rights reserved.
//

import UIKit
import Firebase


class oneLinerDisplay: UITableViewController {
    
   //Declarations
    
    var checked:Bool = false
    var dateFire:NSDate = NSDate()
    var chosenOption:Int!
    var deselectedIndexPath:NSIndexPath = NSIndexPath()
    

    //methods
    func setTime() {
        
        
        let calendar:NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        var dateFire = NSDate()
        
        var fireComponents = calendar.components([NSCalendarUnit.Day, .Month, .Year, .Hour, .Minute],fromDate:dateFire)
        
        if (fireComponents.hour >= 7) {
            
            dateFire = dateFire.dateByAddingTimeInterval(86400)
            fireComponents = calendar.components([NSCalendarUnit.Day, .Month, .Year, .Hour, .Minute],fromDate:dateFire)
            
        }
        
        fireComponents.hour = 7
        fireComponents.minute = 0
        
        self.dateFire = calendar.dateFromComponents(fireComponents)!
        
        
        
        
    }
    
    
    
    func scheduleNotifications(alertTitle:String, alertBody:String) {
        
        let localNotification = UILocalNotification()
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 15)
        localNotification.alertTitle = alertTitle
        localNotification.alertBody = alertBody
        localNotification.userInfo = ["TYPE":"SharePage"]
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        
        self.tableView.allowsMultipleSelection = false

        
    }
    
    
    
    let oneLiners = Topics.oneLiners
    
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

    }
    

    
    

}
