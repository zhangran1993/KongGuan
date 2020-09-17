//
//  ContactTableViewCell.m
//  WeChatContacts-demo
//
//  Created by shen_gh on 16/3/12.
//  Copyright © 2016年 com.joinup(Beijing). All rights reserved.
//

#import "ContactTableViewCell.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation ContactTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //布局View
        [self setUpView];
    }
    return self;
}

#pragma mark - setUpView
- (void)setUpView{
    //头像
    [self.contentView addSubview:self.headImageView];
    //姓名
    [self.contentView addSubview:self.nameLabel];
    //姓名
    [self.contentView addSubview:self.phoneLabel];
}
- (UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(16.0, 12.0, 20.0, 20.0)];
        _headImageView.image = [UIImage imageNamed:@"kg_contacg_unsel"];
        [_headImageView setContentMode:UIViewContentModeScaleAspectFill];
    }
    return _headImageView;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(46.0, 0.0, 150, 44.0)];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
        _nameLabel.numberOfLines = 1;
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        [_nameLabel setFont:[UIFont systemFontOfSize:14.0]];
    }
    return _nameLabel;
}
- (UILabel *)phoneLabel{
    if (!_phoneLabel) {
        _phoneLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH -21-200, 0.0, 200, 44.0)];
        _phoneLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
        _phoneLabel.numberOfLines = 1;
        _phoneLabel.textAlignment = NSTextAlignmentRight;
        _phoneLabel.text = @"13244443333";
        [_phoneLabel setFont:[UIFont systemFontOfSize:14.0]];
    }
    return _phoneLabel;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
