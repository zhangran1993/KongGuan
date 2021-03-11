//
//  KG_AddressbookSearchCell.m
//  Frame
//
//  Created by zhangran on 2020/9/2.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_AddressbookSearchCell.h"

@interface KG_AddressbookSearchCell (){
    
    
}

@property (nonatomic ,strong) UILabel *titleLabel;

@property (nonatomic ,strong) UILabel *deatilLabel;

@end

@implementation KG_AddressbookSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //布局View
        self.contentView.backgroundColor = self.backgroundColor;
        [self setUpView];
    }
    return self;
}

- (void)setUpView {
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.numberOfLines = 1;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.mas_height);
        make.left.equalTo(self.mas_left).offset(16);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@200);
        
    }];
    
    
    self.deatilLabel = [[UILabel alloc]init];
    [self addSubview:self.deatilLabel];
    self.deatilLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.deatilLabel.font = [UIFont systemFontOfSize:14];
    self.deatilLabel.textAlignment = NSTextAlignmentRight;
    self.deatilLabel.numberOfLines = 1;
    [self.deatilLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.mas_height);
        make.right.equalTo(self.mas_right).offset(-16);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@200);
        
    }];
    
}

- (void)setDic:(NSDictionary *)dic {
    _dic = dic;
    
    self.titleLabel.text = safeString(dic[@"name"]);
    
    self.deatilLabel.text = safeString(dic[@"tel"]);
}
@end
