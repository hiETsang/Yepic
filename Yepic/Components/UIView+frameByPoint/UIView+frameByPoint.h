//
//  UIView+frameByPoint.h
//  pican微博
//
//  Created by apple on 14-6-6.
//  Copyright (c) 2014年 pican. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (frameByPoint)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;


/**
 设置几个角为圆角

 @param cornerRadius 大小
 @param rectCorner   角的位置
 */
- (void)jx_setCornerRadius:(CGFloat)cornerRadius roundingCorners:(UIRectCorner)rectCorner;

@end
