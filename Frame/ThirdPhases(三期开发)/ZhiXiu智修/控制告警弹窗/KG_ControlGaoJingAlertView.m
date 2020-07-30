//
//  KG_ControlGaoJingAlertView.m
//  Frame
//
//  Created by zhangran on 2020/5/19.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_ControlGaoJingAlertView.h"
#import "WYLDatePickerView.h"
#import "ZRDatePickerView.h"
@interface  KG_ControlGaoJingAlertView()<ZRDatePickerViewDelegate>{
    
}
@property (nonatomic, strong) UIButton *bgBtn ;

@property (nonatomic, strong) UIButton *startBtn ;
@property (nonatomic, strong) UIButton *endBtn ;
@property (nonatomic, assign) int  currIndex;
@property (nonatomic,strong)ZRDatePickerView *dataPickerview; //选择日期



@property (nonatomic, copy) NSString *startTimeStr ;
@property (nonatomic, copy) NSString *endTimeStr ;
@end
@implementation KG_ControlGaoJingAlertView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
        [self setupDataSubviews];
        
      
    }
    return self;
}
//初始化数据
- (void)initData {
    self.currIndex = 0;
}

//创建视图
-(void)setupDataSubviews
{
    //按钮背景 点击消失
    self.bgBtn = [[UIButton alloc]init];
    [self addSubview:self.bgBtn];
    [self.bgBtn setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    self.bgBtn.alpha = 0.46;
    [self.bgBtn addTarget:self action:@selector(buttonClickMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
        
    UIView *centerView = [[UIView alloc] init];
    centerView.frame = CGRectMake(52.5,209,270,234);
    centerView.backgroundColor = [UIColor whiteColor];
    centerView.layer.cornerRadius = 12;
    centerView.layer.masksToBounds = YES;
    [self addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset((SCREEN_WIDTH -270)/2);
        make.top.equalTo(self.mas_top).offset((SCREEN_HEIGHT -166)/2);;
        make.width.equalTo(@270);
        make.height.equalTo(@166);
       
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [centerView addSubview:titleLabel];
    titleLabel.text = @"抑制告警";
    titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView.mas_left);
        make.top.equalTo(centerView.mas_top).offset(16);
        make.right.equalTo(centerView.mas_right);
        make.height.equalTo(@22);
    }];
    
    UIView *startView = [[UIView alloc]init];
    startView.backgroundColor = [UIColor colorWithHexString:@"#F8F9FA"];
    startView.layer.borderColor = [[UIColor colorWithHexString:@"#E6E8ED"]CGColor];
    startView.layer.borderWidth = 0.5;
    [centerView addSubview:startView];
    [startView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView.mas_left).offset(16);
        make.right.equalTo(centerView.mas_right).offset(-17);
        make.height.equalTo(@24);
        make.top.equalTo(titleLabel.mas_bottom).offset(15);
    }];
    UIImageView *startImage= [[ UIImageView alloc ]init];
    [startView addSubview:startImage];
    startImage.image = [UIImage imageNamed:@"start_calImage"];
    [startImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(startView.mas_left).offset(9);
        make.width.height.equalTo(@12);
        make.centerY.equalTo(startView.mas_centerY);
    }];
    UILabel *startLabel = [[UILabel alloc]init];
    [startView addSubview:startLabel];
    startLabel.text = @"开始时间";
    startLabel.textColor = [UIColor colorWithHexString:@"#BABCC4"];
    startLabel.font = [UIFont systemFontOfSize:12];
    [startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(startImage.mas_right).offset(6);
        make.top.equalTo(startView.mas_top);
        make.bottom.equalTo(startView.mas_bottom);
        make.width.equalTo(@100);
    }];
    
    self.startBtn = [[UIButton alloc]init];
    [startView addSubview:self.startBtn];
    [self.startBtn setTitle:@"请选择" forState:UIControlStateNormal];
    self.startBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.startBtn setTitleColor:[UIColor colorWithHexString:@"#BABCC4"] forState:UIControlStateNormal];
    self.startBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    NSDate *date=[NSDate date];
    NSString *timeStr=[[self dateFormatWith:@"YYYY-MM-dd HH:mm:ss"] stringFromDate:date];
    self.startTimeStr = timeStr;
    [self.startBtn setTitle:timeStr forState:UIControlStateNormal];
    [self.startBtn setTitleColor:[UIColor colorWithHexString:@"#24252A"] forState:UIControlStateNormal];
    if (self.selTime) {
        self.selTime(timeStr,self.currIndex);
    }
    
    [self.startBtn addTarget:self action:@selector(startMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(startView.mas_right).offset(-11);
        make.top.equalTo(startView.mas_top);
        make.bottom.equalTo(startView.mas_bottom);
        make.width.equalTo(@200);
    }];
    
    UIView *endView = [[UIView alloc]init];
    endView.backgroundColor = [UIColor colorWithHexString:@"#F8F9FA"];
    endView.layer.borderColor = [[UIColor colorWithHexString:@"#E6E8ED"]CGColor];
    endView.layer.borderWidth = 0.5;
    [centerView addSubview:endView];
    [endView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView.mas_left).offset(16);
        make.right.equalTo(centerView.mas_right).offset(-17);
        make.height.equalTo(@24);
        make.top.equalTo(startView.mas_bottom).offset(8);
    }];
    
    UIImageView *endImage= [[ UIImageView alloc ]init];
    [endView addSubview:endImage];
    endImage.image = [UIImage imageNamed:@"start_calImage"];
    [endImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(endView.mas_left).offset(9);
        make.width.height.equalTo(@12);
        make.centerY.equalTo(endView.mas_centerY);
    }];
    UILabel *endLabel = [[UILabel alloc]init];
    [endView addSubview:endLabel];
    endLabel.text = @"结束时间";
    endLabel.textColor = [UIColor colorWithHexString:@"#BABCC4"];
    endLabel.font = [UIFont systemFontOfSize:12];
    [endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(endImage.mas_right).offset(6);
        make.top.equalTo(endView.mas_top);
        make.bottom.equalTo(endView.mas_bottom);
        make.width.equalTo(@100);
    }];
    
    self.endBtn = [[UIButton alloc]init];
    [endView addSubview:self.endBtn];
    [self.endBtn setTitle:@"请选择" forState:UIControlStateNormal];
    self.endBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.endBtn setTitleColor:[UIColor colorWithHexString:@"#BABCC4"] forState:UIControlStateNormal];
    self.endBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;


    [self.endBtn addTarget:self action:@selector(endMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.endBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(endView.mas_right).offset(-11);
        make.top.equalTo(endView.mas_top);
        make.bottom.equalTo(endView.mas_bottom);
        make.width.equalTo(@200);
    }];
    
    
    
    
    
    
    
    UIView *lineView = [[UIView alloc]init];
    [centerView addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#E6E8ED"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView.mas_left);
        make.right.equalTo(centerView.mas_right);
        make.height.equalTo(@1);
        make.top.equalTo(endView.mas_bottom).offset(13);
    }];
    
    UIView *lineView1 = [[UIView alloc]init];
    [centerView addSubview:lineView1];
    lineView1.backgroundColor = [UIColor colorWithHexString:@"#E6E8ED"];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView.mas_left).offset(135);
        make.width.equalTo(@1);
        make.top.equalTo(lineView.mas_bottom);
        make.bottom.equalTo(centerView.mas_bottom);
    }];

    UIButton *cancelBtn = [[UIButton alloc]init];
    [self addSubview:cancelBtn];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setBackgroundColor:[UIColor clearColor]];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];

    [cancelBtn addTarget:self action:@selector(cancelMethod:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView.mas_left);
        make.right.equalTo(lineView1.mas_left).offset(-1);
        make.bottom.equalTo(centerView.mas_bottom);
        make.top.equalTo(lineView.mas_bottom).offset(1);
    }];


    UIButton *confirmBtn = [[UIButton alloc]init];
    [self addSubview:confirmBtn];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setBackgroundColor:[UIColor clearColor]];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [confirmBtn setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];

    [confirmBtn addTarget:self action:@selector(confirmMethod:) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineView1.mas_right).offset(1);
        make.right.equalTo(centerView.mas_right);
        make.bottom.equalTo(centerView.mas_bottom);
        make.top.equalTo(lineView.mas_bottom).offset(1);
    }];

    
}

- (void)cancelMethod:(UIButton *)button {
  self.hidden = YES;
    
}
- (void)confirmMethod:(UIButton *)button {
    if (self.startTimeStr.length == 0) {
        [FrameBaseRequest showMessage:@"请选择开始时间"];
        return;
    }
    
    if (self.endTimeStr.length == 0) {
        [FrameBaseRequest showMessage:@"请选择结束时间"];
        return;
    }
    
    
    BOOL result1 = [self.startTimeStr compare:self.endTimeStr]==NSOrderedDescending;
    NSLog(@"result1:%d",result1);
    if (result1==1) {
       
        [FrameBaseRequest showMessage:@"结束时间不能早于开始时间"];
       
        return;
    }
    
  
    
    
    if (self.sureMethod) {
        self.sureMethod();
    }
    self.hidden = YES;
      
}

// 背景按钮点击视图消失
- (void)buttonClickMethod :(UIButton *)btn {
    self.hidden = YES;
   
}


- (void)startMethod:(UIButton *)button {
    self.currIndex = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.dataPickerview.frame = CGRectMake(0, self.height - 300, self.width, 300);
        
        [self.dataPickerview  show];
    }];
}
- (void)endMethod:(UIButton *)button {
    self.currIndex = 1;
    [UIView animateWithDuration:0.3 animations:^{
        self.dataPickerview.frame = CGRectMake(0, self.height - 300, self.width, 300);
        
        [self.dataPickerview  show];
    }];
    
}


- (ZRDatePickerView *)dataPickerview {
    if (!_dataPickerview) {
        ZRDatePickerView *dateView = [[ZRDatePickerView alloc] initWithFrame:CGRectMake(0, self.height, self.width, 300) withDatePickerType:ZRDatePickerTypeYMDHMS];
        dateView.delegate = self;
        dateView.title = @"请选择时间";
        dateView.isSlide = NO;
        dateView.toolBackColor = [UIColor colorWithHexString:@"#F7F7F7"];
        dateView.toolTitleColor = [UIColor colorWithHexString:@"#555555"];
        dateView.saveTitleColor = [UIColor colorWithHexString:@"#EA3425"];
        dateView.cancleTitleColor = [UIColor colorWithHexString:@"#EA3425"];
        _dataPickerview = dateView;
        [self addSubview:dateView];
    }
    return _dataPickerview;
}
- (void)datePickerViewSaveBtnClickDelegate:(NSString *)timer {
    NSString *newTime = [NSString stringWithFormat:@"%@",timer];
    
    if (self.currIndex == 0) {
        self.startTimeStr = newTime;
        //start
         [self.startBtn setTitle:newTime forState:UIControlStateNormal];
         [self.startBtn setTitleColor:[UIColor colorWithHexString:@"#24252A"] forState:UIControlStateNormal];
        
    }else {
        self.endTimeStr = newTime;
        //end
         [self.endBtn setTitle:newTime forState:UIControlStateNormal];
         [self.endBtn setTitleColor:[UIColor colorWithHexString:@"#24252A"] forState:UIControlStateNormal];
    }
    if (self.selTime) {
        self.selTime(newTime,self.currIndex);
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.dataPickerview.frame = CGRectMake(0, self.height, self.width, 300);
        
        [self.dataPickerview  show];
    }];
    
}
/**
 取消按钮代理方法
 */
- (void)datePickerViewCancelBtnClickDelegate {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.dataPickerview.frame = CGRectMake(0, self.height, self.width, 300);
        
        [self.dataPickerview  show];
    }];
}

- (NSDateFormatter *)dateFormatWith:(NSString *)formatStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:formatStr];//@"YYYY-MM-dd HH:mm:ss"
    //设置时区
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    return formatter;
}


@end
