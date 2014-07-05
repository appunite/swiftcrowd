//
//  BeaconsManager.swift
//  swiftcrowd
//
//  Created by Emil Wojtaszek on 05/07/14.
//  Copyright (c) 2014 AppUnite.com. All rights reserved.
//

import Foundation
import CoreLocation
import CoreBluetooth

@objc
protocol SCBeaconsManagerDelegate: NSObjectProtocol {
    @optional func beaconsManager(manager: SCBeaconsManager!, didRangeBeacons beacons: AnyObject[]!)
}

class SCBeaconsManager: NSObject, CLLocationManagerDelegate, CBPeripheralManagerDelegate {
    // user identifier
    let uid: CLBeaconMinorValue
    
    // core location objects
    var locationManager: CLLocationManager?
    var beaconRegion: CLBeaconRegion?

    // advertising
    var peripheralManager: CBPeripheralManager?
    
    // delegate object
    var delegate: SCBeaconsManagerDelegate!

    struct SCBeaconParams {
        static let proximityUUID = "D510EB7A-F98D-486E-9517-779AF6A00E45"
        static let majorValue: CLBeaconMinorValue = 1
        static let identifier = "swift_beacon"
    }
    
    init(delegate: SCBeaconsManagerDelegate!, uid: CLBeaconMinorValue!) {
        // assing passed values
        self.uid = uid;
        self.delegate = delegate;

        super.init()

        // create uuid
        let uuid: NSUUID = NSUUID(UUIDString: SCBeaconParams.proximityUUID);
        
        // create region
        self.beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier:SCBeaconParams.identifier)
    
        // create location manager
        self.locationManager = CLLocationManager()
        
        // create peripheral manager
        self.peripheralManager = CBPeripheralManager(delegate:self, queue: dispatch_get_main_queue())
    }
    
    
    //# ranging

    func startRangingForBeacons() -> Bool {
        
        if CLLocationManager.isRangingAvailable() {
            return false;
        }
        
        if (self.locationManager?.rangedRegions.count == 0) {
            self.locationManager?.startRangingBeaconsInRegion(self.beaconRegion);
        }
        
        return true;
    }
    
    func stopRangingForBeacons() {
        if (self.locationManager?.rangedRegions.count > 0) {
            self.locationManager?.stopRangingBeaconsInRegion(self.beaconRegion)
        }
    }

    //# advertising

    func startAdvertisingBeacon() {
        if (self.peripheralManager?.state == CBPeripheralManagerState.PoweredOn) {
            // create uuid
            let uuid: NSUUID = NSUUID(UUIDString: SCBeaconParams.proximityUUID);

            // creaue uniq region
            let region = CLBeaconRegion(proximityUUID:uuid, major:SCBeaconParams.majorValue, minor:self.uid, identifier:SCBeaconParams.identifier)

            // start advertising
            let beaconPeripheralData = region.peripheralDataWithMeasuredPower(nil)
            self.peripheralManager?.startAdvertising(beaconPeripheralData)
        }
    }

    func stopAdvertisingBeacon() {
        self.peripheralManager?.stopAdvertising()
    }
    
    //# CBPeripheralManagerDelegate

    func peripheralManagerDidStartAdvertising(peripheral: CBPeripheralManager!, error: NSError!) {
        if (error) {
            println("Couldn't turn on advertising: \(error)");
        }
        
        else if (peripheralManager?.isAdvertising) {
            println("Turned on advertising.");
        }
    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
        if (peripheralManager?.state == CBPeripheralManagerState.PoweredOn) {
            self.startAdvertisingBeacon()
        }
    }
    
    //# CLLocationManagerDelegate

    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if (!CLLocationManager.locationServicesEnabled()) {
            println("Couldn't turn on ranging: Location services are not enabled.");
        }
        
        
        else if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.Authorized) {
            println("Couldn't turn on ranging: Location services not authorised.");
        }
    }
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: AnyObject[]!, inRegion region: CLBeaconRegion!) {
        self.delegate?.beaconsManager!(self, didRangeBeacons:beacons)
    }
}
