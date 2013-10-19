//
//  PFHardnessCaseDepthViewController.h
//  com.pennaflame.app
//
//  Created by Gerald Stralko on 10/5/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFHardnessCaseDepthViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UIWebViewDelegate> {
   // IBOutlet UIWebView *hardnessWebView;
    UIWebView *hardnessChartWebView;
    UIButton *showMetalPickerButton;
    UIButton *showRangePickerButton;
    UIPickerView *metalPicker;
    UIPickerView *rangePicker;
    UIScrollView *scrollView;
    UIButton *generateChart;
    UIButton *showFullChart;
}

@end
