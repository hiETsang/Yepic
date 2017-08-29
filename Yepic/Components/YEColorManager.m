//
//  YEColorManager.m
//  Yepic
//
//  Created by 肖坚伟 on 2016/10/30.
//  Copyright © 2016年 Canoe. All rights reserved.
//

#import "YEColorManager.h"
#import "YECommonDefine.h"

@implementation YEColorManager

//背景颜色
+ (UIColor *)backgroundClolor
{
    return UIColorFromRGB(0xFCFCFC);
}
//浅色字颜色
+ (UIColor *)lightTextColor
{
    return UIColorFromRGB(0x9C9C9C);
}
//深色字颜色
+ (UIColor *)darkTextColor
{
    return UIColorFromRGB(0x585858);
}
//按钮颜色
+ (UIColor *)buttonTintColor
{
    return UIColorFromRGB(0x646464);
}
//随机颜色
+ (UIColor *)randomColor
{
    NSArray * array = @[UIColorFromRGB(0x66CCCC),UIColorFromRGB(0xCCFF66),UIColorFromRGB(0xFF99cc),
                        UIColorFromRGB(0xFF9999),UIColorFromRGB(0xFFCC99),UIColorFromRGB(0xFF6666),
                        UIColorFromRGB(0xFFFF66),UIColorFromRGB(0xFF9900),UIColorFromRGB(0xCCFF00),
                        UIColorFromRGB(0xCC3399),UIColorFromRGB(0x666699),UIColorFromRGB(0xFF6600),
                        UIColorFromRGB(0xFFFF99),UIColorFromRGB(0x33CC99),UIColorFromRGB(0xFFFFCC)];
    return array[arc4random() % 15];
}

@end
