//
//  KG_GaoJingFourthCell.m
//  Frame
//
//  Created by zhangran on 2020/5/20.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_GaoJingFourthCell.h"
#import "KG_SelPhotoView.h"
#import "KG_SelVideoView.h"

#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@interface KG_GaoJingFourthCell (){
    
}
@property (nonatomic,strong) KG_SelPhotoView *selPhoneView;
@property (nonatomic,strong) KG_SelVideoView *selVideoView;
@end
@implementation KG_GaoJingFourthCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSubviewsView];
    }
    return self;
}

- (void)createSubviewsView {
    UILabel *titleLabel = [[UILabel alloc]init];
    [self addSubview:titleLabel];
    titleLabel.text = @"资料上传";
    titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    titleLabel.font = [UIFont my_font:16];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.top.equalTo(self.mas_top).offset(13);
        make.width.equalTo(@120);
        make.height.equalTo(@22);
    }];
    
    UIImageView *picImage = [[UIImageView alloc]init];
    [self addSubview:picImage];
    picImage.image = [UIImage imageNamed:@"pic_upload"];
    [picImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.top.equalTo(titleLabel.mas_bottom).offset(17);
        make.width.equalTo(@14);
        make.height.equalTo(@16);
    }];
    UILabel *picLabel = [[UILabel alloc]init];
    [self addSubview:picLabel];
    picLabel.text = @"图片上传";
    picLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    picLabel.textAlignment = NSTextAlignmentLeft;
    picLabel.font = [UIFont systemFontOfSize:14];
    picLabel.font = [UIFont my_font:14];
    [picLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(picImage.mas_right).offset(6);
        make.centerY.equalTo(picImage.mas_centerY);
        make.width.equalTo(@120);
        make.height.equalTo(@20);
    }];
    UIView *lineImage = [[UIView alloc]init];
    [self addSubview:lineImage];
    lineImage.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.right.equalTo(self.mas_right).offset(-14);
        make.top.equalTo(picImage.mas_bottom).offset(105);
        make.height.equalTo(@1);
    }];
       
    self.selPhoneView = [[KG_SelPhotoView alloc]init];
    self.selPhoneView.addMethod = ^{
        if (self.addMethod) {
            self.addMethod();
        }
    };
    self.selPhoneView.zhankaiMethod = ^(NSString * _Nonnull dataDic) {
        if (self.zhankaiMethod) {
            self.zhankaiMethod(dataDic);
        }
    };
    
    self.selPhoneView.closeMethod = ^(NSInteger index) {
        if (self.closeMethod) {
            self.closeMethod(index);
        }
    };
    [self addSubview:self.selPhoneView];
    [self.selPhoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(picLabel.mas_left);
        make.right.equalTo(self.mas_right).offset(-20);
        make.top.equalTo(picLabel.mas_bottom).offset(10);
        make.height.equalTo(@70);
    }];
   
    UIImageView *videoImage = [[UIImageView alloc]init];
    [self addSubview:videoImage];
    videoImage.image = [UIImage imageNamed:@"video_upload"];
    [videoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.top.equalTo(lineImage.mas_bottom).offset(18);
        make.width.equalTo(@14);
        make.height.equalTo(@16);
    }];
    UILabel *videoLabel = [[UILabel alloc]init];
    [self addSubview:videoLabel];
    videoLabel.text = @"视频上传";
    videoLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    videoLabel.textAlignment = NSTextAlignmentLeft;
    videoLabel.font = [UIFont systemFontOfSize:14];
    videoLabel.font = [UIFont my_font:14];
    [videoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(videoImage.mas_right).offset(6);
        make.centerY.equalTo(videoImage.mas_centerY);
        make.width.equalTo(@120);
        make.height.equalTo(@20);
    }];
    
    self.selVideoView = [[KG_SelVideoView alloc]init];
    self.selVideoView.addVideoMethod = ^{
        if (self.addVideoMethod) {
            self.addVideoMethod();
        }
    };
    self.selVideoView.playVideoMethod = ^(NSString * _Nonnull dataDic) {
          if (self.playVideoMethod) {
              self.playVideoMethod(dataDic);
          }
      };
      
    self.selVideoView.closeVideoMethod = ^(NSInteger index) {
        if (self.closeVideoMethod) {
            self.closeVideoMethod(index);
        }
    };
    [self addSubview:self.selVideoView];
    [self.selVideoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(videoLabel.mas_left);
        make.right.equalTo(self.mas_right).offset(-20);
        make.top.equalTo(videoLabel.mas_bottom).offset(10);
        make.height.equalTo(@70);
    }];
}

- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
    self.selPhoneView.dataArray = dataArray;
}
- (void)setVideoArray:(NSMutableArray *)videoArray{
    _videoArray = videoArray;
    self.selVideoView.videoArray = videoArray;
}


@end
