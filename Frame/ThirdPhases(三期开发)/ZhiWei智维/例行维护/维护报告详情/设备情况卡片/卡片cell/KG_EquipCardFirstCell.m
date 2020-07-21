//
//  KG_EquipCardFirstCell.m
//  Frame
//
//  Created by zhangran on 2020/6/16.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_EquipCardFirstCell.h"

@interface KG_EquipCardFirstCell () {
    
}

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIImageView *statusImage;

@property (nonatomic,strong) UILabel *detailLabel;

@property (nonatomic,strong) UIImageView *arrowImage;

@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@end

@implementation KG_EquipCardFirstCell

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
    
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.text = @"";
    self.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-100);
        make.height.equalTo(self.mas_height);
    }];
//
//    self.statusImage  = [[UIImageView alloc]init];
//    [self.statusImage sizeToFit];
//    self.statusImage.contentMode = UIViewContentModeScaleAspectFit;
//    [self addSubview:self.statusImage];
//    [self.statusImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.mas_right);
//        make.top.equalTo(self.mas_top).offset(14);
//
//        make.height.equalTo(@26);
//    }];
    
    self.detailLabel = [[UILabel alloc]init];
    [self addSubview:self.detailLabel];
    self.detailLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    self.detailLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    self.detailLabel.textAlignment = NSTextAlignmentRight;
    self.detailLabel.text = @"";
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@200);
        make.height.equalTo(self.mas_height);
    }];

    [self createSegment];
    
    UIView *lineView = [[UIView alloc]init];
    [self addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.right.equalTo(self.mas_right).offset(-16);
        make.height.equalTo(@1);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    
    
    
}

- (void)setDic:(NSDictionary *)dic {
    _dic = dic;
   
    self.titleLabel.text = safeString(dic[@"title"]);
   
    if(safeString(dic[@"title"]).length == 0) {
        
        self.titleLabel.text = safeString(dic[@"measureTagName"]);
    }
    self.statusImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"状态标签-%@",[self getTaskStatus:safeString(dic[@"status"])]]];
    
    if ([dic[@"childrens"] count] ==0) {
        return;
    }
    NSDictionary *fifDic = [self.dic[@"childrens"] firstObject];
    
    if([safeString(fifDic[@"type"]) isEqualToString:@"textarea"] ||[safeString(fifDic[@"type"]) isEqualToString:@"charset"] ) {
        self.segmentedControl.hidden = YES;
        self.detailLabel.hidden = NO;
        self.detailLabel.text = safeString(self.dic[@"measureValueAlias"]);
    }else if([safeString(fifDic[@"type"]) isEqualToString:@"radio"] ||[safeString(fifDic[@"type"])  isEqualToString:@"select"]) {
        if ([UserManager shareUserManager].isChangeTask) {
            self.segmentedControl.userInteractionEnabled = YES;
        }else {
            self.segmentedControl.userInteractionEnabled = NO;
        }
        self.segmentedControl.hidden = NO;
        if ([dic[@"childrens"] count] >0) {
            NSDictionary *dd = [dic[@"childrens"] firstObject];
            NSString *value = safeString(dd[@"value"]) ;
            NSString *valueNum = safeString(self.dic[@"measureValueAlias"]) ;
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
}



}

- (NSString *)getTaskStatus :(NSString *)status {
    NSString *ss = @"已完成";
    if ([status isEqualToString:@"0"]) {
        ss = @"待执行";
    }else if ([status isEqualToString:@"1"]) {
        ss = @"进行中";
    }else if ([status isEqualToString:@"2"]) {
        ss = @"已完成";
    }else if ([status isEqualToString:@"3"]) {
        ss = @"逾期未完成";
    }else if ([status isEqualToString:@"4"]) {
        ss = @"逾期完成";
    }else if ([status isEqualToString:@"5"]) {
        ss = @"待领取";
    }else if ([status isEqualToString:@"6"]) {
        ss = @"待指派";
    }
    return ss;
    
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
    
    NSMutableDictionary *toDic = [NSMutableDictionary dictionary];
    
    NSDictionary *resultDic  = [UserManager shareUserManager].resultDic;
    [toDic addEntriesFromDictionary:resultDic];
    NSDictionary *dd = [self.dic[@"childrens"] firstObject];
    
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
