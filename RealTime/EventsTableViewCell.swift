//
//  EventsTableViewCell.swift
//  RealTime
//
//  Created by Vicki  Liu on 8/21/15.
//  Copyright (c) 2015 vickiliu. All rights reserved.
//

import UIKit

class EventsTableViewCell: PFTableViewCell {
   
    @IBOutlet weak var eventFilters: UILabel!
    @IBOutlet weak var eventName: UILabel!
    
    @IBOutlet weak var eventDistance: UILabel!
    @IBOutlet weak var eventImage: PFImageView!
}
