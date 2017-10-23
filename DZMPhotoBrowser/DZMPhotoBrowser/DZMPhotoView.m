//
//  DZMPhotoView.m
//  DZMPhotoBrowser
//
//  Created by 邓泽淼 on 2017/6/6.
//  Copyright © 2017年 DZM. All rights reserved.
//

/// 本地文件导入使用头文件
#import "UIImageView+WebCache.h"

/// Pods FrameWork 导入
//#import <SDWebImage/UIImageView+WebCache.h>

#import "DZMPhotoView.h"
#import "DZMProgressView.h"

@interface DZMPhotoView()<UIScrollViewDelegate>

@property(nonatomic, weak) UIScrollView *scrollView;

@property(nonatomic, weak) UIImageView *imageView;

@property(nonatomic, weak) DZMProgressView *progressView;

@property(nonatomic, weak) UIButton *failButton;

@property(nonatomic, weak) UIButton *saveButton;

@property(nonatomic, weak) UITapGestureRecognizer *singleTap;

@property(nonatomic, weak) UITapGestureRecognizer *doubleTap;

@property(nonatomic, assign) BOOL isSingleTap;

@end

@implementation DZMPhotoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self creatUI];
    }
    
    return self;
}

#pragma mark - 创建UI

- (void)creatUI
{
    // scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.maximumZoomScale = 3.0;
    scrollView.minimumZoomScale = 1.0;
    scrollView.zoomScale = scrollView.minimumZoomScale;
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    // 布局
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[scrollView]-0-|" options:0 metrics:nil views:@{@"scrollView":scrollView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[scrollView]-0-|" options:0 metrics:nil views:@{@"scrollView":scrollView}]];
    
    // imageView
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    imageView.hidden = YES;
    imageView.backgroundColor = [UIColor redColor];
    [scrollView addSubview:imageView];
    self.imageView = imageView;
    
    // 进度条
    [self creatProgressView];
    
    // 失败按钮
    [self creatFailButton];
    
    // 保存按钮
    [self creatSaveButton];
    
    // 手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:singleTap];
    self.singleTap = singleTap;
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTap];
    self.doubleTap = doubleTap;
    
    [singleTap requireGestureRecognizerToFail:doubleTap];
}

#pragma mark - 失败按钮

- (void)creatFailButton
{
    // failButton
    UIButton *failButton = [UIButton buttonWithType:UIButtonTypeCustom];
    failButton.translatesAutoresizingMaskIntoConstraints = NO;
    failButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    failButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [failButton setTitle:@"重新加载" forState:UIControlStateNormal];
    [failButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    failButton.layer.cornerRadius = 5;
    failButton.layer.borderColor = [UIColor whiteColor].CGColor;
    failButton.layer.borderWidth = 1.0;
    failButton.layer.masksToBounds = YES;
    failButton.hidden = YES;
    [failButton addTarget:self action:@selector(clickFail) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:failButton];
    self.failButton = failButton;
    
    // size
    CGSize failButtonSize = [failButton.currentTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:failButton.titleLabel.font} context:nil].size;
    failButtonSize = CGSizeMake(failButtonSize.width + 10, failButtonSize.height + 10);
    
    // 设置宽度
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"[failButton(%f)]",failButtonSize.width] options:0 metrics:nil views:@{@"failButton":failButton}]];
    
    // 设置高度
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[failButton(%f)]",failButtonSize.height] options:0 metrics:nil views:@{@"failButton":failButton}]];
    
    // 垂直居中
    [self addConstraint:[NSLayoutConstraint constraintWithItem:failButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    // 水平居中
    [self addConstraint:[NSLayoutConstraint constraintWithItem:failButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
}

- (void)clickFail {
    
    self.photo = self.photo;
}

#pragma mark - 保存按钮

- (void)creatSaveButton
{
    // failButton
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.translatesAutoresizingMaskIntoConstraints = NO;
    saveButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    saveButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    saveButton.layer.cornerRadius = 5;
    saveButton.layer.borderColor = [UIColor whiteColor].CGColor;
    saveButton.layer.borderWidth = 1.0;
    saveButton.layer.masksToBounds = YES;
    [saveButton addTarget:self action:@selector(clickSave) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:saveButton];
    self.saveButton = saveButton;
    [self saveButtonSelected:NO];
    
    // size
    CGSize saveButtonSize = [saveButton.currentTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:saveButton.titleLabel.font} context:nil].size;
    saveButtonSize = CGSizeMake(saveButtonSize.width + 10, saveButtonSize.height + 10);
    
    // 设置宽度
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"[saveButton(%f)]",saveButtonSize.width] options:0 metrics:nil views:@{@"saveButton":saveButton}]];
    
    // 设置Y
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[saveButton(%f)]-20-|",saveButtonSize.height] options:0 metrics:nil views:@{@"saveButton":saveButton}]];
    
    // 水平居中
    [self addConstraint:[NSLayoutConstraint constraintWithItem:saveButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
}

/// 以防扩展保存方法操作
- (void)saveButtonSelected:(BOOL)isSelected {
    
    self.saveButton.selected = isSelected;
}

- (void)clickSave
{
    if (self.saveButton.isSelected) {return;}
    
    if (!self.photo.isSave) {
        
        UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    
    [self saveButtonSelected:YES];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error != NULL) {
        
        [self saveButtonSelected:NO];
        
    }else{
        
        [self.photo setValue:@(YES) forKey:@"isSave"];
    }
    
    if ([self.delegate respondsToSelector:@selector(photoView:savePhoto:error:)]) {
        
        [self.delegate photoView:self savePhoto:self.photo error:error];
    }
}

#pragma mark - 进度

- (void)creatProgressView
{
    // progressView
    DZMProgressView *progressView = [[DZMProgressView alloc] init];
    progressView.translatesAutoresizingMaskIntoConstraints = NO;
    progressView.progress = 0;
    progressView.hidden = YES;
    [self addSubview:progressView];
    self.progressView = progressView;
    
    // 设置宽度
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[progressView(60)]" options:0 metrics:nil views:@{@"progressView":progressView}]];
    
    // 设置高度
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[progressView(60)]" options:0 metrics:nil views:@{@"progressView":progressView}]];
    
    // 垂直居中
    [self addConstraint:[NSLayoutConstraint constraintWithItem:progressView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    // 水平居中
    [self addConstraint:[NSLayoutConstraint constraintWithItem:progressView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
}

#pragma mark - 设置模型数据

- (void)setPhoto:(DZMPhoto *)photo
{
    _photo = photo;
    
    // 设置
    self.imageView.hidden = YES;
    self.progressView.hidden = YES;
    self.failButton.hidden = YES;
    self.saveButton.hidden = YES;
    
    // 返回
    if (!photo) {return;}
    
    // 回调
    if ([self.delegate respondsToSelector:@selector(photoView:willShowPhoto:)]) {
        
        [self.delegate photoView:self willShowPhoto:photo];
    }
    
    // 展示
    if (photo.url || photo.image) {
        
        if (photo.url) {
            
            __weak DZMPhotoView *weakSelf = self;
            
            self.progressView.progress = 0;
            
            // 如果没有刷新进度条可以打印线程是否在主线程 progress 这个block有的版本是异步有的版本是主线程
            [[SDWebImageManager sharedManager] diskImageExistsForURL:photo.url completion:^(BOOL isInCache) {
                
                weakSelf.progressView.hidden = isInCache;
               
                [weakSelf.imageView sd_setImageWithURL:photo.url placeholderImage:photo.imageView.image options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                   
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        
                        weakSelf.progressView.progress = (float)receivedSize / (float)expectedSize;
                    });
                    
                } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                   
                    weakSelf.progressView.hidden = YES;
                    
                    if (error) {
                        
                        weakSelf.failButton.hidden = NO;
                        
                    }else{
                        
                        [self saveButtonSelected:photo.isSave];
                        
                        self.saveButton.hidden = NO;
                    }
                    
                    [weakSelf clearZoomScale];
                }];
                
                [weakSelf clearZoomScale];
                
            }];
            
        }else{
            
            self.imageView.image = photo.image;
            
            [self clearZoomScale];
            
            [self saveButtonSelected:photo.isSave];
            
            self.saveButton.hidden = NO;
        }
    }
}

#pragma mark - 布局

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.isSingleTap) {
        
        [self adjustImageViewFrame];
    }
}

- (void)adjustImageViewFrame
{
    if (self.imageView.image) {
        
        if (!self.photo.isFirst) { self.imageView.hidden = NO;}
        
        CGSize viewSize = self.bounds.size;
        
        CGSize imageSize = self.imageView.image.size;
        
        if (imageSize.width > viewSize.width || imageSize.height > viewSize.height) {
            
            CGFloat imageScale = imageSize.width / imageSize.height;
            
            CGFloat screenScale = viewSize.width / viewSize.height;
            
            if (screenScale > imageScale) {
               
                imageSize = CGSizeMake(viewSize.height * imageSize.width / imageSize.height, viewSize.height);
                
            }else{
                
                imageSize = CGSizeMake(viewSize.width, viewSize.width * imageSize.height / imageSize.width);
            }
        }
        
        self.imageView.frame = CGRectMake((viewSize.width - imageSize.width)/2, (viewSize.height - imageSize.height)/2, imageSize.width, imageSize.height);
        
        self.scrollView.contentSize = imageSize;
        
        [self scrollViewDidZoom:self.scrollView];
    }
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (self.imageView.image) {
        
        CGSize viewSize = self.bounds.size;
        
        CGRect imageViewFrame = self.imageView.frame;
        
        if (imageViewFrame.size.width < viewSize.width) {
            
            imageViewFrame.origin.x = floorf((viewSize.width - imageViewFrame.size.width) / 2);
            
        }else{
            
            imageViewFrame.origin.x = 0;
        }
        
        if (imageViewFrame.size.height < viewSize.height) {
            
            imageViewFrame.origin.y = floorf((viewSize.height - imageViewFrame.size.height) / 2);
            
        }else{
            
            imageViewFrame.origin.y = 0;
        }
        
        if (!CGRectEqualToRect(self.imageView.frame, imageViewFrame)) {
            
            self.imageView.frame = imageViewFrame;
        }
        
        if (self.photo.isFirst) {
            
            [self.photo setValue:@(NO) forKey:@"isFirst"];
            
            __weak DZMPhotoView *weakSelf = self;
            
            if (self.photo.imageView && self.photo.imageView.image) {
                
                CGRect frame = [self convertRect:self.photo.imageView];
                
                self.imageView.frame = frame;
                
                self.imageView.hidden = NO;
                
                [UIView animateWithDuration:DZMAnimateDuration animations:^{
                    
                    weakSelf.imageView.frame = imageViewFrame;
                }];
                
            }else{
                
                self.imageView.hidden = NO;
                
                self.imageView.alpha = 0;
                
                [UIView animateWithDuration:DZMAnimateDuration animations:^{
                    
                    weakSelf.imageView.alpha = 1.0;
                }];
            }
        }
    }
}

#pragma mark - 手势点击

- (void)doubleTap:(UITapGestureRecognizer *)tap
{
    CGPoint point = [tap locationInView:self.imageView];
    
    if (self.scrollView.zoomScale != self.scrollView.minimumZoomScale) {
        
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
        
    }else{
        
        [self.scrollView zoomToRect:CGRectMake(point.x, point.y, 1, 1) animated:YES];
    }
}

- (void)singleTap:(UITapGestureRecognizer *)tap
{
    self.isSingleTap = true;
    
    if ([self.delegate respondsToSelector:@selector(photoView:willHiddenPhoto:)]) {
        
        [self.delegate photoView:self willHiddenPhoto:self.photo];
    }
    
    self.userInteractionEnabled = false;
    
    __weak DZMPhotoView *weakSelf = self;
    
    [UIView animateWithDuration:DZMAnimateDuration animations:^{
        
        weakSelf.progressView.alpha = 0;
        
        weakSelf.failButton.alpha = 0;
        
        weakSelf.saveButton.alpha = 0;
    }];
    
    if (self.photo.imageView) {
        
        CGRect frame = [self convertRect:self.photo.imageView];
        
        [UIView animateWithDuration:DZMAnimateDuration animations:^{

            weakSelf.imageView.frame = frame;

        } completion:^(BOOL finished) {

            [weakSelf removeFromSuperview];
        }];
        
    }else{
        
        [UIView animateWithDuration:DZMAnimateDuration animations:^{
         
            if (weakSelf.scrollView.zoomScale < 1.8f) {
                
                weakSelf.imageView.transform = CGAffineTransformMakeScale(1.8f, 1.8f);
            }
            
            weakSelf.imageView.alpha = 0;
            
        } completion:^(BOOL finished) {
            
            [weakSelf removeFromSuperview];
        }];
    }
}

- (void)removeFromSuperview
{
    if ([self.delegate respondsToSelector:@selector(photoViewDidHidden:)]) {
        
        [self.delegate photoViewDidHidden:self];
    }
    
    [self.scrollView removeFromSuperview];
    
    self.scrollView = nil;
    
    [self.failButton removeFromSuperview];
    
    self.failButton = nil;
    
    [self.progressView removeFromSuperview];
    
    self.progressView = nil;
    
    self.imageView.image = nil;
    
    [self.imageView removeFromSuperview];
    
    self.imageView = nil;
    
    [super removeFromSuperview];
}

- (CGRect)convertRect:(UIView *)view
{
    return [view convertRect:view.bounds toView:self.scrollView];
}

- (void)clearZoomScale
{
    [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    
    self.scrollView.contentSize = CGSizeZero;
    
    [self setNeedsLayout];
}

- (void)dealloc
{
    self.delegate = nil;
    
    self.photo = nil;
}

@end
