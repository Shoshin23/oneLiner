//
//  oneLinerDisplay.swift
//  oneLiner
//
//  Created by Karthik Kannan on 08/05/16.
//  Copyright © 2016 Karthik Kannan. All rights reserved.
//

import UIKit


class oneLinerDisplay: UITableViewController {
    
    
    let oneLiners = ["Motivation", "Health Tips", "Fun Facts", "Startup Quotes", "Jokes", "Buddhist Quotes", "Shower Thoughts", "Pop Quiz", "Emojis", "Random"]
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = oneLiners[indexPath.row]
        
        return cell
    }
    
    

}
