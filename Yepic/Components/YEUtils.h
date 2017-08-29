//
//  YEUtils.h
//  Yepic
//
//  Created by CheckRan on 2016/10/25.
//  Copyright © 2016年 Canoe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YEUtils : NSObject

#pragma mark - 图片处理

/**
 把一张图片按等比例分为9张

 @param image 图片

 @return 返回9张图片
 */
+ (NSArray <UIImage *>*)cropImgWithImage:(UIImage *)image;

/**
 把9张图片中间有间隔的合为一张

 @param imageArray 图片数组

 @return 整张图片
 */
+ (UIImage *)drawImages:(NSArray <UIImage *>*)imageArray;


/**
 将View转成Image
 
 @param view View
 
 @return 图片
 */
+ (UIImage*) imageWithUIView:(UIView*) view;

@end
