//
//  PFFullChartViewController.h
//  PennaFlame
//
//  Created by Gerald Stralko on 10/19/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFFullChartViewController : UIViewController <UIWebViewDelegate> {
    UIWebView *chart;
    UIWebView *header_internalChart;
    UIImageView *background;
    UIView *redBanner;
    UITextField *disclaimer;
    NSDictionary *chartDictionary;
}

-(id) initWithDict:(NSDictionary *)chartDict;

-(id) initWithDict:(NSDictionary *)chartDict withTile:(NSString *)title;

@end
