//
//  KG_JiaoJieBanRecordCell.m
//  Frame
//
//  Created by zhangran on 2020/6/1.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_JiaoJieBanRecordCell.h"


@interface KG_JiaoJieBanRecordCell (){
    
}
@property (nonatomic,strong) UIImageView *bgImage;

@property (nonatomic,strong) UILabel *titleLabel;

//状态image
@property (nonatomic,strong) UIImageView *statusImage;

@property (nonatomic,strong) UILabel *leftLabel;


@property (nonatomic,strong) UILabel *rightLabel;


@end

@implementation KG_JiaoJieBanRecordCell

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
  
 
  
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.numberOfLines = 1;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImage.mas_left).offset(16);
        make.top.equalTo(self.bgImage.mas_top).offset(7);
        make.width.equalTo(@200);
        make.height.equalTo(@20);
    }];
    self.leftLabel = [[UILabel alloc]init];
    [self addSubview:self.leftLabel];
    self.leftLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    self.leftLabel.font = [UIFont systemFontOfSize:12];
    self.leftLabel.numberOfLines = 1;
    self.leftLabel.text = @"2020.05.07 08:00:23";
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.width.equalTo(@((SCREEN_WIDTH -32-34)/2));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(4);
       
    }];
     
    
    self.statusImage  = [[UIImageView alloc]init];
    
    self.statusImage.contentMode = UIViewContentModeScaleAspectFit;
    self.statusImage.image = [UIImage imageNamed:@"jiaojiebanjiantou"];
    [self addSubview:self.statusImage];
    [self.statusImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.bgImage.mas_top);
        make.width.height.equalTo(@8);
    }];
    
   
    self.rightLabel = [[UILabel alloc]init];
    [self addSubview:self.rightLabel];
    self.rightLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    self.rightLabel.font = [UIFont systemFontOfSize:12];
    self.rightLabel.numberOfLines = 1;
    self.rightLabel.textAlignment = NSTextAlignmentLeft;
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgImage.mas_right).offset(-16);
        make.bottom.equalTo(self.bgImage.mas_bottom).offset(-11 );
        make.width.equalTo(@200);
        make.height.equalTo(@17);
    }];
    
   
    UIView *lineView = [[UIView alloc]init];
    [self addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImage.mas_left);
        make.right.equalTo(self.bgImage.mas_right);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(self.mas_bottom);
       
    }];
    
    
    
}
@end

