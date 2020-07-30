//
//  KG_KongTiaoCeDianCell.m
//  Frame
//
//  Created by zhangran on 2020/5/21.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_KongTiaoCeDianCell.h"

@interface KG_KongTiaoCeDianCell (){
    
    
}

@property (nonatomic ,strong) UILabel *titleLabel;

@property (nonatomic ,strong) UIImageView *iconImage;

@property (nonatomic ,strong) UILabel *valueLabel;

@end

@implementation KG_KongTiaoCeDianCell

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
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.width.equalTo(@6);
        make.height.equalTo(@6);
        make.centerY.equalTo(self.mas_centerY);
    }];
    self.iconImage.layer.cornerRadius = 3.f;
    self.iconImage.layer.masksToBounds = YES;
    self.iconImage.backgroundColor = [UIColor colorWithHexString:@"#95A8D7"];
    
    
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.text = @"温度";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#7C7E86"];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset(12);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.width.equalTo(@200);
    }];
    
    self.valueLabel = [[UILabel alloc]init];
    [self addSubview:self.valueLabel];
    self.valueLabel.text = @"温度";
    self.valueLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.valueLabel.textAlignment = NSTextAlignmentRight;
    self.valueLabel.font = [UIFont systemFontOfSize:14];
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-17);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.width.equalTo(@100);
    }];
    
    UIView *lineImage = [[UIView alloc]init];
    [self addSubview:lineImage];
    lineImage.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(17);
        make.right.equalTo(self.mas_right).offset(-14);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@1);
    }];
    
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    self.titleLabel.text = safeString(dataDic[@"name"]);
    
    self.valueLabel.text = [NSString stringWithFormat:@"%@",safeString(dataDic[@"valueAlias"])];
    
    for (NSDictionary *arDic in self.alarmArray) {
        if ([safeString(arDic[@"name"]) containsString:safeString(dataDic[@"name"])]
            &&[safeString(arDic[@"name"]) containsString:safeString(dataDic[@"valueAlias"])]) {
            self.titleLabel.textColor = [UIColor colorWithHexString:@"#FB394C"];
            self.valueLabel.textColor = [UIColor colorWithHexString:@"#FB394C"];
            self.iconImage.backgroundColor = [UIColor colorWithHexString:@"#FB394C"];
            break;
        }else {
            
            self.titleLabel.textColor = [UIColor colorWithHexString:@"#7C7E86"];
            self.valueLabel.textColor = [UIColor colorWithHexString:@"#7C7E86"];
            self.iconImage.backgroundColor = [UIColor colorWithHexString:@"#95A8D7"];
        }
    }
}
@end
