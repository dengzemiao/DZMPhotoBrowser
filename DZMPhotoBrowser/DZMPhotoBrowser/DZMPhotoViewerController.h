//
//  DZMPhotoViewerController.h
//  DZMPhotoBrowser
//
//  Created by 邓泽淼 on 2017/10/19.
//  Copyright © 2017年 DZM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZMPhotoView.h"
#import "DZMPhoto.h"

@class DZMPhotoViewerController;
@protocol DZMPhotoViewerControllerDelegate <NSObject>
@optional

/// 将要显示的模型
- (void)viewerController:(DZMPhotoViewerController * _Nonnull)viewerController willShowPhoto:(DZMPhoto * _Nullable)photo;

/// 即将隐藏销毁
- (void)viewerController:(DZMPhotoViewerController * _Nonnull)viewerController willHiddenPhoto:(DZMPhoto * _Nullable)photo;

/// 完成隐藏销毁
- (void)viewerControllerDidHidden:(DZMPhotoViewerController * _Nonnull)viewerController;

/// 图片保存结果
- (void)viewerController:(DZMPhotoViewerController * _Nonnull)viewerController savePhoto:(DZMPhoto * _Nullable)photo error:(NSError * _Nullable)error;

@end

@interface DZMPhotoViewerController : UIViewController

/// 初始化
+ (instancetype _Nonnull)viewerController:(DZMPhoto * _Nonnull)photo delegate:(id<DZMPhotoViewerControllerDelegate> _Nullable)delegate;

/// 模型
@property(nonatomic, weak, readonly, nullable) DZMPhoto *photo;

/// 清空缩放
- (void)clearZoomScale;
@end
