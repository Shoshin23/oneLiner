//
//  ModalViewController.swift
//  oneLiner
//
//  Created by Karthik Kannan on 23/06/16.
//  Copyright © 2016 Karthik Kannan. All rights reserved.
//

import UIKit


class ModalViewController: UIViewController {
    @IBOutlet var popUpView: UIView!
    
    
    
    @IBAction func dismissVC(_ sender: UIButton) {
        
        let presentingViewController: UIViewController! = self.presentingViewController
        
        self.dismiss(animated: false) {
            presentingViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func aboutButton(_ sender: UIButton) {
        
        UIApplication.shared.openURL(URL(string: "http://www.lotus-bee.com")!)

        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
       DataService.configureCard(popUpView)
        
//        view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)

        
        
    }

}
