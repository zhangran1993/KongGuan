//
//  KG_RadarEnvCell.m
//  Frame
//
//  Created by zhangran on 2020/4/26.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_RadarEnvCell.h"

@implementation KG_RadarEnvCell

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
    
    self.leftIcon = [[UIImageView alloc]init];
    [self addSubview:self.leftIcon];
    self.leftIcon.layer.cornerRadius = 2.5f;
    self.leftIcon.layer.masksToBounds = YES;
    self.leftIcon.backgroundColor = [UIColor colorWithHexString:@"#BABCC4"];
    [self.leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left);
        make.width.height.equalTo(@5);
    }];

    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    [self.titleLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.leftIcon.mas_right).offset(8);
        make.height.equalTo(self.mas_height);
        make.width.equalTo(@150);
    }];

    self.tempLabel = [[UILabel alloc]init];
    [self addSubview:self.tempLabel];
    self.tempLabel.text = @"18℃";
    self.tempLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    self.tempLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    self.tempLabel.numberOfLines = 1;
    self.tempLabel.textAlignment = NSTextAlignmentRight;
  
    self.zhexianIcon = [[UIImageView alloc]init];
    [self addSubview:self.zhexianIcon];
    self.zhexianIcon.image = [UIImage imageNamed:@"zhexian_image"];
    
    
    self.starIcon = [[UIImageView alloc]init];
    [self addSubview:self.starIcon];
    self.starIcon.image = [UIImage imageNamed:@"gray_starImage"];
    [self.starIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-33.5);
        make.height.equalTo(@12);
        make.width.equalTo(@12);
    }];
    
    [self.zhexianIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.starIcon.mas_right).offset(-14);
        make.height.equalTo(@14);
        make.width.equalTo(@14);
    }];
    [self.tempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.zhexianIcon.mas_left).offset(-14);
        make.height.equalTo(@15);
        make.centerY.equalTo(self.mas_centerY);
        make.width.lessThanOrEqualTo(@100);
      }];
      

//    @property (nonatomic, strong) UIView *detailView;
//    @property (nonatomic, strong) UILabel *detailTitleLabel;
//    @property (nonatomic, strong) UILabel *detailTxtLabel;
//
    self.detailView = [[UIView alloc]init];
    [self addSubview:self.detailView];
    self.detailView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(50);
        make.right.equalTo(self.mas_right).offset(-32);
        make.height.equalTo(@57);
    }];
    self.detailTitleLabel = [[UILabel alloc]init];
    [self.detailView addSubview:self.detailTitleLabel];
    self.detailTitleLabel.text = @"A相输入电压特殊参数标记";
    self.detailTitleLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.detailTitleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    self.detailTitleLabel.numberOfLines = 1;
    self.detailTitleLabel.textAlignment = NSTextAlignmentLeft;
    [self.detailTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailView.mas_top).offset(10);
        make.left.equalTo(self.detailView.mas_left).offset(9.5);
        make.right.equalTo(self.detailView.mas_right).offset(-20);
        make.height.equalTo(@12);
    }];
    
    self.detailTextLabel = [[UILabel alloc]init];
    [self.detailView addSubview:self.detailTextLabel];
    self.detailTextLabel.text = @"电压过高";
    self.detailTextLabel.textColor = [UIColor colorWithHexString:@"#FFB428"];
    self.detailTextLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    self.detailTextLabel.numberOfLines = 1;
    self.detailTextLabel.textAlignment = NSTextAlignmentLeft;
    [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailTitleLabel.mas_bottom).offset(9.5);
        make.left.equalTo(self.detailView.mas_left).offset(9.5);
        make.right.equalTo(self.detailView.mas_right).offset(-20);
        make.height.equalTo(@12);
    }];
    
    NSArray *array = [NSArray arrayWithObjects:@"正常",@"不正常", nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:array];
    segmentedControl.frame = CGRectMake(SCREEN_WIDTH - 32 -84, 8,84,24);
   
    
    [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FFFFFF"]}forState:UIControlStateSelected];
    
    [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#2F5ED1"],NSFontAttributeName:[UIFont boldSystemFontOfSize:14.0f]}forState:UIControlStateNormal];
    [self addSubview:segmentedControl];
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor = [UIColor redColor];
    segmentedControl.layer.borderWidth = 1;                   //    边框宽度，重新画边框，若不重新画，可能会出现圆角处无边框的情况
    segmentedControl.layer.borderColor = [UIColor colorWithHexString:@"#2F5ED1"].CGColor; //     边框颜色
    [segmentedControl setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]]
                                forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [segmentedControl setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:@"#2F5ED1"]]
                                forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    [segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-32);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@84);
        make.height.equalTo(@24);
    }];
    
    
}

- (UIImage*)createImageWithColor: (UIColor*) color{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
@end
