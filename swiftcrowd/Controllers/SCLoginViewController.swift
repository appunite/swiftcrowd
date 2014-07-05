//
//  LoginViewController.swift
//  swiftcrowd
//
//  Created by Emil Wojtaszek on 05/07/14.
//  Copyright (c) 2014 AppUnite.com. All rights reserved.
//

import UIKit

class SCLoginViewController: UIViewController, UIAlertViewDelegate {
    
    override func loadView()  {
        let view_ = SCLoginView(frame: CGRectZero)
        view_.loginButton.addTarget(self, action: Selector("loginButtonAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view = view_
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func loginButtonAction(sender: AnyObject?) {
        var alert = UIAlertController(title: "Title", message: "Message", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

}
