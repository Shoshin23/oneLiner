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
    @IBOutlet var popUpView: UIView!
    
    
    
    @IBAction func dismissVC(sender: UIButton) {
        
        let presentingViewController: UIViewController! = self.presentingViewController
        
        self.dismissViewControllerAnimated(false) {
            presentingViewController.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func aboutButton(sender: UIButton) {
        
        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.lotus-bee.com")!)

        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popUpView.layer.cornerRadius = 10
        popUpView.layer.borderColor = UIColor.blackColor().CGColor
        popUpView.layer.borderWidth = 0.25
        popUpView.layer.shadowColor = UIColor.blackColor().CGColor
        popUpView.layer.shadowOpacity = 0.8
        popUpView.layer.shadowRadius = 25
        popUpView.layer.shadowOffset = CGSize(width: 5, height: 5)
        popUpView.layer.masksToBounds = false
        
//        view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)

        
        
    }

}
