//
//  FiltersViewController.swift
//  RealTime
//
//  Created by Vicki  Liu on 8/25/15.
//  Copyright (c) 2015 vickiliu. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController {

    
       
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "onePressed" {
            let eventViewController = segue.destinationViewController as! EventsTableViewController
            eventViewController.predicate = NSPredicate(format: "1 IN filters")
            eventViewController.filter = true
        }else if segue.identifier == "twoPressed" {
            let eventViewController = segue.destinationViewController as! EventsTableViewController
            eventViewController.predicate = NSPredicate(format: "2 IN filters")
            eventViewController.filter = true
        }else if segue.identifier == "threePressed" {
            let eventViewController = segue.destinationViewController as! EventsTableViewController
            eventViewController.predicate = NSPredicate(format: "3 IN filters")
            eventViewController.filter = true
        }else if segue.identifier == "fourPressed" {
            let eventViewController = segue.destinationViewController as! EventsTableViewController
            eventViewController.predicate = NSPredicate(format: "4 IN filters")
            eventViewController.filter = true
        }else if segue.identifier == "fivePressed" {
            let eventViewController = segue.destinationViewController as! EventsTableViewController
            eventViewController.predicate = NSPredicate(format: "5 IN filters")
            eventViewController.filter = true
        }else if segue.identifier == "sixPressed" {
            let eventViewController = segue.destinationViewController as! EventsTableViewController
            eventViewController.predicate = NSPredicate(format: "6 IN filters")
            eventViewController.filter = true
        }else if segue.identifier == "sevenPressed" {
            println("seven pressed")
            let eventViewController = segue.destinationViewController as! EventsTableViewController
            eventViewController.predicate = NSPredicate(format: "7 IN filters")
            eventViewController.filter = true
        }else if segue.identifier == "eightPressed" {
            let eventViewController = segue.destinationViewController as! EventsTableViewController
            eventViewController.predicate = NSPredicate(format: "8 IN filters")
            eventViewController.filter = true
        }else if segue.identifier == "ninePressed" {
            let eventViewController = segue.destinationViewController as! EventsTableViewController
            eventViewController.predicate = NSPredicate(format: "9 IN filters")
            eventViewController.filter = true
        }else if segue.identifier == "tenPressed" {
            let eventViewController = segue.destinationViewController as! EventsTableViewController
            eventViewController.predicate = NSPredicate(format: "10 IN filters")
            eventViewController.filter = true
        }

    }
}
