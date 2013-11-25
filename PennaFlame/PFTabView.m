//
//  PFTabView.m
//  PennaFlame
//
//  Created by Jerry Stralko on 11/17/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import "PFTabView.h"
#import <QuartzCore/QuartzCore.h>

#define TAB_BUTTON_TITLE_FONT_SIZE      6
#define TAB_BUTTONTITLE_FONT_SIZE_IPAD  14

#define TAB_PADDING                     2

#define TAB_IMAGE_WIDTH                 35
#define TAB_IMAGE_WIDTH_QUIRK           40 //english and mti images are special
#define TAB_IMAGE_IPAD_WIDTH            50
#define TAB_IMAGE_IPAD_WIDTH_QUIRK      60 //english and mti images are special

#define TAB_IMAGE_HEIGHT                35
#define TAB_IMAGE_HEIGHT_QUIRK          40 //english and mti images are special
#define TAB_IMAGE_IPAD_HEIGHT           50
#define TAB_IMAGE_IPAD_HEIGHT_QUIRK     60 //english and mti images are special

#define TAB_TOP_PADDING                 5
#define NUMBER_OF_TABS                  6

@interface PFTabView ()

@end

@implementation PFTabView

@synthesize delegate;
@synthesize metricTabButton;
@synthesize fractionTabButton;
@synthesize hardnessCaseDepthButton;
@synthesize hardnessChart;
@synthesize mtiButton;
@synthesize contactButton;

UIView *groupView;

- (id)initWithFrame:(CGRect)frame withIndex:(NSInteger)index
{
    self = [super initWithFrame:frame];
    if (self) {
        
        int titleFontSize;
        int imageHeightQuirk;
        int imageWidthQuirk;
        int imageHeight;
        int imageWidth;
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            titleFontSize = TAB_BUTTONTITLE_FONT_SIZE_IPAD;
            imageHeight = TAB_IMAGE_IPAD_HEIGHT;
            imageWidth = TAB_IMAGE_IPAD_WIDTH;
            imageHeightQuirk = TAB_IMAGE_IPAD_HEIGHT_QUIRK;
            imageWidthQuirk = TAB_IMAGE_IPAD_WIDTH_QUIRK;
        } else {
            titleFontSize = TAB_BUTTON_TITLE_FONT_SIZE;
            imageHeight = TAB_IMAGE_HEIGHT;
            imageWidth = TAB_IMAGE_WIDTH;
            imageHeightQuirk = TAB_IMAGE_HEIGHT_QUIRK;
            imageWidthQuirk = TAB_IMAGE_WIDTH_QUIRK;
        }
        
        int tabButtonWidth = (frame.size.width / NUMBER_OF_TABS) - TAB_PADDING;
        // Initialization code
        [self setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        self.backgroundColor = [UIColor blackColor];
        
        int w = frame.size.width;
        int h = frame.size.height - 5;
        int y = 5;
        int x = 0;
        groupView = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        [groupView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
        
        w = index == NUMBER_OF_TABS ? tabButtonWidth+3 : tabButtonWidth+6;
        UIView *selectedView = [[UIView alloc] init];
        selectedView.backgroundColor = [UIColor blackColor];
        [selectedView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
        [selectedView setFrame:CGRectMake((tabButtonWidth*index + (index*TAB_PADDING)-1), 0, w, frame.size.height)];
        [groupView addSubview:selectedView];
        
        //gradient magic
        CAGradientLayer *nonSelectedTabGradient = [CAGradientLayer layer];
        nonSelectedTabGradient.frame = CGRectMake(0, 0, groupView.bounds.size.width, groupView.bounds.size.height);
        nonSelectedTabGradient.colors = [NSArray arrayWithObjects:(id) [[UIColor redColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
        [groupView.layer insertSublayer:nonSelectedTabGradient atIndex:0];
        [self addSubview:groupView];
        
        int centerX = (tabButtonWidth / 2) - (imageWidth / 2);
        metricTabButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //custom - adjust for the image size
        x = centerX;
        metricTabButton.frame = CGRectMake(x, 0, imageWidthQuirk, imageHeightQuirk);
        UIImage *img = [UIImage imageNamed:@"EnglishMetric"];
        [metricTabButton setBackgroundImage:img forState:UIControlStateNormal];
        [metricTabButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
        [metricTabButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [groupView addSubview:metricTabButton];

        y = metricTabButton.frame.size.height - 10;
        int height = frame.size.height - metricTabButton.frame.size.height + 10;
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, y, tabButtonWidth, height)];
        [title setTextColor:[UIColor whiteColor]];
        [title setFont:[UIFont boldSystemFontOfSize:titleFontSize]];
        title.numberOfLines = 2;
        [title setTextAlignment:NSTextAlignmentCenter];
        [title setText:@"English/Metric Converter"];
        [title setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
        [groupView addSubview:title];
        
        x = title.frame.origin.x + title.frame.size.width;
        UIView *wedge = [[UIView alloc] initWithFrame:CGRectMake(x, 0,2,h)];
        wedge.backgroundColor = [UIColor blackColor];
        [wedge setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
        [groupView addSubview:wedge];
        
        fractionTabButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [fractionTabButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        centerX = (tabButtonWidth / 2) - (imageWidth / 2);
        fractionTabButton.frame = CGRectMake(title.frame.size.width + centerX, 0, imageWidth, imageHeight);
        img = [UIImage imageNamed:@"FractionDecimal"];
        [fractionTabButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
        [fractionTabButton setBackgroundImage:img forState:UIControlStateNormal];
        [fractionTabButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [groupView addSubview:fractionTabButton];
        
        x = title.frame.origin.x + title.frame.size.width + 2;
        y = fractionTabButton.frame.size.height - 10;
        height = frame.size.height - fractionTabButton.frame.size.height + 10;
        title = [[UILabel alloc]initWithFrame:CGRectMake(x, y, tabButtonWidth, height)];
        [title setTextColor:[UIColor whiteColor]];
        [title setFont:[UIFont boldSystemFontOfSize:titleFontSize]];
        title.numberOfLines = 2;
        [title setTextAlignment:NSTextAlignmentCenter];
        [title setText:@"Fraction/Decimal Converter"];
        [title setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
        [groupView addSubview:title];
        
        x = title.frame.origin.x + title.frame.size.width;
        wedge = [[UIView alloc] initWithFrame:CGRectMake(x, 0,2,h)];
        wedge.backgroundColor = [UIColor blackColor];
        [wedge setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
        [groupView addSubview:wedge];
        
        x = wedge.frame.origin.x + 2;
        centerX = x + (tabButtonWidth / 2) - (imageWidth / 2);
        hardnessCaseDepthButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        hardnessCaseDepthButton.frame = CGRectMake(centerX, 3, imageWidth, imageHeight);
        img = [UIImage imageNamed:@"CaseDepthButton"];
        [hardnessCaseDepthButton setBackgroundImage:img forState:UIControlStateNormal];
        [hardnessCaseDepthButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
        [hardnessCaseDepthButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [groupView addSubview:hardnessCaseDepthButton];
        
        y = hardnessCaseDepthButton.frame.size.height - 10;
        height = frame.size.height - hardnessCaseDepthButton.frame.size.height + 10;
        title = [[UILabel alloc]initWithFrame:CGRectMake(x, y, tabButtonWidth, height)];
        [title setTextColor:[UIColor whiteColor]];
        [title setFont:[UIFont boldSystemFontOfSize:titleFontSize]];
        title.numberOfLines = 2;
        [title setTextAlignment:NSTextAlignmentCenter];
        [title setText:@"Hardness Case Depth"];
        [title setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
        [groupView addSubview:title];
        
        x = title.frame.origin.x + title.frame.size.width;
        wedge = [[UIView alloc] initWithFrame:CGRectMake(x, 0, 2, h)];
        wedge.backgroundColor = [UIColor blackColor];
        [wedge setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
        [groupView addSubview:wedge];
        
        x = wedge.frame.origin.x + 2;
        centerX = x + (tabButtonWidth / 2) - (imageWidth / 2);
        hardnessChart = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        hardnessChart.frame = CGRectMake(centerX, 3, imageWidth, imageHeight);
        img = [UIImage imageNamed:@"HardnessChartButton"];
        [hardnessChart setBackgroundImage:img forState:UIControlStateNormal];
        [hardnessChart setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
        [hardnessChart addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [groupView addSubview:hardnessChart];
        
        y = hardnessChart.frame.size.height - 10;
        height = frame.size.height - hardnessChart.frame.size.height + 10;
        title = [[UILabel alloc]initWithFrame:CGRectMake(x, y, tabButtonWidth, height)];
        [title setTextColor:[UIColor whiteColor]];
        [title setFont:[UIFont boldSystemFontOfSize:titleFontSize]];
        title.numberOfLines = 2;
        [title setTextAlignment:NSTextAlignmentCenter];
        [title setText:@"Hardness Chart"];
        [title setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
        [groupView addSubview:title];
        
        
        x = title.frame.origin.x + title.frame.size.width;
        wedge = [[UIView alloc] initWithFrame:CGRectMake(x, 0, 2, h)];
        wedge.backgroundColor = [UIColor blackColor];
        [wedge setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
        [groupView addSubview:wedge];
        
        x = wedge.frame.origin.x + 2;
        centerX = x + (tabButtonWidth / 2) - (imageWidth / 2) - 2;
        mtiButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //custom - adjust for the image size
        mtiButton.frame = CGRectMake(centerX, 0, imageWidthQuirk, imageHeightQuirk);
        img = [UIImage imageNamed:@"MTIStatementButton"];
        [mtiButton setBackgroundImage:img forState:UIControlStateNormal];
        [mtiButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
        [mtiButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [groupView addSubview:mtiButton];
        
        y = mtiButton.frame.size.height - 10;
        height = frame.size.height - mtiButton.frame.size.height + 10;
        title = [[UILabel alloc]initWithFrame:CGRectMake(x, y, tabButtonWidth, height)];
        [title setTextColor:[UIColor whiteColor]];
        [title setFont:[UIFont boldSystemFontOfSize:titleFontSize]];
        title.numberOfLines = 2;
        [title setTextAlignment:NSTextAlignmentCenter];
        [title setText:@"MTI Statement of Liability"];
        [title setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
        [groupView addSubview:title];
        
        x = title.frame.origin.x + title.frame.size.width;
        wedge = [[UIView alloc] initWithFrame:CGRectMake(x, 0, 2, h)];
        wedge.backgroundColor = [UIColor blackColor];
        [wedge setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
        [groupView addSubview:wedge];
        
        x = wedge.frame.origin.x + 2;
        centerX = x + (tabButtonWidth / 2) - (imageWidth / 2);
        contactButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        contactButton.frame = CGRectMake(centerX, 3, imageWidth, imageHeight);
        img = [UIImage imageNamed:@"ContactButton"];
        [contactButton setBackgroundImage:img forState:UIControlStateNormal];
        [contactButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
        [contactButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [groupView addSubview:contactButton];
        
        y = contactButton.frame.size.height - 10;
        height = frame.size.height - contactButton.frame.size.height + 10;
        title = [[UILabel alloc]initWithFrame:CGRectMake(x, y, tabButtonWidth, height)];
        [title setTextColor:[UIColor whiteColor]];
        [title setFont:[UIFont boldSystemFontOfSize:titleFontSize]];
        title.numberOfLines = 2;
        [title setTextAlignment:NSTextAlignmentCenter];
        [title setText:@"Contact Us"];
        [title setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
        [groupView addSubview:title];
    }
    return self;
}

- (void)layoutSubviews {
    [[[groupView.layer sublayers] objectAtIndex:0] setFrame:groupView.bounds];
}

- (void)setDelegate:(id <PFTabViewDelegate>)aDelegate {
    if (delegate != aDelegate) {
        delegate = aDelegate;
    }
}

- (void) buttonClicked:(id) sender {
    if (metricTabButton == sender) {
        [delegate tabBarButtonClicked:sender withIndex:1];
    } else if (fractionTabButton == sender) {
        [delegate tabBarButtonClicked:sender withIndex:2];
    } else if (hardnessCaseDepthButton == sender) {
        [delegate tabBarButtonClicked:sender withIndex:3];
    } else if (hardnessChart == sender) {
        [delegate tabBarButtonClicked:sender withIndex:4];
    } else if (mtiButton == sender) {
        [delegate tabBarButtonClicked:sender withIndex:5];
    } else if (contactButton == sender) {
        [delegate tabBarButtonClicked:sender withIndex:6];
    } else {
        NSLog(@"ingore event for %@", [sender description]);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
