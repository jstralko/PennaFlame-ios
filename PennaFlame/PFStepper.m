//
//  PFStepper.m
//  PennaFlame
//
//  Created by Jerry Stralko on 12/8/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import "PFStepper.h"

@implementation PFStepper

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage *minusImage = [[UIImage imageNamed:@"MinusImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *minusDownStateImage = [[UIImage imageNamed:@"MinusDownStateImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *plusImage = [[UIImage imageNamed:@"PlusImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *plusDownStateImage = [[UIImage imageNamed:@"PlusDownStateImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        [self setDecrementImage:minusImage forState:UIControlStateNormal];
        [self setDecrementImage:minusDownStateImage forState:UIControlStateHighlighted];
        [self setIncrementImage:plusImage forState:UIControlStateNormal];
        [self setIncrementImage:plusDownStateImage forState:UIControlStateHighlighted];
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
