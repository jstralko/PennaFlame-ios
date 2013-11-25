//
//  PFHomeCollectionViewCell.m
//  PennaFlame
//
//  Created by Jerry Stralko on 11/15/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import "PFHomeCollectionViewCell.h"

@implementation PFHomeCollectionViewCell

@synthesize title;

UIImageView *backgroundImageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"HomeButtonImage"]];
        //self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"HomeButtonImageHiRes"]];
        backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeButtonImage"]];
        [self addSubview:backgroundImageView];
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:imageView];
        
        self.title = [[UILabel alloc] initWithFrame:CGRectZero];
        self.title.numberOfLines = 2;
        self.autoresizesSubviews = YES;
        self.title.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                       UIViewAutoresizingFlexibleHeight);
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            self.title.font = [UIFont boldSystemFontOfSize:22];
        } else {
            self.title.font = [UIFont boldSystemFontOfSize:14];
        }
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.adjustsFontSizeToFitWidth = NO;
        [self.title setTextColor:[UIColor whiteColor]];
        [self addSubview:self.title];
        
        //drop shadow
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowRadius = 3.0f;
        self.layer.shadowOffset = CGSizeMake(4.0f, 5.0f);
        self.layer.shadowOpacity = 0.8f;
    }
    return self;
}

-(void) setImageViewFrame:(UIImage *)image {
    int x = ((self.bounds.origin.x + self.bounds.size.width) / 2) - (image.size.width / 2);
    int padding;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        padding = 25;
    } else {
        padding = 15;
    }
    
    int y = (self.bounds.size.height / 2) - (image.size.height /2) - padding;
    [imageView setFrame:CGRectMake(x, y, image.size.width, image.size.height)];
    [imageView setImage:image];

    y = imageView.frame.origin.y + imageView.frame.size.height;
    int height = self.bounds.size.height - y;
    [title setFrame:CGRectMake(0, y, self.bounds.size.width, height)];
    
    [backgroundImageView setFrame:self.bounds];
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
