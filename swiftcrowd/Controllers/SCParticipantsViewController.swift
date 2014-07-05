
//
//  ParticipantsViewController.swift
//  swiftcrowd
//
//  Created by Emil Wojtaszek on 05/07/14.
//  Copyright (c) 2014 AppUnite.com. All rights reserved.
//

import UIKit

class SCParticipantsViewController: UITableViewController, SCBeaconsManagerDelegate {
    
    let beaconsManager: SCBeaconsManager?
    let beacons: AnyObject[]!
    
    struct MainStoryboard {
        struct TableViewCellIdentifiers {
            static let participantCellIdentifier = "participantCell"
        }
        
        struct SegueIdentifiers {
            static let loginSegueIdentifier = "loginSegue"
            static let signupSegueIdentifier = "signupSegue"
        }
    }

    convenience init() {
        self.init(style: UITableViewStyle.Plain)
        self.beaconsManager = SCBeaconsManager(delegate:self, uid:1)
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

