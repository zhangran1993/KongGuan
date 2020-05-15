//
//  KG_NewContentCell.m
//  Frame
//
//  Created by zhangran on 2020/4/27.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_NewContentCell.h"

@implementation KG_NewContentCell

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
   
    
    self.iconImage = [[UIImageView alloc]init];
    [self addSubview:self.iconImage];
   
    self.iconImage.image = [UIImage imageNamed:@"must_starIcon"];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.equalTo(@7);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.text = @"设备选择";
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset(10);
        make.width.equalTo(@200);
        make.centerY.equalTo(self.iconImage.mas_centerY);
    }];
    
    self.rightImage = [[UIImageView alloc]init];
    [self addSubview:self.rightImage];
    
    self.rightImage.image = [UIImage imageNamed:@"content_right"];
    [self.rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-12);
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.equalTo(@15);
    }];
    
    self.selBtn = [[UIButton alloc]init];
    [self addSubview:self.selBtn];
    self.selBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.selBtn setTitle:@"请选择内容模块" forState:UIControlStateNormal];
    self.selBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.selBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightImage.mas_left);
        make.width.equalTo(@100);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(self.mas_height);
    }];
    [self.selBtn addTarget:self action:@selector(selMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    self.lineView = [[UIView alloc]init];
    [self addSubview:self.lineView];
    
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@0.5);
    }];
}

- (void)selMethod:(UIButton *)button {
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.hideKeyBoard) {
        self.hideKeyBoard();
    }
}
@end
