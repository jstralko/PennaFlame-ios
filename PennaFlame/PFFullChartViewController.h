//
//  PFFullChartViewController.h
//  PennaFlame
//
//  Created by Gerald Stralko on 10/19/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PFTabView;

@interface PFFullChartViewController : UIViewController <UIWebViewDelegate> {
    UIWebView *chart;
    UIWebView *headerWebView;
    UIImageView *background;
    UIView *redBanner;
    UILabel *disclaimer;
    NSDictionary *chartDictionary;
    NSArray *sortedKeys;
    NSInteger tabBarHeight;
    PFTabView *tabBar;
}

-(id) initWithDict:(NSDictionary *)chartDict;

-(id) initWithDict:(NSDictionary *)chartDict withTile:(NSString *)title;

-(id) initWithDict:(NSDictionary *)chartDict withSortedKeys:(NSArray *)keys withTile:(NSString *)title;

@end
