//
//  YECommonDefine.h
//  Yepic
//
//  Created by CheckRan on 2016/10/25.
//  Copyright © 2016年 Canoe. All rights reserved.
//

#ifndef YECommonDefine_h
#define YECommonDefine_h

//release 时去掉log
#ifdef DEBUG
#   define NSLog(format, ...) do {                                                  \
fprintf(stderr, "<%s : %d> %s\n",                                           \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__LINE__, __func__);                                                        \
(NSLog)((format), ##__VA_ARGS__);                                           \
fprintf(stderr, "\n");                                                      \
} while (0)
#else
#define NSLog(...){}
#endif

#define JX_DEPRECATED __attribute__((deprecated))

//异步 主线程
#define safe_async_main(block)\
if ([NSThread isMainThread]) {\
block();\
}\
else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


// rgb颜色转换（16进制->10进制）
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1)
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//按比例适配屏幕
#define FIT(a) (a/375.0 * SCREEN_WIDTH)

#endif /* YECommonDefine_h */
