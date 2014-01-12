//
//  PFButton.m
//  PennaFlame
//
//  Created by Jerry Stralko on 1/12/14.
//  Copyright (c) 2014 Gerald Stralko. All rights reserved.
//

#import "PFButton.h"

@implementation PFButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setFrame:CGRectZero];
        [self setTintColor:[UIColor whiteColor]];
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.layer.cornerRadius = 10;
    }
    return self;
}

/*
 * call this method on viewDidAppear
 */
- (void) addGradientLayer {
    CAGradientLayer *buttonGradient = [CAGradientLayer layer];
    buttonGradient.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    buttonGradient.cornerRadius = 10;
    buttonGradient.colors = [NSArray arrayWithObjects:(id) [[UIColor lightGrayColor] CGColor],
                             (id)[[UIColor grayColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
    NSNumber *stopOne       = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo       = [NSNumber numberWithFloat:0.2];
    NSNumber *stopThree = [NSNumber numberWithFloat:0.5];
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, stopThree, nil];
    buttonGradient.locations = locations;
    
    [self.layer insertSublayer:buttonGradient atIndex:0];
}

@end
