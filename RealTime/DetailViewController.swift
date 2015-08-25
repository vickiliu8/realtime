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
    var eventImage: PFFile?
    var eventEnd: String?
    
    @IBOutlet weak var Image: PFImageView!
    
    @IBOutlet weak var EndTime: UILabel!
    @IBOutlet weak var Name: UILabel!
    
    @IBOutlet weak var Blurb: UILabel!
    @IBOutlet weak var Address: UILabel!
    @IBOutlet weak var Distance: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Name.text = eventName
        //println(eventName)
        // Do any additional setup after loading the view.
        Distance.text = eventDistance! + "mi"
        Address.text = eventAddress
        Blurb.text = eventBlurb
        if eventEnd != nil {
            EndTime.text = "END TIME: " + eventEnd!}
        if eventImage != nil {
            Image.file = eventImage
            Image.loadInBackground()
        }else {
            var placeholder = UIImage(named: "placeholder.JPG")
            Image.image = placeholder
        }
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
