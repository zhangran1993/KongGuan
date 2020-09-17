//
//  KG_XunShiSelTimeCell.m
//  Frame
//
//  Created by zhangran on 2020/9/1.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_XunShiSelTimeCell.h"

@interface KG_XunShiSelTimeCell () {
    
}

@property (nonatomic ,strong) UILabel *yearLabel;

@property (nonatomic ,strong) UILabel *monthLabel;

@property (nonatomic ,strong) UILabel *dayLabel;

@property (nonatomic ,strong) UILabel *hourLabel;

@end

@implementation KG_XunShiSelTimeCell

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
        [self initData];
        [self setupDataSubviews];
    }
    return self;
}

//初始化数据
- (void)initData {
    
}

//创建视图
-(void)setupDataSubviews
{
    
//    float with = (SCREEN_WIDTH -96)/4;
    
    self.yearLabel = [[UILabel alloc ]init];
    [self addSubview:self.yearLabel];
    self.yearLabel.textColor = [UIColor colorWithHexString:@"#BABCC4"];
    self.yearLabel.textAlignment = NSTextAlignmentCenter;
    self.yearLabel.font = [UIFont systemFontOfSize:14];
    [self.yearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@44);
        make.centerY.equalTo(self.mas_centerY);
    }];
//
//    self.monthLabel = [[UILabel alloc ]init];
//    [self addSubview:self.monthLabel];
//    self.monthLabel.textColor = [UIColor colorWithHexString:@"#BABCC4"];
//    self.monthLabel.textAlignment = NSTextAlignmentCenter;
//    self.monthLabel.font = [UIFont systemFontOfSize:14];
//    [self.monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.yearLabel.mas_right);
//        make.width.equalTo(@(with));
//        make.height.equalTo(@44);
//        make.centerY.equalTo(self.mas_centerY);
//    }];
//
//    self.dayLabel = [[UILabel alloc ]init];
//    [self addSubview:self.dayLabel];
//    self.dayLabel.textColor = [UIColor colorWithHexString:@"#BABCC4"];
//    self.dayLabel.textAlignment = NSTextAlignmentCenter;
//    self.dayLabel.font = [UIFont systemFontOfSize:14];
//    [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.monthLabel.mas_right);
//        make.width.equalTo(@(with));
//        make.height.equalTo(@44);
//        make.centerY.equalTo(self.mas_centerY);
//    }];
//
//    self.hourLabel = [[UILabel alloc ]init];
//    [self addSubview:self.hourLabel];
//    self.hourLabel.textColor = [UIColor colorWithHexString:@"#BABCC4"];
//    self.hourLabel.textAlignment = NSTextAlignmentRight;
//    self.hourLabel.font = [UIFont systemFontOfSize:14];
//    [self.hourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.dayLabel.mas_right);
//        make.width.equalTo(@(with));
//        make.height.equalTo(@44);
//        make.centerY.equalTo(self.mas_centerY);
//    }];
    
    UIView *lineView = [[UIView alloc]init];
    [self addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lineView.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@1);
    }];
    
}

- (void)setTimeStr:(NSString *)timeStr {
    _timeStr = timeStr;
    
    
    NSString *yearStr = @"";
    NSString *monthStr = @"";
    NSString *dayStr = @"";
    NSString *hourStr = @"";
    if (timeStr.length) {
        NSArray *firstArr = [timeStr componentsSeparatedByString:@" "];
        if (firstArr.count == 2) {
            NSArray *secondArr = [[firstArr firstObject] componentsSeparatedByString:@"-"];
            if (secondArr.count == 3) {
                yearStr = [NSString stringWithFormat:@"%@年",safeString(secondArr[0])];
                
                monthStr = [NSString stringWithFormat:@"%@月",safeString(secondArr[1])];
                
                dayStr = [NSString stringWithFormat:@"%@日",safeString(secondArr[2])];
            }
            
            hourStr = [NSString stringWithFormat:@"%@时",safeString([[firstArr lastObject] substringToIndex:2])];
        }
    }
    self.yearLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",yearStr,monthStr,dayStr,hourStr];
    
//    self.monthLabel.text = monthStr;
//
//    self.dayLabel.text = dayStr;
//
//    self.hourLabel.text = hourStr;
    if (self.selTimeStr.length ) {
        NSString *selyearStr = @"";
        NSString *selmonthStr = @"";
        NSString *seldayStr = @"";
        NSString *selhourStr = @"";
        if (self.selTimeStr.length) {
            NSArray *firstArr = [self.selTimeStr componentsSeparatedByString:@" "];
            if (firstArr.count == 2) {
                NSArray *secondArr = [[firstArr firstObject] componentsSeparatedByString:@"-"];
                if (secondArr.count == 3) {
                    selyearStr = [NSString stringWithFormat:@"%@年",safeString(secondArr[0])];
                    
                    selmonthStr = [NSString stringWithFormat:@"%@月",safeString(secondArr[1])];
                    
                    seldayStr = [NSString stringWithFormat:@"%@日",safeString(secondArr[2])];
                }
                
                selhourStr = [NSString stringWithFormat:@"%@时",safeString([[firstArr lastObject] substringToIndex:2])];
            }
            
        }
        
        if ([yearStr   isEqualToString: selyearStr]  &&
            [monthStr  isEqualToString: selmonthStr] &&
            [dayStr    isEqualToString: seldayStr]   &&
            [hourStr   isEqualToString: selhourStr]  ) {
            self.yearLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
           
        }else {
            self.yearLabel.textColor = [UIColor colorWithHexString:@"#BABCC4"];
           
            
        }
        
        
    }
    
}

- (void)setSelTimeStr:(NSString *)selTimeStr {
    _selTimeStr = selTimeStr;
    
    
}
@end
