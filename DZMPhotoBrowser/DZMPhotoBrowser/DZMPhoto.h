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
 url有值:(网络图片展示使用)
 当url有值时则下载进行使用
 默认图片则使用 imageView.image
 没有传 imageView 则等待下载完成在显示
 
 image有值:(本地图片展示使用)
 
 注意: url image 二选一即可 如果都有值则使用url
 
 在DZMPhoto数组中可以存在两种数据模型
 */

/// 图片URL (网络图片展示使用)
@property (nonatomic, copy, nullable) NSURL *url;

/// 图片 (本地图片展示使用)
@property (nonatomic, strong, nullable) UIImage *image;

/// 图片来源控件 有值则会带有返回动画
@property (nonatomic, weak, nullable) UIImageView *imageView;



/// 该模型在列表中的索引
@property (nonatomic, assign, readonly) NSInteger index;

/// CurrentIndex 首个显示
@property (nonatomic, assign, readonly) BOOL isFirst;

/// 是否保存到相册过
@property (nonatomic, assign, readonly) BOOL isSave;

@end
