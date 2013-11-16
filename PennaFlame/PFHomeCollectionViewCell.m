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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"HomeButtonImage"]];

        imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:imageView];
        
        int x = self.bounds.origin.x;
        int y = self.bounds.origin.y + self.bounds.size.height - 80;
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(x, y, self.bounds.size.width, self.bounds.size.height)];
        self.title.numberOfLines = 2;
        self.autoresizesSubviews = YES;
        self.title.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                       UIViewAutoresizingFlexibleHeight);
        self.title.font = [UIFont boldSystemFontOfSize:14];
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.adjustsFontSizeToFitWidth = YES;
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
    int y = self.bounds.origin.y + 5;
    [imageView setFrame:CGRectMake(x, y, image.size.width, image.size.height)];
    [imageView setImage:image];
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
