//
//  UIView+Extension.h
//  KVO
//
//  Created by 樊小聪 on 16/5/9.
//  Copyright © 2016年 樊小聪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

/** frame.origin.x */
@property (nonatomic) CGFloat left;

/** frame.origin.y */
@property (nonatomic) CGFloat top;

/** frame.origin.x + frame.size.width */
@property (nonatomic) CGFloat right;

/** frame.origin.y + frame.size.height */
@property (nonatomic) CGFloat bottom;

/** frame.size.width */
@property (nonatomic) CGFloat width;

/** frame.size.height */
@property (nonatomic) CGFloat height;

/** center.x */
@property (nonatomic) CGFloat centerX;

/** center.y */
@property (nonatomic) CGFloat centerY;

/** frame.origin */
@property (nonatomic) CGPoint origin;

/** frame.origin.size */
@property (nonatomic) CGSize  size;

@property (nonatomic) CGFloat x;

@property (nonatomic) CGFloat y;


/**
 *  手势事件
 */
@property (nullable, copy, nonatomic) void(^tapGestureHandle)(UITapGestureRecognizer * _Nullable gesture, UIView * _Nullable tapView);


/**
 手势事件
 */
@property (nullable, copy, nonatomic) void(^tapHandle)();



/**
 *   返回当前视图的下一级控制器，可能为空
 */
@property (nullable, nonatomic, readonly) UIViewController *viewController;


/**
 *  给 UIView 的图层添加阴影
 *
 *  @param color  阴影颜色
 *  @param offset 阴影的偏移量
 *  @param radius 阴影的渐变距离
 */
- (void)setLayerShadow:(nullable UIColor*)color
                offset:(CGSize)offset
                radius:(CGFloat)radius;

/**
 *  截取当前视图
 *
 */
- (nullable UIImage *)snapshotImage;

/**
 Create a snapshot image of the complete view hierarchy.
 @discussion It's faster than "snapshotImage", but may cause screen updates.
 See -[UIView drawViewHierarchyInRect:afterScreenUpdates:] for more information.
 */
- (nullable UIImage *)snapshotImageAfterScreenUpdates:(BOOL)afterUpdates;



@end












