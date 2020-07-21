//
//  KG_RadarEnvCell.m
//  Frame
//
//  Created by zhangran on 2020/4/26.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_RadarEquipCell.h"

@implementation KG_RadarEquipCell

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
    self.titleLabel.textColor =[UIColor colorWithHexString:@"#626470"];
    self.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    
    [self.titleLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(49.5);
        make.height.equalTo(self.mas_height);
        make.width.equalTo(@150);
    }];
    
    self.detailLabel = [[UILabel alloc]init];
    [self addSubview:self.detailLabel];
    self.detailLabel.textColor =[UIColor colorWithHexString:@"#626470"];
    self.detailLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    self.detailLabel.textAlignment = NSTextAlignmentRight;
    [self.detailLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-20);
        make.height.equalTo(self.mas_height);
        make.width.equalTo(@250);
    }];
    
    [self createSegment];
    //    self.tempLabel = [[UILabel alloc]init];
    //    [self addSubview:self.tempLabel];
    //    self.tempLabel.text = @"18℃";
    //    self.tempLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    //    self.tempLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    //    self.tempLabel.numberOfLines = 1;
    //    self.tempLabel.textAlignment = NSTextAlignmentRight;
    //
    //    self.zhexianIcon = [[UIImageView alloc]init];
    //    [self addSubview:self.zhexianIcon];
    //    self.zhexianIcon.image = [UIImage imageNamed:@"zhexian_image"];
    //
    //
    //    self.starIcon = [[UIImageView alloc]init];
    //    [self addSubview:self.starIcon];
    //    self.starIcon.image = [UIImage imageNamed:@"gray_starImage"];
    //    [self.starIcon mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.equalTo(self.mas_centerY);
    //        make.right.equalTo(self.mas_right).offset(-33.5);
    //        make.height.equalTo(@12);
    //        make.width.equalTo(@12);
    //    }];
    //
    //    [self.zhexianIcon mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.equalTo(self.mas_centerY);
    //        make.right.equalTo(self.starIcon.mas_right).offset(-14);
    //        make.height.equalTo(@14);
    //        make.width.equalTo(@14);
    //    }];
    //    [self.tempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.right.equalTo(self.zhexianIcon.mas_left).offset(-14);
    //        make.height.equalTo(@15);
    //        make.centerY.equalTo(self.mas_centerY);
    //        make.width.lessThanOrEqualTo(@100);
    //    }];
    //
    //
    //    @property (nonatomic, strong) UIView *detailView;
    //    @property (nonatomic, strong) UILabel *detailTitleLabel;
    //    @property (nonatomic, strong) UILabel *detailTxtLabel;
    //
    if (0) {
        
        
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
        
        self.detailTextTitleLabel = [[UILabel alloc]init];
        [self.detailView addSubview:self.detailTextTitleLabel];
        self.detailTextTitleLabel.text = @"电压过高";
        self.detailTextTitleLabel.textColor = [UIColor colorWithHexString:@"#FFB428"];
        self.detailTextTitleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        self.detailTextTitleLabel.numberOfLines = 1;
        self.detailTextTitleLabel.textAlignment = NSTextAlignmentLeft;
        [self.detailTextTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.detailTitleLabel.mas_bottom).offset(9.5);
            make.left.equalTo(self.detailView.mas_left).offset(9.5);
            make.right.equalTo(self.detailView.mas_right).offset(-20);
            make.height.equalTo(@12);
        }];
    }
    
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

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.segmentedControl.hidden = YES;
    if ([safeString(dataDic[@"measureTagName"]) isEqualToString:@"当前模式"]) {
        NSLog(@"1");
    }
    if ([safeString(dataDic[@"measureTagName"]) isEqualToString:@"湿度"]) {
        NSLog(@"2");
    }
    NSDictionary *dd = nil;
    NSArray *arr = _dataDic[@"childrens"];
    if (arr.count >0) {
        dd = [arr firstObject];
    }
    
    self.titleLabel.text = safeString(dataDic[@"measureTagName"]);
    if (safeString(dataDic[@"measureTagName"]).length == 0) {
        self.titleLabel.text = safeString(dataDic[@"title"]);
    }
    self.detailLabel.text = safeString(dataDic[@"measureValueAlias"]);
    if (safeString(dataDic[@"unit"]).length > 0) {
        self.detailLabel.text = [NSString stringWithFormat:@"%@%@",safeString(dataDic[@"measureValueAlias"]),safeString(dataDic[@"unit"])];
    }
    if(safeString(dataDic[@"measureValueAlias"]).length >0){
        
    }else {
        
        
        if([safeString(dd[@"type"])  isEqualToString:@"charset"] ||
           [safeString(dd[@"type"])  isEqualToString:@"radio"]
           ) {
            if ([UserManager shareUserManager].isChangeTask) {
                self.segmentedControl.userInteractionEnabled = YES;
            }else {
                self.segmentedControl.userInteractionEnabled = NO;
            }
            self.segmentedControl.hidden = NO;
            if ([dataDic[@"childrens"] count] >0) {
                NSDictionary *dd = [dataDic[@"childrens"] firstObject];
                NSString *value = safeString(dd[@"value"]) ;
                NSString *valueNum = safeString(self.dataDic[@"measureValueAlias"]) ;
                if (value.length >0) {
                    
                    NSArray *array = [value componentsSeparatedByString:@"@&@"];
                    if (array.count == 2) {
                        [self.segmentedControl setTitle:safeString(array[0]) forSegmentAtIndex:0];
                        [self.segmentedControl setTitle:safeString(array[1]) forSegmentAtIndex:1];
                        if (valueNum.length >0) {
                            if ([valueNum isEqualToString:array[0]]) {
                                self.segmentedControl.selectedSegmentIndex = 0;
                                
                            }else if ([valueNum isEqualToString:array[1]]) {
                                self.segmentedControl.selectedSegmentIndex = 1;
                                
                            }else {
                                self.segmentedControl.selectedSegmentIndex = 2;
                            }
                        }else {
                            self.segmentedControl.selectedSegmentIndex = 2;
                        }
                    }
                }else {
                    
                    NSArray *array = [NSArray arrayWithObjects:@"正常",@"不正常", nil];
                    if (array.count == 2) {
                        [self.segmentedControl setTitle:safeString(array[0]) forSegmentAtIndex:0];
                        [self.segmentedControl setTitle:safeString(array[1]) forSegmentAtIndex:1];
                        
                    }
                }
                
                
            }
            self.detailLabel.hidden = YES;
            
        }else if( [safeString(dd[@"type"])  isEqualToString:@"radio"]) {
            
            
        }else if([safeString(dataDic[@"type"]) isEqualToString:@"textarea"]) {
            
            
        }else if([safeString(dataDic[@"type"])  isEqualToString:@"select"]) {
            
        }else if([safeString(dataDic[@"type"]) isEqualToString:@"input"]) {
            if ([UserManager shareUserManager].isChangeTask) {
                self.segmentedControl.userInteractionEnabled = YES;
            }else {
                self.segmentedControl.userInteractionEnabled = NO;
            }
            self.segmentedControl.hidden = NO;
            if ([dataDic[@"childrens"] count] >0) {
                NSDictionary *dd = [dataDic[@"childrens"] firstObject];
                NSString *value = safeString(dd[@"value"]) ;
                NSString *valueNum = safeString(self.dataDic[@"measureValueAlias"]) ;
                if (value.length >0) {
                    
                    NSArray *array = [value componentsSeparatedByString:@"@&@"];
                    if (array.count == 2) {
                        [self.segmentedControl setTitle:safeString(array[0]) forSegmentAtIndex:0];
                        [self.segmentedControl setTitle:safeString(array[1]) forSegmentAtIndex:1];
                        if (valueNum.length >0) {
                            if ([valueNum isEqualToString:array[0]]) {
                                self.segmentedControl.selectedSegmentIndex = 0;
                                
                            }else if ([valueNum isEqualToString:array[1]]) {
                                self.segmentedControl.selectedSegmentIndex = 1;
                                
                            }else {
                                self.segmentedControl.selectedSegmentIndex = 2;
                            }
                        }else {
                            self.segmentedControl.selectedSegmentIndex = 2;
                        }
                    }
                }
                
                
            }
            self.detailLabel.hidden = YES;
        }
    }
    
}
- (void)createSegment {
    
    NSArray *array = [NSArray arrayWithObjects:@"正常",@"不正常", nil];
    
    [self.segmentedControl removeFromSuperview];
    
    self.segmentedControl = [[UISegmentedControl alloc]initWithItems:array];
    self.segmentedControl.frame = CGRectMake(SCREEN_WIDTH - 32 -84, 8,84,24);
    
    
    
    [self.segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FFFFFF"]}forState:UIControlStateSelected];
    
    [self.segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#2F5ED1"],NSFontAttributeName:[UIFont boldSystemFontOfSize:10.0f]}forState:UIControlStateNormal];
    [self addSubview:self.segmentedControl];
    
    self.segmentedControl.tintColor = [UIColor colorWithHexString:@"#2F5ED1"];
    self.segmentedControl.layer.borderWidth = 1;                   //    边框宽度，重新画边框，若不重新画，可能会出现圆角处无边框的情况
    self.segmentedControl.layer.borderColor = [UIColor colorWithHexString:@"#2F5ED1"].CGColor; //     边框颜色
    [self.segmentedControl setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]]
                                     forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.segmentedControl addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    
    [self.segmentedControl setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:@"#2F5ED1"]]
                                     forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@100);
        make.height.equalTo(@24);
    }];
}
- (void)change:(UISegmentedControl *)sender {
    NSLog(@"测试");
    self.segmentedControl.selectedSegmentIndex = sender.selectedSegmentIndex;
    if (sender.selectedSegmentIndex == 0) {
        NSLog(@"1");
    }else if (sender.selectedSegmentIndex == 1){
        NSLog(@"2");
    }else if (sender.selectedSegmentIndex == 2){
        NSLog(@"3");
    }else if (sender.selectedSegmentIndex == 3){
        NSLog(@"4");
    }
    NSMutableDictionary *toDic = [NSMutableDictionary dictionary];
    
    NSDictionary *resultDic  = [UserManager shareUserManager].resultDic;
    [toDic addEntriesFromDictionary:resultDic];
    NSDictionary *dd = [self.dataDic[@"childrens"] firstObject];
    
    NSString *infoId = safeString(dd[@"parentId"]);
    NSString *value = safeString(dd[@"value"]) ;
    
    if (value.length >0) {
        
        NSArray *array = [value componentsSeparatedByString:@"@&@"];
        
        if (array.count == 2) {
            
            NSString *valueNum = safeString(array[sender.selectedSegmentIndex]);
//            for (NSString *str in [resultDic allKeys]) {
//                NSLog(@"%@",str);
//                NSLog(@"%@",infoId);
//                if ([str isEqualToString:infoId]) {
                    NSMutableDictionary *aDic = [NSMutableDictionary dictionary];
                    [aDic setValue:safeString(valueNum) forKey:safeString(infoId)];
                    [toDic addEntriesFromDictionary:aDic];
//                }
//            }
            
            [UserManager shareUserManager].resultDic = toDic;
            
        }
        
    }
    switch (sender.selectedSegmentIndex) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        default:
            break;
    }
}
@end
