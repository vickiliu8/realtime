//
//  Event.swift
//  RealTime
//
//  Created by Vicki  Liu on 8/19/15.
//  Copyright (c) 2015 vickiliu. All rights reserved.
//

import Foundation

class Event: PFObject, PFSubclassing {
    @NSManaged var picture: PFFile
    @NSManaged var user: PFUser
    @NSManaged var blurb: String?
    @NSManaged var location: PFGeoPoint?
    @NSManaged var start: NSDate?
    @NSManaged var end: NSDate?
    
    //1
    class func parseClassName() -> String {
        return "Event"
    }
    
    //2
    override class func initialize() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    override class func query() -> PFQuery? {
        let query = PFQuery(className: Event.parseClassName()) //1
        query.includeKey("user") //2
        query.orderByDescending("createdAt") //3
        return query
    }
    
    init(picture: PFFile, user: PFUser, blurb: String?, location: PFGeoPoint?, start: NSDate?, end: NSDate?) {
        super.init()
        
        self.picture = picture
        self.user = user
        self.blurb = blurb
        self.location = location
        self.start = start
        self.end = end
        
    }
    
    override init() {
        super.init()
    }
    



}