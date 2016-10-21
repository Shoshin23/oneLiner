//
//  WalkthroughPageViewController.swift
//  oneLiner
//
//  Created by Karthik Kannan on 22/06/16.
//  Copyright © 2016 Karthik Kannan. All rights reserved.
//

import UIKit

class WalkthroughPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    var pageContent = ["Welcome to 1Liner, a simple app that sends you one line everyday about the things you like.","You pick a topic you like.", "And you get a line about it twice everyday.", "You open the app only if you feel like sharing it."]
    var pageImages = ["LaunchImage","page1", "page2", "page3"]
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController:UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentViewController).index
        index += 1
        return viewControllerAtIndex(index)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) ->
        UIViewController? {
            var index = (viewController as! WalkthroughContentViewController).index
            index -= 1
            return viewControllerAtIndex(index)
    }
    func viewControllerAtIndex(_ index: Int) -> WalkthroughContentViewController? {
        if index == NSNotFound || index < 0 || index >= pageContent.count {
            return nil
        }
        // Create a new view controller and pass suitable data.
        if let pageContentViewController =
            storyboard?.instantiateViewController(withIdentifier: "WalkthroughContentViewController")
                as? WalkthroughContentViewController {
            pageContentViewController.imageFile = pageImages[index]
            pageContentViewController.content = pageContent[index]
            pageContentViewController.index = index
            return pageContentViewController
        }
        return nil }
    
    func forward(_ index:Int) {
        if let nextViewController = viewControllerAtIndex(index + 1) {
            setViewControllers([nextViewController], direction: .forward, animated:
                true, completion: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the data source to itself
        dataSource = self
        // Create the first walkthrough screen
        if let startingViewController = viewControllerAtIndex(0) {
            setViewControllers([startingViewController], direction: .forward,animated: true, completion: nil)
        }


}
}
