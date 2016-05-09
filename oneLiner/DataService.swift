//
//  DataService.swift
//  oneLiner
//
//  Created by Karthik Kannan on 10/05/16.
//  Copyright © 2016 Karthik Kannan. All rights reserved.
//

import UIKit
import Firebase


let BASE_URL = "https://1liner.firebaseio.com"

class DataService {
    
static let ds = DataService()
    
    
    private var _REF_POSTS = Firebase(url: BASE_URL)
    
    var REF_POSTS:Firebase {
        return _REF_POSTS
    }
    
    
}
