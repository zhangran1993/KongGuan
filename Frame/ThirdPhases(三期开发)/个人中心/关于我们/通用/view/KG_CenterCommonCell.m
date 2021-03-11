//
//  KG_CenterCommonCell.m
//  Frame
//
//  Created by zhangran on 2020/12/10.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_CenterCommonCell.h"
#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@interface KG_CenterCommonCell (){
    
}

@property (nonatomic ,strong)   UIImageView     *iconImage;


@property (nonatomic ,strong)   UILabel         *titleLabel;


@property (nonatomic ,strong)   UILabel         *detailLabel;


@property (nonatomic ,strong)   UIImageView     *rightImage;

@end

@implementation KG_CenterCommonCell

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
        self.contentView.backgroundColor = self.backgroundColor;
        [self createSubviewsView];
    }
    return self;
}

- (void)createSubviewsView {
    
    self.iconImage = [[UIImageView alloc]init];
    [self addSubview:self.iconImage];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.width.height.equalTo(@14);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
//    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.font = [UIFont my_font:14];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(42);
        make.width.equalTo(@200);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(self.mas_height);
    }];
    
   
    
    self.rightImage = [[UIImageView alloc]init];
    self.rightImage.image = [UIImage imageNamed:@"about_rightImage"];
    [self addSubview:self.rightImage];
    [self.rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-9.5);
        make.width.height.equalTo(@18);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    self.detailLabel = [[UILabel alloc]init];
    [self addSubview:self.detailLabel];
    self.detailLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.detailLabel.font = [UIFont systemFontOfSize:14];
    self.detailLabel.font = [UIFont my_font:14];
    self.detailLabel.textAlignment = NSTextAlignmentRight;
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightImage.mas_left).offset(-5);
        make.width.equalTo(@200);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(self.mas_height);
    }];
    self.detailLabel.hidden = YES;
    
    
}

- (void)setStr:(NSString *)str {
    _str = str;
    self.titleLabel.text = str;
    self.detailLabel.hidden = YES;
    if ([str isEqualToString:@"新消息通知"]) {
        
        self.iconImage.image = [UIImage imageNamed:@"kg_messnoti"];
    }else if ([str isEqualToString:@"字体大小"]) {
        
        self.iconImage.image = [UIImage imageNamed:@"kg_fontsize"];
    }else if ([str isEqualToString:@"清除缓存"]) {
        
        self.detailLabel.hidden = NO;
        CGFloat size = [self folderSizeAtPath:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject] +[self folderSizeAtPath:NSTemporaryDirectory()];
                  //if(size <= 0.00025){wo
                  //   size = 0.0;
                  //}
                  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                  [userDefaults removeObjectForKey:@"station"];
                  
                  NSString *message =@"";
                  if(size > 1){
                      message =[NSString stringWithFormat:@"%.2fM", size];
                  } else if(size == 0){
                      message =[NSString stringWithFormat:@"%dK", 0];
                  }else{
                      message =[NSString stringWithFormat:@"%.2fKB", size * 1024.0];
                  }
                  
        self.detailLabel.text = safeString(message);
        self.iconImage.image = [UIImage imageNamed:@"kg_clearcache"];
    }else if ([str isEqualToString:@"密码修改"]) {
       
        self.iconImage.image = [UIImage imageNamed:@"center_changpass"];
    }
        
}
// 计算目录大小
- (CGFloat)folderSizeAtPath:(NSString *)path{
    // 利用NSFileManager实现对文件的管理
    NSFileManager *manager = [NSFileManager defaultManager];
    CGFloat size = 0;
    if ([manager fileExistsAtPath:path]) {
        // 获取该目录下的文件，计算其大小
        NSArray *childrenFile = [manager subpathsAtPath:path];
        for (NSString *fileName in childrenFile) {
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            size += [manager attributesOfItemAtPath:absolutePath error:nil].fileSize;
        }
        // 将大小转化为M
        return size / 1024.0 / 1024.0;
    }
    return 0;
}
@end
