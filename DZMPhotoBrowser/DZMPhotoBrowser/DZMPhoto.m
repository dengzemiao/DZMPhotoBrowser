//
//  DZMPhoto.m
//  DZMPhotoBrowser
//
//  Created by 邓泽淼 on 2017/6/6.
//  Copyright © 2017年 DZM. All rights reserved.
//

#import "DZMPhoto.h"

@interface DZMPhoto()

@end

@implementation DZMPhoto

- (instancetype)init
{
    if (self = [super init]) {
        
        self.frame = CGRectZero;
    }
    
    return self;
}

- (void)dealloc
{
    self.imageView = nil;
    
    self.image = nil;
    
    self.url = nil;
}

@end
