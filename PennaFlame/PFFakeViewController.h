//
//  PFFakeViewController.h
//  PennaFlame
//
//  Created by Chris Copac on 10/6/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFFakeViewController : UIViewController {
    UIImageView *logo;
    UILabel *label;
    UIButton *websiteButton;
    UIButton *callButton;
    UIButton *emailButton;
    UIScrollView *scrollView;
    NSLayoutConstraint *scrollViewBottom;
}

@end
