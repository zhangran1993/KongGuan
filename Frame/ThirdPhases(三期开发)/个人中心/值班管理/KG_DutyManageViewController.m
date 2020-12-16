//
//  KG_DutyManageViewController.m
//  Frame
//
//  Created by zhangran on 2020/12/10.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_DutyManageViewController.h"
#import "KG_DutyManageCell.h"
#import "PGDatePickManager.h"

@interface KG_DutyManageViewController ()<UITableViewDelegate,UITableViewDataSource,PGDatePickerDelegate>{
    
}

@property (nonatomic, strong)   UITableView              *tableView;

@property (nonatomic, strong)   NSArray                  *dataArray;

@property (nonatomic, strong)   UILabel                  *titleLabel;

@property (nonatomic, strong)   UIView                   *navigationView;

@property (nonatomic, strong)   UIButton                 *rightButton;

@property (nonatomic, strong)   UIView                   *selDataView;

@property (nonatomic, strong)   UILabel                  *selDataTitleLabel;


@property (nonatomic, copy)     NSString                 *currentDateStr;


@property (nonatomic,assign)    NSString* dateStrA;
@property (nonatomic,assign)    NSInteger viewNum;
@property (nonatomic,assign)    NSInteger chooseDay;
@property                       NSDate *NdDate;
//时间选择器
@property(strong,nonatomic)     PGDatePicker *DatePicker;

@end

@implementation KG_DutyManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    // Do any additional setup after loading the view.
    [self createNaviTopView];
    [self createSelDataView];
    [self createTableView];
    [self setDateNow];
    [self queryZhiBanData];
}


-(void)viewWillAppear:(BOOL)animated{
    
    NSLog(@"StationDetailController viewWillAppear");
    if (@available(iOS 13.0, *)){
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    }else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    [self.navigationController setNavigationBarHidden:YES];
 
}

-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillDisappear");

}

- (void)initData {
    
    
}

- (void)createSelDataView {
    
    self.selDataView = [[UIView alloc]init];
    [self.view addSubview:self.selDataView];
    [self.selDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(21);
        make.height.equalTo(@38);
    }];
    
    UIButton *leftBtn = [[UIButton alloc]init];
    [self.selDataView addSubview:leftBtn];
    [leftBtn setImage:[UIImage imageNamed:@"kg_dutymanage_left"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(selTimeLeftMethod:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selDataView.mas_left).offset(68);
        make.width.height.equalTo(@38);
        make.centerY.equalTo(self.selDataView.mas_centerY);
    }];
    
    UIButton *rightBtn = [[UIButton alloc]init];
    [self.selDataView addSubview:rightBtn];
    [rightBtn setImage:[UIImage imageNamed:@"kg_dutymanage_right"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(selTimeRightMethod:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.selDataView.mas_right).offset(-67);
        make.width.height.equalTo(@38);
        make.centerY.equalTo(self.selDataView.mas_centerY);
    }];
    
    UIButton *centerBtn = [[UIButton alloc]init];
    [self.selDataView addSubview:centerBtn];
    
    [centerBtn addTarget:self action:@selector(dateAction) forControlEvents:UIControlEventTouchUpInside];
    [centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftBtn.mas_right).offset(10);
        make.right.equalTo(rightBtn.mas_left).offset(-10);
        make.centerY.equalTo(rightBtn.mas_centerY);
        make.height.equalTo(@40);
    }];
    
    self.selDataTitleLabel = [[UILabel alloc]init];
    [self.selDataView addSubview:self.selDataTitleLabel];
    self.selDataTitleLabel.textColor = [UIColor colorWithHexString:@"#004EC4"];
    self.selDataTitleLabel.font = [UIFont systemFontOfSize:16];
    self.selDataTitleLabel.numberOfLines = 1;
    [self.selDataTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftBtn.mas_right).offset(10);
        make.right.equalTo(rightBtn.mas_left).offset(-10);
        make.centerY.equalTo(rightBtn.mas_centerY);
        make.height.equalTo(@22);
    }];
    
    
}

//左边选择日期
- (void)selTimeLeftMethod :(UIButton *)button {
    
    
    [self lastDay];
}

//右边选择日期
- (void)selTimeRightMethod :(UIButton *)button {
    [self nextDay];
}

- (void)createNaviTopView {
    
    UIImageView *topImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT +44)];
    [self.view addSubview:topImage1];
    topImage1.backgroundColor  =[UIColor whiteColor];
    UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT + 44)];
    [self.view addSubview:topImage];
    topImage.backgroundColor  =[UIColor whiteColor];
    topImage.image = [self createImageWithColor:[UIColor whiteColor]];
    /** 导航栏 **/
    self.navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Height_NavBar)];
    self.navigationView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.navigationView];
    
    /** 添加标题栏 **/
    [self.navigationView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.navigationView.mas_centerX);
        make.top.equalTo(self.navigationView.mas_top).offset(Height_StatusBar+9);
    }];
    self.titleLabel.text = safeString(@"值班管理");
    
    /** 返回按钮 **/
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, (Height_NavBar -44)/2, 44, 44)];
    [backBtn addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@44);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.left.equalTo(self.navigationView.mas_left);
    }];
    
    //按钮设置点击范围扩大.实际显示区域为图片的区域
    UIImageView *leftImage = [[UIImageView alloc] init];
    leftImage.image = IMAGE(@"back_black");
    [backBtn addSubview:leftImage];
    [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backBtn.mas_centerX);
        make.centerY.equalTo(backBtn.mas_centerY);
    }];
    
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.titleLabel.font = FontSize(16);
    
    [self.rightButton setTitleColor:[UIColor colorWithHexString:@"#24252A"] forState:UIControlStateNormal];
    [self.rightButton setTitle:@"调班" forState:UIControlStateNormal];
    
    [self.view addSubview:self.rightButton];
    
    [self.rightButton addTarget:self action:@selector(tiaobanMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@60);
        make.centerY.equalTo(backBtn.mas_centerY);
        make.height.equalTo(@44);
        make.right.equalTo(self.view.mas_right).offset(-10);
    }];
    
}

//调班
- (void)tiaobanMethod {
    
    
}

- (void)backButtonClick:(UIButton *)button {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

/** 标题栏 **/
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
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


- (void)createTableView {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).offset(NAVIGATIONBAR_HEIGHT +21 +38 + 15);
        make.bottom.equalTo(self.view.mas_bottom).offset(-TABBAR_HEIGHT);
    }];
}

-(NSArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = YES;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 37;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_DutyManageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_DutyManageCell"];
    if (cell == nil) {
        cell = [[KG_DutyManageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_DutyManageCell"];
        cell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }
    
    NSDictionary *dataDic = self.dataArray[indexPath.row];
    if (self.dataArray.count) {
        if (self.dataArray.count -1 == indexPath.row) {
            cell.botLineView.hidden = NO;
        }else {
            cell.botLineView.hidden = YES;
        }
    }
    
    if (indexPath.row %2 == 0) {//如果是偶数
  
        cell.bgView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }else{//如果是奇数

        cell.bgView.backgroundColor = [UIColor colorWithHexString:@"#FBFBFB"];
    }
    
    
    cell.dataDic = dataDic;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

//查询值班数据
- (void)queryZhiBanData {
    
    NSString * current_date = [NSString stringWithFormat:@"/intelligent/api/dutyList/%@",_dateStrA];
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:current_date];
    [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil  success:^(id result) {
        [MBProgressHUD hideHUD];
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        //        _onetableview.emptyDataSetDelegate = self;
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        self.dataArray = result[@"value"];
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *error)  {
        [MBProgressHUD hideHUD];
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
    
    return ;
}

-(void)lastDay{
    _chooseDay --;
    [self setDateNow];
}
-(void)nextDay{
    _chooseDay ++;
    [self setDateNow];
}
-(void)setDateNow{
    NSDate *date = [NSDate date];
    if([_NdDate isKindOfClass:[NSNull class]] || [_NdDate isEqual:[NSNull null]] || _NdDate == nil){
        
    }else{
        date = _NdDate;
    }
    if(_chooseDay != 0){
        date = [NSDate dateWithTimeInterval:24*60*60*_chooseDay sinceDate:date];
    }
    //NSDate * date = [NSDate date];//当前时间 NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:date];//前一天 NSDate *nextDay = [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];//后一天
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    comps = [calendar components:unitFlags fromDate:date];
    
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    NSString *weekStr = [weekdays objectAtIndex:comps.weekday];

    NSDateFormatter *dateFormaterA = [[NSDateFormatter alloc]init];
    [dateFormaterA setDateFormat:@"yyyy-MM-dd"];
    _dateStrA = [dateFormaterA stringFromDate:date];

    self.selDataTitleLabel.text = [NSString stringWithFormat:@"%@ %@", _dateStrA, weekStr ] ;
    
    [self queryZhiBanData];
}

//时间选择器

-(void)dateAction{
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    datePickManager.isShadeBackground = true;
    _DatePicker = datePickManager.datePicker;
    _DatePicker.delegate = self;
    _DatePicker.datePickerType = PGPickerViewLineTypeline;
    _DatePicker.isHiddenMiddleText = false;
    _DatePicker.datePickerMode = PGDatePickerModeDate;
    [self presentViewController:datePickManager animated:false completion:nil];
    
}

#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    
    dateComponents.hour = 0;
    dateComponents.minute = 0;
    dateComponents.second = 0;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat =@"yyyy-MM-dd";
    NSCalendar * calendar = [NSCalendar currentCalendar];
    
    // 时间转为字符串
    NSString *dateStr = [formatter stringFromDate:[calendar dateFromComponents:dateComponents]];
    //NSString *dateStr = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)dateComponents.year,(long)dateComponents.month,(long)dateComponents.day];
    NSLog(@"dateStrdateStrdateStr%@",dateStr);
    
    NSCalendar *calendar1 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    
    _NdDate = [calendar1 dateFromComponents:dateComponents];
    
    comps = [calendar components:unitFlags fromDate:_NdDate];
    [calendar components:unitFlags fromDate:_NdDate];
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    NSString *weekStr = [weekdays objectAtIndex:comps.weekday];
    _dateStrA = dateStr;
 
    self.selDataTitleLabel.text = [NSString stringWithFormat:@"%@ %@", dateStr, weekStr];
    _chooseDay = 0;
    [self queryZhiBanData];
}

@end
