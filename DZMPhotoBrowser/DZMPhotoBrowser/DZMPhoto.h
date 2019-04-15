//
//  DZMPhoto.h
//  DZMPhotoBrowser
//
//  Created by 邓泽淼 on 2017/6/6.
//  Copyright © 2017年 DZM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface DZMPhoto : NSObject

/*
 组合使用的情况下: (所有的占位图都是可选设置)
 1.如果 imageView 没有值的情况下, url有值, image 则会被当做 placeholderImage 使用。
 2.如果 imageView 没有值的情况下, 需要展示跟隐藏动画, 可使用 frame 做为动画坐标。
 2.如果 imageView 没有值的情况下, frame有值, image 则会被当做 placeholderImage 使用。
 */

/// 图片URL (网络图片展示使用)
@property (nonatomic, copy, nullable) NSURL *url;

/// 图片 (本地图片展示使用)
@property (nonatomic, strong, nullable) UIImage *image;

/// 图片来源控件,有值则会带有动画 【(来源位置 || 占位图) 优先使用改字段】
@property (nonatomic, weak, nullable) UIImageView *imageView;

/// 图片来源位置,有值则会带有动画 默认 CGRectZero【需要屏幕上位置,不是单纯的控件Frame, 会使用 image(可选) 对象当做占位图使用。】
@property (nonatomic, assign) CGRect frame;



/// 该模型在列表中的索引
@property (nonatomic, assign, readonly) NSInteger index;

/// CurrentIndex 首个显示
@property (nonatomic, assign, readonly) BOOL isFirst;

/// 是否保存到相册过
@property (nonatomic, assign, readonly) BOOL isSave;

@end
