//
//  YEUploadQiNiuTableViewCell.h
//  Yepic
//
//  Created by canoe on 2017/3/16.
//  Copyright © 2017年 Canoe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YEShowImageModel;
@interface YEUploadQiNiuTableViewCell : UITableViewCell

@property(nonatomic, strong) YEShowImageModel *model;

@property(nonatomic, strong) UIView *backView;
@property (nonatomic ,strong)  UIImageView *picView;
@property (nonatomic ,strong) UILabel *stateLabel;
@property (nonatomic ,strong) UILabel *urlLabel;
@property(nonatomic, strong) UIButton *myCopyButton;
@property(nonatomic, strong) UIButton *linkButton;
@property(nonatomic, strong) UIProgressView *progressView;

/** 点击图片 */
@property (nonatomic,copy) void (^didClickPicView)(UIImageView *picView);
/** copy */
@property (nonatomic,copy) void (^copyButtonClick)(NSString *str,UIButton *copyButton);
/** link */
@property (nonatomic,copy) void (^linkButtonClick)(NSString *link);

@end
