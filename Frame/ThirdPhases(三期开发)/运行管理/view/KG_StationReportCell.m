//
//  KG_StationReportCell.m
//  Frame
//
//  Created by zhangran on 2020/5/28.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_StationReportCell.h"

@interface KG_StationReportCell (){
    
    
}

@property (nonatomic,strong) UILabel *titleLabel ;

@property (nonatomic,strong) UIImageView *iconImage;

@property (nonatomic,strong) UILabel *statusLabel;

@end

@implementation KG_StationReportCell

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
    
    self.iconImage = [[UIImageView alloc]init];
    [self addSubview:self.iconImage];
    self.iconImage.layer.cornerRadius =3.f;
    self.iconImage.layer.masksToBounds = YES;
    self.iconImage.backgroundColor = [UIColor colorWithHexString:@"#2B8EFF"];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.centerY.equalTo(self.mas_centerY);
        make.height.width.equalTo(@6);
        
    }];
    
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.text = @"2020.02.02终端本场设备";
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset(8);
        make.width.equalTo(@200);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    self.statusLabel = [[UILabel alloc]init];
    [self addSubview:self.statusLabel];
    self.statusLabel.textColor = [UIColor colorWithHexString:@"#2B8EFF"];
    self.statusLabel.font = [UIFont systemFontOfSize:14];
    self.statusLabel.textAlignment = NSTextAlignmentRight;
    self.statusLabel.text = @"进行中";
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.right.equalTo(self.mas_right).offset(-16);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    self.titleLabel.text = safeString(dataDic[@"taskName"]);
    self.iconImage.backgroundColor = [UIColor colorWithHexString:@"#2B8EFF"];
    self.statusLabel.textColor = [UIColor colorWithHexString:@"#2B8EFF"];
    if ([dataDic[@"status"] isEqualToString:@"0"]) {
        self.statusLabel.text = @"待执行";
    }else if ([dataDic[@"status"] isEqualToString:@"1"]) {
        self.statusLabel.text = @"进行中";
    }else if ([dataDic[@"status"] isEqualToString:@"2"]) {
        self.statusLabel.text = @"完成";
    }else if ([dataDic[@"status"] isEqualToString:@"3"]) {
        self.statusLabel.text = @"逾期未完成";
        self.iconImage.backgroundColor = [UIColor colorWithHexString:@"#FB394C"];
        self.statusLabel.textColor = [UIColor colorWithHexString:@"#FB394C"];
    }else if ([dataDic[@"status"] isEqualToString:@"4"]) {
        self.statusLabel.text = @"逾期完成";
       
    }
}
@end
