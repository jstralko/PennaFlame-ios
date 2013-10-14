//
//  PFHardnessChartViewController.h
//  PennaFlame
//
//  Created by Gerald Stralko on 10/7/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFHardnessChartViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UIWebViewDelegate>{
    IBOutlet UIWebView *pdfWrapper;
    UIWebView *hardnessChartWebView;
    UIButton *showMetalPickerButton;
    UIButton *showRangePickerButton;
    UIPickerView *metalPicker;
    UIPickerView *rangePicker;
    UIScrollView *scrollView;
    UIButton *generateChart;
}
@end
