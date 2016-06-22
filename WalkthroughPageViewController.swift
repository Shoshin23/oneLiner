//
//  WalkthroughPageViewController.swift
//  oneLiner
//
//  Created by Karthik Kannan on 22/06/16.
//  Copyright © 2016 Karthik Kannan. All rights reserved.
//

import UIKit

class WalkthroughPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    var pageContent = ["You pick a topic you like.", "And you get a line about it twice everyday. Once at 8 AM and 6 PM.", "You open the app only if you feel like sharing it."]
    var pageImages = ["page1", "page2", "page3"]
    
    func pageViewController(pageViewController: UIPageViewController,
                            viewControllerAfterViewController viewController:UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentViewController).index
        index += 1
        return viewControllerAtIndex(index)
        
    }
    
    func pageViewController(pageViewController: UIPageViewController,
                            viewControllerBeforeViewController viewController: UIViewController) ->
        UIViewController? {
            var index = (viewController as! WalkthroughContentViewController).index
            index -= 1
            return viewControllerAtIndex(index)
    }
    func viewControllerAtIndex(index: Int) -> WalkthroughContentViewController? {
        if index == NSNotFound || index < 0 || index >= pageContent.count {
            return nil
        }
        // Create a new view controller and pass suitable data.
        if let pageContentViewController =
            storyboard?.instantiateViewControllerWithIdentifier("WalkthroughContentViewController")
                as? WalkthroughContentViewController {
            pageContentViewController.imageFile = pageImages[index]
            pageContentViewController.content = pageContent[index]
            pageContentViewController.index = index
            return pageContentViewController
        }
        return nil }
    
    func forward(index:Int) {
        if let nextViewController = viewControllerAtIndex(index + 1) {
            setViewControllers([nextViewController], direction: .Forward, animated:
                true, completion: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the data source to itself
        dataSource = self
        // Create the first walkthrough screen
        if let startingViewController = viewControllerAtIndex(0) {
            setViewControllers([startingViewController], direction: .Forward,animated: true, completion: nil)
        }


}
}
