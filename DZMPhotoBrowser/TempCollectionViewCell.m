//
//  TempCollectionViewCell.m
//  DZMPhotoBrowser
//
//  Created by 邓泽淼 on 2017/6/6.
//  Copyright © 2017年 DZM. All rights reserved.
//

#import "TempCollectionViewCell.h"

@implementation TempCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:imageView];
        self.imageView = imageView;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
}

@end
