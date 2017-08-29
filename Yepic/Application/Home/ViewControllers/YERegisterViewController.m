//
//  YERegisterViewController.m
//  Yepic
//
//  Created by canoe on 2017/3/21.
//  Copyright © 2017年 Canoe. All rights reserved.
//

#import "YERegisterViewController.h"
#import "Yepic-Swift.h"
#import "YepicConstants.h"

@interface YERegisterViewController ()<UITextFieldDelegate>

@end

@implementation YERegisterViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

-(void)backButtonClick
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(239, 237, 237);
    [self createUI];
    [self.leftButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
}

-(void) createUI
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    scrollView.backgroundColor = self.view.backgroundColor;
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+1);
    
    [scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIImageView *qiniu = [[UIImageView alloc] init];
    qiniu.image = [UIImage imageNamed:@"qiniu"];
    [scrollView addSubview:qiniu];
    
    [qiniu makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView).offset(100);
        make.centerX.equalTo(self.view);
        make.height.equalTo(40);
    }];
    
    HoshiTextField *accessKey = [[HoshiTextField alloc] init];
    accessKey.delegate = self;
    accessKey.keyboardType = UIKeyboardTypeASCIICapable;
    accessKey.tag = 100;
    [scrollView addSubview:accessKey];
    accessKey.placeholder = @"AccessKey";
    accessKey.borderInactiveColor = [UIColor blackColor];
    accessKey.borderActiveColor = RGB(70, 134, 241);
    accessKey.placeholderColor = RGB(87, 101, 118);
    accessKey.textColor= RGB(87, 101, 118);
    accessKey.font = [UIFont fontWithName:@"Avenir Next" size:20.0];
    accessKey.text = [[NSUserDefaults standardUserDefaults] objectForKey:kAccessKey];
    [accessKey makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(scrollView).offset(180);
        make.height.equalTo(66);
    }];
    
    HoshiTextField *secretKey = [[HoshiTextField alloc] init];
    secretKey.delegate = self;
    secretKey.keyboardType = UIKeyboardTypeASCIICapable;
    secretKey.secureTextEntry = YES;
    secretKey.tag = 101;
    [scrollView addSubview:secretKey];
    secretKey.placeholder = @"SecretKey";
    secretKey.borderInactiveColor = [UIColor blackColor];
    secretKey.borderActiveColor = RGB(231, 69, 60);
    secretKey.placeholderColor = RGB(87, 101, 118);
    secretKey.textColor= RGB(87, 101, 118);
    secretKey.font = [UIFont fontWithName:@"Avenir Next" size:20.0];
    secretKey.text = [[NSUserDefaults standardUserDefaults] objectForKey:kSecretKey];
    [secretKey makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(accessKey).offset(0);
        make.right.equalTo(accessKey).offset(0);
        make.top.equalTo(accessKey.bottom).offset(16);
        make.height.equalTo(66);
    }];
    
    HoshiTextField *scopeName = [[HoshiTextField alloc] init];
    scopeName.keyboardType = UIKeyboardTypeASCIICapable;
    scopeName.delegate = self;
    scopeName.tag = 102;
    [scrollView addSubview:scopeName];
    scopeName.placeholder = @"空间名称";
    scopeName.borderInactiveColor = [UIColor blackColor];
    scopeName.borderActiveColor = RGB(249, 187, 45);
    scopeName.placeholderColor = RGB(87, 101, 118);
    scopeName.textColor= RGB(87, 101, 118);
    scopeName.font = [UIFont fontWithName:@"Avenir Next" size:20.0];
    scopeName.text = [[NSUserDefaults standardUserDefaults] objectForKey:kScopeName];
    [scopeName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(accessKey).offset(0);
        make.right.equalTo(accessKey).offset(0);
        make.top.equalTo(secretKey.bottom).offset(16);
        make.height.equalTo(66);
    }];
    
    HoshiTextField *urlName = [[HoshiTextField alloc] init];
    urlName.keyboardType = UIKeyboardTypeASCIICapable;
    urlName.delegate = self;
    urlName.tag = 103;
    [scrollView addSubview:urlName];
    urlName.placeholder = @"URL前缀";
    urlName.borderInactiveColor = [UIColor blackColor];
    urlName.borderActiveColor = RGB(58, 167, 87);
    urlName.placeholderColor = RGB(87, 101, 118);
    urlName.textColor= RGB(87, 101, 118);
    urlName.font = [UIFont fontWithName:@"Avenir Next" size:20.0];
    urlName.text = [[NSUserDefaults standardUserDefaults] objectForKey:kUrlName];
    [urlName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(accessKey).offset(0);
        make.right.equalTo(accessKey).offset(0);
        make.top.equalTo(scopeName.bottom).offset(16);
        make.height.equalTo(66);
    }];
    
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 100:
        {
            [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:kAccessKey];
        }
            break;
        case 101:
        {
            [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:kSecretKey];
        }
            break;
        case 102:
        {
            [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:kScopeName];
        }
            break;
        case 103:
        {
            [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:kUrlName];
        }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
