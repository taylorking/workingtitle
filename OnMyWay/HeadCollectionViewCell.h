//
//  HeadCollectionViewCell.h
//  OnMyWay
//
//  Created by Taylor King on 10/7/15.
//  Copyright © 2015 omwltd. All rights reserved.
//
#import "BFPaperView.h"

#import <UIKit/UIKit.h>

@interface HeadCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet BFPaperView *roundView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
