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
//import Armchair


class oneLinerDisplay: UITableViewController,MGSwipeTableCellDelegate {
    
   //Declarations
    
    var chosenOption:Int!
    var oneLiners = ["Random"]
    var cellClicked:Int!
    var chosenTopics = [String]() //store all chosen topics here.
    var olRef: FIRDatabaseReference!
    var chosenTopic = UserDefaults.standard.value(forKey: "chosenOption") as? Int
    

        // Animate table method.
        //  ref: Appcoda tutorial
    
    func animateTable() {
        
        self.tableView.reloadData()
        
        let cells = self.tableView.visibleCells
        let tableHeight: CGFloat = self.tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
                }, completion: nil)
            
            index += 1
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.animateTable() // call each time the view(coming from the cardView back to the listView.)
        
        print("In viewWillAppear:")
        //print(NSUserDefaults.standardUserDefaults().valueForKey("chosenOption"))
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
        let defaults = UserDefaults.standard
        let hasViewedWalkthrough = defaults.bool(forKey: "hasViewedWalkthrough")
        if hasViewedWalkthrough {
            return
        }
        if let pageViewController =
            storyboard?.instantiateViewController(withIdentifier: "WalkthroughController")
                as? WalkthroughPageViewController {
            present(pageViewController, animated: true, completion: nil)
        }
        //print("In viewDidAppear.")
    }
    
    
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Armchair.appID("1127228637")  //Ask for a review. Set it to default.
        //Check if chosenTopic is not nil. If not, then add it to the array of chosenTopics. Add some backwards compatability between 1.1 and 1.2
        
       self.tableView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(swipeAction(_:))))
        
        if Reachability.isConnectedToNetwork() == true {
            //fetch 1Liners from Firebase.
            olRef = FIRDatabase.database().reference()
            olRef.child("topics").observe(.value, with: { (snapshot) in
                if snapshot.exists(){
                    let postDict = snapshot.value as! [String: AnyObject]
                    
                    let olTopicString = postDict["topic"] as! String
                    if olTopicString != "" {
                        self.oneLiners = olTopicString.components(separatedBy: ",")
                    }
                    print(snapshot.childrenCount)
                    
                    if self.oneLiners.count >= Int(snapshot.childrenCount)  {
                        print(self.oneLiners.count)
                        
                        //LOGIC: Add chosenTopic to the array. This ensures some kind of backward compatibility with previous versions. You check if chosenTopic is part of the existing array of 'ChosenTopics'. If not, you add it. Else you you let it be.
                        
                        
                        if(self.chosenTopic != nil) {
                            if (UserDefaults.standard.value(forKey: "chosenTopics") != nil) {
                                //fetch existing chosen topics.
                                var ct2 = UserDefaults.standard.value(forKey: "chosenTopics") as! [String] //there's already something here.
                                //check if chosenTopics is already there in the array.
                                if(ct2.contains(self.oneLiners[self.chosenTopic!]) == false) {
                                    ct2.append(self.oneLiners[self.chosenTopic!])
    
                                    UserDefaults.standard.setValue(ct2, forKey: "chosenTopics") //write to NSUSerDefaults.
                                    //print( NSUserDefaults.standardUserDefaults().valueForKey("chosenTopics"))
                                }
                            }
                            else {
                                self.chosenTopics.append(self.oneLiners[self.chosenTopic!])
                                UserDefaults.standard.setValue(self.chosenTopics, forKey: "chosenTopics")
                               // print(NSUserDefaults.standardUserDefaults().valueForKey("chosenTopics"))

                            }
                        }
                        else {
                            if (UserDefaults.standard.value(forKey: "chosenTopics") == nil) {
                            UserDefaults.standard.setValue(self.chosenTopics, forKey: "chosenTopics")
                            }
                            
                        }
                self.tableView.delegate = self
                self.tableView.dataSource = self
                        self.tableView.reloadData()
                        self.animateTable()
                        JDStatusBarNotification.show(withStatus: "Done.",dismissAfter: 2.0)
                        
                    }
                }
            })
            
        }
            
        else {
            DataService.showAlert(self)
            
        }
        self.view.backgroundColor = UIColor.init(red: 244, green: 236, blue: 14, alpha: 1)
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
        self.tableView.allowsMultipleSelection = false
        JDStatusBarNotification.show(withStatus: "Fetching topics.",dismissAfter: 2.0)
        
        
        print(UserDefaults.standard.value(forKey: "chosenTopics"))
        
        let image = UIImage(named: "logo_small")
        self.navigationItem.titleView = UIImageView(image: image)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit

    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
      
        return self.oneLiners.count
    }
    
    func swipeAction(_ sender:UIGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.ended {
            let swipeLocation = sender.location(in: self.tableView)
            if let swipedIndexPath = tableView.indexPathForRow(at: swipeLocation) {
                if self.tableView.cellForRow(at: swipedIndexPath) != nil {
                    print("Gesture recognized!")
                }
            }
        }
    }


   
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.contentView.backgroundColor = UIColor.init(red: 244, green: 236, blue: 14, alpha: 1)
        cell.accessoryView?.backgroundColor = UIColor.yellow
        cell.textLabel?.font = UIFont(name: "Avenir-Light", size: 24.0)
        
        //Rework the cell swiping without any external libraries that break.
//        let cSelector : Selector = "swipeAction"
        
        cell.isUserInteractionEnabled = true
        
//        for recognizer in cell.contentView.gestureRecognizers! {
//            cell.contentView.removeGestureRecognizer(recognizer)
//        }
        
        
        
        cell.contentView.tag = indexPath.row

        
//        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
//        rightSwipe.direction = UISwipeGestureRecognizerDirection.right
//        cell.addGestureRecognizer(rightSwipe) //add gesture recognizer to the cell.
        
        
        
        
//        //configure right buttons
//        cell.rightSwipeSettings.transition = .drag
//        cell.rightExpansion.animationDuration = 2
//        cell.rightExpansion.fillOnTrigger = true
//        cell.rightExpansion.expansionColor = UIColor.yellow
//        cell.rightExpansion.buttonIndex = 0
//        
        
//        
//        let swipeToCard = MGSwipeButton(title: "", icon: DataService.resizeImage(UIImage(named: "swipeArrow")!, newWidth: 24), backgroundColor: UIColor.yellow) { (cell) -> Bool in
//            let indexPath = self.tableView.indexPath(for:cell!)
//            self.performSegue(withIdentifier: "oneLinerShow", sender: indexPath)
//            return true
//
//        }
        
        
//        swipeToCard?.tintColor = UIColor.black
        
//        cell.rightButtons = [swipeToCard]
        
        cell.textLabel?.text = oneLiners[(indexPath as NSIndexPath).row]
       // let getOption = NSUserDefaults.standardUserDefaults().valueForKey("chosenOption") as? Int
//        print(getTopics)
        
        //LOGIC: Here. You fetch the latest and greatest array of ChosenTopics. You simply check if there's something in there from the oneLiners array and the chosenTopics array. And you rain in the check marks. else it's the tabs.
        if(UserDefaults.standard.value(forKey: "chosenTopics") != nil) {
            let getTopics = UserDefaults.standard.value(forKey: "chosenTopics") as! [String]
            print(getTopics)
            
            if getTopics.contains(oneLiners[(indexPath as NSIndexPath).row]) {
                var imageView : UIImageView
                imageView  = UIImageView(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
                imageView.image = UIImage(named:"Tick")
                cell.accessoryView = imageView
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 24.0)
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
    
  
   
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        FIRAnalytics.logEvent(withName: kFIREventSelectContent, parameters: [kFIRParameterContentType: oneLiners[(indexPath as NSIndexPath).row] as NSObject])
        
        //Local Variables
        
        let indexPath = tableView.indexPathForSelectedRow
        let cell = tableView.cellForRow(at: indexPath!)
        let optionChecked = (indexPath as NSIndexPath?)?.row

        cell?.accessoryView?.superview?.backgroundColor = UIColor.init(red: 244, green: 236, blue: 14, alpha: 1)

        //cell?.accessoryType = .Checkmark
        cell!.textLabel?.font = UIFont.boldSystemFont(ofSize: 24.0)

        
        let topic = oneLiners[optionChecked!] //topic is the cell I just chose.
        
        //LOG: Check if topic is already there in selected_topics. If it's there, remove it, save and reload table. Else, append, save and reload data.
        
        var selected_Topics = UserDefaults.standard.value(forKey: "chosenTopics") as! [String]
        if(selected_Topics.contains(oneLiners[optionChecked!])) {
            FIRMessaging.messaging().unsubscribe(fromTopic: "/topics/\(topic.replacingOccurrences(of: " ", with: ""))")
            let getIndex = selected_Topics.index(of: oneLiners[optionChecked!]) //get index of the element within selected_Topics
            selected_Topics.remove(at: getIndex!) //remove that element.
            
            UserDefaults.standard.setValue(selected_Topics, forKey: "chosenTopics")
            print("Unsubscribed from \(topic), here's the latest array: \(selected_Topics)")
            JDStatusBarNotification.show(withStatus: "Succesfully unsubscribed from topic!", dismissAfter: 2.0, styleName: "JDStatusBarStyleDark")
            
            tableView.reloadData()
        }
        
        else {
        FIRMessaging.messaging().subscribe(toTopic: "/topics/\(topic.replacingOccurrences(of: " ", with: ""))")
        print("Subscribed to the \(topic). Send me PNs?")
        JDStatusBarNotification.show(withStatus: "Topic selected! You may now close the app. :)", dismissAfter: 4.0, styleName: "JDStatusBarStyleDark")
        selected_Topics.append(topic)
        UserDefaults.standard.setValue(selected_Topics, forKey: "chosenTopics")
        tableView.reloadData()
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        let cell = tableView.cellForRow(at: indexPath!)
        print("De-selected row \(cell?.textLabel?.text)")
        }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "oneLinerShow" {
                let indexPath = sender! //this is how you send indexPath!
                let destinationViewController = segue.destination as! dailyOneLiner
                destinationViewController.cellClicked = (indexPath as AnyObject).row
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
    
