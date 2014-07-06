//
//  SignupViewController.swift
//  swiftcrowd
//
//  Created by Emil Wojtaszek on 05/07/14.
//  Copyright (c) 2014 AppUnite.com. All rights reserved.
//

import UIKit

import Accounts
import Social

class SCSignupViewController: UIViewController {
    
    override func loadView() {
        let view_ = SCSignupView(frame: CGRectZero)
        view_.loginButton.addTarget(self, action: Selector("loginButtonAction:"), forControlEvents: .TouchUpInside)
        
        self.view = view_
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func loginButtonAction(sender: AnyObject?) {
        
        func loginHandler(account: AUAccount?, success: Bool, error: NSError!) {
            if (success) {
                let user = SCAccount.account.user
                self.dismissModalViewControllerAnimated(true)
            } else {
                showErrorMessage(error!)
            }
        }
        
        func socialAuthHandler(success: Bool, tokens: NSDictionary?, error: NSError?) {
            if (success) {
                SCAppService.createUserWithTwitterCredentials(tokens, handler: loginHandler);
            } else {
                showErrorMessage(error!)
            }
        }
        
        YPSocialAuth.credentialForAccount(ACAccountTypeIdentifierTwitter, handler: socialAuthHandler)
    }
    
    func showErrorMessage(error: NSError) {
        let alert = UIAlertView()
        alert.title = "Error"
        alert.message = error.localizedDescription
        alert.addButtonWithTitle("Ok")
        alert.show()
    }
    
    
}
