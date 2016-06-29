//
//  ModalViewController.swift
//  oneLiner
//
//  Created by Karthik Kannan on 23/06/16.
//  Copyright © 2016 Karthik Kannan. All rights reserved.
//

import UIKit
import Spring


class ModalViewController: UIViewController {
    @IBAction func dismissVC(sender: UIButton) {
        
        let presentingViewController: UIViewController! = self.presentingViewController
        
        self.dismissViewControllerAnimated(false) {
            presentingViewController.dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
    @IBAction func aboutButton(sender: UIButton) {
        
        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.lotus-bee.com")!)

        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

}
