//
//  PFFullChartViewController.h
//  PennaFlame
//
//  Created by Gerald Stralko on 10/19/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFFullChartViewController : UIViewController {
    UIWebView *chart;
    UIImageView *background;
    UIView *redBanner;
    UITextField *disclaimer;
}

-(id) initWithString:(NSString *)html setTitle:(NSString *)title;
@end
