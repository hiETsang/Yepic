//
//  YEUploadQiNiuViewController.m
//  Yepic
//
//  Created by 肖坚伟 on 2017/1/19.
//  Copyright © 2017年 Canoe. All rights reserved.
//

#import "YEUploadQiNiuViewController.h"
#import "QiniuUploader.h"
#import "YEUploadQiNiuTableViewCell.h"
#import "JJPhotoManeger.h"
#import <Photos/Photos.h>
#import "JMAnimationButton.h"
#import "JDStatusBarNotification.h"
#import "YepicConstants.h"
#import "YEShowImageModel.h"
#import <SafariServices/SafariServices.h>

@interface YEUploadQiNiuViewController ()<UITableViewDelegate,UITableViewDataSource,JMAnimationButtonDelegate,SFSafariViewControllerDelegate>
{
    QiniuUploader *uploader;
}
@property(nonatomic, strong) UITableView *tableView;
//@property(nonatomic, strong) UIProgressView *progressView;
@property(nonatomic, strong) JMAnimationButton *button;
@property (nonatomic ,strong) PHImageRequestOptions *options;
@property (nonatomic ,strong) NSMutableArray *showArray;

@property(nonatomic, assign) NSInteger uploadIndex;

@end

@implementation YEUploadQiNiuViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"七牛上传";
    self.uploadIndex = 0;
    [self leftButton];
    self.showArray = [NSMutableArray array];
    for (NSInteger i = 0; i < self.imageArray.count; i++) {
        YEShowImageModel *model = [[YEShowImageModel alloc] init];
        model.state = YEUploadStateWaiting;
        model.image = [[UIImage alloc] init];
        [self.showArray addObject:model];
    }
    
    //register qiniu
    [QiniuToken registerWithScope:[[NSUserDefaults standardUserDefaults] objectForKey:kScopeName] SecretKey:[[NSUserDefaults standardUserDefaults] objectForKey:kSecretKey] Accesskey:[[NSUserDefaults standardUserDefaults] objectForKey:kAccessKey]];
    
    //PHAsset 转图片
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.version = PHImageRequestOptionsVersionCurrent;
    options.networkAccessAllowed = YES;
    options.synchronous = NO;
    self.options = options;
    
    for (NSInteger i = 0; i< self.imageArray.count;i++) {
        PHAsset *asset = self.imageArray[i];
        
        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            if (imageData) {
                YEShowImageModel *model = [[YEShowImageModel alloc] init];
                model.state = YEUploadStateWaiting;
                model.image = [UIImage imageWithData:imageData];
                model.data = imageData;
                [self.showArray replaceObjectAtIndex:i withObject:model];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }
        }];
    }
    
    [self createUI];
}

- (void)createUI
{
    self.view.backgroundColor = RGB(239, 237, 237);
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    
    UITableView *tableView = [[UITableView alloc] init];
    self.tableView = tableView;
    tableView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:tableView];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
    
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.bottom.equalTo(self.view.bottom).offset(-70);
        make.top.equalTo(self.view).offset(64);
    }];
    
    JMAnimationButton *button = [JMAnimationButton buttonWithFrame:CGRectMake(100, SCREEN_HEIGHT - 55, self.view.bounds.size.width - 2 * 100, 40)];
    self.button = button;
    button.delegate = self;
    button.backgroundColor = RGB(37, 140, 247);
    [button setTitle:@"开始上传" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16.0];
    [self.view addSubview:button];
    
    [button addTarget:self action:@selector(upload:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - DataUplod
- (void)upload:(JMAnimationButton *)button
{
    if (button) {
        [button startAnimation];
    }
    
    for (NSInteger i = self.uploadIndex; i < self.imageArray.count; i++) {
        YEShowImageModel *model = self.showArray[i];
        if (model.state == YEUploadStateFail || model.state == YEUploadStateWaiting) {
            self.uploadIndex = i;
            [self uploadImageData:model.data];
            break;
        }
    }
}

-(void)uploadImageData:(NSData *)data
{
    __weak __typeof(self)weakSelf = self;
    uploader = [[QiniuUploader alloc] init];
    
    QiniuFile *file = [[QiniuFile alloc] initWithFileData:data];
    [uploader addFile:file];
    
    //开始上传
    [uploader startUploadWithAccessToken:[[QiniuToken sharedQiniuToken] uploadToken]];
    YEShowImageModel *model = self.showArray[self.uploadIndex];
    model.state = YEUploadStateUploading;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.uploadIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    
    //上传进度
    [uploader setUploadOneFileProgress:^(NSInteger index, NSProgress *process){
        YEShowImageModel *model = weakSelf.showArray[weakSelf.uploadIndex];
        model.progress = process.fractionCompleted;
        YEUploadQiNiuTableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.uploadIndex inSection:0]];
        [cell.progressView setProgress:process.fractionCompleted animated:YES];
    }];
    
    //所有文件传输完成
    [uploader setUploadAllFilesComplete:^(void){
        //1、判断是否全部上传完成
        BOOL isAllUploaded = YES;
        for (YEShowImageModel *model in weakSelf.showArray) {
            if (model.state == YEUploadStateWaiting ||model.state == YEUploadStateUploading) {
                isAllUploaded = NO;
                return ;
            }
        }
        
        //2、判断是否全部上传成功
        BOOL isAllSuccess = YES;
        for (YEShowImageModel *model in weakSelf.showArray) {
            if (model.state != YEUploadStateSuccess) {
                isAllSuccess = NO;
                break;
            }
        }
        if (isAllSuccess == YES) {
            //全部上传成功
            weakSelf.uploadIndex = 0;
            [weakSelf.button setTitle:nil forState:UIControlStateNormal];
            [weakSelf.button setImage:[UIImage imageNamed:@"ok"] forState:UIControlStateNormal];
            [weakSelf.button stopAnimation];
            weakSelf.button.userInteractionEnabled = NO;
            if (weakSelf.showArray.count == 1) {
                YEUploadQiNiuTableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                cell.model.isCopyed = YES;
                [weakSelf copyStr:cell.urlLabel.text withCopyButton:cell.myCopyButton];
            }
        }else
        {
            //有上传失败的图片
            weakSelf.uploadIndex = 0;
            [weakSelf.button setTitle:@"失败图片上传" forState:UIControlStateNormal];
            [weakSelf.button stopAnimation];
        }
    }];
    
    
    //上传单个文件成功
    [uploader setUploadOneFileSucceeded:^(NSInteger index, NSString *key, NSDictionary *info){
        YEShowImageModel *model = weakSelf.showArray[weakSelf.uploadIndex];
        model.state = YEUploadStateSuccess;
        model.imageKey = key;
        
        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.uploadIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        
        weakSelf.uploadIndex++;
        if (weakSelf.uploadIndex < weakSelf.showArray.count) {
            [weakSelf upload:nil];
        }
    }];
    
    //上传单个文件失败
    [uploader setUploadOneFileFailed:^(NSInteger index, NSError * _Nullable error){
        YEShowImageModel *model = weakSelf.showArray[weakSelf.uploadIndex];
        model.state = YEUploadStateFail;
        
        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.uploadIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        
        weakSelf.uploadIndex++;
        if (weakSelf.uploadIndex < weakSelf.showArray.count) {
            [weakSelf upload:nil];
        }
    }];
    
}


#pragma mark - collectionView dataSource and delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.imageArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak __typeof(self)weakSelf = self;
    static NSString *identify = @"cell";
    YEUploadQiNiuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[YEUploadQiNiuTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
    }
    
    YEShowImageModel *model = self.showArray[indexPath.row];
    cell.model = model;
    
    [cell setDidClickPicView:^(UIImageView *picView) {
        [[JJPhotoManeger maneger] showLocalPhotoViewer:@[picView] selecView:picView];
    }];
    
    [cell setCopyButtonClick:^(NSString *str,UIButton *button){
        [weakSelf copyStr:str withCopyButton:button];
        model.isCopyed = YES;
    }];
    
    [cell setLinkButtonClick:^(NSString *link){
        SFSafariViewController *safari = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:link]];
        safari.preferredControlTintColor = RGB(62, 62, 62);
        [self.navigationController presentViewController:safari animated:YES completion:nil];
    }];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)copyStr:(NSString *)str withCopyButton:(UIButton *)button
{
    if (str.length > 0) {
        [button setImage:[UIImage imageNamed:@"copy-selected"] forState:UIControlStateNormal];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = str;
        JDStatusBarView *bar = [JDStatusBarNotification showWithStatus:@"链接复制成功" dismissAfter:1.5 styleName:JDStatusBarStyleDefault];
        bar.textLabel.textColor = RGB(62, 62, 62);
        bar.backgroundColor = RGB(239, 237, 237);
    }
}



-(void)backButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
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
