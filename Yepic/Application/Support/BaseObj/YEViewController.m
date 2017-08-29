//
//  YEViewController.m
//  Yepic
//
//  Created by CheckRan on 2016/10/25.
//  Copyright © 2016年 Canoe. All rights reserved.
//

#import "YEViewController.h"

@interface YEViewController ()

@end

@implementation YEViewController

-(UIButton *)leftButton
{
    if (_leftButton == nil) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:_leftButton];
        [_leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        [_leftButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.top).offset(20);
            make.left.equalTo(self.view.left);
            make.width.equalTo(40);
            make.height.equalTo(40);
        }];
    }
    return _leftButton;
}

-(UIButton *)rightButton
{
    if (_rightButton == nil) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:_rightButton];
        
        [_rightButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.top).offset(20);
            make.right.equalTo(self.view.right);
            make.width.equalTo(44);
            make.height.equalTo(44);
        }];
    }
    return _rightButton;
}

-(UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        [self.view addSubview:_titleLabel];
        _titleLabel.textColor = RGB(62, 62, 62);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont fontWithName:@"HiraginoSansGB-W3" size:20.0];
        
        [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(20);
            make.centerX.equalTo(self.view);
            make.height.equalTo(40);
        }];
    }
    return _titleLabel;
}

-(void)setTitle:(NSString *)title
{
    [super setTitle:title];
    self.titleLabel.text = title;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [YEColorManager backgroundClolor];
}

- (void)backButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
