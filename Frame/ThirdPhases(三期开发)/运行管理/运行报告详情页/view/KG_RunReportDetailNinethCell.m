//
//  KG_RunReportDetailNinethCell.m
//  Frame
//
//  Created by zhangran on 2020/6/3.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_RunReportDetailNinethCell.h"

@interface KG_RunReportDetailNinethCell (){
    
    
}



@end

@implementation KG_RunReportDetailNinethCell

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
    
    self.centerBtn = [[UIButton alloc]init];
    [self.centerBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [self addSubview:self.centerBtn];
    [self.centerBtn setBackgroundColor:[UIColor colorWithHexString:@"#2F5ED1"]];
    self.centerBtn.layer.cornerRadius = 6;
    self.centerBtn.layer.masksToBounds = YES;
    self.centerBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.right.equalTo(self.mas_right).offset(-16);
        make.top.equalTo(self.mas_top).offset(5);
        make.height.equalTo(@44);
    }];
   
}


@end
