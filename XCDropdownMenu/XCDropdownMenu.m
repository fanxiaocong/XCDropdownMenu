//
//  XCDropdownMenu.m
//  自定义账号输入框
//
//  Created by 樊小聪 on 2016/12/1.
//  Copyright © 2016年 樊小聪. All rights reserved.
//



/*
 *  备注：自定义下拉菜单 🐾
 */

#import "XCDropdownMenu.h"

#import "UIView+Extension.h"




#define K_SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define K_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define K_KEY_WINDOW    [UIApplication sharedApplication].keyWindow

/** 👀 item 上图片的尺寸 👀 */
#define K_ICON_SIZE            CGSizeMake(20, 20)

// 最大显示的 item 的个数，超过这个最大值 menu 的高度将不再发生改变，但是可以上下滚动
#define K_MAX_ITEMS_COUNT      5


@implementation XCDropdownModel

/**
 创建一个 item 的数据模型
 
 @param imageName 图片名称
 @param title     文字
 @param didClickHandle 点击的回调
 */
- (instancetype)initWithImageName:(NSString *)imageName
                            title:(NSString *)title
                   didClickHandle:(void(^)(void))didClickHandle
{
    if (self = [super init])
    {
        self.imageName = imageName;
        self.title     = title;
        self.didClickHandle = didClickHandle;
    }
    
    return self;
}

/**
 创建一个 item 的数据模型
 
 @param imageName 图片名称
 @param title 文字
 @param didClickHandle 点击的回调
 */
+ (instancetype)dropdownModelWithImageName:(NSString *)imageName
                                     title:(NSString *)title
                            didClickHandle:(void(^)(void))didClickHandle
{
    return [[self alloc] initWithImageName:imageName title:title didClickHandle:didClickHandle];
}

@end


/* 🐖 ***************************** 🐖 华丽的分隔线 🐖 *****************************  🐖 */


@implementation XCDropdownOptionConfiguration

+ (instancetype)defaultConfiguration
{
    XCDropdownOptionConfiguration *configuration = [[XCDropdownOptionConfiguration alloc] init];
    
    /*⏰ ----- 这里配置一些默认参数 ----- ⏰*/
    configuration.itemWidth           = 120;
    configuration.itemHeight          = 44;
    configuration.iconToTitleSpacing  = 15;
    configuration.leftInsetsX         = 25;
    configuration.menuCornerRadius    = 5;
    configuration.titleFontSize       = 15;
    configuration.normalMenuBackgroundColor     = [[UIColor blackColor] colorWithAlphaComponent:.7f];
    configuration.selectedMenuBackgroundColor   = [[UIColor blackColor] colorWithAlphaComponent:.5f];
    configuration.titleColor                    = [UIColor whiteColor];
    configuration.seperatorLineColor            = [UIColor lightGrayColor];
    
    return configuration;
}

@end


/* 🐖 ***************************** 🐖 华丽的分隔线 🐖 *****************************  🐖 */

#pragma mark - 👀 Private cell 👀 💤

@interface XCDropdownMenuCell : UITableViewCell
/** 👀 图片 👀 */
@property (weak, nonatomic) UIImageView *icon;
/** 👀 标题LB 👀 */
@property (weak, nonatomic) UILabel *titleLB;
/** 👀 分隔线 👀 */
@property (weak, nonatomic) UIView *sepratorLineView;

/** 👀 是否显示分隔线 👀 */
@property (nonatomic, assign) BOOL isShowSeparator;
/** 👀 分隔线的颜色 👀 */
@property (nonatomic, weak) UIColor * separatorColor;
/** 👀 图片距离左边距的偏移量 👀 */
@property (assign, nonatomic) CGFloat leftInsetsX;
/** 👀 图片与文字的距离 👀 */
@property (assign, nonatomic) CGFloat iconAndTitleMargin;

/** 👀 数据 👀 */
@property (strong, nonatomic) XCDropdownModel *model;

@end


@implementation XCDropdownMenuCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _isShowSeparator    = YES;
        _separatorColor     = [UIColor lightGrayColor];
        _leftInsetsX        = 15;
        _iconAndTitleMargin = 15;
        
        // 设置 子视图
        [self icon];
        [self titleLB];
        
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self setNeedsDisplay];
    }
    return self;
}

#pragma mark - 💤 👀 LazyLoad Method 👀

- (UIImageView *)icon
{
    if (!_icon)
    {
        UIImageView *icon = [[UIImageView alloc] init];
        icon.contentMode = UIViewContentModeScaleAspectFit;
        _icon = icon;
        [self.contentView addSubview:icon];
    }
    return _icon;
}

- (UILabel *)titleLB
{
    if (!_titleLB)
    {
        UILabel *titleLB = [[UILabel alloc] init];
        titleLB.textAlignment = NSTextAlignmentLeft;
        _titleLB = titleLB;
        [self.contentView addSubview:titleLB];
    }
    return _titleLB;
}

- (UIView *)sepratorLineView
{
    if (!_sepratorLineView)
    {
        UIView *sepratorLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentView.height-0.5, self.contentView.width, .5f)];
        _sepratorLineView = sepratorLine;
        [self.contentView addSubview:sepratorLine];
    }
    
    return _sepratorLineView;
}

#pragma mark - 👀 Setter Method 👀 💤

- (void)setIsShowSeparator:(BOOL)isShowSeparator
{
    _isShowSeparator = isShowSeparator;
    
    self.sepratorLineView.hidden = !isShowSeparator;
}

- (void)setLeftInsetsX:(CGFloat)leftInsetsX
{
    _leftInsetsX = leftInsetsX;
    
    [self setNeedsLayout];
}

- (void)setIconAndTitleMargin:(CGFloat)iconAndTitleMargin
{
    _iconAndTitleMargin = iconAndTitleMargin;
    
    [self setNeedsLayout];
}

- (void)setModel:(XCDropdownModel *)model
{
    _model = model;
    
    self.icon.image     = [UIImage imageNamed:model.imageName];
    self.titleLB.text   = model.title;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.icon.x        = self.leftInsetsX;
    self.icon.size     = K_ICON_SIZE;
    self.icon.centerY  = self.contentView.height * 0.5;
    
    self.titleLB.x       = CGRectGetMaxX(self.icon.frame) + self.iconAndTitleMargin;
    self.titleLB.centerY = self.icon.centerY;
    [self.titleLB sizeToFit];
}

@end


/* 🐖 ***************************** 🐖 华丽的分隔线 🐖 *****************************  🐖 */


@interface XCDropdownMenu () <UITableViewDataSource, UITableViewDelegate>

/** 👀 蒙板视图 👀 */
@property (weak, nonatomic) UIControl *maskView;
/** 👀 数据源 👀 */
@property (strong, nonatomic) NSArray<XCDropdownModel *> *models;
/** 👀 容器视图 👀 */
@property (weak, nonatomic) UIView *containerView;
/** 👀 内容视图 👀 */
@property (weak, nonatomic) UITableView *contentView;
/** 👀 背景视图 👀 */
@property (strong, nonatomic) UIView *bgView;

/** 👀 配置 👀 */
@property (strong, nonatomic) XCDropdownOptionConfiguration *options;

@end


@implementation XCDropdownMenu
{
    // 箭头的锚点
    CGPoint _anchorPoint;
    
    // 定位位置的偏移量
    CGFloat _offsetY;
    
    // 箭头的高度
    CGFloat kArrowHeight;
    // 箭头的宽度
    CGFloat kArrowWidth;
    // 箭头的位置
    CGFloat kArrowPosition;
}

#pragma mark - 👀 Init Method 👀 💤

- (instancetype)initWithModels:(NSArray<XCDropdownModel *> *)models
                       options:(XCDropdownOptionConfiguration *)options
{
    if (self = [super init])
    {
        // 设置默认参数
        kArrowHeight  = 10;
        kArrowWidth   = 15;
        
        _offsetY      = 2;
        
        self.options  = options ? options : [XCDropdownOptionConfiguration defaultConfiguration];
        self.models   = models;
    
        // 有效个数
        NSInteger visibleCount = MIN(K_MAX_ITEMS_COUNT, models.count);
        
        self.width  = self.options.itemWidth;
        self.height = visibleCount * self.options.itemHeight + 2 * kArrowHeight;
        self.alpha  = 0;
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowOffset  = CGSizeMake(0, 0);
        self.layer.shadowRadius  = 2.0;
        self.backgroundColor     = [UIColor clearColor];
        
        // 设置 子视图
        [self bgView];
        [self containerView];
        [self contentView];
        
        self.containerView.layer.mask = [self drawMaskLayer];
        
        if (self.y < _anchorPoint.y)
        {
            self.containerView.layer.mask.affineTransform = CGAffineTransformMakeRotation(M_PI);
        }
    }

    return self;
}


#pragma mark - 💤 👀 LazyLoad Method 👀

- (UIView *)bgView
{
    if (!_bgView)
    {
        UIView *maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bgView       = maskView;
        _bgView.alpha = 0;
        _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        
        __block typeof(self)weakSelf = self;
        _bgView.tapGestureHandle = ^(UITapGestureRecognizer *tap, UIView *tapView){
            [weakSelf dismiss]; // 消失
        };
    }
    return _bgView;
}

- (UIView *)containerView
{
    if (!_containerView)
    {
        UIView *containerView = [[UIView alloc] initWithFrame:self.bounds];
        _containerView = containerView;
        _containerView.backgroundColor     = self.options.normalMenuBackgroundColor;
        _containerView.layer.cornerRadius  = self.options.menuCornerRadius;
        _containerView.layer.masksToBounds = YES;
        [self addSubview:containerView];
    }
    return _containerView;
}

- (UITableView *)contentView
{
    if (!_contentView)
    {
        UITableView *contentView = [[UITableView alloc] initWithFrame:self.containerView.bounds style:UITableViewStylePlain];
        _contentView = contentView;
        _contentView.dataSource = self;
        _contentView.delegate   = self;
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.bounces         = (self.models.count > K_MAX_ITEMS_COUNT);
        _contentView.tableFooterView = [UIView new];
        _contentView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _contentView.height -= (2 * kArrowHeight);
        _contentView.centerY    = self.containerView.centerY;
        _contentView.rowHeight  = self.options.itemHeight;
        
        [self.containerView addSubview:_contentView];
    }
    return _contentView;
}

#pragma mark - 🎬 👀 Action Method 👀

/**
    消失
 */
- (void)dismiss
{
    [UIView animateWithDuration: 0.25 animations:^{
        
        self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
        self.alpha = 0;
        self.bgView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        [self.bgView removeFromSuperview];
        
    }];
}

/**
    显示
 */
- (void)show
{
    [K_KEY_WINDOW addSubview:self.bgView];
    [K_KEY_WINDOW addSubview:self];
    XCDropdownMenuCell *cell = [self getLastVisibleCell];
    cell.isShowSeparator = NO;
    self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration: 0.25 animations:^{
        self.layer.affineTransform = CGAffineTransformMakeScale(1.0, 1.0);
        self.alpha = 1;
        self.bgView.alpha = 1;
    }];
}


/**
    在指定位置显示

 */
- (void)showAtPoint:(CGPoint)point
{
    self.containerView.layer.mask = [self getMaskLayerWithPoint:point];
    [self show];
}


/**
    在指定的视图上显示

 */
- (void)showRelyOnView:(UIView *)view
{
    CGRect absoluteRect = [view convertRect:view.bounds toView:K_KEY_WINDOW];
    CGPoint relyPoint = CGPointMake(absoluteRect.origin.x + absoluteRect.size.width / 2, absoluteRect.origin.y + absoluteRect.size.height);
    relyPoint.y += _offsetY;
    self.containerView.layer.mask = [self getMaskLayerWithPoint:relyPoint];
    
    if (self.y < _anchorPoint.y)
    {
        self.y -= absoluteRect.size.height;
    }
    [self show];
}


#pragma mark - 🔒 👀 Privite Method 👀


/**
 获取最后一个 可见的cell

 */
- (XCDropdownMenuCell *)getLastVisibleCell
{
    NSArray<NSIndexPath *> *indexPaths = [_contentView indexPathsForVisibleRows];
    indexPaths = [indexPaths sortedArrayUsingComparator:^NSComparisonResult(NSIndexPath * _Nonnull obj1, NSIndexPath *  _Nonnull obj2) {
        return obj1.row < obj2.row;
    }];
    NSIndexPath *indexPath = indexPaths.firstObject;
    return [self.contentView cellForRowAtIndexPath:indexPath];
}


/**
 根据指定的位置，获取一个 视图形状的 图层
 
 */
- (CAShapeLayer *)getMaskLayerWithPoint:(CGPoint)point
{
    [self setArrowPointingWhere:point];
    CAShapeLayer *layer = [self drawMaskLayer];
    [self determineAnchorPoint];
    if (CGRectGetMaxY(self.frame) > K_SCREEN_HEIGHT)
    {
        kArrowPosition = self.width - kArrowPosition - kArrowWidth;
        layer = [self drawMaskLayer];
        layer.affineTransform = CGAffineTransformMakeRotation(M_PI);
        self.y = _anchorPoint.y - self.height;
    }
    return layer;
}


/**
 设置 箭头的位置

 */
- (void)setArrowPointingWhere:(CGPoint)anchorPoint
{
    _anchorPoint = anchorPoint;
    
    self.x = anchorPoint.x - self.width * 0.5;
    self.y = anchorPoint.y;
    
    CGFloat maxX = CGRectGetMaxX(self.frame);
    CGFloat minX = CGRectGetMinX(self.frame);
    
    if (maxX > K_SCREEN_WIDTH - 10)
    {
        self.x = K_SCREEN_WIDTH - 10 - self.width;
    }
    else if (minX < 10)
    {
        self.x = 10;
    }
    
    maxX = CGRectGetMaxX(self.frame);
    minX = CGRectGetMinX(self.frame);
    
    if ((anchorPoint.x <= maxX - self.options.menuCornerRadius) && (anchorPoint.x >= minX + self.options.menuCornerRadius))
    {
        kArrowPosition = anchorPoint.x - minX - 0.5*kArrowWidth;
    }
    else if (anchorPoint.x < minX + self.options.menuCornerRadius)
    {
        kArrowPosition = self.options.menuCornerRadius;
    }
    else
    {
        kArrowPosition = self.width - self.options.menuCornerRadius - kArrowWidth;
    }
}

/**
 确定 锚点的位置
 */
- (void)determineAnchorPoint
{
    CGPoint aPoint = CGPointMake(0.5, 0.5);
    if (CGRectGetMaxY(self.frame) > K_SCREEN_HEIGHT)
    {
        aPoint = CGPointMake(fabs(kArrowPosition) / self.width, 1);
    }
    else
    {
        aPoint = CGPointMake(fabs(kArrowPosition) / self.width, 0);
    }
    
    [self setAnimationAnchorPoint:aPoint];
}

/**
 根据锚点的位置确定视图的位置

 */
- (void)setAnimationAnchorPoint:(CGPoint)point
{
    CGRect originRect = self.frame;
    self.layer.anchorPoint = point;
    self.frame = originRect;
}


/**
 画 视图的外形

 */
- (CAShapeLayer *)drawMaskLayer
{
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.containerView.bounds;
    
    CGPoint topRightArcCenter = CGPointMake(self.width-self.options.menuCornerRadius, kArrowHeight+self.options.menuCornerRadius);
    CGPoint topLeftArcCenter = CGPointMake(self.options.menuCornerRadius, kArrowHeight+self.options.menuCornerRadius);
    CGPoint bottomRightArcCenter = CGPointMake(self.width-self.options.menuCornerRadius, self.height - kArrowHeight - self.options.menuCornerRadius);
    CGPoint bottomLeftArcCenter = CGPointMake(self.options.menuCornerRadius, self.height - kArrowHeight - self.options.menuCornerRadius);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(0, kArrowHeight+self.options.menuCornerRadius)];
    [path addLineToPoint: CGPointMake(0, bottomLeftArcCenter.y)];
    [path addArcWithCenter: bottomLeftArcCenter radius: self.options.menuCornerRadius startAngle: -M_PI endAngle: -M_PI-M_PI_2 clockwise: NO];
    [path addLineToPoint: CGPointMake(self.width-self.options.menuCornerRadius, self.height - kArrowHeight)];
    [path addArcWithCenter: bottomRightArcCenter radius: self.options.menuCornerRadius startAngle: -M_PI-M_PI_2 endAngle: -M_PI*2 clockwise: NO];
    [path addLineToPoint: CGPointMake(self.width, kArrowHeight+self.options.menuCornerRadius)];
    [path addArcWithCenter: topRightArcCenter radius: self.options.menuCornerRadius startAngle: 0 endAngle: -M_PI_2 clockwise: NO];
    [path addLineToPoint: CGPointMake(kArrowPosition+kArrowWidth, kArrowHeight)];
    [path addLineToPoint: CGPointMake(kArrowPosition+0.5*kArrowWidth, 0)];
    [path addLineToPoint: CGPointMake(kArrowPosition, kArrowHeight)];
    [path addLineToPoint: CGPointMake(self.options.menuCornerRadius, kArrowHeight)];
    [path addArcWithCenter: topLeftArcCenter radius: self.options.menuCornerRadius startAngle: -M_PI_2 endAngle: -M_PI clockwise: NO];
    [path closePath];
    
    maskLayer.path = path.CGPath;
    
    return maskLayer;
}


#pragma mark - 📕 👀 UITableViewDataSource 👀

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    XCDropdownMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell)
    {
        cell = [[XCDropdownMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    UIView *selectedView = [[UIView alloc] initWithFrame:cell.contentView.bounds];
    selectedView.backgroundColor = self.options.selectedMenuBackgroundColor;
    cell.selectedBackgroundView  = selectedView;
    
    cell.sepratorLineView.backgroundColor = self.options.seperatorLineColor;
    cell.iconAndTitleMargin = self.options.iconToTitleSpacing;
    cell.leftInsetsX        = self.options.leftInsetsX;
    
    cell.titleLB.textColor = self.options.titleColor;
    cell.titleLB.font      = [UIFont systemFontOfSize:self.options.titleFontSize];
    
    if (self.models.count > indexPath.row)
    {
        cell.model = self.models[indexPath.row];
    }
    
    return cell;
}

#pragma mark - 💉 👀 UITableViewDelegate 👀

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self dismiss];
    
    if (self.models.count > indexPath.row)
    {
        XCDropdownModel *model = self.models[indexPath.row];
        
        if (model.didClickHandle)
        {
            model.didClickHandle();
        }
    }
}

#pragma mark - 💉 👀 UIScrollViewDelegate 👀

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    XCDropdownMenuCell *cell = [self getLastVisibleCell];
    cell.isShowSeparator = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    XCDropdownMenuCell *cell = [self getLastVisibleCell];
    cell.isShowSeparator = NO;
}


#pragma mark - 🔓 👀 Public Method 👀

/**
 显示一个下拉菜单的视图
 
 @param view        需要显示的容器视图
 @param models      数据源
 @param options     配置
 */
+ (void)showInView:(UIView *)view
            models:(NSArray<XCDropdownModel *> *)models
           options:(XCDropdownOptionConfiguration *)options
{
    XCDropdownMenu *menu = [[XCDropdownMenu alloc] initWithModels:models options:options];
    
    [menu showRelyOnView:view];
}


/**
 在指定位置弹出视图
 
 @param point       指定位置
 @param models      数据源
 @param options     配置
 */
+ (void)showAtPoint:(CGPoint)point
             models:(NSArray<XCDropdownModel *> *)models
            options:(XCDropdownOptionConfiguration *)options
{
    XCDropdownMenu *menu = [[XCDropdownMenu alloc] initWithModels:models options:options];
    
    [menu showAtPoint:point];
}

@end

