//
//  XCDropdownMenu.h
//  自定义账号输入框
//
//  Created by 樊小聪 on 2016/12/1.
//  Copyright © 2016年 樊小聪. All rights reserved.
//



/*
 *  备注：自定义下拉菜单 🐾
 */


#import <UIKit/UIKit.h>



/**
 每个 item 的模型类
 */
@interface XCDropdownModel : NSObject

/** 👀 item 的图片 👀 */
@property (copy, nonatomic) NSString *imageName;
/** 👀 item 的文字 👀 */
@property (copy, nonatomic) NSString *title;
/** 👀 点击 item 的回调 👀 */
@property (copy, nonatomic) void(^didClickHandle)();


/**
 创建一个 item 的数据模型
 
 @param imageName 图片名称
 @param title     文字
 @param didClickHandle 点击的回调
 */
- (instancetype)initWithImageName:(NSString *)imageName
                            title:(NSString *)title
                   didClickHandle:(void(^)(void))didClickHandle;

/**
 创建一个 item 的数据模型
 
 @param imageName 图片名称
 @param title 文字
 @param didClickHandle 点击的回调
 */
+ (instancetype)dropdownModelWithImageName:(NSString *)imageName
                                     title:(NSString *)title
                            didClickHandle:(void(^)(void))didClickHandle;

@end

/* 🐖 ***************************** 🐖 华丽的分隔线 🐖 *****************************  🐖 */




/**
 下拉菜单的配置类
 */
@interface XCDropdownOptionConfiguration : NSObject

/** 👀 每个 item 的宽度 👀 */
@property (assign, nonatomic) CGFloat itemWidth;
/** 👀 每个 item 的高度 👀 */
@property (assign, nonatomic) CGFloat itemHeight;
/** 👀 标题文字的大小 👀 */
@property (assign, nonatomic) CGFloat titleFontSize;
/** 👀 图片距离左边距的偏移量 👀 */
@property (assign, nonatomic) CGFloat leftInsetsX;
/** 👀 图片与文字的距离 👀 */
@property (assign, nonatomic) CGFloat iconToTitleSpacing;
/** 👀 下拉菜单的圆角大小 👀 */
@property (assign, nonatomic) CGFloat menuCornerRadius;
/** 👀 下拉菜单的背景颜色 👀 */
@property (strong, nonatomic) UIColor *normalMenuBackgroundColor;
/** 👀 选中状态下的背景颜色 👀 */
@property (strong, nonatomic) UIColor *selectedMenuBackgroundColor;
/** 👀 标题的文字的颜色 👀 */
@property (strong, nonatomic) UIColor *titleColor;
/** 👀 分隔线的颜色 👀 */
@property (strong, nonatomic) UIColor *seperatorLineColor;

/**
 默认配置
 */
+ (instancetype)defaultConfiguration;

@end


/* 🐖 ***************************** 🐖 华丽的分隔线 🐖 *****************************  🐖 */



@interface XCDropdownMenu : UIView


/**
 显示一个下拉菜单的视图

 @param view        需要显示的容器视图
 @param models      数据源
 @param options     配置   注：传空为 默认配置
 */
+ (void)showInView:(UIView *)view
            models:(NSArray<XCDropdownModel *> *)models
            options:(XCDropdownOptionConfiguration *)options;


/**
 在指定位置弹出视图

 @param point       指定位置
 @param models      数据源
 @param options     配置   注：传空为 默认配置
 */
+ (void)showAtPoint:(CGPoint)point
             models:(NSArray<XCDropdownModel *> *)models
            options:(XCDropdownOptionConfiguration *)options;

@end

