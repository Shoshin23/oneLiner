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

public class DataService {
    
    //Show Alert regarding the internet.
    class func showAlert(viewController:UIViewController) -> Void {
        let alertController = UIAlertController(title: "No Internet Connection", message: "Please make sure your device is connected to the Internet.", preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        viewController.presentViewController(alertController, animated: true, completion: nil)

        
    }
    
    //Configure a Material Design Card.
    class func configureCard (card:UIView) -> Void {
        card.layer.cornerRadius = 2
        card.layer.borderColor = UIColor.blackColor().CGColor
        card.layer.borderWidth = 0.25
        card.layer.shadowColor = UIColor.blackColor().CGColor
        card.layer.shadowOpacity = 0.8
        card.layer.shadowRadius = 6
        card.layer.shadowOffset = CGSize(width: 2, height: 2)
        card.layer.masksToBounds = false
        
        
    }

    class func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    

}