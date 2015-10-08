//
//  HeadsCollectionViewCellLarge.h
//  OnMyWay
//
//  Created by Taylor King on 10/7/15.
//  Copyright © 2015 omwltd. All rights reserved.
//
#import "BFPaperView.h"
#import <UIKit/UIKit.h>

@interface HeadsCollectionViewCellLarge : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet BFPaperView *circularView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end
