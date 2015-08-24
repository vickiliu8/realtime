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
    
    var events = [AnyObject]()
    
    var location: CLLocationCoordinate2D
    let place = PFGeoPoint(latitude:40.0, longitude:-30.0)
    
   
    required init(coder aDecoder: NSCoder!) {
        location = CLLocationCoordinate2DMake(0, 0)
        //place = PFGeoPoint(latitude: 0, longitude: 0)
        super.init(coder: aDecoder)
    }
    
    let cellIdentifier:String = "EventCell"
    let locationManager = CLLocationManager()
    
   // var events = [Event]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorColor = UIColor.blackColor()
        
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
       
        var query = PFQuery(className:"Event")
        var usersLocation: AnyObject? = PFUser.currentUser()!["location"]
        println(usersLocation)
        query.whereKey("location", nearGeoPoint:usersLocation! as! PFGeoPoint)
        
        
        //query.limit = 10
        // Final list of objects
        events = query.findObjects()!
        
         return query

    }
    
    //3
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject!) -> EventsTableViewCell? {
               let cell:EventsTableViewCell? = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as? EventsTableViewCell
        
        
        if let pfObject = object {
            cell?.eventName?.text = pfObject["name"] as? String
            println(pfObject)
            
            var locA: AnyObject? = pfObject["location"]
            var locB: AnyObject? = PFUser.currentUser()!["location"]
            println("stuff")
            println(locA)
            println(locB)
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
            println("miles")
            
            println(distance * 0.000621371)
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
            let detailViewController = segue.destinationViewController as! DetailViewController
            if let indexPath = tableView.indexPathForCell(sender as! EventsTableViewCell) {
                
                //println(events[indexPath.row])
                    
                detailViewController.eventName = events[indexPath.row]["name"] as! String?
                detailViewController.eventBlurb = events[indexPath.row]["blurb"] as! String?
                detailViewController.eventDistance = events[indexPath.row]["distFromCurrentUser"] as! String?
                detailViewController.eventAddress = events[indexPath.row]["address"] as! String?
                
            }
        }
    }

}
