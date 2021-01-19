//
//  KG_NewMessNotiCell.m
//  Frame
//
//  Created by zhangran on 2020/12/18.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_NewMessNotiCell.h"
#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@implementation KG_NewMessNotiCell

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
    self.iconImage.backgroundColor = [UIColor colorWithHexString:@"#2F5ED1"];
    self.iconImage.layer.cornerRadius = 3.f;
    self.iconImage.layer.masksToBounds = YES;
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.top.equalTo(self.mas_top).offset(18);
        make.width.height.equalTo(@6);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.font = [UIFont my_font:14];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(32);
        make.width.equalTo(@200);
        make.centerY.equalTo(self.iconImage.mas_centerY);
        make.height.equalTo(@13);
    }];
    
    self.detailLabel = [[UILabel alloc]init];
    [self addSubview:self.detailLabel];
    self.detailLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.detailLabel.font = [UIFont systemFontOfSize:12];
    self.detailLabel.font = [UIFont my_font:12];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(32);
        make.width.equalTo(@300);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.height.equalTo(@11.5);
    }];
    
    self.lineView = [[UIView alloc]init];
    [self addSubview:self.lineView];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.right.equalTo(self.mas_right).offset(-16);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@1);
    }];
    
    self.swh = [[UISwitch alloc]init];
    [self addSubview:self.swh];
    self.swh.onTintColor = [UIColor colorWithHexString:@"#2F5ED1"];  //On状态下颜色
    [self.swh mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-16);
        make.height.equalTo(@36);
        make.width.equalTo(@54);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.swh addTarget:self action:@selector(swhValueChange:) forControlEvents:UIControlEventValueChanged];
}

- (void)swhValueChange:(id)sender {
    
    UISwitch *swh = (UISwitch *)sender;
    if(self.switchOnBlock){
        self.switchOnBlock(swh.isOn, self.indexPath);
    }
    
}

- (void)setIndexPath:(NSInteger )indexPath {
    _indexPath = indexPath;
    
}

@end
