//
//  UIView+Extension.m
//  KVO
//
//  Created by 樊小聪 on 16/5/9.
//  Copyright © 2016年 樊小聪. All rights reserved.
//

#import "UIView+Extension.h"
#import <objc/runtime.h>

@implementation UIView (Extension)

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)x {
    return self.frame.origin.x;
}
- (void)setX:(CGFloat)x {
    CGRect tempRect = self.frame;
    tempRect.origin.x = x;
    self.frame = tempRect;
}

- (CGFloat)y {
    return self.frame.origin.y;
}


- (void)setY:(CGFloat)y {
    CGRect tempRect = self.frame;
    tempRect.origin.y = y;
    self.frame = tempRect;
}


static char event_key;

- (void)setTapGestureHandle:(void (^)(UITapGestureRecognizer *, UIView *))tapGestureHandle
{
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapHandle:)];
    
    [self addGestureRecognizer:tapGesture];
    
    objc_setAssociatedObject(self, &event_key, tapGestureHandle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UITapGestureRecognizer *, UIView *))tapGestureHandle
{
    return objc_getAssociatedObject(self, &event_key);
}

- (void)didTapHandle:(UITapGestureRecognizer *)tap
{
    void (^tapGestureHandle)(UITapGestureRecognizer *tap, UIView *tapView) = objc_getAssociatedObject(self, &event_key);
    
    if (tapGestureHandle)
    {
        tapGestureHandle(tap, tap.view);
    }
}


- (void)setTapHandle:(void (^)())tapHandle
{
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapHandle)];
    
    [self addGestureRecognizer:tapGesture];
    
    objc_setAssociatedObject(self, @selector(tapHandle), tapHandle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)())tapHandle
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)didTapHandle
{
    void (^tapGestureHandle)() = objc_getAssociatedObject(self, @selector(tapHandle));
    
    if (tapGestureHandle)
    {
        tapGestureHandle();
    }
}


- (UIViewController *)viewController
{
    UIResponder *nextResponder = [self nextResponder];
    
    while (nextResponder)
    {
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)nextResponder;
        }
    }
    
    return nil;
}


/**
 *  给 UIView 的图层添加阴影
 *
 *  @param color  阴影颜色
 *  @param offset 阴影的偏移量
 *  @param radius 阴影的渐变距离
 */
- (void)setLayerShadow:(nullable UIColor*)color
                offset:(CGSize)offset
                radius:(CGFloat)radius
{
    // 阴影颜色
    self.layer.shadowColor        = color.CGColor;
    // 阴影的偏移量
    self.layer.shadowOffset       = offset;
    // shadow 的渐变距离，从外围开始，往里渐变 shadowRadius 距离
    self.layer.shadowRadius       = radius;
    // 阴影的透明效果
    self.layer.shadowOpacity      = 1;
    
    self.layer.shouldRasterize    = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (UIImage *)snapshotImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

- (UIImage *)snapshotImageAfterScreenUpdates:(BOOL)afterUpdates {
    if (![self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        return [self snapshotImage];
    }
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:afterUpdates];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}


@end















