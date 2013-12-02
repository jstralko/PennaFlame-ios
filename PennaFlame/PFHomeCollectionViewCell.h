//
//  PFHomeCollectionViewCell.h
//  PennaFlame
//
//  Created by Jerry Stralko on 11/15/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFHomeCollectionViewCell : UICollectionViewCell {
    UILabel *title;
    UIImageView *imageView;
    UIImageView *backgroundImageView;
}

@property (strong, nonatomic) UILabel *title;

- (void) setImageViewFrame:(UIImage *)image;
- (void) setSelection;
- (void) unSelect;

@end
