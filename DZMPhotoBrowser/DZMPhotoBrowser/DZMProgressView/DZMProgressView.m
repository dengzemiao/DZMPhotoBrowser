//
//  DZMProgressView.m
//  DZMProgressView
//
//  Created by 邓泽淼 on 16/7/27.
//  Copyright © 2016年 DZM. All rights reserved.
//

#import "DZMProgressView.h"

@implementation DZMProgressAppearance

// 获取单利对象
+ (DZMProgressAppearance *)progressAppearance {
    
    static DZMProgressAppearance *progressAppearance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        progressAppearance = [[self alloc] init];
    });
    return progressAppearance;
}

// 单个创建
- (id)init {
    
    self = [super init];
    
    if (self) {
        
        self.schemeColor = [UIColor whiteColor];
        self.percentageTextFont = [UIFont systemFontOfSize:10];
        self.percentageTextOffset = CGPointZero;
        self.type = DZMProgressTypeCircle;
        self.showPercentage = YES;
    }
    
    return self;
}

- (void)setSchemeColor:(UIColor *)schemeColor {
    
    _schemeColor = schemeColor;

    _progressTintColor = [UIColor colorWithCGColor:CGColorCreateCopyWithAlpha(schemeColor.CGColor, 1)];
    _backgroundTintColor = [UIColor colorWithCGColor:CGColorCreateCopyWithAlpha(schemeColor.CGColor, 0.1)];
    _percentageTextColor = [UIColor colorWithCGColor:CGColorCreateCopyWithAlpha(schemeColor.CGColor, 1)];
}

@end


@implementation DZMProgressView

- (DZMProgressAppearance *)progressAppearance {
    
    if (!_progressAppearance) {
        
        _progressAppearance = [DZMProgressAppearance progressAppearance];
    }
    
    return _progressAppearance;
}

- (id)init {
    
    return [self initWithFrame:CGRectMake(0.f, 0.f, 40.f, 40.f)];
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        self.progress = 0.f;

        [self registerForKVO];
    }
    
    return self;
}

- (void)dealloc {
    
    [self unregisterFromKVO];
}


#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    
    CGRect allRect = self.bounds;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    DZMProgressAppearance *appearance = self.progressAppearance;
    
    if (appearance.type == DZMProgressTypeAnnular) {
        
        CGFloat lineWidth = 5.f;
        UIBezierPath *processBackgroundPath = [UIBezierPath bezierPath];
        processBackgroundPath.lineWidth = lineWidth;
        processBackgroundPath.lineCapStyle = kCGLineCapRound;
        CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        CGFloat radius = (self.bounds.size.width - lineWidth)/2;
        CGFloat startAngle = - ((float)M_PI / 2);
        CGFloat endAngle = (2 * (float)M_PI) + startAngle;
        [processBackgroundPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
        [appearance.backgroundTintColor set];
        [processBackgroundPath stroke];
        
        UIBezierPath *processPath = [UIBezierPath bezierPath];
        processPath.lineCapStyle = kCGLineCapRound;
        processPath.lineWidth = lineWidth;
        endAngle = (self.progress * 2 * (float)M_PI) + startAngle;
        [processPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
        [appearance.progressTintColor set];
        [processPath stroke];
        
        if (appearance.showPercentage)
            [self drawTextInContext:context];
        
    } else if (appearance.type == DZMProgressTypeCircle) {
        
        CGColorRef colorBackAlpha = CGColorCreateCopyWithAlpha(appearance.backgroundTintColor. CGColor, 0.05f);
        CGColorRef colorProgressAlpha = CGColorCreateCopyWithAlpha(appearance.progressTintColor. CGColor, 0.2f);
        
        CGRect allRect = rect;
        CGRect circleRect = CGRectMake(allRect.origin.x + 2, allRect.origin.y + 2, allRect.size.width - 4, allRect.size.height - 4);
        float x = allRect.origin.x + (allRect.size.width / 2);
        float y = allRect.origin.y + (allRect.size.height / 2);
        float angle = (_progress) * 360.0f;
        
        CGContextSaveGState(context);
        CGContextSetStrokeColorWithColor(context, colorProgressAlpha);
        CGContextSetFillColorWithColor(context, colorBackAlpha);
        CGContextSetLineWidth(context, 2.0);
        CGContextFillEllipseInRect(context, circleRect);
        CGContextStrokeEllipseInRect(context, circleRect);
        
        CGContextSetRGBFillColor(context, 1.0, 0.0, 1.0, 1.0);
        CGContextMoveToPoint(context, x, y);
        CGContextAddArc(context, x, y, (allRect.size.width + 4) / 2, -M_PI / 2, (angle * M_PI) / 180.0f - M_PI / 2, 0);
        CGContextClip(context);
        
        CGContextSetStrokeColorWithColor(context, appearance.progressTintColor.CGColor);
        CGContextSetFillColorWithColor(context, appearance.backgroundTintColor.CGColor);
        CGContextSetLineWidth(context, 2.0);
        CGContextFillEllipseInRect(context, circleRect);
        CGContextStrokeEllipseInRect(context, circleRect);
        CGContextRestoreGState(context);
        
        if (appearance.showPercentage)
            [self drawTextInContext:context];
        
    } else {
        
        CGRect circleRect = CGRectInset(allRect, 2.0f, 2.0f);
        CGColorRef colorBackAlpha = CGColorCreateCopyWithAlpha(appearance.backgroundTintColor. CGColor, 0.1f);
        
        [appearance.progressTintColor setStroke];
        CGContextSetFillColorWithColor(context, colorBackAlpha);
        
        CGContextSetLineWidth(context, 2.0f);
        CGContextFillEllipseInRect(context, circleRect);
        CGContextStrokeEllipseInRect(context, circleRect);
        
        CGPoint center = CGPointMake(allRect.size.width / 2, allRect.size.height / 2);
        CGFloat radius = (allRect.size.width - 4) / 2 - 3;
        CGFloat startAngle = - ((float)M_PI / 2);
        CGFloat endAngle = (self.progress * 2 * (float)M_PI) + startAngle;
        [appearance.progressTintColor setFill];
        CGContextMoveToPoint(context, center.x, center.y);
        CGContextAddArc(context, center.x, center.y, radius, startAngle, endAngle, 0);
        CGContextClosePath(context);
        CGContextFillPath(context);
    }
}

- (void)drawTextInContext:(CGContextRef)context {
    
    DZMProgressAppearance *appearance = self.progressAppearance;
    
    CGRect allRect = self.bounds;
    
    UIFont *font = appearance.percentageTextFont;
    
    NSString *text = [NSString stringWithFormat:@"%i%%", (int)(_progress * 100.0f)];
    
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
    
    float x = floorf(allRect.size.width / 2) + 3 + appearance.percentageTextOffset.x;
    
    float y = floorf(allRect.size.height / 2) - 6 + appearance.percentageTextOffset.y;
    
    [text drawAtPoint:CGPointMake(x - textSize.width / 2.0, y)  withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:appearance.percentageTextColor}];
}


#pragma mark - KVO


- (void)registerForKVO {
    
    for (NSString *keyPath in [self observableKeypaths]) {
        
        [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
    }
}


- (void)unregisterFromKVO {
    
    for (NSString *keyPath in [self observableKeypaths]) {
        
        [self removeObserver:self forKeyPath:keyPath];
    }
}


- (NSArray *)observableKeypaths {
    
    return [NSArray arrayWithObjects:@"progressAppearance", @"progress", nil];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    [self setNeedsDisplay];
}

@end
