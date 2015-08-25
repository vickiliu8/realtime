//
//  CreateEventViewController.swift
//  RealTime
//
//  Created by Vicki  Liu on 8/23/15.
//  Copyright (c) 2015 vickiliu. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController, UITextFieldDelegate{

    
 
    @IBOutlet weak var eventTitle: UITextField!
    
    
    
    @IBOutlet weak var eventLocation: UITextField!
    
    @IBOutlet weak var imageToUpload: UIImageView!
    @IBOutlet weak var eventDescription: UITextField!
    
    
    @IBOutlet weak var startTextField: UITextField!
    
    
    @IBOutlet weak var endTextField: UITextField!
    required init(coder aDecoder: (NSCoder!)) {
        //location = CLLocationCoordinate2DMake(0, 0)
        //place = PFGeoPoint(latitude: 0, longitude: 0)
        starttime = NSDate()
        endtime = NSDate()
        super.init(coder: aDecoder)

    }
    
    
   
    @IBAction func startEditing(sender: UITextField) {
        var datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: Selector("startdatePickerValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    
    @IBAction func endEditing(sender: UITextField) {
        
        var datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: Selector("enddatePickerValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)

    }
   
    var starttime: NSDate
    var endtime: NSDate
    func startdatePickerValueChanged(sender:UIDatePicker) {
        
        var dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle

        
        startTextField.text = dateFormatter.stringFromDate(sender.date)
        starttime = sender.date
    }
    
    func enddatePickerValueChanged(sender:UIDatePicker) {
        
        
        var dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        
        endTextField.text = dateFormatter.stringFromDate(sender.date)
        endtime = sender.date
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    
    
    @IBAction func addAPicture(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    
    
    
   @IBAction func donePressed(sender: AnyObject) {
        //commentTextField.resignFirstResponder()
        
        //Disable the send button until we are ready
        navigationItem.rightBarButtonItem?.enabled = false
        
       // loadingSpinner.startAnimating()
        
        //TODO: Upload a new picture
    if imageToUpload.image != nil {
        let pictureData = UIImagePNGRepresentation(imageToUpload.image)
        
        //1
        let file = PFFile(name: "image", data: pictureData)
        file.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
            if succeeded {
                //2
                self.saveEvent(file)
                println("success")
            } else if let error = error {
                //3
                println("error")
            }
            }, progressBlock: { percent in
                //4
                println("Uploaded: \(percent)%")
        })
    } else {
        var event = PFObject(className: "Event")
        event["address"] = self.eventLocation.text
        event["name"] = self.eventTitle.text
        var loc = event["address"] as! String
        var geocoder = CLGeocoder()
        event["start"] = starttime
        event["end"] = endtime
        event["startString"] = self.startTextField.text
        event["endString"] = self.endTextField.text
        
        println("times")
        println(starttime)
        println(endtime)
        
        CLGeocoder().geocodeAddressString(loc, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                println("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as! CLPlacemark
                println(pm)
                println(pm.location)
                var gp = PFGeoPoint(location: pm.location)
                println("geopoint")
                println(gp)
                event["location"] = gp
                event.saveInBackground()
            }
            else {
                println("Problem with the data received from geocoder")
            }
        })
        
        //2
        event.saveInBackgroundWithBlock{ succeeded, error in
            if succeeded {
                //3
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                //4
                println("couldn't save object")
            }
        }

    }
    
    }
    
    func saveEvent(file: PFFile)
    {
        //1
        var event = PFObject(className: "Event")
        event["address"] = self.eventLocation.text
        event["name"] = self.eventTitle.text
        event["picture"] = file
        
        var loc = event["address"] as! String
        var geocoder = CLGeocoder()
        event["start"] = starttime
        event["end"] = endtime
        println("times")
        println(starttime)
        println(endtime)

        
        CLGeocoder().geocodeAddressString(loc, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                println("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as! CLPlacemark
                println(pm)
                println(pm.location)
                var gp = PFGeoPoint(location: pm.location)
                println("geopoint")
                println(gp)
                event["location"] = gp
                event.saveInBackground()
            }
            else {
                println("Problem with the data received from geocoder")
            }
        })

        //2
        event.saveInBackgroundWithBlock{ succeeded, error in
            if succeeded {
                //3
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                //4
                println("couldn't save object")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.toolbarHidden = false

        self.eventTitle.delegate = self
       // self.startTime.delegate = self
       // self.endTime.delegate = self
        self.eventLocation.delegate = self
        self.eventDescription.delegate = self
        self.startTextField.delegate = self
        self.endTextField.delegate = self
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
               // Do any additional setup after loading the view.
    }
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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


extension CreateEventViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        //Place the image in the imageview
        imageToUpload.image = image
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}

