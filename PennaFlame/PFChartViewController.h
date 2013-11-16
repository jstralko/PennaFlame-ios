//
//  PFHardnessCaseDepthViewController.h
//  com.pennaflame.app
//
//  Created by Gerald Stralko on 10/5/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFChartViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UIWebViewDelegate> {
   // IBOutlet UIWebView *hardnessWebView;
    UIWebView *chartWebView;
    UIButton *showTopPickerButton;
    UIButton *showRangePickerButton;
    UIPickerView *topPicker;
    UIPickerView *rangePicker;
    UIScrollView *scrollView;
    UIButton *generateChart;
    UIButton *showFullChart;
    UIView *redBanner;
}

-(id)initWithDict:(NSMutableDictionary *)chartDict withTitle:(NSString *)title;

@end
