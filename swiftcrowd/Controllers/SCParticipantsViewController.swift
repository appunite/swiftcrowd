
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
    // populate collctions
    var uids: AnyObject[]!
    var users: AnyObject[]?;

    // manage detected beacons
    let beaconsManager: SCBeaconsManager?

    // fetch timer
    var timer: NSTimer?
    
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
        if SCAccount.account.isLoggedIn() {
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
        if let users = self.users {
            return users.count
        }
        
        return 0
    }
    
    //# TableViewDelegate
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!  {
        
        // dequeue cell
        let cell = tableView.dequeueReusableCellWithIdentifier(MainStoryboard.TableViewCellIdentifiers.participantCellIdentifier, forIndexPath: indexPath) as UITableViewCell

        let _users = self.users as SCUser[]
        
        // get user
        let user: SCUser = _users[indexPath.row]
        
        cell.textLabel!.text = user.displayName
        cell.detailTextLabel!.text = user.twitterAccount
        cell.imageView.setImageWithURL(user.assetURL())
        
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
    
    //# Private
    
    func refetchNewData(ids: AnyObject[]!) {

        // fetch completition block -> save new users list, relaod data
        func fetchBlock(users: AnyObject[]!, error: NSError!) -> Void {
            if (!error) {
                self.users = users;
                self.tableView.reloadData()
            }
            
            var timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: Selector("timerAction"), userInfo: nil, repeats: true)
        }
        
//        let manager: SCAppService = SCAppService.sharedManager()
//        manager.fetchUserWithIds(ids, handler: fetchBlock)
    }
    
    func timerAction() {
        self.refetchNewData(self.uids);
    }
}

