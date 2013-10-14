//
//  PFHardnessChartViewController.h
//  PennaFlame
//
//  Created by Chris Copac on 10/7/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFHardnessChartViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate>{
    IBOutlet UIWebView *pdfWrapper;
    UIButton *showMetalPickerButton;
    UIButton *showRangePickerButton;
    UIPickerView *metalPicker;
    UIPickerView *rangePicker;
    UIScrollView *scrollView;
    UIButton *generateChart;
}
@end
