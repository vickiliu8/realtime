//
//  EventsTableViewController.swift
//  RealTime
//
//  Created by Vicki  Liu on 8/19/15.
//  Copyright (c) 2015 vickiliu. All rights reserved.
//

import UIKit
import CoreLocation
import AddressBookUI

extension PFGeoPoint {
    public var cllocation: CLLocation {
        get {
            return CLLocation(latitude: latitude, longitude: longitude)
        }
    }
}


class EventsTableViewController: PFQueryTableViewController,  CLLocationManagerDelegate {
    // MARK: - Lifecycle
    
   // let predicate = NSPredicate(format: "2 IN filters")
    var predicate: NSPredicate
    var events = [AnyObject]()
    var filter: Bool
    var location: CLLocationCoordinate2D
    

    let place = PFGeoPoint(latitude:40.0, longitude:-30.0)
    
    required init(coder aDecoder: NSCoder!) {
        location = CLLocationCoordinate2DMake(0, 0)
        predicate = NSPredicate()
        filter = Bool()
        //var date = NSDate()
        //place = PFGeoPoint(latitude: 0, longitude: 0)
        super.init(coder: aDecoder)
    }
  
    let cellIdentifier:String = "EventCell"
    let locationManager = CLLocationManager()
    
    
    
   // var events = [Event]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorColor = UIColor.blackColor()
        self.navigationController!.toolbarHidden = false
        //self.navigationController!.toolbar.barStyle = UIBarStyleDefault
        
        self.navigationController!.toolbar.tintColor =  UIColor.whiteColor().colorWithAlphaComponent(0.8)

        
        /*self.navigationController!.toolbar.setBackgroundImage(UIImage(),
            forToolbarPosition: UIBarPosition.Any,
            barMetrics: UIBarMetrics.Default)
        
        
        self.navigationController!.toolbar.setShadowImage(UIImage(),
            forToolbarPosition: UIBarPosition.Any)*/
        
        
        
        
        /*PFGeoPoint.geoPointForCurrentLocationInBackground { point, error in
            if error == nil {
                println("la")
                self.usersLocation = point
            }
        }*/
                
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        PFGeoPoint.geoPointForCurrentLocationInBackground { point, error in
            if error == nil {
            //    self.place = point!
                println("hi")
                println(point)
               // print(self.currentLocation)
                println(self.place)
                
                var currentUser: PFUser = PFUser.currentUser()!
                currentUser.setObject(point!, forKey: "location")
                currentUser.saveInBackground()
            }
        }

        
    }
    
    @IBAction func homePressed(sender: AnyObject) {
        self.loadObjects()
    }
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var locValue:CLLocationCoordinate2D = manager.location.coordinate
        self.location = locValue
       // self.currentLocation = locValue
       // println("locations = \(locValue.latitude) \(locValue.longitude)")
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location " + error.localizedDescription)
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        println("didChangeAuthorizationStatus called")
        if(status == CLAuthorizationStatus.AuthorizedWhenInUse) {
            println("status = authorized when in use")
        }
    }
    
           //1
    /*override func viewWillAppear(animated: Bool) {
        loadObjects()
    }*/
    
    //2
    override func queryForTable() -> PFQuery {
        
        var query : PFQuery
        if filter == false {
            query = PFQuery(className:"Event")
        }else {
            query = PFQuery(className: "Event", predicate: predicate)
           // events = query.findObjects()!
           // println(events)
        }
        //query.cachePolicy = .NetworkElseCache

        var usersLocation: AnyObject? = PFUser.currentUser()!["location"]
        println(usersLocation)
        
        query.whereKey("location", nearGeoPoint:usersLocation! as! PFGeoPoint)
        //query.limit = 10
        // Final list of objects
        
        query.limit = 30
      /*  query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects!.count) scores.")
                self.events = objects!
            } else {
                // Log details of the failure
                println("Error")
            }
        }*/
        
       // events = query.findObjects()!
        return query

    }
    
    //3
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject!) -> EventsTableViewCell? {
               let cell:EventsTableViewCell? = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as? EventsTableViewCell
        
        
        if let pfObject = object {
            cell?.eventName?.text = pfObject["name"] as? String
            //println(pfObject)
            
            var locA: AnyObject? = pfObject["location"]
            var locB: AnyObject? = PFUser.currentUser()!["location"]
            println("stuff")
            //println(locA)
            //println(locB)
            locA = locA as! PFGeoPoint
            locB = locB as! PFGeoPoint
            var latitude: CLLocationDegrees = locA!.latitude
            var longitude: CLLocationDegrees = locA!.longitude
            
             var locationA = CLLocation(latitude: latitude, longitude: longitude)
            
            var eventLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            latitude = locB!.latitude
            longitude = locB!.longitude
            
            var locationB = CLLocation(latitude: latitude, longitude: longitude)
            let distance = locationA.distanceFromLocation(locationB)
            //println("miles")
            
            //println(distance * 0.000621371)
            var miles = distance * 0.000621371
            var m:String = String(format:"%.1f", miles)
            cell!.eventDistance.text = m + " mi"
        
            pfObject.setObject(m, forKey: "distFromCurrentUser")
            pfObject.saveInBackground()
            
            var placeholder = UIImage(named: "placeholder.JPG")
            cell?.eventImage.image = placeholder
            if pfObject.objectForKey("picture") != nil {
            cell!.eventImage.file = (pfObject.objectForKey("picture") as! PFFile)
            cell!.eventImage.loadInBackground(nil) { percent in
                
                println("uploading")
            }
            }
            
            CLGeocoder().reverseGeocodeLocation(locationA, completionHandler: {(placemarks, error) -> Void in
                if error != nil {
                    println("Reverse geocoder failed with error" + error.localizedDescription)
                    return
                }
                
                if placemarks.count > 0 {
                    let pm = placemarks[0] as! CLPlacemark
                   //println(pm)
                    //println("locality")
                   // println(pm.locality)
                    let s = ABCreateStringWithAddressDictionary(pm.addressDictionary, false)
                    pfObject.setObject(s, forKey: "address")
                    pfObject.saveInBackground()
                    //print(pm.street)
                }
                else {
                    println("Problem with the data received from geocoder")
                }
            })
            
        }
       cell?.clipsToBounds = true
        return cell
}
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showEventDetail" {
            
            /*let detailViewController = segue.destinationViewController as! DetailViewController
            if let indexPath = tableView.indexPathForCell(sender as! EventsTableViewCell) {
                
                /*var b_image = self.view.convertViewToImage()
                b_image = b_image.applyBlurWithRadius(2, tintColor: UIColor(white: 0.0, alpha: 0.5), saturationDeltaFactor: 1.0, maskImage: nil)!
                var backView = UIImageView(frame: self.view.frame)
                backView.image = b_image
                backView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
                detailViewController.view.insertSubview(backView, atIndex: 0)*/
                
                
                detailViewController.eventName = events[indexPath.row]["name"] as! String?
                detailViewController.eventBlurb = events[indexPath.row]["blurb"] as! String?
                detailViewController.eventDistance = events[indexPath.row]["distFromCurrentUser"] as! String?
                detailViewController.eventAddress = events[indexPath.row]["address"] as! String?
                detailViewController.eventImage = events[indexPath.row]["picture"] as! PFFile?
                detailViewController.eventBlurb = events[indexPath.row]["blurb"] as! String?
                detailViewController.eventEnd = events[indexPath.row]["endString"] as! String?
            
            }*/
            let detailViewController = segue.destinationViewController as! DetailViewController
            if let  indexPath = tableView.indexPathForCell(sender as! EventsTableViewCell){
            var object: PFObject = self.objectAtIndexPath(indexPath)!
                detailViewController.eventName = object["name"] as! String?
                detailViewController.eventBlurb = object["blurb"] as! String?
                detailViewController.eventDistance = object["distFromCurrentUser"] as! String?
                detailViewController.eventAddress = object["address"] as! String?
                detailViewController.eventImage = object["picture"] as! PFFile?
                detailViewController.eventBlurb = object["blurb"] as! String?
                detailViewController.eventEnd = object["endString"] as! String?

            
                
                
            }
        }
        
    }

}

extension UIView {
    func convertViewToImage() -> UIImage{
        UIGraphicsBeginImageContext(self.bounds.size);
        self.drawViewHierarchyInRect(self.bounds, afterScreenUpdates: true)
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        return image;
    }
}
