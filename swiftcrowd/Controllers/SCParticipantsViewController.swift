
//
//  ParticipantsViewController.swift
//  swiftcrowd
//
//  Created by Emil Wojtaszek on 05/07/14.
//  Copyright (c) 2014 AppUnite.com. All rights reserved.
//

import UIKit
import CoreLocation

class SCParticipantsViewController: UITableViewController, SCBeaconsManagerDelegate {
    var uids: AnyObject[]!
    var users: SCUser[]?;
    
    let beaconsManager: SCBeaconsManager?
    
    @lazy var account: AUAccount = {
        let account = AUAccount()
        return account
    }()
    
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
        self.beaconsManager?.startAdvertisingBeacon()
    }

    //# View Life Cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // present signup sheet
        if self.account.isLoggedIn() {
            let signupViewController = SCSignupViewController()
            let navigationController = UINavigationController(rootViewController: signupViewController)
            self.presentModalViewController(navigationController, animated:true)
        }
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

    //# SCBeaconsManagerDelegate
    
    func beaconsManager(manager: SCBeaconsManager!, didRangeBeacons beacons: AnyObject[]!) {
        // save beacon list
        let uids = beacons.map{(let b) -> NSNumber in
            let beacon: CLBeacon = b as CLBeacon
            return beacon.minor
        }
        
        self.uids = uids
    }
}

