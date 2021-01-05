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
#import "KG_AddressbookViewController.h"

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

@property (nonatomic,copy)      NSString                 *dateStrA;
@property (nonatomic,assign)    NSInteger                viewNum;
@property (nonatomic,assign)    NSInteger                chooseDay;
@property                       NSDate                   *NdDate;
//时间选择器
@property(strong,nonatomic)     PGDatePicker             *DatePicker;

@property (nonatomic,assign)    BOOL                     isClickZhiBan;

@property (nonatomic, copy)     NSString                 *selNameStr;
@property (nonatomic, copy)     NSString                 *selNameId;
@property (nonatomic, strong)   NSDictionary             *selDic;

@property (nonatomic, copy)     NSString                 *currentTime;
@property (nonatomic, copy)     NSString                 *postId;

@end

@implementation KG_DutyManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
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
    self.isClickZhiBan = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToAddressBook) name:@"pushToAddressBook" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addressBookSelPerson:) name:@"addressBookSelPerson" object:nil];
    
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
    self.selDataTitleLabel.font = [UIFont my_font:16];
    self.selDataTitleLabel.numberOfLines = 1;
    [self.selDataTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftBtn.mas_right).offset(6);
        make.right.equalTo(rightBtn.mas_left).offset(-6);
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
    self.isClickZhiBan = YES;
    [self.tableView reloadData];
    
    
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
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , 37)];
    UIView *bgView = [[UIView alloc]init];
    [headView addSubview:bgView];
    bgView.backgroundColor = [UIColor colorWithHexString:@"#F1F5FC"];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView.mas_left).offset(16);
        make.top.equalTo(headView.mas_top);
        make.bottom.equalTo(headView.mas_bottom);
        make.right.equalTo(headView.mas_right).offset(-16);
    }];
    
    UIView *leftView = [[UIView alloc]init];
    [headView addSubview:leftView];
    leftView.backgroundColor = [UIColor colorWithHexString:@"#E7ECF6"];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView.mas_left).offset(16);
        make.top.equalTo(headView.mas_top);
        make.bottom.equalTo(headView.mas_bottom);
        make.width.equalTo(@1);
    }];
    
    UIView *topLineView = [[UIView alloc]init];
    [headView addSubview:topLineView];
    topLineView.backgroundColor = [UIColor colorWithHexString:@"#E7ECF6"];
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView.mas_left).offset(16);
        make.top.equalTo(headView.mas_top);
        make.right.equalTo(headView.mas_right).offset(-16);
        make.height.equalTo(@1);
    }];
    
    UIView *rightLineView = [[UIView alloc]init];
    [headView addSubview:rightLineView];
    rightLineView.backgroundColor = [UIColor colorWithHexString:@"#E7ECF6"];
    [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headView.mas_right).offset(-16);
        make.top.equalTo(headView.mas_top);
        make.bottom.equalTo(headView.mas_bottom);
        make.width.equalTo(@1);
    }];
    
    UIView *botLineView = [[UIView alloc]init];
    [headView addSubview:botLineView];
    botLineView.backgroundColor = [UIColor colorWithHexString:@"#E7ECF6"];
    [botLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headView.mas_right).offset(-16);
        make.bottom.equalTo(headView.mas_bottom);
        make.left.equalTo(headView.mas_left).offset(16);
        make.height.equalTo(@1);
    }];
    
    UILabel *leftLabel = [[UILabel alloc]init];
    [headView addSubview:leftLabel];
    leftLabel.text = @"职位";
    leftLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    leftLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    leftLabel.font = [UIFont my_font:16];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView.mas_left).offset(34);
        make.width.equalTo(@100);
        make.centerY.equalTo(headView.mas_centerY);
        make.height.equalTo(headView.mas_height);
    }];
    
    UILabel *rightLabel = [[UILabel alloc]init];
    [headView addSubview:rightLabel];
    rightLabel.text = @"人员";
    rightLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    rightLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    rightLabel.font = [UIFont my_font:16];
    rightLabel.textAlignment = NSTextAlignmentCenter;
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView.mas_left).offset(SCREEN_WIDTH/2);
        make.right.equalTo(headView.mas_right).offset(-16);
        make.centerY.equalTo(headView.mas_centerY);
        make.height.equalTo(headView.mas_height);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).offset(NAVIGATIONBAR_HEIGHT +21 +38 + 15);
        make.bottom.equalTo(self.view.mas_bottom).offset(-TABBAR_HEIGHT);
    }];
    self.tableView.tableHeaderView = headView;
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *dataDic = self.dataArray[indexPath.row];
    if (self.dataArray.count) {
        if (self.dataArray.count -1 == indexPath.row) {
            cell.botLineView.hidden = NO;
        }else {
            cell.botLineView.hidden = YES;
        }
    }
    if (self.isClickZhiBan ==YES) {
        cell.changeDutyButton.hidden = NO;
    }else {
        cell.changeDutyButton.hidden = YES;
    }
    
    if (indexPath.row %2 == 0) {//如果是偶数
        cell.bgView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }else{//如果是奇数
        
        cell.bgView.backgroundColor = [UIColor colorWithHexString:@"#FBFBFB"];
    }
    cell.ischangeDutyBlock = ^(NSDictionary * _Nonnull dataDic) {
        self.selDic = dataDic;
        [self pushToAddressBook];
    };
    
    
    cell.dataDic = dataDic;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

//查询值班数据
- (void)queryZhiBanData {
    NSString * current_date = [NSString stringWithFormat:@"/intelligent/api/dutyList/%@",self.dateStrA];
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
    self.dateStrA = [dateFormaterA stringFromDate:date];
    
    self.selDataTitleLabel.text = [NSString stringWithFormat:@"%@ %@", self.dateStrA, weekStr ] ;
    
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
    self.dateStrA = dateStr;
    
    self.selDataTitleLabel.text = [NSString stringWithFormat:@"%@ %@", dateStr, weekStr];
    _chooseDay = 0;
    [self queryZhiBanData];
}

- (void)pushToAddressBook {
    
    [UserManager shareUserManager].isSelContact = YES;
    KG_AddressbookViewController *vc = [[KG_AddressbookViewController alloc]init];
    vc.sureBlockMethod = ^(NSString * _Nonnull nameID, NSString * _Nonnull nameStr) {
        
        UIAlertController *alertContor = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@",safeString(self.selDic[@"post"])] message:[NSString stringWithFormat:@"%@>%@",safeString(self.selDic[@"name"]),safeString(nameStr)] preferredStyle:UIAlertControllerStyleAlert];
        [alertContor addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            self.isClickZhiBan = NO;
            [self.tableView reloadData];
            
        }]];
        [alertContor addAction:[UIAlertAction actionWithTitle:@"确定调班" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self queryCurrWithId];
          
           
        }]];
        
        [self presentViewController:alertContor animated:NO completion:nil];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addressBookSelPerson:(NSNotification *)notification {
    NSDictionary *dataDic = notification.userInfo;
    if (dataDic.count) {
        self.selNameStr = safeString(dataDic[@"nameStr"]);
        self.selNameId = safeString(dataDic[@"nameID"]);
      
        [self performSelector:@selector(delayMethod:) withObject:nil afterDelay:0.1f];
        
    }
}

- (void)delayMethod:(id)sender {
    
    UIAlertController *alertContor = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@",safeString(self.selDic[@"post"])] message:[NSString stringWithFormat:@"%@>%@",safeString(self.selDic[@"name"]),safeString(self.selNameStr)] preferredStyle:UIAlertControllerStyleAlert];
          [alertContor addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
              
              self.isClickZhiBan = NO;
              [self.tableView reloadData];
          }]];
          [alertContor addAction:[UIAlertAction actionWithTitle:@"确定调班" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
              [self queryCurrWithId];
             
              
          }]];
          
          [self presentViewController:alertContor animated:NO completion:nil];
}

//查询currenttime ID，用于保存接口使用（）
- (void)queryCurrWithId {
   
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcShiftManagement/%@",self.dateStrA]];
    [FrameBaseRequest postWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code != 0){
            
            return ;
        }
        NSDictionary *resultDic = result[@"value"];
        
        self.currentTime = safeString(resultDic[@"currentTime"]);
        self.postId = safeString(resultDic[@"id"]);
        [self changeDuty:self.selDic];
        
    }  failure:^(NSError *error) {
        NSLog(@"请求失败 原因：%@",error);
        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    } ];
    
}

//调班保存接口
- (void)changeDuty:(NSDictionary *)dataDic {
    
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:@"/intelligent/atcShiftManagement"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.postId.length >0) {
        params[@"id"] = safeString(self.postId);
    }
    if (self.currentTime.length >0) {
        params[@"currentTime"] = safeString(self.currentTime);
    }
    
    for (NSDictionary *dataDic in self.dataArray) {
  
        if([safeString(dataDic[@"alias"]) isEqualToString:safeString(self.selDic[@"alias"])]) {
            
             [params setValue:safeString(self.selNameStr) forKey:safeString(dataDic[@"alias"])];
        }else {
             [params setValue:safeString(dataDic[@"name"]) forKey:safeString(dataDic[@"alias"])];
        }
    }
    [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
    [FrameBaseRequest putWithUrl:FrameRequestURL param:params success:^(id result) {
        [MBProgressHUD hideHUD];
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        [FrameBaseRequest showMessage:@"调班成功"];
        self.isClickZhiBan = NO;
        [self.tableView reloadData];
        [self queryZhiBanData];
        
        
    } failure:^(NSError *error)  {
        [MBProgressHUD hideHUD];
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}


@end
