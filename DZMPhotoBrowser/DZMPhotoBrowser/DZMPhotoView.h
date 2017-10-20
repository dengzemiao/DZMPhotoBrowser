//
//  DZMPhotoScrollView.h
//  DZMPhotoBrowser
//
//  Created by 邓泽淼 on 2017/6/6.
//  Copyright © 2017年 DZM. All rights reserved.
//

/// 动画时间
#define DZMAnimateDuration 0.25

#import <UIKit/UIKit.h>
#import "DZMPhoto.h"

@class DZMPhotoView;
@protocol DZMPhotoViewDelegate <NSObject>
@optional

/// 将要显示的模型
- (void)photoView:(DZMPhotoView * _Nonnull)photoView willShowPhoto:(DZMPhoto * _Nullable)photo;

/// 即将隐藏销毁
- (void)photoView:(DZMPhotoView * _Nonnull)photoView willHiddenPhoto:(DZMPhoto * _Nullable)photo;

/// 完成隐藏销毁
- (void)photoViewDidHidden:(DZMPhotoView * _Nonnull)photoView;

/// 图片保存结果
- (void)photoView:(DZMPhotoView * _Nonnull)photoView savePhoto:(DZMPhoto * _Nullable)photo error:(NSError * _Nullable)error;

@end

@interface DZMPhotoView : UIView

/// 代理(优先赋值)
@property(nonatomic, weak, nullable) id <DZMPhotoViewDelegate> delegate;

/// 模型
@property(nonatomic, weak, nullable) DZMPhoto *photo;

/// 清空缩放
- (void)clearZoomScale;
@end
