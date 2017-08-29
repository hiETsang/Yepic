//
//  YEShowImageModel.h
//  Yepic
//
//  Created by canoe on 2017/3/24.
//  Copyright © 2017年 Canoe. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, YEUploadState) {
    YEUploadStateWaiting,
    YEUploadStateUploading,
    YEUploadStateSuccess,
    YEUploadStateFail,
};

@interface YEShowImageModel : NSObject
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, assign) YEUploadState state;
@property(nonatomic, copy) NSString *imageKey;
@property(nonatomic, strong) NSData *data;
@property(nonatomic, assign) float progress;
@property(nonatomic, assign) BOOL isCopyed;
@end
