//
//  WYLDatePickerView.m
//  ylh-app-primary-ios
//
//  Created by 巨商汇 on 2019/1/8.
//  Copyright © 2019 巨商汇. All rights reserved.
//

#import "WYLDatePickerView.h"

@interface WYLDatePickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UIPickerView *pickerView; // 选择器
@property (strong, nonatomic) UIView *toolView; // 工具条
@property (strong, nonatomic) UILabel *titleLbl; // 标题
@property(nonatomic , strong) UIButton *saveBtn; //完成按钮
@property(nonatomic , strong) UIButton *cancelBtn ; //取消按钮
@property (strong, nonatomic) NSMutableArray *dataArray; // 数据源
@property (copy, nonatomic) NSString *selectStr; // 选中的时间


@property (strong, nonatomic) NSMutableArray *yearArr; // 年数组
@property (strong, nonatomic) NSMutableArray *monthArr; // 月数组
@property (strong, nonatomic) NSMutableArray *dayArr; // 日数组
@property (strong, nonatomic) NSMutableArray *hourArr; // 时数组
@property (strong, nonatomic) NSMutableArray *minuteArr; // 分数组
@property (strong, nonatomic) NSArray *timeArr; // 当前时间数组

@property (copy, nonatomic) NSString *year; // 选中年
@property (copy, nonatomic) NSString *month; //选中月
@property (copy, nonatomic) NSString *day; //选中日
@property (copy, nonatomic) NSString *hour; //选中时
@property (copy, nonatomic) NSString *minute; //选中分

/** 时间选择器类型 */
@property(nonatomic , assign) WYLDatePickerType datePickerType;

@end


@implementation WYLDatePickerView

#pragma mark - init
/// 初始化
/** 构造方法 */
- (instancetype)initWithFrame:(CGRect)frame withDatePickerType:(WYLDatePickerType)datePickerType{
     self = [super initWithFrame:frame];
    if (self) {
        self.maxYear = 2099;
        self.minYear = 1970;
        self.backgroundColor = [UIColor whiteColor];
        self.datePickerType = datePickerType;
        self.timeArr = [NSArray array];
        self.dataArray = [[NSMutableArray alloc]init];
        [self configToolView];
        [self configPickerView];
        [self creatDatePickerWithWYLDatePickerType:datePickerType];
        [self configDataWithWYLDatePickerType:datePickerType];
    }
    
    return self;
}

#pragma mark ---- 根据DatePickerType初始化
-(void)creatDatePickerWithWYLDatePickerType:(WYLDatePickerType)datePickerType{
    switch (datePickerType) {
            
        case WYLDatePickerTypeYMDHM:
        {
            self.minuteArr = [[NSMutableArray alloc]init];
            [self.dataArray addObject:self.yearArr];
            [self.dataArray addObject:self.monthArr];
            [self.dataArray addObject:self.dayArr];
            [self.dataArray addObject:self.hourArr];
        }
            break;
            
        case WYLDatePickerTypeYMD:
        {
            [self.dataArray addObject:self.yearArr];
            [self.dataArray addObject:self.monthArr];
            [self.dataArray addObject:self.dayArr];
        }
            break;
            
        case WYLDatePickerTypeYM:
        {
            [self.dataArray addObject:self.yearArr];
            [self.dataArray addObject:self.monthArr];
        }
            break;
        case WYLDatePickerTypeY:
        {
            [self.dataArray addObject:self.yearArr];
        }
            break;
        default:
            break;
    }
}


- (void) configDataWithWYLDatePickerType:(WYLDatePickerType)datePickerType {
    
    self.isSlide = YES;
    self.minuteInterval = 5;
    
    NSDate *date = [NSDate date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
   
    
    switch (datePickerType) {
        case WYLDatePickerTypeYMDHM:
        {
             [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        }
            break;
            
        case WYLDatePickerTypeYMD:
        {
             [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        }
            break;
            
        case WYLDatePickerTypeYM:
        {
             [dateFormatter setDateFormat:@"yyyy-MM"];
        }
            break;
        case WYLDatePickerTypeY:
        {
            [dateFormatter setDateFormat:@"yyyy"];
        }
            break;
        default:
            break;
    }
    
    self.date = [dateFormatter stringFromDate:date];
}


#pragma mark - 配置界面
/// 配置工具条
- (void)configToolView {
    
    self.toolView = [[UIView alloc] init];
    self.toolView.frame = CGRectMake(0, 0, self.frame.size.width, 44);
    [self addSubview:self.toolView];
    
    self.saveBtn = [[UIButton alloc] init];
    self.saveBtn.frame = CGRectMake(self.frame.size.width - 50, 2, 40, 40);
    [self.saveBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self.saveBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.toolView addSubview:self.saveBtn];
    
    self.cancelBtn = [[UIButton alloc] init];
    self.cancelBtn.frame = CGRectMake(10, 2, 40, 40);
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn  setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.toolView addSubview:self.cancelBtn];
    
    self.titleLbl = [[UILabel alloc] init];
    self.titleLbl.frame = CGRectMake(60, 2, self.frame.size.width - 120, 40);
    self.titleLbl.textAlignment = NSTextAlignmentCenter;
    self.titleLbl.textColor = WYLGrayColor(34);
    [self.toolView addSubview:self.titleLbl];
}

-(void)setToolBackColor:(UIColor *)toolBackColor{
    _toolBackColor = toolBackColor;
    self.toolView.backgroundColor = toolBackColor;
}

-(void)setSaveTitleColor:(UIColor *)saveTitleColor{
    _saveTitleColor = saveTitleColor;
     [self.saveBtn setTitleColor:saveTitleColor forState:UIControlStateNormal];
}

-(void)setCancleTitleColor:(UIColor *)cancleTitleColor{
    _cancleTitleColor = cancleTitleColor;
    [self.cancelBtn setTitleColor:cancleTitleColor forState:UIControlStateNormal];
}

-(void)setToolTitleColor:(UIColor *)toolTitleColor{
    _toolTitleColor = toolTitleColor;
    self.titleLbl.textColor = toolTitleColor;
}

-(void)setDatePickerColor:(UIColor *)datePickerColor{
    _datePickerColor = datePickerColor;
    self.pickerView.backgroundColor = datePickerColor;
}

/// 配置UIPickerView
- (void)configPickerView {
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.toolView.frame), self.frame.size.width, self.frame.size.height - 44)];
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    self.pickerView.showsSelectionIndicator = YES;
    [self addSubview:self.pickerView];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLbl.text = title;
}

- (void)setDate:(NSString *)date {
    _date = date;
    NSString *newDate = [[date stringByReplacingOccurrencesOfString:@"-" withString:@" "] stringByReplacingOccurrencesOfString:@":" withString:@" "];
    NSMutableArray *timerArray = [NSMutableArray arrayWithArray:[newDate componentsSeparatedByString:@" "]];
    switch (self.datePickerType) {
        case WYLDatePickerTypeYMDHM:
        {
            [timerArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%@年", timerArray[0]]];
            [timerArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%@月", timerArray[1]]];
            [timerArray replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%@日", timerArray[2]]];
            [timerArray replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%@时", timerArray[3]]];
            [timerArray replaceObjectAtIndex:4 withObject:[NSString stringWithFormat:@"%@分", timerArray[4]]];
        }
            break;
         
        case WYLDatePickerTypeYMD:
        {
            [timerArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%@年", timerArray[0]]];
            [timerArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%@月", timerArray[1]]];
            [timerArray replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%@日", timerArray[2]]];
        }
            break;
            
        case WYLDatePickerTypeYM:
        {
            [timerArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%@年", timerArray[0]]];
            [timerArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%@月", timerArray[1]]];
        }
            break;
        case WYLDatePickerTypeY:
        {
            [timerArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%@年", timerArray[0]]];
        }
        default:
            break;
    }
    
   
   
    self.timeArr = timerArray;
}

- (void)setMinuteInterval:(NSInteger)minuteInterval {
    _minuteInterval = minuteInterval;
    
    if (self.datePickerType == WYLDatePickerTypeYMDHM) {
        if (self.minuteArr.count > 0) {
            [self.minuteArr removeAllObjects];
            self.minuteArr = [self configMinuteArray];
            [self.dataArray replaceObjectAtIndex:self.dataArray.count - 1 withObject:self.minuteArr];
        } else {
            self.minuteArr = [self configMinuteArray];
            [self.dataArray addObject:self.minuteArr];
        }
    }
    
    
}

- (void)show {
    self.year = self.timeArr[0];
    [self.pickerView selectRow:[self.yearArr indexOfObject:self.year] inComponent:0 animated:YES];
    if (self.datePickerType != WYLDatePickerTypeY) {
        self.month = [NSString stringWithFormat:@"%ld月", [self.timeArr[1] integerValue]];
        /// 重新格式化转一下，是因为如果是09月/日/时，数据源是9月/日/时,就会出现崩溃
        [self.pickerView selectRow:[self.monthArr indexOfObject:self.month] inComponent:1 animated:YES];        
    }
    
    switch (self.datePickerType) {
        case WYLDatePickerTypeYMDHM:
        {
            self.day = [NSString stringWithFormat:@"%ld日", [self.timeArr[2] integerValue]];
            self.hour = [NSString stringWithFormat:@"%ld时", [self.timeArr[3] integerValue]];
            /** 判断是否时间间隔为1 **/
            if (self.minuteInterval == 1) {
                //若时间间隔为1,直接取时间数组最后的时间值即分钟值
                self.minute = [NSString stringWithFormat:@"%ld分", [self.timeArr[4] integerValue]];
            }else{
                //若时间间隔不为1,则要判断时间数组最后的时间值除以自定义时间间隔,是否有余数:若有余数,那么分钟值为大于时间数组最后的时间值且可以整除时间间隔且是最接近时间数组最后的时间值的数;若没有余数,则直接取时间数组最后的时间值即分钟值
                if ([self.timeArr[4] integerValue] % self.minuteInterval > 0) {
                    self.minute = [NSString stringWithFormat:@"%ld分",([self.timeArr[4] integerValue] / self.minuteInterval + 1)*self.minuteInterval];
                }else{
                    self.minute = [NSString stringWithFormat:@"%ld分", [self.timeArr[4] integerValue]];
                }
            }
            
            [self.pickerView selectRow:[self.dayArr indexOfObject:self.day] inComponent:2 animated:YES];
            [self.pickerView selectRow:[self.hourArr indexOfObject:self.hour] inComponent:3 animated:YES];
            [self.pickerView selectRow:[self.minuteArr indexOfObject:self.minute] inComponent:4 animated:YES];
            
            /// 刷新日
            [self refreshDay];
        }
            break;
        
        case WYLDatePickerTypeYMD:
        {
            self.day = [NSString stringWithFormat:@"%ld日", [self.timeArr[2] integerValue]];
            [self.pickerView selectRow:[self.dayArr indexOfObject:self.day] inComponent:2 animated:YES];
            /// 刷新日
            [self refreshDay];
        }
            break;
            
        case WYLDatePickerTypeYM:
        {
           
        }
            break;
        case WYLDatePickerTypeY:
        {
            
        }
            
        default:
            break;
    }
    
}

#pragma mark - 点击方法
/// 保存按钮点击方法
- (void)saveBtnClick {
    NSLog(@"点击了保存");
    NSString *month = self.month.length == 3 ? [NSString stringWithFormat:@"%ld", self.month.integerValue] : [NSString stringWithFormat:@"0%ld", self.month.integerValue];
    switch (self.datePickerType) {
        case WYLDatePickerTypeYMDHM:
        {
            NSString *day = self.day.length == 3 ? [NSString stringWithFormat:@"%ld", self.day.integerValue] : [NSString stringWithFormat:@"0%ld", self.day.integerValue];
            NSString *hour = self.hour.length == 3 ? [NSString stringWithFormat:@"%ld", self.hour.integerValue] : [NSString stringWithFormat:@"0%ld", self.hour.integerValue];
            NSString *minute = self.minute.length == 3 ? [NSString stringWithFormat:@"%ld", self.minute.integerValue] : [NSString stringWithFormat:@"0%ld", self.minute.integerValue];
            
            self.selectStr = [NSString stringWithFormat:@"%ld-%@-%@ %@:%@", [self.year integerValue], month, day, hour, minute];
        }
            break;
            
        case WYLDatePickerTypeYMD:
        {
            NSString *day = self.day.length == 3 ? [NSString stringWithFormat:@"%ld", self.day.integerValue] : [NSString stringWithFormat:@"0%ld", self.day.integerValue];
            
            self.selectStr = [NSString stringWithFormat:@"%ld-%@-%@", [self.year integerValue], month,day];
        }
            break;
            
        case WYLDatePickerTypeYM:
        {
            self.selectStr = [NSString stringWithFormat:@"%ld-%@", [self.year integerValue], month];
        }
            break;
        case WYLDatePickerTypeY:
        {
            self.selectStr = [NSString stringWithFormat:@"%ld",self.year.integerValue];
            break;
        }
        default:
            break;
    }
    
    
    if ([self.delegate respondsToSelector:@selector(datePickerViewSaveBtnClickDelegate:)]) {
        [self.delegate datePickerViewSaveBtnClickDelegate:self.selectStr];
    }
}
/// 取消按钮点击方法
- (void)cancelBtnClick {
    NSLog(@"点击了取消");
    if ([self.delegate respondsToSelector:@selector(datePickerViewCancelBtnClickDelegate)]) {
        [self.delegate datePickerViewCancelBtnClickDelegate];
    }
}
#pragma mark - UIPickerViewDelegate and UIPickerViewDataSource
/// UIPickerView返回多少组
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return self.dataArray.count;
}

/// UIPickerView返回每组多少条数据
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (_isForbidCirculate) {
        return [self.dataArray[component] count];
    } else {
        return  [self.dataArray[component] count] * 200;        
    }
}

/// UIPickerView选择哪一行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSInteger time_integerValue = [self.timeArr[component] integerValue];
    
    if (self.datePickerType == WYLDatePickerTypeYMDHM) {
        
        switch (component) {
            case 0: { // 年
                
                NSString *year_integerValue = self.yearArr[row%[self.dataArray[component] count]];
                if (!self.isSlide) {
                    self.year = year_integerValue;
                    return;
                }
                if (year_integerValue.integerValue < time_integerValue) {
                    [pickerView selectRow:[self.dataArray[component] indexOfObject:self.timeArr[component]] inComponent:component animated:YES];
                } else {
                    self.year = year_integerValue;
                    /// 刷新日
                    [self refreshDay];
                    /// 根据当前选择的年份和月份获取当月的天数
                    NSString *dayStr = [self getDayNumber:[self.year integerValue] month:[self.month integerValue]];
                    if (self.dayArr.count > [dayStr integerValue]) {
                        if (self.day.integerValue > [dayStr integerValue]) {
                            [pickerView selectRow:[self.dataArray[2] indexOfObject:[dayStr stringByAppendingString:@"日"]] inComponent:2 animated:YES];
                            self.day = [dayStr stringByAppendingString:@"日"];
                        }
                    }
                }
            } break;
            case 1: { // 月
                
                NSString *month_value = self.monthArr[row%[self.dataArray[component] count]];
                
                if (!self.isSlide) {
                    self.month = month_value;
                    /// 刷新日
                    [self refreshDay];
                    return;
                }
                
                // 如果选择年大于当前年 就直接赋值月
                if ([self.year integerValue] > [self.timeArr[0] integerValue]) {
                    
                    self.month = month_value;
                    
                    /// 根据当前选择的年份和月份获取当月的天数
                    NSString *dayStr = [self getDayNumber:[self.year integerValue] month:[self.month integerValue]];
                    if (self.dayArr.count > [dayStr integerValue]) {
                        if (self.day.integerValue > [dayStr integerValue]) {
                            if (self.isSlide) {
                                [pickerView selectRow:[self.dataArray[2] indexOfObject:[dayStr stringByAppendingString:@"日"]] inComponent:2 animated:YES];
                                self.day = [dayStr stringByAppendingString:@"日"];
                            } else {
                                self.month = month_value;
                            }
                        }
                    }
                    // 如果选择的年等于当前年，就判断月份
                } else if ([self.year integerValue] == [self.timeArr[0] integerValue]) {
                    // 如果选择的月份小于当前月份 就刷新到当前月份
                    if (month_value.integerValue < [self.timeArr[component] integerValue]) {
                        if (self.isSlide) {
                            [pickerView selectRow:[self.dataArray[component] indexOfObject:[NSString stringWithFormat:@"%ld月", [self.timeArr[component] integerValue]]] inComponent:component animated:YES];
                        } else {
                            self.month = month_value;
                        }
                        // 如果选择的月份大于当前月份，就直接赋值月份
                    } else {
                        self.month = month_value;
                        
                        /// 根据当前选择的年份和月份获取当月的天数
                        NSString *dayStr = [self getDayNumber:[self.year integerValue] month:[self.month integerValue]];
                        if (self.dayArr.count > dayStr.integerValue) {
                            if (self.day.integerValue > dayStr.integerValue) {
                                [pickerView selectRow:[self.dataArray[2] indexOfObject:[dayStr stringByAppendingString:@"日"]] inComponent:2 animated:YES];
                                self.day = [dayStr stringByAppendingString:@"日"];
                            }
                        }
                    }
                }
                
                /// 刷新日
                [self refreshDay];
                
            } break;
            case 2: { // 日
                /// 根据当前选择的年份和月份获取当月的天数
                NSString *dayStr = [self getDayNumber:[self.year integerValue] month:[self.month integerValue]];
                // 如果选择年大于当前年 就直接赋值日
                NSString *day_value = self.dayArr[row%[self.dataArray[component] count]];
                
                if (!self.isSlide) {
                    self.day = day_value;
                    return;
                }
                
                if ([self.year integerValue] > [self.timeArr[0] integerValue]) {
                    if (self.dayArr.count <= [dayStr integerValue]) {
                        self.day = day_value;
                    } else {
                        if (day_value.integerValue <= [dayStr integerValue]) {
                            self.day = day_value;
                        } else {
                            [pickerView selectRow:[self.dataArray[component] indexOfObject:[dayStr stringByAppendingString:@"日"]] inComponent:component animated:YES];
                        }
                    }
                    // 如果选择的年等于当前年，就判断月份
                } else if ([self.year integerValue] == [self.timeArr[0] integerValue]) {
                    // 如果选择的月份大于当前月份 就直接复制
                    if ([self.month integerValue] > [self.timeArr[1] integerValue]) {
                        if (self.dayArr.count <= [dayStr integerValue]) {
                            self.day = day_value;
                        } else {
                            if (day_value.integerValue <= [dayStr integerValue]) {
                                self.day = day_value;
                            } else {
                                [pickerView selectRow:[self.dataArray[component] indexOfObject:[dayStr stringByAppendingString:@"日"]] inComponent:component animated:YES];
                            }
                        }
                        // 如果选择的月份等于当前月份，就判断日
                    } else if ([self.month integerValue] == [self.timeArr[1] integerValue]) {
                        // 如果选择的日小于当前日，就刷新到当前日
                        if (day_value.integerValue < [self.timeArr[component] integerValue]) {
                            if (self.isSlide) {
                                [pickerView selectRow:[self.dataArray[component] indexOfObject:[NSString stringWithFormat:@"%ld日", time_integerValue]] inComponent:component animated:YES];
                            } else {
                                self.day = day_value;
                            }
                            // 如果选择的日大于当前日，就复制日
                        } else {
                            if (self.dayArr.count <= [dayStr integerValue]) {
                                self.day = day_value;
                            } else {
                                if ([self.dayArr[row%[self.dataArray[component] count]] integerValue] <= [dayStr integerValue]) {
                                    self.day = day_value;
                                } else {
                                    [pickerView selectRow:[self.dataArray[component] indexOfObject:[dayStr stringByAppendingString:@"日"]] inComponent:component animated:YES];
                                }
                            }
                        }
                    }
                }
            } break;
            case 3: { // 时
                NSString *hour_value = self.hourArr[row%[self.dataArray[component] count]];
                if (!self.isSlide) {
                    self.hour = hour_value;
                    return;
                }
                // 如果选择年大于当前年 就直接赋值时
                if ([self.year integerValue] > [self.timeArr[0] integerValue]) {
                    self.hour = hour_value;
                    // 如果选择的年等于当前年，就判断月份
                } else if ([self.year integerValue] == [self.timeArr[0] integerValue]) {
                    // 如果选择的月份大于当前月份 就直接复制时
                    if ([self.month integerValue] > [self.timeArr[1] integerValue]) {
                        self.hour = hour_value;
                        // 如果选择的月份等于当前月份，就判断日
                    } else if ([self.month integerValue] == [self.timeArr[1] integerValue]) {
                        // 如果选择的日大于当前日，就直接复制时
                        if ([self.day integerValue] > [self.timeArr[2] integerValue]) {
                            self.hour = hour_value;
                            // 如果选择的日等于当前日，就判断时
                        } else if ([self.day integerValue] == [self.timeArr[2] integerValue]) {
                            // 如果选择的时小于当前时，就刷新到当前时
                            if ([self.hourArr[row%[self.dataArray[component] count]] integerValue] < [self.timeArr[3] integerValue]) {
                                [pickerView selectRow:[self.dataArray[component] indexOfObject:self.timeArr[component]] inComponent:component animated:YES];
                                // 如果选择的时大于当前时，就直接赋值
                            } else {
                                self.hour = hour_value;
                            }
                        }
                    }
                }
            } break;
            case 4: { // 分
                
                NSString *minute_value = self.minuteArr[row%[self.dataArray[component] count]];
                if (!self.isSlide) {
                    self.minute = minute_value;
                    return;
                }
                
                // 如果选择年大于当前年 就直接赋值时
                 if ([self.year integerValue] > [self.timeArr[0] integerValue]) {
                     self.minute = minute_value;
                     // 如果选择的年等于当前年，就判断月份
                       } else if ([self.year integerValue] == [self.timeArr[0] integerValue]) {
                            // 如果选择的月份大于当前月份 就直接赋值时
                            if ([self.month integerValue] > [self.timeArr[1] integerValue]) {
                               self.minute = minute_value;
                                // 如果选择的月份等于当前月份，就判断日
                            } else if ([self.month integerValue] == [self.timeArr[1] integerValue]) {
                                // 如果选择的日大于当前日，就直接复制时
                                if ([self.day integerValue] > [self.timeArr[2] integerValue]) {
                                    self.minute = minute_value;
                                    // 如果选择的日等于当前日，就判断时
                                } else if ([self.day integerValue] == [self.timeArr[2] integerValue]) {
                                    // 如果选择的时大于当前时，就直接赋值
                                    if ([self.hour integerValue] > [self.timeArr[3] integerValue]) {
                                        self.minute = minute_value;
                                    // 如果选择的时等于当前时,就判断分
                                    } else if ([self.hour integerValue] == [self.timeArr[3] integerValue]) {
                                        // 如果选择的分小于当前分，就刷新分
                                        if ([self.minuteArr[row%[self.dataArray[component] count]] integerValue] < [self.timeArr[4] integerValue]) {
                                            
                                            NSString *minute = @"";
                                            
                                            if (self.minuteInterval == 1) {
                                                /** 时间间隔为1,分钟值选择时间数组最后的时间值即分钟值 **/
                                                minute = self.timeArr[component];
                                                
                                            }else{
                                                /** 若时间间隔不为1,则要判断时间数组最后的时间值除以自定义时间间隔,是否有余数:若有余数,那么分钟值为大于时间数组最后的时间值且可以整除时间间隔且是最接近时间数组最后的时间值的数;若没有余数,则直接取时间数组最后的时间值即分钟值 **/
                                                if ([self.timeArr[4] integerValue] % self.minuteInterval > 0) {
                                                    minute = [NSString stringWithFormat:@"%ld分",([self.timeArr[4] integerValue] / self.minuteInterval + 1)*self.minuteInterval];
                                                    
                                                    
                                                }else{
                                                    minute = [NSString stringWithFormat:@"%ld分", [self.timeArr[4] integerValue]];
                                                   
                                                }
                                            }
                                            
                                            /** 最后根据分钟值获取时间分钟数总数组中的最小下标,然后让pickerView选择相应的行 **/
                                            [pickerView selectRow:[self.dataArray[component] indexOfObject:minute] inComponent:component animated:YES];
                                           
                                        // 如果选择分大于当前分，就直接赋值
                                        } else {
                                            self.minute = minute_value;
                                            }
                                        }
                                    }
                                }
                            }
            } break;
            default: break;
        }
        
    }else if (self.datePickerType == WYLDatePickerTypeYMD){
        
        switch (component) {
            case 0: { // 年
                
                NSString *year_integerValue = self.yearArr[row%[self.dataArray[component] count]];
                if (!self.isSlide) {
                    self.year = year_integerValue;
                    return;
                }
                if (year_integerValue.integerValue < time_integerValue) {
                    [pickerView selectRow:[self.dataArray[component] indexOfObject:self.timeArr[component]] inComponent:component animated:YES];
                } else {
                    self.year = year_integerValue;
                    /// 刷新日
                    [self refreshDay];
                    /// 根据当前选择的年份和月份获取当月的天数
                    NSString *dayStr = [self getDayNumber:[self.year integerValue] month:[self.month integerValue]];
                    if (self.dayArr.count > [dayStr integerValue]) {
                        if (self.day.integerValue > [dayStr integerValue]) {
                            [pickerView selectRow:[self.dataArray[2] indexOfObject:[dayStr stringByAppendingString:@"日"]] inComponent:2 animated:YES];
                            self.day = [dayStr stringByAppendingString:@"日"];
                        }
                    }
                    
                }
            } break;
            case 1: { // 月
                
                NSString *month_value = self.monthArr[row%[self.dataArray[component] count]];
                
                if (!self.isSlide) {
                    self.month = month_value;
                    /// 刷新日
                    [self refreshDay];
                    return;
                }
                
                // 如果选择年大于当前年 就直接赋值月
                if ([self.year integerValue] > [self.timeArr[0] integerValue]) {
                    
                    self.month = month_value;
                    /// 根据当前选择的年份和月份获取当月的天数
                    NSString *dayStr = [self getDayNumber:[self.year integerValue] month:[self.month integerValue]];
                    if (self.dayArr.count > [dayStr integerValue]) {
                        if (self.day.integerValue > [dayStr integerValue]) {
                            if (self.isSlide) {
                                [pickerView selectRow:[self.dataArray[2] indexOfObject:[dayStr stringByAppendingString:@"日"]] inComponent:2 animated:YES];
                                self.day = [dayStr stringByAppendingString:@"日"];
                            } else {
                                self.month = month_value;
                            }
                        }
                    }
                    
                    // 如果选择的年等于当前年，就判断月份
                } else if ([self.year integerValue] == [self.timeArr[0] integerValue]) {
                    // 如果选择的月份小于当前月份 就刷新到当前月份
                    if (month_value.integerValue < [self.timeArr[component] integerValue]) {
                        if (self.isSlide) {
                            [pickerView selectRow:[self.dataArray[component] indexOfObject:[NSString stringWithFormat:@"%ld月", [self.timeArr[component] integerValue]]] inComponent:component animated:YES];
                        } else {
                            self.month = month_value;
                        }
                        // 如果选择的月份大于当前月份，就直接赋值月份
                    } else {
                        self.month = month_value;
                        
                        /// 根据当前选择的年份和月份获取当月的天数
                        NSString *dayStr = [self getDayNumber:[self.year integerValue] month:[self.month integerValue]];
                        if (self.dayArr.count > dayStr.integerValue) {
                            if (self.day.integerValue > dayStr.integerValue) {
                                [pickerView selectRow:[self.dataArray[2] indexOfObject:[dayStr stringByAppendingString:@"日"]] inComponent:2 animated:YES];
                                self.day = [dayStr stringByAppendingString:@"日"];
                            }
                        }
                        
                    }
                }
                
                /// 刷新日
                [self refreshDay];
                
            } break;
                
            case 2: { // 日
                /// 根据当前选择的年份和月份获取当月的天数
                NSString *dayStr = [self getDayNumber:[self.year integerValue] month:[self.month integerValue]];
                // 如果选择年大于当前年 就直接赋值日
                NSString *day_value = self.dayArr[row%[self.dataArray[component] count]];
                
                if (!self.isSlide) {
                    self.day = day_value;
                    return;
                }
                
                if ([self.year integerValue] > [self.timeArr[0] integerValue]) {
                    if (self.dayArr.count <= [dayStr integerValue]) {
                        self.day = day_value;
                    } else {
                        if (day_value.integerValue <= [dayStr integerValue]) {
                            self.day = day_value;
                        } else {
                            [pickerView selectRow:[self.dataArray[component] indexOfObject:[dayStr stringByAppendingString:@"日"]] inComponent:component animated:YES];
                        }
                    }
                    // 如果选择的年等于当前年，就判断月份
                } else if ([self.year integerValue] == [self.timeArr[0] integerValue]) {
                    // 如果选择的月份大于当前月份 就直接复制
                    if ([self.month integerValue] > [self.timeArr[1] integerValue]) {
                        if (self.dayArr.count <= [dayStr integerValue]) {
                            self.day = day_value;
                        } else {
                            if (day_value.integerValue <= [dayStr integerValue]) {
                                self.day = day_value;
                            } else {
                                [pickerView selectRow:[self.dataArray[component] indexOfObject:[dayStr stringByAppendingString:@"日"]] inComponent:component animated:YES];
                            }
                        }
                        // 如果选择的月份等于当前月份，就判断日
                    } else if ([self.month integerValue] == [self.timeArr[1] integerValue]) {
                        // 如果选择的日小于当前日，就刷新到当前日
                        if (day_value.integerValue < [self.timeArr[component] integerValue]) {
                            if (self.isSlide) {
                                [pickerView selectRow:[self.dataArray[component] indexOfObject:[NSString stringWithFormat:@"%ld日", time_integerValue]] inComponent:component animated:YES];
                            } else {
                                self.day = day_value;
                            }
                            // 如果选择的日大于当前日，就复制日
                        } else {
                            if (self.dayArr.count <= [dayStr integerValue]) {
                                self.day = day_value;
                            } else {
                                if ([self.dayArr[row%[self.dataArray[component] count]] integerValue] <= [dayStr integerValue]) {
                                    self.day = day_value;
                                } else {
                                    [pickerView selectRow:[self.dataArray[component] indexOfObject:[dayStr stringByAppendingString:@"日"]] inComponent:component animated:YES];
                                }
                            }
                        }
                    }
                }
            }
                
            default: break;
        }
        
    }else if (self.datePickerType == WYLDatePickerTypeYM){
        
        switch (component) {
            case 0: { // 年
                
                NSString *year_integerValue = self.yearArr[row%[self.dataArray[component] count]];
                if (!self.isSlide) {
                    self.year = year_integerValue;
                    return;
                }
                if (year_integerValue.integerValue < time_integerValue) {
                    [pickerView selectRow:[self.dataArray[component] indexOfObject:self.timeArr[component]] inComponent:component animated:YES];
                } else {
                    self.year = year_integerValue;
                }
            } break;
            case 1: { // 月
                
                NSString *month_value = self.monthArr[row%[self.dataArray[component] count]];
                
                if (!self.isSlide) {
                    self.month = month_value;
                    return;
                }
                
                // 如果选择年大于当前年 就直接赋值月
                if ([self.year integerValue] > [self.timeArr[0] integerValue]) {
                    
                    self.month = month_value;
                    
                    // 如果选择的年等于当前年，就判断月份
                } else if ([self.year integerValue] == [self.timeArr[0] integerValue]) {
                    // 如果选择的月份小于当前月份 就刷新到当前月份
                    if (month_value.integerValue < [self.timeArr[component] integerValue]) {
                        if (self.isSlide) {
                            [pickerView selectRow:[self.dataArray[component] indexOfObject:[NSString stringWithFormat:@"%ld月", [self.timeArr[component] integerValue]]] inComponent:component animated:YES];
                        } else {
                            self.month = month_value;
                        }
                        // 如果选择的月份大于当前月份，就直接赋值月份
                    } else {
                        self.month = month_value;
                        
                    }
                }
                
            } break;
                
            default: break;
        }
    } else if (self.datePickerType == WYLDatePickerTypeY) {
        switch (component) {
            case 0: { // 年
                
                NSString *year_integerValue = self.yearArr[row%[self.dataArray[component] count]];
                if (!self.isSlide) {
                    self.year = year_integerValue;
                    return;
                }
                if (year_integerValue.integerValue < time_integerValue) {
                    [pickerView selectRow:[self.dataArray[component] indexOfObject:self.timeArr[component]] inComponent:component animated:YES];
                } else {
                    self.year = year_integerValue;
                }
            } break;
            default:
                break;
        }
    }
    
    
}

/// UIPickerView返回每一行数据
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return  [self.dataArray[component] objectAtIndex:row%[self.dataArray[component] count]];
}
/// UIPickerView返回每一行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44;
}
/// UIPickerView返回每一行的View
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *titleLbl;
    if (!view) {
        titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, 44)];
        titleLbl.font = [UIFont systemFontOfSize:15];
        titleLbl.textAlignment = NSTextAlignmentCenter;
    } else {
        titleLbl = (UILabel *)view;
    }
    titleLbl.text = [self.dataArray[component] objectAtIndex:row%[self.dataArray[component] count]];
    return titleLbl;
}


- (void)pickerViewLoaded:(NSInteger)component row:(NSInteger)row{
    NSUInteger max = 16384;
    NSUInteger base10 = (max/2)-(max/2)%row;
    [self.pickerView selectRow:[self.pickerView selectedRowInComponent:component] % row + base10 inComponent:component animated:NO];
}


/// 获取年份
- (NSMutableArray *)yearArr {
    if (!_yearArr) {
        [self resetYear];
    }
    return _yearArr;
}

- (void)resetYear {
    
    _yearArr = [[NSMutableArray alloc]init];
    for (NSInteger i = self.minYear; i <= self.maxYear; i ++) {
        [_yearArr addObject:[NSString stringWithFormat:@"%ld年", i]];
    }
}

/// 获取月份
- (NSMutableArray *)monthArr {
    //    NSDate *today = [NSDate date];
    //    NSCalendar *c = [NSCalendar currentCalendar];
    //    NSRange days = [c rangeOfUnit:NSCalendarUnitMonth inUnit:NSCalendarUnitYear forDate:today];
    if (!_monthArr) {
        _monthArr = [[NSMutableArray alloc]init];
        for (int i = 1; i <= 12; i ++) {
            [_monthArr addObject:[NSString stringWithFormat:@"%d月", i]];
        }
    }
    return _monthArr;
}

/// 获取当前月的天数
- (NSMutableArray *)dayArr {
    if (!_dayArr) {
        _dayArr = [[NSMutableArray alloc]init];
        for (int i = 1; i <= 31; i ++) {
            [_dayArr addObject:[NSString stringWithFormat:@"%d日", i]];
        }
    }
    return _dayArr;
}

/// 获取小时
- (NSMutableArray *)hourArr {
    if (!_hourArr) {
        _hourArr = [[NSMutableArray alloc]init];
        for (int i = 0; i < 24; i ++) {
            [_hourArr addObject:[NSString stringWithFormat:@"%d时", i]];
        }
    }
    return _hourArr;
}

/// 获取分钟
- (NSMutableArray *)configMinuteArray {
    NSMutableArray *minuteArray = [[NSMutableArray alloc]init];
    for (int i = 0; i <= 60; i ++) {
       
        [minuteArray addObject:[NSString stringWithFormat:@"%d分", i]];
        
    }
    return minuteArray;
}

// 比较选择的时间是否小于当前时间
- (int)compareDate:(NSString *)date01 withDate:(NSString *)date02{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    
    switch (self.datePickerType) {
        case WYLDatePickerTypeYMDHM:
        {
            [df setDateFormat:@"yyyy年,MM月,dd日,HH时,mm分"];
        }
            break;
            
        case WYLDatePickerTypeYMD:
        {
            [df setDateFormat:@"yyyy年,MM月,dd日"];
        }
            break;
            
        case WYLDatePickerTypeYM:
        {
            [df setDateFormat:@"yyyy年,MM月"];
        }
            break;
        case WYLDatePickerTypeY:
        {
            [df setDateFormat:@"yyyy年"];
        }
        default:
            break;
    }
    
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result) {
            //date02比date01大
        case NSOrderedAscending: ci=1;break;
            //date02比date01小
        case NSOrderedDescending: ci=-1;break;
            //date02=date01
        case NSOrderedSame: ci=0;break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1);break;
    }
    return ci;
}


- (void)refreshDay {
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i = 1; i < [self getDayNumber:self.year.integerValue month:self.month.integerValue].integerValue + 1; i ++) {
        [arr addObject:[NSString stringWithFormat:@"%d日", i]];
    }
    
    [self.dataArray replaceObjectAtIndex:2 withObject:arr];
    [self.pickerView reloadComponent:2];
}

- (NSString *)getDayNumber:(NSInteger)year month:(NSInteger)month{
    NSArray *days = @[@"31", @"28", @"31", @"30", @"31", @"30", @"31", @"31", @"30", @"31", @"30", @"31"];
    if (2 == month && 0 == (year % 4) && (0 != (year % 100) || 0 == (year % 400))) {
        return @"29";
    }
    return days[month - 1];
}

#pragma mark - Setter
- (void)setMaxYear:(NSInteger)maxYear {
    
    _maxYear = maxYear;
    
    if (self.dataArray.count) {
        [self resetYear];
        [self.dataArray replaceObjectAtIndex:0 withObject:self.yearArr];
    }
}

- (void)setMinYear:(NSInteger)minYear {
    
    _minYear = minYear;
    if (self.dataArray.count) {
        [self resetYear];
        [self.dataArray replaceObjectAtIndex:0 withObject:self.yearArr];
    }
}

- (void)setIsForbidCirculate:(BOOL)isForbidCirculate {
    
    _isForbidCirculate = isForbidCirculate;
    [self.pickerView reloadAllComponents];
}

@end
