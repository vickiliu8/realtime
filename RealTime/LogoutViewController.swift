//
//  LogoutViewController.swift
//  RealTime
//
//  Created by Vicki  Liu on 8/24/15.
//  Copyright (c) 2015 vickiliu. All rights reserved.
//

import UIKit

class LogoutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func logoutPressed(sender: AnyObject) {
        /*var login: FBSDKLoginManager = FBSDKLoginManager()
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            login.logOut()
        }*/
            PFUser.logOut()
            println(PFUser.currentUser())
            navigationController?.popToRootViewControllerAnimated(true)
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
