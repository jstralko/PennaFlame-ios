//
//  PFHardnessCaseDepthViewController.h
//  com.pennaflame.app
//
//  Created by Gerald Stralko on 10/5/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PFTabView;

@interface PFChartViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UIWebViewDelegate> {
    UIWebView *chartWebView;
    UIButton *showTopPickerButton;
    UIButton *showRangePickerButton;
    UIPickerView *topPicker;
    UIPickerView *rangePicker;
    UIScrollView *scrollView;
    UIButton *generateChart;
    UIButton *showFullChart;
    UIView *redBanner;
    UIImageView *backgroundImage;
    UIImageView *logoImageView;
    PFTabView *tabBar;
    NSLayoutConstraint *logoImageViewTop;
    int tabBarHeight;
    NSMutableDictionary *chartDictionary;
    NSArray *sortedKeys;
    NSLayoutConstraint *webViewHeightConstraint;
}

-(id)initWithDict:(NSMutableDictionary *)chartDict withTitle:(NSString *)title;

-(id)initWithDict:(NSMutableDictionary *)chartDict sortedKeys:(NSArray *)keys withTitle:(NSString *)title;

@end
