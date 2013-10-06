//
//  PFContactInfoViewController.h
//  com.pennaflame.app
//
//  Created by Chris Copac on 10/5/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#

@interface PFContactInfoViewController: UIViewController <MFMailComposeViewControllerDelegate> {
    
    IBOutlet UIButton *emailButton;
    IBOutlet UIButton *callButton;
    IBOutlet UIButton *websiteButton;
    
}

-(IBAction) emailButtonClicked:(id) sender;
-(IBAction) callButtonClicked:(id) sender;
-(IBAction) websiteButtonClicked:(id)sender;
@end
