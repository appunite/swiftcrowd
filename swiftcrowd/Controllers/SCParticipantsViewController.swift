//
//  ParticipantsViewController.swift
//  swiftcrowd
//
//  Created by Emil Wojtaszek on 05/07/14.
//  Copyright (c) 2014 AppUnite.com. All rights reserved.
//

import UIKit
import CoreLocation

class SCParticipantsViewController: UITableViewController, CLLocationManagerDelegate {

    var locationManager: CLLocationManager?
    var beaconRegion: CLBeaconRegion?

    struct MainStoryboard {
        struct TableViewCellIdentifiers {
            static let participantCellIdentifier = "participantCell"
        }
        
        struct SegueIdentifiers {
            static let loginSegueIdentifier = "loginSegue"
            static let signupSegueIdentifier = "signupSegue"
        }
    }

    //# Initialization
    
    init(style: UITableViewStyle) {
        self.locationManager = CLLocationManager()
        super.init(style: style)
        
        self.locationManager!.delegate = self
    }
    
    //# View Life Cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    //# TableViewDataSource

    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    //# TableViewDelegate

    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!  {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(MainStoryboard.TableViewCellIdentifiers.participantCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        cell.textLabel!.text = "text"
        cell.detailTextLabel!.text = "text22"
        
        return cell
    }
    
}
