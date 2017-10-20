//
//  DZMProgressView.h
//  DZMProgressView
//
//  Created by 邓泽淼 on 16/7/27.
//  Copyright © 2016年 DZM. All rights reserved.
//

// 类型
typedef enum {
    DZMProgressTypeAnnular = 0,
    DZMProgressTypeCircle,
    DZMProgressTypePie
}DZMProgressType;

#import <UIKit/UIKit.h>

// 该对象可使用单利全局控制 也可以单独创建使用
@interface DZMProgressAppearance : NSObject

// 获取单利对象
+ (DZMProgressAppearance *)progressAppearance;

/**
 *  进度条显示类型
 */
@property (assign, nonatomic) DZMProgressType type;

/**
 *  是否显示 百分比文字 只对 DZMProgressTypeAnnular 和 DZMProgressTypeCircle 会有效
 */
@property (assign, nonatomic) BOOL showPercentage;

/**
 *  设置该属性颜色 会一起设置 progressTintColor backgroundTintColor percentageTextColor
 */
@property (strong, nonatomic) UIColor *schemeColor;

// 进度颜色
@property (strong, nonatomic) UIColor *progressTintColor;

// 背景颜色
@property (strong, nonatomic) UIColor *backgroundTintColor;

// 进度字体颜色
@property (strong, nonatomic) UIColor *percentageTextColor;

// 进度字体大小
@property (strong, nonatomic) UIFont *percentageTextFont;

// 进度字体偏移
@property (assign, nonatomic) CGPoint percentageTextOffset;

@end

// 进度View
@interface DZMProgressView : UIView

// 进度
@property (assign, nonatomic) float progress;

// 配置
@property (strong, nonatomic) DZMProgressAppearance *progressAppearance;

@end
