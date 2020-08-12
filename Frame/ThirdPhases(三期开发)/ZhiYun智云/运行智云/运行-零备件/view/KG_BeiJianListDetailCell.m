//
//  KG_BeiJianListDetailCell.m
//  Frame
//
//  Created by zhangran on 2020/7/30.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_BeiJianListDetailCell.h"

@interface KG_BeiJianListDetailCell (){
    
}
@property (nonatomic ,strong) UILabel *leftTitleLabel;

@property (nonatomic ,strong) UILabel *rightTitleLabel;

@end


@implementation KG_BeiJianListDetailCell

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
    self.leftTitleLabel = [[UILabel alloc]init];
    [self addSubview:self.leftTitleLabel];
    self.leftTitleLabel.text = @"--";
    self.leftTitleLabel.font = [UIFont systemFontOfSize:14];
    self.leftTitleLabel.textAlignment = NSTextAlignmentLeft;
    self.leftTitleLabel.textColor = [UIColor colorWithHexString:@"#004EC4"];
    self.leftTitleLabel.numberOfLines = 2;
    [self.leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
        make.width.equalTo(@160);
        make.height.equalTo(@45);
    }];
    
    
    self.rightTitleLabel = [[UILabel alloc]init];
    [self addSubview:self.rightTitleLabel];
    self.rightTitleLabel.text = @"--";
    self.rightTitleLabel.font = [UIFont systemFontOfSize:14];
    self.rightTitleLabel.textAlignment = NSTextAlignmentRight;
    self.rightTitleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.rightTitleLabel.numberOfLines = 2;
    [self.rightTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-32);
        make.centerY.equalTo(self.leftTitleLabel.mas_centerY);
        make.width.equalTo(@80);
        make.height.equalTo(@45);
    }];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    self.leftTitleLabel.text = safeString(dataDic[@"attachmentTypeName"]);
    self.rightTitleLabel.text = safeString(dataDic[@"attachmentSize"]);
      
}

@end
