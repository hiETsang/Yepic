//
//  YEMainViewController.m
//  Yepic
//
//  Created by canoe on 2017/3/16.
//  Copyright © 2017年 Canoe. All rights reserved.
//

#import "YEMainViewController.h"
#import "YENavigationController.h"
#import "YEUploadQiNiuViewController.h"
#import "YERegisterViewController.h"
#import "YMSPhotoPickerViewController.h"
#import "YepicConstants.h"
#import "JDStatusBarNotification.h"
#import "UINavigationController+WXSTransition.h"

@interface YEMainViewController ()<YMSPhotoPickerViewControllerDelegate>

@property(nonatomic, strong) YMSPhotoPickerViewController *pickVc;

@end

@implementation YEMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBA(0, 0, 0, 0.8);
    
    [self configUI];
    
    YMSPhotoPickerViewController *pickerViewController = [[YMSPhotoPickerViewController alloc] init];
    pickerViewController.delegate = self;
    UIColor *customColor = [UIColor colorWithRed:52.0/255.0 green:57.0/255.0 blue:60.0/255.0 alpha:1.0];
    pickerViewController.numberOfPhotoToSelect = 0;
    pickerViewController.theme.titleLabelTextColor = [UIColor whiteColor];
    pickerViewController.theme.navigationBarBackgroundColor = customColor;
    pickerViewController.theme.tintColor = [UIColor whiteColor];
    pickerViewController.theme.orderTintColor = customColor;
    pickerViewController.theme.orderLabelTextColor = [UIColor whiteColor];
    pickerViewController.theme.cameraVeilColor = customColor;
    pickerViewController.theme.cameraIconColor = [UIColor whiteColor];
    pickerViewController.theme.statusBarStyle = UIStatusBarStyleLightContent;
    self.pickVc = pickerViewController;
}

-(void)configUI
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    [self.view addSubview:imageView];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UIView *coverView = [[UIView alloc] init];
    [self.view addSubview:coverView];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0.55;
    
    UIButton *configButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:configButton];
    configButton.clipsToBounds = YES;
    configButton.layer.cornerRadius = FIT(50)/2.0;
    [configButton setBackgroundImage:[UIImage imageNamed:@"category"] forState:UIControlStateNormal];
    [configButton addTarget:self action:@selector(configButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:addButton];
    addButton.clipsToBounds = YES;
    addButton.layer.cornerRadius = FIT(80)/2.0;
    [addButton setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(choosePhoto:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *tip = [[UILabel alloc] init];
    [self.view addSubview:tip];
    tip.textColor = [UIColor whiteColor];
    tip.font = [UIFont fontWithName:@"PingFangSC-Light" size:23.0];
    tip.textAlignment = NSTextAlignmentCenter;
    tip.numberOfLines = 0;
    tip.text = @"轻点按钮上传图片";
    
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [coverView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [configButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(FIT(28));
        make.top.equalTo(self.view).offset(FIT(48));
        make.size.equalTo(CGSizeMake(FIT(50), FIT(50)));
    }];
    
    [addButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-FIT(80/2.0));
        make.size.equalTo(CGSizeMake(FIT(80), FIT(80)));
    }];
    
    [tip makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addButton.bottom).offset(FIT(10));
        make.centerX.equalTo(self.view);
        make.width.equalTo(FIT(250));
    }];
}

-(void)configButtonClick:(UIButton *)button
{
    YERegisterViewController *vc = [[YERegisterViewController alloc] init];
    YENavigationController *nav = [[YENavigationController alloc] initWithRootViewController:vc];
    [self wxs_presentViewController:nav makeTransition:^(WXSTransitionProperty *transition) {
        transition.animationType =  WXSTransitionAnimationTypeSpreadFromTop;
        transition.animationTime = 0.3;
        transition.backGestureEnable = NO;
    }];
}

- (void)choosePhoto:(UIButton *)button
{
    if ([self judgeHasUserInfo]) {
        
        YENavigationController *nav = [[YENavigationController alloc] initWithRootViewController:self.pickVc];
        [self wxs_presentViewController:nav makeTransition:^(WXSTransitionProperty *transition) {
            transition.animationType =  WXSTransitionAnimationTypePointSpreadPresent;
            transition.animationTime = 0.4;
            transition.backGestureEnable = NO;
            transition.startView = button;
        }];
    }else
    {
        JDStatusBarView *bar = [JDStatusBarNotification showWithStatus:@"请先配置完成" dismissAfter:1.5 styleName:JDStatusBarStyleDefault];
        bar.textLabel.textColor = RGB(62, 62, 62);
        bar.backgroundColor = RGB(239, 237, 237);
        YERegisterViewController *vc = [[YERegisterViewController alloc] init];
        YENavigationController *nav = [[YENavigationController alloc] initWithRootViewController:vc];
        [self wxs_presentViewController:nav makeTransition:^(WXSTransitionProperty *transition) {
            transition.animationType =  WXSTransitionAnimationTypePointSpreadPresent;
            transition.animationTime = 0.4;
            transition.backGestureEnable = NO;
            transition.startView = button;
        }];
    }
}

-(BOOL)judgeHasUserInfo
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:kAccessKey] length] >0 &&
        [[[NSUserDefaults standardUserDefaults] objectForKey:kSecretKey] length] >0 &&
        [[[NSUserDefaults standardUserDefaults] objectForKey:kScopeName] length] >0 &&
        [[[NSUserDefaults standardUserDefaults] objectForKey:kUrlName] length] >0)
    {
        return YES;
    }else
    {
        return NO;
    }
}



#pragma mark - YMSPhotoPickerViewControllerDelegate
- (void)photoPickerViewControllerDidReceivePhotoAlbumAccessDenied:(YMSPhotoPickerViewController *)picker
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Allow photo album access?", nil) message:NSLocalizedString(@"Need your permission to access photo albumbs", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Settings", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    [alertController addAction:dismissAction];
    [alertController addAction:settingsAction];
    
    [picker presentViewController:alertController animated:YES completion:nil];
}

- (void)photoPickerViewControllerDidReceiveCameraAccessDenied:(YMSPhotoPickerViewController *)picker
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Allow camera access?", nil) message:NSLocalizedString(@"Need your permission to take a photo", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Settings", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    [alertController addAction:dismissAction];
    [alertController addAction:settingsAction];
    
    // The access denied of camera is always happened on picker, present alert on it to follow the view hierarchy
    [picker presentViewController:alertController animated:YES completion:nil];
}

- (void)photoPickerViewController:(YMSPhotoPickerViewController *)picker didFinishPickingImages:(NSArray *)photoAssets
{
    //跳转操作
    YEUploadQiNiuViewController *qiniu = [[YEUploadQiNiuViewController alloc] init];
    qiniu.imageArray = photoAssets;
    [picker.navigationController pushViewController:qiniu animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
