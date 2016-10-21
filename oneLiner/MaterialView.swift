//
//  MaterialView.swift
//  oneLiner
//
//  Created by Karthik Kannan on 10/05/16.
//  Copyright © 2016 Karthik Kannan. All rights reserved.
//

import UIKit


class MaterialView: UIView {
    
    override func awakeFromNib() {
        layer.cornerRadius = 2.0
        layer.shadowColor = UIColor(red: 157.0/255.0, green: 157.0/255.0, blue: 157.0/255.0, alpha: 0.5).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        
    }
    
}
