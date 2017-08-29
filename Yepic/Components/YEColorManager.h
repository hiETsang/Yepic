//
//  YEColorManager.h
//  Yepic
//
//  Created by 肖坚伟 on 2016/10/30.
//  Copyright © 2016年 Canoe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YEColorManager : NSObject
//背景颜色
+ (UIColor *)backgroundClolor;
//浅色字颜色
+ (UIColor *)lightTextColor;
//深色字颜色
+ (UIColor *)darkTextColor;
//按钮颜色
+ (UIColor *)buttonTintColor;
//随机颜色
+ (UIColor *)randomColor;

@end
