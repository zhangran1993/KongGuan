//
//  KG_HistoryTaskCell.m
//  Frame
//
//  Created by zhangran on 2020/5/11.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_RunLingBeiJianSearchCell.h"

#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@interface KG_RunLingBeiJianSearchCell () {
    
    
}

@property (nonatomic ,strong) UIView    *centerView;

@property (nonatomic ,strong) UILabel   *titleLabel;

@property (nonatomic ,strong) UILabel   *detailLabel;

@end

@implementation KG_RunLingBeiJianSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    if([super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.contentView.backgroundColor = self.backgroundColor;
        
        
        [self createUI];
    }
    
    return self;
}


- (void)createUI{
    self.centerView = [[UIView alloc]init];
    self.centerView.layer.cornerRadius = 10;
    self.centerView.layer.masksToBounds = YES;
    self.centerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.centerView];
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.top.equalTo(self.mas_top).offset(5);
        make.right.equalTo(self.mas_right).offset(-16);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
    }];
  
    self.titleLabel = [[UILabel alloc]init];
    [self.centerView addSubview:self.titleLabel];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.font = [UIFont my_font:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.numberOfLines = 2;
    [self.titleLabel sizeToFit];
    self.titleLabel.text = @"雷达机房";
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView.mas_left).offset(15);
        make.right.equalTo(self.centerView.mas_right).offset(-15);
        make.top.equalTo(self.centerView.mas_top).offset(13);
        make.height.equalTo(@20);
    }];

    
    self.detailLabel = [[UILabel alloc]init];
    [self.centerView addSubview:self.detailLabel];
    self.detailLabel.text = @"秋季换季时将此备上机测试，测量发射机峰值";
    self.detailLabel.font = [UIFont systemFontOfSize:12];
    self.detailLabel.font = [UIFont my_font:12];
    self.detailLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.detailLabel.textAlignment = NSTextAlignmentLeft;
    self.detailLabel.numberOfLines = 2;
    [self.detailLabel sizeToFit];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView.mas_left).offset(15);
        make.right.equalTo(self.centerView.mas_right).offset(-15);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
       
    }];
    
}


- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@-%@",safeString(dataDic[@"equipmentName"]),safeString(dataDic[@"name"])] ;
    
    self.detailLabel.text = safeString(dataDic[@"description"]);
    
    
}
@end
