//
//  DZMPhotoViewerController.m
//  DZMPhotoBrowser
//
//  Created by 邓泽淼 on 2017/10/19.
//  Copyright © 2017年 DZM. All rights reserved.
//

#import "DZMPhotoViewerController.h"

@interface DZMPhotoViewerController ()<DZMPhotoViewDelegate>

/// DZMPhotoView
@property(nonatomic, strong, nullable) DZMPhotoView *photoView;

/// 代理
@property(nonatomic, weak) id <DZMPhotoViewerControllerDelegate> aDelegate;

@end

@implementation DZMPhotoViewerController

/// 初始化
+ (instancetype _Nonnull)viewerController:(DZMPhoto * _Nonnull)photo delegate:(id<DZMPhotoViewerControllerDelegate> _Nullable)delegate {
    
    DZMPhotoViewerController *viewerController = [[DZMPhotoViewerController alloc] initWithPhoto:photo delegate:delegate];
    
    return viewerController;
}

/// 初始化
- (instancetype)initWithPhoto:(DZMPhoto * _Nonnull)photo delegate:(id<DZMPhotoViewerControllerDelegate> _Nullable)delegate {
    
    self = [super init];
    
    if (self) {
        
        _photo = photo;
        
        _aDelegate = delegate;
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // 清空背景
    self.view.backgroundColor = [UIColor clearColor];
    
    // photoView
    self.photoView = [[DZMPhotoView alloc] init];
    self.photoView.delegate = self;
    self.photoView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_photoView];
    
    // 布局
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[photoView]-0-|" options:0 metrics:nil views:@{@"photoView":_photoView,@"view":self.view}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[photoView]-0-|" options:0 metrics:nil views:@{@"photoView":_photoView}]];
    
    // 显示
    self.photoView.photo = self.photo;
}

/// 清空缩放
- (void)clearZoomScale {
    
    [self.photoView clearZoomScale];
}

/// 屏幕旋转
- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    __weak DZMPhotoViewerController *weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [weakSelf clearZoomScale];
    });
}

#pragma mark - DZMPhotoViewDelegate

- (void)photoView:(DZMPhotoView *)photoView savePhoto:(DZMPhoto *)photo error:(NSError *)error
{
    if ([self.aDelegate respondsToSelector:@selector(viewerController:savePhoto:error:)]) {
        
        [self.aDelegate viewerController:self savePhoto:photo error:error];
    }
}

- (void)photoView:(DZMPhotoView *)photoView willShowPhoto:(DZMPhoto *)photo
{
    if ([self.aDelegate respondsToSelector:@selector(viewerController:willShowPhoto:)]) {
        
        [self.aDelegate viewerController:self willShowPhoto:photo];
    }
}

- (void)photoView:(DZMPhotoView *)photoView willHiddenPhoto:(DZMPhoto *)photo
{
    if ([self.aDelegate respondsToSelector:@selector(viewerController:willHiddenPhoto:)]) {
        
        [self.aDelegate viewerController:self willHiddenPhoto:photo];
    }
}

- (void)dealloc {
    
    self.photoView = nil;
    
    _photo = nil;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
