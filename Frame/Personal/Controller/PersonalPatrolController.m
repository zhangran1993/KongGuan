//
//  PersonalPatrolController.m
//  Frame
//
//  Created by hibayWill on 2018/3/18.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//


#import "PersonalPatrolController.h"
#import "PersonalPatrolItems.h"
#import "PGDatePickManager.h"
#import "UIView+LX_Frame.h"
#import "DIYNoDataView.h"
#import "FrameBaseRequest.h"
#import <MJExtension.h>

@interface PersonalPatrolController ()<UITableViewDelegate,UITableViewDataSource,PGDatePickerDelegate,DIYNoDataViewDelegate>

/** 存放数据模型的数组 */

@property (strong, nonatomic) NSMutableArray<PersonalPatrolItems *> * PersonalPatrols;
@property(strong,nonatomic)UITableView *onetableview;
@property(strong,nonatomic)UIButton *dateButton;
@property(strong,nonatomic)UIView * oneView;
@property(strong,nonatomic)UIView * twoView;
@property(strong,nonatomic)UIButton * leftBtn;
@property(strong,nonatomic)UIButton * rightBtn;
/** 请求管理者 */
//@property (nonatomic,weak) AFHTTPSessionManager * manager;
/** 用于加载下一页的参数(页码) */
@property (nonatomic,assign) NSString* dateStrA;
@property (nonatomic,assign) NSInteger viewNum;
@property (nonatomic,assign) NSInteger chooseDay;
//时间选择器
@property(strong,nonatomic)PGDatePicker *DatePicker;
@property NSDate *NdDate;
@property (nonatomic, strong)DIYNoDataView *backView;




@property (nonatomic, strong)  UILabel   *titleLabel;
@property (nonatomic, strong)  UIView    *navigationView;
@property (nonatomic, strong)  UIButton  *rightButton;
@end

@implementation PersonalPatrolController

#pragma mark - 全局常量
//


#pragma mark - life cycle 生命周期方法

- (void)viewDidLoad {
    NSLog(@"viewDidLoad");
    [self createNaviTopView];
       
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:YES];
    self.navigationItem.title = @"值班信息";
    self.view.backgroundColor =  [UIColor  colorWithPatternImage:[UIImage imageNamed:@"personal_gray_bg"]] ;
    _oneView =  [[UIView alloc] initWithFrame:CGRectMake(0,Height_NavBar, WIDTH_SCREEN, HEIGHT_SCREEN)];
    _oneView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_oneView];
    //添加左右按钮
    _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(FrameWidth(80), FrameWidth(30),FrameWidth(60), FrameWidth(60))];
    _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(FrameWidth(510), FrameWidth(30),FrameWidth(60), FrameWidth(60))];
    
    [_leftBtn setImage:[UIImage imageNamed:@"personal_left"] forState:UIControlStateNormal];
    [_rightBtn setImage:[UIImage imageNamed:@"personal_right"] forState:UIControlStateNormal];
    
    [_leftBtn addTarget:self action:@selector(lastDay) forControlEvents:UIControlEventTouchUpInside];
    [_rightBtn addTarget:self action:@selector(nextDay) forControlEvents:UIControlEventTouchUpInside];
    
    [_oneView addSubview:_leftBtn];
    [_oneView addSubview:_rightBtn];
    //添加日期
    _dateButton = [[UIButton alloc] initWithFrame:CGRectMake(FrameWidth(150), FrameWidth(30), FrameWidth(350), FrameWidth(60))];
    [_dateButton.titleLabel setFont:FontSize(16)];
    [_dateButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_oneView addSubview:_dateButton];
    
    
    [self setDateNow];
    [self backBtn];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetNotificationAction) name:kNetworkStatusNotification object:nil];
}


/**
 无数据占位图
 */
- (void)setEmptyDataSetView {
    self.backView = [[DIYNoDataView alloc]initWithFrame:self.onetableview.bounds];
    self.backView.hidden = YES;
    self.backView.delegate = self;
    self.backView.noDataImage.lx_width = self.backView.lx_width;
    self.backView.tipsLabel.lx_width = self.backView.lx_width;
    self.backView.button.frame = CGRectMake(100, CGRectGetMaxY(self.backView.tipsLabel.frame)+20, self.backView.lx_width-200, 40);
    self.backView.userInteractionEnabled = YES;
    [self.onetableview addSubview:self.backView ];
}

- (void)DIYNoDataViewButtonClcik {
     [self setDateNow];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}



/**
 监听网络
 */
- (void)resetNotificationAction {
    if (!IsNetwork) {
        self.PersonalPatrols = nil;
        [self.onetableview reloadData];
        self.backView.hidden = NO;
        self.backView.noDataImage.image = [UIImage imageNamed:@"error_net"];
        self.backView.tipsLabel.text = scrollViewNoNetworkText;
        self.backView.button.hidden = NO;
    } else {
        [self setDateNow];
    }
}



-(void)allView{
    [_twoView removeFromSuperview];
    float tableViewHeight = (int)((self.PersonalPatrols.count+1)/2 ) * FrameWidth(80);
    NSLog(@"xtableViewHeight%f",tableViewHeight);
    if( tableViewHeight> FrameWidth(750)){
        tableViewHeight = FrameWidth(750);
    }
    
    if( tableViewHeight < FrameWidth(640)){
        tableViewHeight = FrameWidth(640);
    }
    _twoView = [[UIView alloc] initWithFrame:CGRectMake(FrameWidth(25), FrameWidth(115), FrameWidth(590), FrameWidth(65) + tableViewHeight)];
    _twoView.backgroundColor = [UIColor  colorWithPatternImage:[UIImage imageNamed:@"personal_gray_bg"]] ;
    _twoView.layer.cornerRadius=6; //设置为图片宽度的一半出来为圆形
    _twoView.layer.borderWidth = 3;
    _twoView.layer.borderColor = [[UIColor colorWithRed:240/255.0 green:233/255.0 blue:233/255.0 alpha:0.5]CGColor];
    [_oneView addSubview:_twoView];
    
    UILabel *position = [[UILabel alloc] initWithFrame:CGRectMake(0, FrameWidth(15), FrameWidth(145), FrameWidth(30))];
    position.text = @"职位";
    position.font = FontSize(17);
    position.textAlignment = NSTextAlignmentCenter;
    [_twoView addSubview:position];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(145), FrameWidth(15), FrameWidth(155), FrameWidth(30))];
    name.text = @"人员";
    name.font = FontSize(17);
    name.textAlignment = NSTextAlignmentCenter;
    [_twoView addSubview:name];
    
    UILabel *position2 = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(300), FrameWidth(15), FrameWidth(145), FrameWidth(30))];
    position2.text = @"职位";
    position2.font = FontSize(17);
    position2.textAlignment = NSTextAlignmentCenter;
    [_twoView addSubview:position2];
    
    UILabel *name2 = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(445), FrameWidth(15), FrameWidth(155), FrameWidth(30))];
    name2.text = @"人员";
    name2.font = FontSize(17);
    name2.textAlignment = NSTextAlignmentCenter;
    [_twoView addSubview:name2];
    [_onetableview removeFromSuperview];
    _onetableview = [[UITableView alloc] initWithFrame:CGRectMake(0, FrameWidth(65), _twoView.frame.size.width, _twoView.frame.size.height - FrameWidth(65))];
    _onetableview.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [_twoView addSubview:_onetableview];
    _onetableview.dataSource = self;
    _onetableview.delegate = self;
    _onetableview.separatorStyle = NO;
    _onetableview.estimatedRowHeight = 0;
    _onetableview.estimatedSectionHeaderHeight = 0;
    _onetableview.estimatedSectionFooterHeight = 0;
    
    _onetableview.rowHeight = FrameWidth(80);//230
    [self setEmptyDataSetView];
    
   // [_onetableview registerNib:[UINib nibWithNibName:NSStringFromClass([FrameNullCell class]) bundle:nil] forCellReuseIdentifier:FrameCellID];
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
    [_dateButton setTitle:[NSString stringWithFormat:@"%@ %@", _dateStrA, weekStr ] forState:UIControlStateNormal];
    [_dateButton addTarget:self action:@selector(dateAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self loadMoreData];
}
#pragma mark - private methods 私有方法


- (void)createNaviTopView {
    
    UIImageView *topImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT +44)];
    [self.view addSubview:topImage1];
    topImage1.backgroundColor  =[UIColor whiteColor];
    UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT + 44)];
    [self.view addSubview:topImage];
    topImage.backgroundColor  =[UIColor whiteColor];
    topImage.image = [self createImageWithColor:[UIColor clearColor]];
    /** 导航栏 **/
    self.navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Height_NavBar)];
    self.navigationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navigationView];
    
    /** 添加标题栏 **/
    [self.navigationView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.navigationView.mas_centerX);
        make.top.equalTo(self.navigationView.mas_top).offset(Height_StatusBar+9);
    }];
    self.titleLabel.text = @"值班表";
    
    /** 返回按钮 **/
    UIButton * backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, (Height_NavBar -44)/2, 44, 44)];
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
   
}

- (void)backButtonClick:(UIButton *)button {
   
     [self.navigationController popViewControllerAnimated:YES];
    
    
}
/** 标题栏 **/
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel * titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}


-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:YES];
}


#pragma mark - 请求数据方法
/**
 *  发送请求并获取数据方法
 */




-(void)viewWillDisappear:(BOOL)animated{
}

-(void)viewDidDisappear:(BOOL)animated{
    
}
-(void)viewAppear:(BOOL)animated{
    
}






/**
 *  加载更多数据
 */
- (void)loadMoreData{
    //_dateStrA = @"2018-10-16";
    NSString * current_date = [NSString stringWithFormat:@"/intelligent/api/dutyList/%@",_dateStrA];
    
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:current_date];
   
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil  success:^(id result) {
        
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
//        _onetableview.emptyDataSetDelegate = self;
        if(code  <= -1){
            [self allView];
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        
        self.PersonalPatrols = [[PersonalPatrolItems class] mj_objectArrayWithKeyValuesArray:[result objectForKey:@"value"]];
        [self allView];
        if (self.PersonalPatrols.count > 0) {
            self.backView.button.hidden = YES;
            self.backView.hidden = YES;
             [_onetableview reloadData];
        } else {
            self.backView.hidden = NO;
            self.backView.button.hidden = YES;
            self.backView.noDataImage.image = [UIImage imageNamed:@"error_date"];
            self.backView.tipsLabel.text = scrollViewNoDataText;
            [_onetableview reloadData];
        }
        
    } failure:^(NSURLSessionDataTask *error)  {
//        _onetableview.emptyDataSetDelegate = self;
        NSMutableArray *dataMutableArray = [NSMutableArray array];
        self.PersonalPatrols = [dataMutableArray copy];
        [self.onetableview reloadData];
        self.backView.hidden = NO;
        self.backView.noDataImage.image = [UIImage imageNamed:@"error_net"];
        self.backView.tipsLabel.text = scrollViewNoNetworkText;
        self.backView.button.hidden = NO;
        [self allView];
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
//        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
//            [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
//            [FrameBaseRequest logout];
//            UIViewController *viewCtl = self.navigationController.viewControllers[0];
//            [self.navigationController popToViewController:viewCtl animated:YES];
//            return;
//        }else if(responses.statusCode == 502){
//            
//        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
    
    return ;
}

#pragma mark - UITableviewDatasource 数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return (int)((self.PersonalPatrols.count+1)/2 );//向上取整
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *ID = @"cell";
    // 1.2 去缓存池中取Cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // 1.3 若取不到便创建一个带重用标识的Cell
    if (cell == nil) {
        cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//不可选择
    
    
    long nowNum = indexPath.row +1;
    long two = nowNum*2-1;
    long one = two-1;
    if (nowNum%2==0) {//如果是偶数
        cell.backgroundColor = [UIColor colorWithRed:249/255.0 green:250/255.0 blue:250/255.0 alpha:0.8];
    }
    
    PersonalPatrolItems *groupOne = self.PersonalPatrols[one];
    
    UILabel *position = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(5), 0, FrameWidth(150), FrameWidth(80))];
    position.textAlignment = NSTextAlignmentCenter;
    position.numberOfLines = 2;
    position.lineBreakMode = NSLineBreakByCharWrapping;
    position.font =  FontSize(14);
    position.textColor = [UIColor grayColor];
    position.text = [NSString stringWithFormat:@"%@",groupOne.post];//groupOne.post;
    [cell addSubview:position];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(155), 0, FrameWidth(140), FrameWidth(80))];
    name.textAlignment = NSTextAlignmentCenter;
    name.font =  FontSize(14);
    name.numberOfLines = 2;
    name.lineBreakMode = NSLineBreakByCharWrapping;
    name.textColor = [UIColor grayColor];
    name.text = [NSString stringWithFormat:@"%@",groupOne.name];////groupOne.name;
    [cell addSubview:name];
    
    if(two < self.PersonalPatrols.count){
        
        PersonalPatrolItems *groupTwo = self.PersonalPatrols[two];
        
        UILabel *position2 = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(295), 0, FrameWidth(140), FrameWidth(80))];
        position2.textAlignment = NSTextAlignmentCenter;
        position2.numberOfLines = 2;
        position2.lineBreakMode = NSLineBreakByCharWrapping;
        position2.font =  FontSize(14);
        position2.textColor = [UIColor grayColor];
        position2.text =  [NSString stringWithFormat:@"%@",groupTwo.post];//groupTwo.post;
        [cell addSubview:position2];
        
        UILabel *name2 = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(445), 0, FrameWidth(140), FrameWidth(80))];
        name2.textAlignment = NSTextAlignmentCenter;
        name2.font =  FontSize(14);
        name2.numberOfLines = 2;
        name2.lineBreakMode = NSLineBreakByCharWrapping;
        name2.textColor = [UIColor grayColor];
        name2.text = [NSString stringWithFormat:@"%@",groupTwo.name];//groupTwo.name;
        [cell addSubview:name2];
    }
    
    
    if(cell == nil){
        NSLog(@"cell ==nil");
        UITableViewCell *nullcell = [UITableViewCell alloc];
        //[[[NSBundle mainBundle] loadNibNamed:@"FrameNullCell" owner:nil options:nil] objectAtIndex:0];
        return nullcell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 点击了第indexPath.row行Cell所做的操作
    NSLog(@"点击了第%ld行Cell所做的操作",(long)indexPath.row);

}

/*返回*/
-(void)backBtn{
    UIButton *leftButon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    leftButon.frame = CGRectMake(0,0,FrameWidth(60),FrameWidth(60));
    [leftButon setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [leftButon setContentEdgeInsets:UIEdgeInsetsMake(0, - FrameWidth(20), 0, FrameWidth(20))];
    //button.alignmentRectInsetsOverride = UIEdgeInsetsMake(0, offset, 0, -(offset));
    [leftButon addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *fixedButton = [[UIBarButtonItem alloc]initWithCustomView:leftButon];
    self.navigationItem.leftBarButtonItem = fixedButton;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
}

-(void)backAction {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation2"] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController popViewControllerAnimated:YES];
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
    [_dateButton setTitle:[NSString stringWithFormat:@"%@ %@", dateStr, weekStr ] forState:UIControlStateNormal];
    _chooseDay = 0;
    [self loadMoreData];
}
////创建导航栏视图
//-  (void)createNaviTopView {
//    UIButton *leftButon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    leftButon.frame = CGRectMake(0,0,FrameWidth(60),FrameWidth(60));
//    [leftButon setImage:[UIImage imageNamed:@"back_gray"] forState:UIControlStateNormal];
//    [leftButon setContentEdgeInsets:UIEdgeInsetsMake(0, - FrameWidth(20), 0, FrameWidth(20))];
//    //button.alignmentRectInsetsOverride = UIEdgeInsetsMake(0, offset, 0, -(offset));
//    [leftButon addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *fixedButton = [[UIBarButtonItem alloc]initWithCustomView:leftButon];
//    self.navigationItem.leftBarButtonItem = fixedButton;
//
//
//    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
//    self.title = [NSString stringWithFormat:@"值班表"];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FontSize(18),NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#24252A"]}] ;
//
//    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
//
//    self.navigationController.navigationBar.translucent = NO;
//
//    //去掉透明后导航栏下边的黑边
//    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
//}
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

