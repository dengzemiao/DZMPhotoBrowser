//
//  DZMPhotoBrowser.m
//  DZMPhotoBrowser
//
//  Created by 邓泽淼 on 2017/6/6.
//  Copyright © 2017年 DZM. All rights reserved.
//

#import "DZMPhotoBrowser.h"
#import "DZMPhotoPageController.h"

@interface DZMPhotoBrowser()<DZMPhotoPageControllerDelegate>

@property(nonatomic, strong) DZMPhotoBrowser *strongSelf;

@end

@implementation DZMPhotoBrowser

#pragma mark - 初始化

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        self.strongSelf = self;
        
        self.initSelectIndex = 0;
    }
    
    return self;
}

- (NSArray<DZMPhoto *> *)photos
{
    if (!_photos) {
        
        _photos = [NSArray array];
    }
    
    return _photos;
}

#pragma mark - 展示

/// 展示
- (void)show
{
    // 整理数据
    if (self.photos.count != 0) {
        
        // 隐藏状态栏
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        
        // DZMPhotoPageController
        [DZMPhotoPageController pageController:self.photos selectIndex:self.initSelectIndex delegate:self];
    }
}

#pragma mark - DZMPhotoPageControllerDelegate

- (void)pageController:(DZMPhotoPageController *)pageController savePhoto:(DZMPhoto *)photo error:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:savePhoto:error:)]) {
        
        [self.delegate photoBrowser:self savePhoto:photo error:error];
    }
}

- (void)pageController:(DZMPhotoPageController *)pageController didShowPhoto:(DZMPhoto *)photo
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:didShowPhoto:)]) {
        
        [self.delegate photoBrowser:self didShowPhoto:photo];
    }
}

- (void)pageController:(DZMPhotoPageController *)pageController willShowPhoto:(DZMPhoto *)photo
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:willShowPhoto:)]) {
        
        [self.delegate photoBrowser:self willShowPhoto:photo];
    }
}

- (void)pageController:(DZMPhotoPageController *)pageController willHiddenPhoto:(DZMPhoto *)photo
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:willHiddenPhoto:)]) {
        
        [self.delegate photoBrowser:self willHiddenPhoto:photo];
    }
    
    // 显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)pageControllerDidHidden:(DZMPhotoPageController *)pageController
{
    if ([self.delegate respondsToSelector:@selector(photoBrowserDidHidden:)]) {
        
        [self.delegate photoBrowserDidHidden:self];
    }
    
    self.strongSelf = nil;
}

- (void)dealloc
{
    self.delegate = nil;
}

@end
