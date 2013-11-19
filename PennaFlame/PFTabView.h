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
    UIButton *metricTabButton;
    UIButton *fractionTabButton;
}

@property (nonatomic, assign) id <PFTabViewDelegate> delegate;

@end
