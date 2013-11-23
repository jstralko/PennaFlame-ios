//
//  PFTabView.h
//  PennaFlame
//
//  Created by Jerry Stralko on 11/17/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PFTabViewDelegate <NSObject>

@required

- (void) tabBarButtonClicked:(id) sender withIndex:(NSInteger) buttonIndex;

@end

@interface PFTabView : UIView {

}

- (id)initWithFrame:(CGRect)frame withIndex:(NSInteger)index;

@property (nonatomic, assign) id <PFTabViewDelegate> delegate;
@property (readonly) UIButton *metricTabButton;
@property (readonly) UIButton *fractionTabButton;
@property (readonly) UIButton *hardnessCaseDepthButton;
@property (readonly) UIButton *hardnessChart;
@property (readonly) UIButton *mtiButton;
@property (readonly) UIButton *contactButton;


@end
