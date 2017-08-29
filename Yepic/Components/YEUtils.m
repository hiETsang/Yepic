//
//  YEUtils.m
//  Yepic
//
//  Created by CheckRan on 2016/10/25.
//  Copyright © 2016年 Canoe. All rights reserved.
//

#import "YEUtils.h"

@implementation YEUtils


#pragma mark - 图片处理
+ (NSArray <UIImage *>*)cropImgWithImage:(UIImage *)image
{
    NSMutableArray * sudokuImageArray = [NSMutableArray array];
    
    CGSize originSize = image.size;
    CGSize cropSize = CGSizeMake(originSize.width / 3.0 , originSize.height / 3.0);
    
    CGFloat x = 0,
    y = 0,
    width = cropSize.width,
    height = cropSize.height;
    
    for (NSInteger i = 0 ; i < 9; i++ ) {
        CGRect rect = CGRectMake(x, y, width, height);
        CGImageRef imgRef = CGImageCreateWithImageInRect(image.CGImage, rect);
        CGFloat deviceScale = [UIScreen mainScreen].scale;
        
        UIGraphicsBeginImageContextWithOptions(rect.size, 0, deviceScale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(context, 0, rect.size.height);
        CGContextScaleCTM(context, 1, -1);
        CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), imgRef);
        UIImage * newImg = UIGraphicsGetImageFromCurrentImageContext();
        CGImageRelease(imgRef);
        UIGraphicsEndImageContext();
        [sudokuImageArray addObject:newImg];
        
        i % 3 == 2 ? (x = 0 , y += height) : (x += width);
    }
    return sudokuImageArray;
}

// 1.把多张绘制成一张图片 9 张
+ (UIImage *)drawImages:(NSArray <UIImage *>*)imageArray {
    NSAssert(imageArray.count, @"imageArray count must > 0");
    // 1.1.图片的宽度 , 高度
    UIImage * firstImage = imageArray.firstObject;
    CGFloat width = firstImage.size.width,
    height = firstImage.size.height;
    
    // 1.4.开始绘制图片的大小
    UIGraphicsBeginImageContext(CGSizeMake(width * 3 + 5 + 5, height * 3 + 5 + 5));
    
    // 1.6.遍历图片的数组
    CGFloat x = 0,
    y = 0;
    for (NSInteger i = 0 ; i < imageArray.count; i++ ) {
        UIImage * image = imageArray[i];
        [image drawAtPoint:CGPointMake(x, y)];
        i % 3 == 2 ? (x = 0 , y += height + 5) : (x += width + 5);
    }
    
    // 1.7.获取已经绘制好的图片
    UIImage * drawImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 1.8.结束绘制图片
    UIGraphicsEndImageContext();
    
    // 1.9.返回已经绘制的图片
    return drawImage;
}

/** UIView转成Image */
+ (UIImage*) imageWithUIView:(UIView*) view
{
    CGSize size = view.bounds.size;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 5);
    CGContextRef ref = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ref];
    UIImage*tImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tImage;
    
}

@end
