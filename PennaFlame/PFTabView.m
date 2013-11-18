//
//  PFTabView.m
//  PennaFlame
//
//  Created by Jerry Stralko on 11/17/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import "PFTabView.h"

#define TAB_BUTTON_TITLE_FONT_SIZE  6
#define TAB_PADDING                 2
#define TAB_IMAGE_HEIGHT            35
#define TAB_IMAGE_WIDTH             35
#define TAB_TOP_PADDING             5
#define NUMBER_OF_TABS              6

@implementation PFTabView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        int tabButtonWidth = (frame.size.width / NUMBER_OF_TABS) - TAB_PADDING;
        // Initialization code
        [self setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
        self.backgroundColor = [UIColor blackColor];
        
        int centerX = (tabButtonWidth / 2) - (TAB_IMAGE_WIDTH / 2);
        UIButton *metricTabButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //metricTabButton.frame = CGRectMake(centerX, 5, TAB_IMAGE_WIDTH, TAB_IMAGE_HEIGHT);
        //custom - adjust for the image size
        metricTabButton.frame = CGRectMake(centerX, 5, 40, 40);
        UIImage *img = [UIImage imageNamed:@"EnglishMetric"];
        [metricTabButton setBackgroundImage:img forState:UIControlStateNormal];
        [metricTabButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
        [self addSubview:metricTabButton];

        int y = metricTabButton.frame.size.height - 5;
        int height = frame.size.height - metricTabButton.frame.size.height + 10;
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(3, y, tabButtonWidth, height)];
        [title setTextColor:[UIColor whiteColor]];
        [title setFont:[UIFont boldSystemFontOfSize:TAB_BUTTON_TITLE_FONT_SIZE]];
        
        title.numberOfLines = 2;
        [title setTextAlignment:NSTextAlignmentCenter];
        [title setText:@"English/Metric Converter"];
        [title setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
        [self addSubview:title];
        
        int w = frame.size.width - title.frame.size.width;
        int h = frame.size.height - 5;
        int x = title.frame.origin.x + title.frame.size.width + 2;
        UIView *groupView = [[UIView alloc] initWithFrame:CGRectMake(x, 5, w, h)];
        groupView.backgroundColor = [UIColor redColor];
        [groupView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
        [self addSubview:groupView];
        
        UIButton *fractionTabButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        centerX = (tabButtonWidth / 2) - (TAB_IMAGE_WIDTH / 2);
        fractionTabButton.frame = CGRectMake(centerX, 0, TAB_IMAGE_WIDTH, TAB_IMAGE_HEIGHT);
        img = [UIImage imageNamed:@"FractionDecimal"];
        [fractionTabButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
        [fractionTabButton setBackgroundImage:img forState:UIControlStateNormal];
        [groupView addSubview:fractionTabButton];
        
        y = fractionTabButton.frame.size.height - 10;
        height = frame.size.height - fractionTabButton.frame.size.height + 10;
        title = [[UILabel alloc]initWithFrame:CGRectMake(0, y, tabButtonWidth, height)];
        [title setTextColor:[UIColor whiteColor]];
        [title setFont:[UIFont boldSystemFontOfSize:TAB_BUTTON_TITLE_FONT_SIZE]];
        title.numberOfLines = 2;
        [title setTextAlignment:NSTextAlignmentCenter];
        [title setText:@"Fraction/Decimal Converter"];
        [title setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
        [groupView addSubview:title];
        
        UIView *wedge = [[UIView alloc] initWithFrame:CGRectMake(title.frame.size.width, 0,2,h)];
        wedge.backgroundColor = [UIColor blackColor];
        [wedge setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
        [groupView addSubview:wedge];
        
        x = wedge.frame.origin.x + 2;
        centerX = x + (tabButtonWidth / 2) - (TAB_IMAGE_WIDTH / 2);
        UIButton *hardnessCaseDepthButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        hardnessCaseDepthButton.frame = CGRectMake(centerX, 3, TAB_IMAGE_WIDTH, TAB_IMAGE_HEIGHT);
        img = [UIImage imageNamed:@"CaseDepthButton"];
        [hardnessCaseDepthButton setBackgroundImage:img forState:UIControlStateNormal];
        [hardnessCaseDepthButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
        [groupView addSubview:hardnessCaseDepthButton];
        
        y = hardnessCaseDepthButton.frame.size.height - 10;
        height = frame.size.height - hardnessCaseDepthButton.frame.size.height + 10;
        title = [[UILabel alloc]initWithFrame:CGRectMake(x, y, tabButtonWidth, height)];
        [title setTextColor:[UIColor whiteColor]];
        [title setFont:[UIFont boldSystemFontOfSize:TAB_BUTTON_TITLE_FONT_SIZE]];
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
        centerX = x + (tabButtonWidth / 2) - (TAB_IMAGE_WIDTH / 2);
        UIButton *hardnessChart = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        hardnessChart.frame = CGRectMake(centerX, 3, TAB_IMAGE_WIDTH, TAB_IMAGE_HEIGHT);
        img = [UIImage imageNamed:@"HardnessChartButton"];
        [hardnessChart setBackgroundImage:img forState:UIControlStateNormal];
        [hardnessChart setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
        [groupView addSubview:hardnessChart];
        
        y = hardnessChart.frame.size.height - 10;
        height = frame.size.height - hardnessChart.frame.size.height + 10;
        title = [[UILabel alloc]initWithFrame:CGRectMake(x, y, tabButtonWidth, height)];
        [title setTextColor:[UIColor whiteColor]];
        [title setFont:[UIFont boldSystemFontOfSize:TAB_BUTTON_TITLE_FONT_SIZE]];
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
        centerX = x + (tabButtonWidth / 2) - (TAB_IMAGE_WIDTH / 2) - 2;
        UIButton *mtiButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //mtiButton.frame = CGRectMake(centerX, 0, TAB_IMAGE_WIDTH, TAB_IMAGE_HEIGHT);
        //custom - adjust for the image size
        mtiButton.frame = CGRectMake(centerX, 0, 40, 40);
        img = [UIImage imageNamed:@"MTIStatementButton"];
        [mtiButton setBackgroundImage:img forState:UIControlStateNormal];
        [mtiButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
        [groupView addSubview:mtiButton];
        
        y = mtiButton.frame.size.height - 10;
        height = frame.size.height - mtiButton.frame.size.height + 10;
        title = [[UILabel alloc]initWithFrame:CGRectMake(x, y, tabButtonWidth, height)];
        [title setTextColor:[UIColor whiteColor]];
        [title setFont:[UIFont boldSystemFontOfSize:TAB_BUTTON_TITLE_FONT_SIZE]];
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
        centerX = x + (tabButtonWidth / 2) - (TAB_IMAGE_WIDTH / 2);
        UIButton *contactButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        contactButton.frame = CGRectMake(centerX, 3, TAB_IMAGE_WIDTH, TAB_IMAGE_HEIGHT);
        img = [UIImage imageNamed:@"ContactButton"];
        [contactButton setBackgroundImage:img forState:UIControlStateNormal];
        [contactButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
        [groupView addSubview:contactButton];
        
        y = contactButton.frame.size.height - 10;
        height = frame.size.height - contactButton.frame.size.height + 10;
        title = [[UILabel alloc]initWithFrame:CGRectMake(x, y, tabButtonWidth, height)];
        [title setTextColor:[UIColor whiteColor]];
        [title setFont:[UIFont boldSystemFontOfSize:TAB_BUTTON_TITLE_FONT_SIZE]];
        title.numberOfLines = 2;
        [title setTextAlignment:NSTextAlignmentCenter];
        [title setText:@"Contact Us"];
        [title setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
        [groupView addSubview:title];
        
        
    }
    return self;
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
