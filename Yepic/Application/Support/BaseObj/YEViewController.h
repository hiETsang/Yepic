//
//  YEViewController.h
//  Yepic
//
//  Created by CheckRan on 2016/10/25.
//  Copyright © 2016年 Canoe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YECommonDefine.h"

@interface YEViewController : UIViewController

@property (nonatomic ,strong) UIButton *leftButton;

@property (nonatomic ,strong) UIButton *rightButton;

@property (nonatomic ,strong) UILabel *titleLabel;

- (void)backButtonClick;

@end
