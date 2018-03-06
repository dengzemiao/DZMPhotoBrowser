//
//  DZMPhotoPageController.h
//  DZMPhotoBrowser
//
//  Created by 邓泽淼 on 2017/10/19.
//  Copyright © 2017年 DZM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZMPhoto.h"

@class DZMPhotoPageController;
@protocol DZMPhotoPageControllerDelegate <NSObject>
@optional

/// 将要显示的模型
- (void)pageController:(DZMPhotoPageController * _Nonnull)pageController willShowPhoto:(DZMPhoto * _Nullable)photo;

/// 当前显示的模型(滚动结束才会调用)
- (void)pageController:(DZMPhotoPageController * _Nonnull)pageController didShowPhoto:(DZMPhoto * _Nullable)photo;

/// 即将隐藏销毁
- (void)pageController:(DZMPhotoPageController * _Nonnull)pageController willHiddenPhoto:(DZMPhoto * _Nullable)photo;

/// 完成隐藏销毁
- (void)pageControllerDidHidden:(DZMPhotoPageController * _Nonnull)pageController;

/// 图片保存结果
- (void)pageController:(DZMPhotoPageController * _Nonnull)pageController savePhoto:(DZMPhoto * _Nullable)photo error:(NSError * _Nullable)error;

@end

@interface DZMPhotoPageController : UIPageViewController

/**
 初始化(外部接收使用弱引用或不接收)

 @param photos 模型数组
 @param selectIndex 初始显示
 */
+ (instancetype _Nonnull)pageController:(NSArray<DZMPhoto *> * _Nonnull)photos selectIndex:(NSInteger)selectIndex delegate:(id<DZMPhotoPageControllerDelegate> _Nullable)delegate;

@end
