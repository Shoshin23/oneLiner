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
    var chosenOption:Int!
    var deselectedIndexPath:NSIndexPath = NSIndexPath()
    let oneLiners = Topics.oneLiners

    

    //Methods
    
        
        
    
        
        
        
    
    
    
    
    func scheduleNotifications(timeOfDay:String, alertTitle:String, alertBody:String) {
        
        
        let calendar:NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        var dateFire = NSDate()
        
        var fireComponents = calendar.components([NSCalendarUnit.Day, .Month, .Year, .Hour, .Minute],fromDate:dateFire)
        
        if(timeOfDay == "M") {
        
        if (fireComponents.hour >= 8) {
            
            dateFire = dateFire.dateByAddingTimeInterval(86400)
            fireComponents = calendar.components([NSCalendarUnit.Day, .Month, .Year, .Hour, .Minute],fromDate:dateFire)
            
        }
        
        fireComponents.hour = 8
        fireComponents.minute = 0
        }
        
        else if(timeOfDay == "E") {
            
        if (fireComponents.hour >= 19) {
            
            dateFire = dateFire.dateByAddingTimeInterval(86400)
            fireComponents = calendar.components([NSCalendarUnit.Day, .Month, .Year, .Hour, .Minute],fromDate:dateFire)
            
        }
        
        fireComponents.hour = 18
        fireComponents.minute = 05
    }
    
        dateFire = calendar.dateFromComponents(fireComponents)!
        
        let localNotification = UILocalNotification()
        localNotification.fireDate = dateFire
        localNotification.alertTitle = alertTitle
        localNotification.alertBody = alertBody
        localNotification.repeatInterval = NSCalendarUnit.Day
        localNotification.userInfo = ["TYPE":"SharePage"]
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        

        print(NSUserDefaults.standardUserDefaults().valueForKey("chosenOption"))
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        
        self.tableView.allowsMultipleSelection = false
        scheduleNotifications("M",alertTitle: "Hello World", alertBody: "The World is Yours!")
        scheduleNotifications("E", alertTitle: "Evening Time", alertBody: "Evening is here!")
        
        
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
        let indexPath = tableView.indexPathForSelectedRow
        
        let cell = tableView.cellForRowAtIndexPath(indexPath!)
        cell?.accessoryType = .Checkmark
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
