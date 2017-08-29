//
//  YEUploadQiNiuTableViewCell.m
//  Yepic
//
//  Created by canoe on 2017/3/16.
//  Copyright © 2017年 Canoe. All rights reserved.
//

#import "YEUploadQiNiuTableViewCell.h"
#import "YEShowImageModel.h"
#import "YepicConstants.h"

@implementation YEUploadQiNiuTableViewCell

-(void)setModel:(YEShowImageModel *)model
{
    _model = model;
    self.picView.image = model.image;
    self.stateLabel.textColor = RGB(55, 55, 55);
    self.myCopyButton.alpha = 0.0;
    self.linkButton.alpha = 0.0;
    self.urlLabel.alpha = 0.0;
    self.progressView.progress = model.progress;
    if (model.isCopyed == NO) {
        [self.myCopyButton setImage:[UIImage imageNamed:@"copy"] forState:UIControlStateNormal];
    }else
    {
        [self.myCopyButton setImage:[UIImage imageNamed:@"copy-selected"] forState:UIControlStateNormal];
    }
    
    switch (model.state) {
        case YEUploadStateWaiting:
        {
            self.progressView.progress = 0.0;
            self.stateLabel.text = @"等待上传";
        }
            break;
        case YEUploadStateUploading:
        {
            self.stateLabel.text = @"上传中...";
        }
            break;
        case YEUploadStateSuccess:
        {
            self.progressView.progress = 0.0;
            self.stateLabel.text = @"上传成功";
            self.urlLabel.text = [NSString stringWithFormat:@"![](%@/%@)",[[NSUserDefaults standardUserDefaults] objectForKey:kUrlName],model.imageKey];
            [self.stateLabel remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.picView.right).offset(FIT(20));
                make.top.equalTo(self.picView).offset(3);
                make.right.equalTo(self.backView).offset(-FIT(50));
            }];
            [self.contentView layoutIfNeeded];
            
            [UIView animateWithDuration:0.8 animations:^{
                self.urlLabel.alpha = 1.0;
                self.myCopyButton.alpha = 1.0;
                self.linkButton.alpha = 1.0;
            } completion:^(BOOL finished) {
            }];
        }
            break;
        case YEUploadStateFail:
        {
            self.progressView.progress = 0.0;
            self.stateLabel.text = @"上传失败";
            self.stateLabel.textColor = RGB(224, 62, 65);
        }
            break;
            
        default:
            break;
    }
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}

-(void) createUI
{
    self.backgroundColor = [UIColor clearColor];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(FIT(10), 0, SCREEN_WIDTH - FIT(20), 94)];
    self.backView = backView;
    backView.backgroundColor = [UIColor whiteColor];
    backView.clipsToBounds = YES;
    backView.layer.cornerRadius = 3;
    [self.contentView addSubview:backView];
    
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.progress = 0.0;
    self.progressView.progressTintColor = RGB(21, 126, 251);
    self.progressView.trackTintColor = [UIColor clearColor];
    self.progressView.clipsToBounds = YES;
    self.progressView.layer.cornerRadius = 1;
    self.progressView.frame = CGRectMake(0, 0, SCREEN_WIDTH - FIT(20), 2);
    [backView addSubview:self.progressView];
    
    self.picView = [[UIImageView alloc] init];
    self.picView.userInteractionEnabled = YES;
    self.picView.contentMode = UIViewContentModeScaleAspectFill;
    self.picView.clipsToBounds = YES;
    self.picView.layer.cornerRadius = FIT(45)/2;
    self.picView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.picView.layer.borderWidth = 1.0;
    [backView addSubview:self.picView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picViewTap)];
    [self.picView addGestureRecognizer:tap];
    
    self.stateLabel = [[UILabel alloc] init];
    self.stateLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15.0];
    self.stateLabel.text = @"等待上传";
    [backView addSubview:self.stateLabel];
    self.stateLabel.textColor = RGB(55, 55, 55);
    
    self.urlLabel = [[UILabel alloc] init];
    self.urlLabel.font = [UIFont fontWithName:@"AvenirNext-Italic" size:12.0];
    [backView addSubview:self.urlLabel];
    self.urlLabel.textColor = RGB(124, 124, 124);
    self.urlLabel.numberOfLines = 1;
    self.urlLabel.alpha = 0.0;
    
    self.myCopyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:self.myCopyButton];
    [self.myCopyButton setImage:[UIImage imageNamed:@"copy"] forState:UIControlStateNormal];
    self.myCopyButton.alpha = 0.0;
    [self.myCopyButton addTarget:self action:@selector(copyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.linkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:self.linkButton];
    [self.linkButton setImage:[UIImage imageNamed:@"link"] forState:UIControlStateNormal];
    self.linkButton.alpha = 0.0;
    [self.linkButton addTarget:self action:@selector(linkButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.picView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(FIT(18));
        make.centerY.equalTo(backView);
        make.size.equalTo(CGSizeMake(FIT(45), FIT(45)));
    }];
    
    [self.stateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.picView.right).offset(FIT(20));
        make.centerY.equalTo(backView);
        make.right.equalTo(backView).offset(-FIT(10));
    }];
    
    [self.urlLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.stateLabel).offset(0);
        make.top.equalTo(self.stateLabel.bottom).offset(3);
        make.right.equalTo(self.stateLabel).offset(0);
    }];
    
    [self.linkButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView.right).offset(-8);
        make.bottom.equalTo(backView.bottom).offset(0);
        make.size.equalTo(CGSizeMake(30, 25));
    }];
    
    [self.myCopyButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.linkButton.left).offset(0);
        make.bottom.equalTo(backView.bottom).offset(0);
        make.size.equalTo(CGSizeMake(30, 25));
    }];
}

-(void)picViewTap
{
    if (self.didClickPicView) {
        self.didClickPicView(self.picView);
    }
}

-(void)copyButtonClick:(UIButton *)button
{
    if (self.copyButtonClick) {
        self.copyButtonClick(self.urlLabel.text,button);
    }
}

-(void)linkButtonClick:(UIButton *)button
{
    if (self.linkButtonClick) {
        self.linkButtonClick( [NSString stringWithFormat:@"%@/%@",[[NSUserDefaults standardUserDefaults] objectForKey:kUrlName],self.model.imageKey]);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
