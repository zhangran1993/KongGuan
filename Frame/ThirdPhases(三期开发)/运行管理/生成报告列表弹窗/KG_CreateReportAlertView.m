//
//  KG_CreateReportAlertView.m
//  Frame
//
//  Created by zhangran on 2020/6/2.
//  Copyright © 2020 hibaysoft. All rights reserved.
//
#import "KG_CreateReportAlertView.h"
#import "ZRDatePickerView.h"
@interface  KG_CreateReportAlertView()<UITableViewDelegate,UITableViewDataSource,ZRDatePickerViewDelegate>{
    
    
}
@property (nonatomic, strong) UIButton *zhibanBtn ;
@property (nonatomic, strong) UIButton *endBtn;
@property (nonatomic, strong) UIButton *startBtn;

@property (nonatomic, strong) ZRDatePickerView *dataPickerview;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *bgBtn ;

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UIView *centerView;
@property (nonatomic,strong) UIButton *startButton;
@property (nonatomic,strong) UIButton *endButton;
@property (nonatomic, strong) UIView *stationListView;

@property (nonatomic, strong) UIButton *fanweiBtn;
@property (nonatomic,copy) NSString *startTime;
@property (nonatomic,copy) NSString *endTime;

@property (nonatomic,assign) int currIndex;
@end
@implementation KG_CreateReportAlertView

- (instancetype)initWithCondition:(NSDictionary *)condition
{
    self = [super init];
    if (self) {
        NSDate *date = [NSDate date];
        NSString *timeStr=[[self dateFormatWith:@"YYYY-MM-dd HH:mm:ss"] stringFromDate:date];
        self.endTime = timeStr;
        self.dataDic = [condition[@"handoverInfo"] firstObject];
        [self.dataArray addObjectsFromArray:condition[@"handoverInfo"]];
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
    self.centerView = [[UIView alloc] init];
    self.centerView.frame = CGRectMake(52.5,209,270,242);
    self.centerView.backgroundColor = [UIColor whiteColor];
    self.centerView.layer.cornerRadius = 12;
    self.centerView.layer.masksToBounds = YES;
    [self addSubview:self.centerView];
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@270);
        make.height.equalTo(@225);
    }];
    
    //
    UILabel *titleLabel = [[UILabel alloc]init];
    [self.centerView addSubview:titleLabel];
    titleLabel.text = @"生成运行报告";
    titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    titleLabel.font = [UIFont my_font:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    titleLabel.numberOfLines = 1;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerView.mas_centerX);
        make.top.equalTo(self.centerView.mas_top).offset(11);
        make.width.equalTo(@200);
        make.height.equalTo(@24);
    }];
    
    UIView *zhibanView = [[UIView alloc]init];
    [self.centerView addSubview:zhibanView];
    zhibanView.backgroundColor = [UIColor colorWithHexString:@"#F8F9FA"];
    zhibanView.layer.borderColor = [[UIColor colorWithHexString:@"#E6E8ED"] CGColor];
    zhibanView.layer.borderWidth = 0.5;
    [zhibanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView.mas_left).offset(16);
        make.right.equalTo(self.centerView.mas_right).offset(-16);
        make.top.equalTo(titleLabel.mas_bottom).offset(15);
        make.height.equalTo(@24);
    }];
    UIImageView *zhibanLeftIcon = [[UIImageView alloc]init];
    [zhibanView addSubview:zhibanLeftIcon];
    zhibanLeftIcon.image = [UIImage imageNamed:@"jiaojieban_leftIcon"];
    [zhibanLeftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(zhibanView.mas_left).offset(6);
        make.width.height.equalTo(@12);
        make.centerY.equalTo(zhibanView.mas_centerY);
    }];
    UILabel *zhibanLabel = [[UILabel alloc]init];
    [zhibanView addSubview:zhibanLabel];
    zhibanLabel.text = @"值班岗位";
    zhibanLabel.textColor = [UIColor colorWithHexString:@"#BABCC4"];
    zhibanLabel.font = [UIFont systemFontOfSize:12];
    zhibanLabel.font = [UIFont my_font:12];
    [zhibanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(zhibanLeftIcon.mas_right).offset(4);
        make.height.equalTo(@17);
        make.width.equalTo(@100);
        make.centerY.equalTo(zhibanView.mas_centerY);
    }];
    UIImageView *zhibanRightImage = [[UIImageView alloc]init];
    [zhibanView addSubview:zhibanRightImage];
    zhibanRightImage.image = [UIImage imageNamed:@"jiaojieban_rightIcon"];
    [zhibanRightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(zhibanView.mas_right).offset(-2);
        make.width.height.equalTo(@12);
        make.centerY.equalTo(zhibanView.mas_centerY);
    }];
    
    UIButton *bgBtn = [[UIButton alloc]init];
    [zhibanView addSubview:bgBtn];
    
    [bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(zhibanRightImage.mas_left).offset(-2);
        make.height.equalTo(zhibanView.mas_height);
        make.width.equalTo(@100);
        make.centerY.equalTo(zhibanView.mas_centerY);
    }];
    [bgBtn addTarget:self action:@selector(showStationList) forControlEvents:UIControlEventTouchUpInside];
    
    self.zhibanBtn= [[UIButton alloc]init];
    [zhibanView addSubview:self.zhibanBtn];
    [self.zhibanBtn setTitle:@"黄城导航台保障岗" forState:UIControlStateNormal];
    
    if (self.dataDic.count) {
        [self.zhibanBtn setTitle:[CommonExtension getWorkType:self.dataDic[@"post"]] forState:UIControlStateNormal];
    }
    [self.zhibanBtn setTitleColor:[UIColor colorWithHexString:@"#24252A"] forState:UIControlStateNormal];
    self.zhibanBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.zhibanBtn sizeToFit];
    [self.zhibanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(zhibanRightImage.mas_left).offset(-2);
        make.height.equalTo(zhibanView.mas_height);
        make.centerY.equalTo(zhibanView.mas_centerY);
    }];
    [self.zhibanBtn addTarget:self action:@selector(showStationList) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#E6E8ED"];
    [self.centerView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.centerView.mas_bottom).offset(-44);
        make.height.equalTo(@1);
        make.width.equalTo(@270);
        make.left.equalTo(self.centerView.mas_left);
        make.right.equalTo(self.centerView.mas_right);
    }];
    
    UIButton *cancelBtn = [[UIButton alloc]init];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.centerView addSubview:cancelBtn];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelMethod:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView.mas_left);
        make.top.equalTo(lineView.mas_bottom);
        make.width.equalTo(@135);
        make.height.equalTo(@43);
    }];
    
    
    UIButton *confirmBtn = [[UIButton alloc]init];
    [self.centerView addSubview:confirmBtn];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmMethod:) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.centerView.mas_right);
        make.top.equalTo(lineView.mas_bottom);
        make.width.equalTo(@135);
        make.height.equalTo(@43);
    }];
    UIView *botLine = [[UIView alloc]init];
    botLine.backgroundColor = [UIColor colorWithHexString:@"#E6E8ED"];
    [self.centerView addSubview:botLine];
    [botLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerView.mas_centerX);
        make.bottom.equalTo(self.centerView.mas_bottom);
        make.width.equalTo(@1);
        make.height.equalTo(@43);
    }];
    
    
    UIView *endView = [[UIView alloc]init];
    endView.backgroundColor = [UIColor colorWithHexString:@"#F8F9FA"];
    endView.layer.borderWidth = 0.5;
    endView.layer.borderColor = [[UIColor colorWithHexString:@"#E6E8ED"] CGColor];
    [self.centerView addSubview:endView];
    [endView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView.mas_left).offset(16);
        make.right.equalTo(self.centerView.mas_right).offset(-16);
        make.height.equalTo(@24);
        make.bottom.equalTo(lineView.mas_bottom).offset(-13);
    }];
    
    UIImageView *endImage = [[UIImageView alloc]init];
    [endView addSubview:endImage];
    endImage.image = [UIImage imageNamed:@"end_calImage"];
    [endImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@12);
        make.left.equalTo(endView.mas_left).offset(6);
        make.centerY.equalTo(endView.mas_centerY);
    }];
    
    UILabel *endPromptlabel = [[UILabel alloc]init];
    [endView addSubview:endPromptlabel];
    endPromptlabel.text = @"值班结束时间";
    endPromptlabel.textColor = [UIColor colorWithHexString:@"#BABCC4"];
    endPromptlabel.font = [UIFont systemFontOfSize:12];
    endPromptlabel.font = [UIFont my_font:12];
    [endPromptlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(endImage.mas_right).offset(4);
        make.height.equalTo(@17);
        make.width.equalTo(@75);
        make.centerY.equalTo(endView.mas_centerY);
    }];
    
    self.endBtn = [[UIButton alloc]init];
    [endView addSubview:self.endBtn];
    self.endBtn.tag = 0;
    self.endBtn.userInteractionEnabled = NO;
    [self.endBtn addTarget:self action:@selector(selEndTimeMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.endBtn setTitle:@"2020.02.02 08:30:00" forState:UIControlStateNormal];
    self.endBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.endBtn setTitleColor:[UIColor colorWithHexString:@"#24252A"] forState:UIControlStateNormal];
    [self.endBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(endView.mas_right).offset(-1);
        make.left.equalTo(endPromptlabel.mas_right).offset(1);
        make.height.equalTo(endView.mas_height);
        make.top.equalTo(endView.mas_top);
    }];
    
    
    
    
    
    UIView *startView = [[UIView alloc]init];
    startView.backgroundColor = [UIColor colorWithHexString:@"#F8F9FA"];
    startView.layer.borderWidth = 0.5;
    startView.layer.borderColor = [[UIColor colorWithHexString:@"#E6E8ED"] CGColor];
    [self.centerView addSubview:startView];
    [startView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView.mas_left).offset(16);
        make.right.equalTo(self.centerView.mas_right).offset(-16);
        make.height.equalTo(@24);
        make.bottom.equalTo(endView.mas_top).offset(-8);
    }];
    UIImageView *startImage = [[UIImageView alloc]init];
    [startView addSubview:startImage];
    startImage.image = [UIImage imageNamed:@"end_calImage"];
    [startImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@12);
        make.left.equalTo(startView.mas_left).offset(6);
        make.centerY.equalTo(startView.mas_centerY);
    }];
    
    UILabel *startPromptlabel = [[UILabel alloc]init];
    [startView addSubview:startPromptlabel];
    startPromptlabel.text = @"值班结束时间";
    startPromptlabel.textColor = [UIColor colorWithHexString:@"#BABCC4"];
    startPromptlabel.font = [UIFont systemFontOfSize:12];
    startPromptlabel.font = [UIFont my_font:12];
    [startPromptlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(startImage.mas_right).offset(4);
        make.height.equalTo(@17);
        make.width.equalTo(@75);
        make.centerY.equalTo(startView.mas_centerY);
    }];
    
    self.startBtn  = [[UIButton alloc]init];
    [self.startBtn addTarget:self action:@selector(selStartTimeMethod:) forControlEvents:UIControlEventTouchUpInside];
    [startView addSubview:self.startBtn];
    self.startBtn.tag = 0;
    [self.startBtn setTitle:@"2020.02.02 08:30:00" forState:UIControlStateNormal];
    self.startBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.startBtn setTitleColor:[UIColor colorWithHexString:@"#24252A"] forState:UIControlStateNormal];
    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(startView.mas_right).offset(-1);
        make.left.equalTo(startPromptlabel.mas_right).offset(1);
        make.height.equalTo(startView.mas_height);
        make.top.equalTo(startView.mas_top);
    }];
    
    
    
    
    UIView *fanweiView = [[UIView alloc]init];
    fanweiView.backgroundColor = [UIColor colorWithHexString:@"#F8F9FA"];
    fanweiView.layer.borderWidth = 0.5;
    fanweiView.layer.borderColor = [[UIColor colorWithHexString:@"#E6E8ED"] CGColor];
    [self.centerView addSubview:fanweiView];
    [fanweiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView.mas_left).offset(16);
        make.right.equalTo(self.centerView.mas_right).offset(-16);
        make.height.equalTo(@24);
        make.bottom.equalTo(startView.mas_top).offset(-8);
    }];
    
    UIImageView *fanweiImage = [[UIImageView alloc]init];
    [fanweiView addSubview:fanweiImage];
    fanweiImage.image = [UIImage imageNamed:@"end_calImage"];
    [fanweiImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@12);
        make.left.equalTo(fanweiView.mas_left).offset(6);
        make.centerY.equalTo(fanweiView.mas_centerY);
    }];
    
    UILabel *fanweiPromptlabel = [[UILabel alloc]init];
    [fanweiView addSubview:fanweiPromptlabel];
    fanweiPromptlabel.text = @"报告范围";
    fanweiPromptlabel.textColor = [UIColor colorWithHexString:@"#BABCC4"];
    fanweiPromptlabel.font = [UIFont systemFontOfSize:12];
    fanweiPromptlabel.font = [UIFont my_font:12];
    [fanweiPromptlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fanweiImage.mas_right).offset(4);
        make.height.equalTo(@17);
        make.width.equalTo(@100);
        make.centerY.equalTo(fanweiView.mas_centerY);
    }];
    
    self.fanweiBtn = [[UIButton alloc]init];
    [fanweiView addSubview:self.fanweiBtn];
    
    [self.fanweiBtn setTitle:@"黄城导航台" forState:UIControlStateNormal];
    if (self.dataDic.count) {
        [self.fanweiBtn setTitle:safeString(self.dataDic[@"stationName"]) forState:UIControlStateNormal];
    }
    self.fanweiBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.fanweiBtn setTitleColor:[UIColor colorWithHexString:@"#24252A"] forState:UIControlStateNormal];
    [self.fanweiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(fanweiView.mas_right).offset(-8);
        make.left.equalTo(fanweiPromptlabel.mas_right).offset(10);
        make.height.equalTo(fanweiView.mas_height);
        make.top.equalTo(fanweiView.mas_top);
    }];
    if (self.dataDic.count) {
        [self refreshData];
    }
    
}
//取消
- (void)cancelMethod:(UIButton *)button {
    self.hidden = YES;
    [self.textField resignFirstResponder];
}
//确定
- (void)confirmMethod:(UIButton *)button {
    
    if (self.confirmBlockMethod) {
        self.confirmBlockMethod(self.dataDic,self.endTime);
    }
}
- (void)buttonClickMethod:(UIButton *)button {
    self.hidden = YES;
    [self.textField resignFirstResponder];
    [self.textView resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField*)textField {
    
    [textField resignFirstResponder];
    
    return YES;
    
}
//选择岗位

- (void)showStationList {
    self.stationListView = [[UIView alloc]init];
    self.stationListView.backgroundColor = [UIColor whiteColor];
    
    [self.centerView addSubview:self.stationListView];
    
    [self.stationListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.dataArray.count*30));
        make.top.equalTo(self.centerView.mas_top).offset(75);
        make.left.equalTo(self.centerView.mas_left).offset(16);
        make.right.equalTo(self.centerView.mas_right).offset(-16);
        
    }];
    [self.centerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(225 + self.dataArray.count*30 +5));
    }];
    
    [self addSubview:self.tableView];
    self.tableView.layer.borderWidth = 0.5;
    self.tableView.layer.borderColor = [[UIColor colorWithHexString:@"#E6E8ED"] CGColor];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stationListView.mas_top);
        make.left.equalTo(self.stationListView.mas_left);
        make.right.equalTo(self.stationListView.mas_right);
        make.bottom.equalTo(self.stationListView.mas_bottom);
    }];
    
    
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        
    }
    return _tableView;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    NSDictionary *dic = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [CommonExtension getWorkType:safeString(dic[@"post"])];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.font = [UIFont my_font:12];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.dataDic = self.dataArray[indexPath.row];
    [self refreshData];
}
- (void)selEndTimeMethod:(UIButton *)btn{
    self.currIndex = 1;
    [UIView animateWithDuration:0.3 animations:^{
        self.dataPickerview.frame = CGRectMake(0,  self.height-300, self.width, 300);
        [self.dataPickerview  show];
    }];
}
- (void)selStartTimeMethod:(UIButton *)btn{
    self.currIndex = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.dataPickerview.frame = CGRectMake(0,  self.height-300, self.width, 300);
        [self.dataPickerview  show];
    }];
}

- (void)refreshData {
    if (self.dataDic.count) {
        [self.fanweiBtn setTitle:safeString(self.dataDic[@"stationName"]) forState:UIControlStateNormal];
        
        [self.zhibanBtn setTitle:[CommonExtension getWorkType:self.dataDic[@"post"]] forState:UIControlStateNormal];
        [self.startBtn setTitle:safeString(self.dataDic[@"time"]) forState:UIControlStateNormal];
        
        [self.endBtn setTitle:self.endTime forState:UIControlStateNormal];
        
    }
}

//将时间戳转换为时间字符串
- (NSString *)timestampToTimeStr:(NSString *)timestamp {
    if (isSafeObj(timestamp)==NO) {
        return @"-/-";
    }
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:timestamp.integerValue/1000];
    NSString *timeStr=[[self dateFormatWith:@"YYYY-MM-dd HH:mm:ss"] stringFromDate:date];
    //    NSString *timeStr=[[self dateFormatWith:@"YYYY-MM-dd"] stringFromDate:date];
    return timeStr;
    
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

- (ZRDatePickerView *)dataPickerview
{
    if (!_dataPickerview) {
        _dataPickerview = [[ZRDatePickerView alloc] initWithFrame:CGRectMake(0, self.height, self.width, 300) withDatePickerType:ZRDatePickerTypeYMDHMS];
        _dataPickerview.delegate = self;
        _dataPickerview.title = @"请选择时间";
        _dataPickerview.isSlide = NO;
        _dataPickerview.toolBackColor = [UIColor colorWithHexString:@"#F7F7F7"];
        _dataPickerview.toolTitleColor = [UIColor colorWithHexString:@"#555555"];
        _dataPickerview.saveTitleColor = [UIColor colorWithHexString:@"#EA3425"];
        _dataPickerview.cancleTitleColor = [UIColor colorWithHexString:@"#EA3425"];
        
        [self addSubview:_dataPickerview];
        
    }
    return _dataPickerview;
}
- (void)datePickerViewSaveBtnClickDelegate:(NSString *)timer {
    
    
    self.startTime = timer;
    NSMutableDictionary *ddic = [[NSMutableDictionary alloc]initWithDictionary:self.dataDic];
    
    [ddic setValue:self.startTime forKey:@"time"];
    self.dataDic = ddic;
    [self refreshData];
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

@end
