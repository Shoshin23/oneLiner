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
    @IBOutlet var aboutLabel: UILabel!
    @IBAction func dismissVC(sender: UIButton) {
        
        let presentingViewController: UIViewController! = self.presentingViewController
        
        self.dismissViewControllerAnimated(false) {
            presentingViewController.dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(ModalViewController.tapFunction(_:)))
        aboutLabel.addGestureRecognizer(tap)
        
        print("In view did load of ModalVC!")
    }
    func tapFunction(sender:UITapGestureRecognizer) {
        print("tap working")
    }

}
