//
//  KG_HistoryTaskCell.m
//  Frame
//
//  Created by zhangran on 2020/5/11.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_InstrumentationSearchCell.h"

@implementation KG_InstrumentationSearchCell

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
        
        
        [self createUI];
    }
    
    return self;
}


- (void)createUI{
    
    self.rightView = [[UIView alloc]init];
    self.rightView.layer.cornerRadius = 10;
    self.rightView.layer.masksToBounds = YES;
    self.rightView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.rightView];
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.top.equalTo(self.mas_top).offset(0);
        make.right.equalTo(self.mas_right).offset(-16);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    [self.rightView addSubview:self.titleLabel];
    self.titleLabel.text = @"电池间蓄电池2#设备故障";
    self.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    self.titleLabel.font = [UIFont my_font:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.numberOfLines = 1;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rightView.mas_left).offset(15);
        make.right.equalTo(self.rightView.mas_right).offset(-20);
        make.top.equalTo(self.rightView.mas_top).offset(13);
        make.height.equalTo(@20);
    }];
    
    
    self.detailLabel = [[UILabel alloc]init];
    [self.rightView addSubview:self.detailLabel];
    self.detailLabel.text = @"电池间";
    self.detailLabel.font = [UIFont systemFontOfSize:14];
    self.detailLabel.font = [UIFont my_font:14];
    self.detailLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.detailLabel.textAlignment = NSTextAlignmentLeft;
    self.detailLabel.numberOfLines = 0;
    [self.detailLabel sizeToFit];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rightView.mas_left).offset(15);
        make.right.equalTo(self.rightView.mas_right).offset(-20);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        
    }];
    
    
}


- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
//    self.titleLabel.text = safeString(dataDic[@"name"]);
    
    self.detailLabel.text = safeString(dataDic[@"introduce"]);
    
    NSString *price = safeString(self.seachStr);
    
    //拼接需要显示的完整字符串
    NSString *string = [NSString stringWithFormat:@"%@",safeString(dataDic[@"name"])];
    
    //获取需要改变的字符串在完整字符串的范围
    NSRange rang = [string rangeOfString:price];
    
    
    NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:string];
    
    //设置文字颜色
    [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#004EC4"] range:rang];
    
    //设置文字大小
    [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:rang];
 
    self.titleLabel.attributedText = attributStr;
    
}

- (void)setSeachStr:(NSString *)seachStr {
    _seachStr = seachStr;
    
}

@end
