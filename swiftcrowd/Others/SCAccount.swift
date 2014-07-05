//
//  SCAccount.swift
//  swiftcrowd
//
//  Created by Karol Wojtaszek on 05.07.2014.
//  Copyright (c) 2014 AppUnite.com. All rights reserved.
//

import UIKit

let _SCAccountSharedInstance = SCAccount()

class SCAccount: AUAccount {
    class var account : SCAccount {
        return _SCAccountSharedInstance
    }
}
