//
//  KG_RunReportDetailCommonCell.m
//  Frame
//
//  Created by zhangran on 2020/6/2.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_RunReportDetailCommonCell.h"

@interface KG_RunReportDetailCommonCell (){
    
    
}

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation KG_RunReportDetailCommonCell

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
    
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    bgView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(26);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.equalTo(self.mas_height);
        make.top.equalTo(self.mas_top);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [bgView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(13);
        make.right.equalTo(bgView.mas_right).offset(-13);
        make.top.equalTo(bgView.mas_top);
        make.bottom.equalTo(bgView.mas_bottom);
    }];
                                     
}
- (void)setString:(NSString *)string {
    _string = string;
    self.titleLabel.text = safeString(string);
}
@end
