//
//  PFMTIViewController.h
//  com.pennaflame.app
//
//  Created by Gerald Stralko on 10/6/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFTabView.h"

@interface PFMTIViewController : UIViewController {
    IBOutlet UIWebView *mtiWebView;
    PFTabView *tabBar;
}
@end
