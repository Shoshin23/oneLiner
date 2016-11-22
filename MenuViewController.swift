//
//  MenuViewController.swift
//  oneLiner
//
//  Created by Karthik Kannan on 21/11/16.
//  Copyright © 2016 Karthik Kannan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import FirebaseInstanceID
import Material

class MenuViewController: UIViewController {

    @IBOutlet weak var muteButton: FlatButton!
    
    
    @IBAction func muteTapped(_ sender: Any) {
        
        FIRMessaging.messaging().subscribe(toTopic: "/topics/RAJINI")
        print("Subscribed to notifications.")

        
        let dateSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        dateSheet.addAction(UIAlertAction(title: "1 Day", style: .default, handler: nil))
        dateSheet.addAction(UIAlertAction(title: "1 Week", style: .default, handler: nil))
        dateSheet.addAction(UIAlertAction(title: "1 Year", style: .default, handler: nil))
        dateSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        

        present(dateSheet, animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print("In MenuViewController. Welcome to 2.0")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
