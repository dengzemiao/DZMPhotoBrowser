//
//  DZMPhotoPageController.m
//  DZMPhotoBrowser
//
//  Created by 邓泽淼 on 2017/10/19.
//  Copyright © 2017年 DZM. All rights reserved.
//

/// 动画时间
#define DZMAnimateDuration 0.25

#import "DZMPhotoPageController.h"
#import "DZMPhotoViewerController.h"

@interface DZMPhotoPageController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,DZMPhotoViewerControllerDelegate>

/// 模型数组
@property(nonatomic, copy, readonly, nullable) NSArray<DZMPhoto *> *photos;

/// 代理
@property(nonatomic, weak) id <DZMPhotoPageControllerDelegate> aDelegate;

/// 首个显示
@property(nonatomic, assign) NSInteger selectIndex;

@end

@implementation DZMPhotoPageController

/// 初始化
+ (instancetype _Nonnull)pageController:(NSArray<DZMPhoto *> * _Nonnull)photos selectIndex:(NSInteger)selectIndex delegate:(id<DZMPhotoPageControllerDelegate> _Nullable)delegate {
    
    // 父控件
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    // 配置
    NSDictionary *options = @{UIPageViewControllerOptionInterPageSpacingKey: @(10)};
    
    // DZMPhotoPageController
    DZMPhotoPageController *pageController =  [[DZMPhotoPageController alloc] initWithPhotos:photos selectIndex:selectIndex transitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options delegate:delegate];
    
    // 显示
    [window.rootViewController addChildViewController:pageController];
    [window.rootViewController.view addSubview:pageController.view];
    
    return pageController;
}

/// 初始化
- (instancetype)initWithPhotos:(NSArray<DZMPhoto *> *)photos selectIndex:(NSInteger)selectIndex transitionStyle:(UIPageViewControllerTransitionStyle)style navigationOrientation:(UIPageViewControllerNavigationOrientation)navigationOrientation options:(NSDictionary<NSString *,id> *)options delegate:(id<DZMPhotoPageControllerDelegate> _Nullable)delegate
{
    self = [super initWithTransitionStyle:style navigationOrientation:navigationOrientation options:options];
    
    if (self) {
        
        if (photos.count > 0) {
            
            // 排序
            for (int i = 0, count = (int)photos.count; i < count; i++) {
                
                DZMPhoto *photo = photos[i];
                
                [photo setValue:@(i) forKey:@"index"];
            }
            
            // 首个显示
            DZMPhoto *photo = photos[selectIndex];
            
            if (photo.imageView.image) {
                
                [photo setValue:@(YES) forKey:@"isFirst"];
            }
        }
        
        _photos = photos;
        
        _aDelegate = delegate;
        
        _selectIndex = selectIndex;
        
        self.delegate = self;
        
        self.dataSource = self;
        
        self.view.backgroundColor = [UIColor clearColor];
        
        __weak DZMPhotoPageController *weakSelf = self;
        
        [UIView animateWithDuration:DZMAnimateDuration animations:^{
            
            weakSelf.view.backgroundColor = [UIColor blackColor];
        }];
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // 初始化显示
    if (self.photos.count > 0) {
    
        DZMPhotoViewerController *vc = [DZMPhotoViewerController viewerController:self.photos[self.selectIndex] delegate:self];
        
        [self setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
}

#pragma mark - UIPageViewControllerDelegate

/// 切换结果
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    if (previousViewControllers.count > 0) {
        
        DZMPhotoViewerController *viewerController = (DZMPhotoViewerController *)pageViewController.viewControllers.lastObject;
        
        if ([self.aDelegate respondsToSelector:@selector(pageController:didShowPhoto:)]) {
            
            [self.aDelegate pageController:self didShowPhoto:viewerController.photo];
        }
    }
}

/// 准备切换
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    
    DZMPhotoViewerController *viewerController = (DZMPhotoViewerController *)pendingViewControllers.lastObject;
    
    [viewerController clearZoomScale];
}

#pragma mark - UIPageViewControllerDataSource

/// 上一页
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    return [self GetViewController:viewController isNext:NO];
}

/// 下一页
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    return [self GetViewController:viewController isNext:YES];
}

/// 获得控制器
- (nullable UIViewController *)GetViewController:(UIViewController *)viewController isNext:(BOOL)isNext {
    
    if (self.photos.count > 0) {
    
        DZMPhotoViewerController *viewerController = (DZMPhotoViewerController *)viewController;
        
        NSInteger index = viewerController.photo.index;
        
        index += isNext ? 1 : -1;
        
        if (index < 0 || index >= self.photos.count) {
            
            return nil;
        }
        
        return [DZMPhotoViewerController viewerController:self.photos[index] delegate:self];
    }
    
    return nil;
}

#pragma mark - DZMPhotoViewDelegate

- (void)viewerController:(DZMPhotoViewerController *)viewerController savePhoto:(DZMPhoto *)photo error:(NSError *)error
{
    if ([self.aDelegate respondsToSelector:@selector(pageController:savePhoto:error:)]) {
        
        [self.aDelegate pageController:self savePhoto:photo error:error];
    }
}

- (void)viewerController:(DZMPhotoViewerController *)viewerController willShowPhoto:(DZMPhoto *)photo
{
    if ([self.aDelegate respondsToSelector:@selector(pageController:willShowPhoto:)]) {
        
        [self.aDelegate pageController:self willShowPhoto:photo];
    }
}

- (void)viewerController:(DZMPhotoViewerController *)viewerController willHiddenPhoto:(DZMPhoto *)photo
{
    if ([self.aDelegate respondsToSelector:@selector(pageController:willHiddenPhoto:)]) {
        
        [self.aDelegate pageController:self willHiddenPhoto:photo];
    }
    
    __weak DZMPhotoPageController *weakSelf = self;
    
    [UIView animateWithDuration:DZMAnimateDuration animations:^{
        
        weakSelf.view.backgroundColor = [UIColor clearColor];
        
    } completion:^(BOOL finished) {
        
        [weakSelf.view removeFromSuperview];
        
        [weakSelf removeFromParentViewController];
    }];
}

- (void)removeFromParentViewController
{
    if ([self.aDelegate respondsToSelector:@selector(pageControllerDidHidden:)]) {

        [self.aDelegate pageControllerDidHidden:self];
    }

    [super removeFromParentViewController];
}

- (void)dealloc
{
    self.delegate = nil;
    
    self.dataSource = self;
    
    self.aDelegate = nil;
    
    _photos = nil;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
