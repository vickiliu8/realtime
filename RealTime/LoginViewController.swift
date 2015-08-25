//
//  LoginViewController.swift
//  RealTime
//
//  Created by Vicki  Liu on 8/20/15.
//  Copyright (c) 2015 vickiliu. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    let permissions = ["public_profile", "email", "user_friends"]
    let tableViewWallSegue = "loginSuccessful"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let user = PFUser.currentUser() {
            if user.isAuthenticated() {
                self.performSegueWithIdentifier(tableViewWallSegue, sender: nil)
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginpressed(sender: AnyObject) {
       PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions, block: {
            (user: PFUser?, error: NSError?) -> Void in
            //switched ! to ? 
            if user == nil {
                NSLog("Uh oh. The user cancelled the Facebook login.")
            } else if user!.isNew {
                NSLog("User signed up and logged in through Facebook!")
               self.performSegueWithIdentifier(self.tableViewWallSegue, sender: nil)
            } else {
                
                NSLog("User logged in through Facebook! \(user!.username)")
                self.performSegueWithIdentifier(self.tableViewWallSegue, sender: nil)
            
            }
            })
    }
        

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
