//
//  DetailViewController.swift
//  RealTime
//
//  Created by Vicki  Liu on 8/23/15.
//  Copyright (c) 2015 vickiliu. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var eventName: String?
    var eventDistance: String?
    var eventBlurb: String?
    var event: AnyObject?
    var eventAddress: String?
    @IBOutlet weak var Name: UILabel!
    
    @IBOutlet weak var Address: UILabel!
    @IBOutlet weak var Distance: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        Name.text = eventName
        //println(eventName)
        // Do any additional setup after loading the view.
        Distance.text = eventDistance
        Address.text = eventAddress
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
