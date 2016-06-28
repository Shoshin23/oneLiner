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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ModalView.animation = "slideUp"
        ModalView.curve = "easeInOutQuart"
        ModalView.duration = 2.3
        ModalView.animate()
        

        
    }

    @IBOutlet var ModalView: SpringView!
}
