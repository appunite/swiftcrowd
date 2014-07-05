//
//  SignupViewController.swift
//  swiftcrowd
//
//  Created by Emil Wojtaszek on 05/07/14.
//  Copyright (c) 2014 AppUnite.com. All rights reserved.
//

import UIKit

class SCSignupViewController: UIViewController {
    
    override func loadView() {
        let view_ = SCSignupView(frame: CGRectZero)
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
        let alert = UIAlertView()
        alert.title = "Title"
        alert.message = "My message"
        alert.addButtonWithTitle("Ok")
        alert.show()
    }
    
}
