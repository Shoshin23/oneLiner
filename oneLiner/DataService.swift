//
//  DataService.swift
//  oneLiner
//
//  Created by Karthik Kannan on 10/05/16.
//  Copyright © 2016 Karthik Kannan. All rights reserved.
// Will host a bunch of functions i'm using across the board.
//

import UIKit
import FirebaseDatabase
import Firebase

open class DataService {
    
    //Show Alert regarding the internet.
    class func showAlert(_ viewController:UIViewController) -> Void {
        let alertController = UIAlertController(title: "No Internet Connection", message: "Please make sure your device is connected to the Internet.", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        viewController.present(alertController, animated: true, completion: nil)

        
    }
    
    //Configure a Material Design Card.
    class func configureCard (_ card:UIView) -> Void {
        card.layer.cornerRadius = 2
        card.layer.borderColor = UIColor.black.cgColor
        card.layer.borderWidth = 0.25
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.8
        card.layer.shadowRadius = 6
        card.layer.shadowOffset = CGSize(width: 2, height: 2)
        card.layer.masksToBounds = false
        
        
    }

    class func resizeImage(_ image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    

}
