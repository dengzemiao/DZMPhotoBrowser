//
//  DZMPhotoBrowser.h
//  DZMPhotoBrowser
//
//  Created by 邓泽淼 on 2017/6/6.
//  Copyright © 2017年 DZM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DZMPhoto.h"

@class DZMPhotoBrowser;
@protocol DZMPhotoBrowserDelegate <NSObject>
@optional

/// 将要显示的模型
- (void)photoBrowser:(DZMPhotoBrowser * _Nonnull)photoBrowser willShowPhoto:(DZMPhoto * _Nullable)photo;

/// 当前显示的模型(滚动结束才会调用)
- (void)photoBrowser:(DZMPhotoBrowser * _Nonnull)photoBrowser didShowPhoto:(DZMPhoto * _Nullable)photo;

/// 即将隐藏销毁
- (void)photoBrowser:(DZMPhotoBrowser * _Nonnull)photoBrowser willHiddenPhoto:(DZMPhoto * _Nullable)photo;

/// 完成隐藏销毁
- (void)photoBrowserDidHidden:(DZMPhotoBrowser * _Nonnull)photoBrowser;

/// 图片保存结果
- (void)photoBrowser:(DZMPhotoBrowser * _Nonnull)photoBrowser savePhoto:(DZMPhoto * _Nullable)photo error:(NSError * _Nullable)error;

@end

/// 创建对象外部接收使用弱引用
@interface DZMPhotoBrowser : NSObject

/// (必传)模型数组
@property(nonatomic, copy, nonnull) NSArray<DZMPhoto *> *photos;

/// (可选)代理
@property(nonatomic, weak, nullable) id <DZMPhotoBrowserDelegate> delegate;

/// (可选)初始化选中位置 defalut: 0
@property(nonatomic, assign) NSInteger initSelectIndex;

/// 展示
- (void)show;

@end
