//
//  SCLoginView.swift
//  swiftcrowd
//
//  Created by Karol Wojtaszek on 05.07.2014.
//  Copyright (c) 2014 AppUnite.com. All rights reserved.
//

import UIKit

class SCSignupView: UIView {

    var bgImageView = UIImageView()
    var loginButton = UIButton()
    
    
    init(frame: CGRect) {
        let bgImage = UIImage(named: "loginBackground")
        bgImageView.image = bgImage;
        
        loginButton.setBackgroundImage(UIImage(named: "LoginButtonBg").resizableImageWithCapInsets(UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)), forState: .Normal)
        loginButton.setImage(UIImage(named: "twitterIcon"), forState: .Normal)
        loginButton.setTitle("Login with Twitter", forState: .Normal)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        loginButton.titleLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 16.0)
        loginButton.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 30.0)
        
        super.init(frame: frame)
        
        self.addSubview(bgImageView)
        self.addSubview(loginButton)
        
    }

    override func layoutSubviews()  {
        super.layoutSubviews()
        
        let rect = self.bounds
        bgImageView.frame = rect
        
        let buttonSize = CGSize(width: 260.0, height: 50.0)
        let buttonFrame = CGRect(x: (rect.size.width - buttonSize.width) / 2,
                                    y: (rect.size.height - buttonSize.height) / 2,
                                    width: buttonSize.width,
                                    height: buttonSize.height);
        
        loginButton.frame = buttonFrame
        
        
    }
    
}
