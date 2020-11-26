//
//  KG_JiaoJieBanRecordViewController.m
//  Frame
//
//  Created by zhangran on 2020/6/1.
//  Copyright © 2020 hibaysoft. All rights reserved.
//
#import "KG_JiaoJieBanRecordViewController.h"
#import "KG_JiaoJieBanRecordCell.h"
#import "WYLDatePickerView.h"
@interface KG_JiaoJieBanRecordViewController ()<UITableViewDelegate,UITableViewDataSource,WYLDatePickerViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *noDataView;
@property (nonatomic,strong)WYLDatePickerView *dataPickerview; //选择日期

@property (nonatomic,strong) UIView *screenView;
@property (nonatomic,strong) UILabel *totalNumLabel;
@property (nonatomic,strong) UIButton *startButton;
@property (nonatomic,strong) UIButton *endButton;
@property (nonatomic,strong) UIButton *resetButton;


@property (nonatomic ,assign) int pageNum;
@property (nonatomic ,assign) int pageSize;
@property (nonatomic ,assign) int currIndex;

@property (nonatomic,copy) NSString *startTime;
@property (nonatomic,copy) NSString *endTime;

@property (nonatomic, strong)  UILabel   *titleLabel;
@property (nonatomic, strong)  UIView    *navigationView;
@property (nonatomic, strong)  UIButton  *rightButton;

@property (nonatomic, strong)  NSMutableArray* jiaojiebanListArr;

@end

@implementation KG_JiaoJieBanRecordViewController
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
    [self.navigationController setNavigationBarHidden:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNum = 1;
    self.pageSize = 20;
    self.currIndex = 0;
    [self createNaviTopView];
    [self createScreenView];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.screenView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [self queryJiaoJieBaneListData];
    
}

- (void)createScreenView{
    self.screenView = [[UIView alloc]init];
    [self.view addSubview:self.screenView];
    [self.screenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@44);
    }];
    self.screenView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    
    
    self.totalNumLabel = [[UILabel alloc]init];
    [self.screenView addSubview:self.totalNumLabel];
    self.totalNumLabel.text = @"共100条";
    self.totalNumLabel.font = [UIFont systemFontOfSize:12];
    self.totalNumLabel.textColor = [UIColor colorWithHexString:@"#BABCC4"];
    [self.totalNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.screenView.mas_left).offset(16);
        make.centerY.equalTo(self.screenView.mas_centerY);
        make.width.equalTo(@100);
        make.height.equalTo(@17);
    }];
    
    self.startButton = [[UIButton alloc]init];
    [self.screenView addSubview:self.startButton];
    [self.startButton setTitle:@"开始日期" forState:UIControlStateNormal];
    [self.startButton setImage:[UIImage imageNamed:@"start_calImage"] forState:UIControlStateNormal];
    self.startButton.layer.cornerRadius =2.f;
    self.startButton.layer.masksToBounds = YES;
//    self.startButton.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
//    self.startButton.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
//
    self.startButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.startButton setTitleColor:[UIColor colorWithHexString:@"#BABCC4"] forState:UIControlStateNormal];
    self.startButton.layer.borderColor = [[UIColor colorWithHexString:@"#E5E7EC"] CGColor];
    self.startButton.layer.borderWidth = 1.f;
//    self.startButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    
    [self.startButton addTarget:self action:@selector(startMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
     self.endButton = [[UIButton alloc]init];
//    self.endButton.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
//    self.endButton.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
//
    self.endButton.layer.cornerRadius =2.f;
    self.endButton.layer.masksToBounds = YES;
    [self.screenView addSubview:self.endButton];
    self.endButton.layer.borderColor = [[UIColor colorWithHexString:@"#E5E7EC"] CGColor];
    self.endButton.layer.borderWidth = 1.f;
    [self.endButton setTitle:@"结束日期" forState:UIControlStateNormal];
    [self.endButton setImage:[UIImage imageNamed:@"end_calImage"] forState:UIControlStateNormal];
    self.endButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.endButton setTitleColor:[UIColor colorWithHexString:@"#BABCC4"] forState:UIControlStateNormal];
    //    self.startButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    
    [self.endButton addTarget:self action:@selector(endMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.resetButton = [[UIButton alloc]init];
    [self.screenView addSubview:self.resetButton];
    [self.resetButton setTitle:@"筛选" forState:UIControlStateNormal];
    
    self.resetButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.resetButton setTitleColor:[UIColor colorWithHexString:@"#BABCC4"] forState:UIControlStateNormal];
    
    
    [self.resetButton addTarget:self action:@selector(screenMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.screenView.mas_right).offset(-15);
        make.centerY.equalTo(self.screenView.mas_centerY);
        make.height.equalTo(@24);
        make.width.equalTo(@35);
    }];
    [self.endButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.resetButton.mas_left).offset(-10);
        make.centerY.equalTo(self.screenView.mas_centerY);
        make.height.equalTo(@24);
        make.width.equalTo(@100);
    }];
    [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.endButton.mas_left).offset(-11);
        make.centerY.equalTo(self.screenView.mas_centerY);
        make.height.equalTo(@24);
        make.width.equalTo(@100);
    }];
}

//筛选
- (void)screenMethod:(UIButton *)btn {
    if(self.startTime.length == 0){
        
        [FrameBaseRequest showMessage:@"请选择开始日期"];
        return;
    }
    if(self.endTime.length == 0){
        
        [FrameBaseRequest showMessage:@"请选择结束日期"];
        return;
    }
    if ([btn.titleLabel.text isEqualToString:@"筛选"]) {
        NSMutableArray *dateArr = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *dateDic in self.jiaojiebanListArr) {
            NSString *ti = [self timestampToTimeStr:safeString(dateDic[@"createTime"])];
            if ([ti isEqualToString:self.startTime] ||[ti isEqualToString:self.endTime]) {
                [dateArr addObject:dateDic];
            }
        }
        self.jiaojiebanListArr = dateArr;
        self.totalNumLabel.text = [NSString stringWithFormat:@"共%lu条",(unsigned long)self.jiaojiebanListArr.count];
        [self.tableView reloadData];
        [self.resetButton setTitle:@"重置" forState:UIControlStateNormal];
    }else {
        
        [self.jiaojiebanListArr removeAllObjects];
        self.pageNum = 1;
        [self queryJiaoJieBaneListData];
        [self.resetButton setTitle:@"筛选" forState:UIControlStateNormal];
        
        [self.startButton setTitle:@"开始日期" forState:UIControlStateNormal];
        [self.startButton setTitleColor:[UIColor colorWithHexString:@"#BABCC4"] forState:UIControlStateNormal];
        
        
        //end
        self.startTime = @"";
        self.endTime = @"";
        [self.endButton setTitle:@"结束日期" forState:UIControlStateNormal];
        [self.endButton setTitleColor:[UIColor colorWithHexString:@"#BABCC4"] forState:UIControlStateNormal];
    }
    
   

}
//开始日期
- (void)startMethod:(UIButton *)button {
    self.currIndex = 0;
      [UIView animateWithDuration:0.3 animations:^{
         self.dataPickerview.frame = CGRectMake(0,  self.view.frame.size.height-300, self.view.frame.size.width, 300);
         [self.dataPickerview  show];
     }];
    
}
//结束日期
- (void)endMethod:(UIButton *)button {
    self.currIndex = 1;
      [UIView animateWithDuration:0.3 animations:^{
         self.dataPickerview.frame = CGRectMake(0,  self.view.frame.size.height-300, self.view.frame.size.width, 300);
         [self.dataPickerview  show];
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

-(void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = YES;
        // 上拉加载
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
    }
    return _tableView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.jiaojiebanListArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 56;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_JiaoJieBanRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_JiaoJieBanRecordCell "];
    if (cell == nil) {
        cell = [[KG_JiaoJieBanRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_JiaoJieBanRecordCell"];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = self.jiaojiebanListArr[indexPath.row];
    cell.dic = dic;
    
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.001)];
    
    return headView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.001;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.001)];
    
    return footView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.001;
}


- (UIView *)noDataView {
    
    if (_noDataView) {
        _noDataView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        UIImageView *iconImage = [[UIImageView alloc]init];
        iconImage.image = [UIImage imageNamed:@"station_ReportNoData@2x"];
        [_noDataView addSubview:iconImage];
        [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@302);
            make.height.equalTo(@153);
            make.centerX.equalTo(_noDataView.mas_centerX);
            make.centerY.equalTo(_noDataView.mas_centerY);
        }];
        
        UILabel *noDataLabel = [[UILabel alloc]init];
        [_noDataView addSubview:noDataLabel];
        noDataLabel.text = @"当前暂无数据";
        noDataLabel.textColor = [UIColor colorWithHexString:@"#BFC6D2"];
        noDataLabel.font = [UIFont systemFontOfSize:12];
        noDataLabel.textAlignment = NSTextAlignmentCenter;
        [noDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_noDataView.mas_centerX);
            make.height.equalTo(@17);
            make.width.equalTo(@200);
            make.top.equalTo(iconImage.mas_bottom).offset(27);
        }];
        
    }
    
    return _noDataView;
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
    self.titleLabel.text = @"交接班记录";
    
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
- (void)queryJiaoJieBaneListData {
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcChangeShiftsRecord/%d/%d",self.pageNum,self.pageSize]];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"post"] = @"";
    params[@"time"] = @"";
    
    [FrameBaseRequest postWithUrl:FrameRequestURL param:params success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code != 0){
            
            return ;
        }
        [self.jiaojiebanListArr addObjectsFromArray: result[@"value"][@"records"] ];
        self.totalNumLabel.text = [NSString stringWithFormat:@"共%lu条",(unsigned long)self.jiaojiebanListArr.count];
        [self.tableView reloadData];
        
        NSLog(@"resultresult %@",result);
        
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
- (void)loadMoreData {
    self.pageNum ++;
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcChangeShiftsRecord/%d/20",self.pageNum ]];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"post"] = @"";
    params[@"time"] = @"";
    WS(weakSelf)
    [FrameBaseRequest postWithUrl:FrameRequestURL param:params success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code != 0){
            
            return ;
        }
        [self.jiaojiebanListArr addObjectsFromArray: result[@"value"][@"records"] ];
        self.totalNumLabel.text = [NSString stringWithFormat:@"共%lu条",(unsigned long)self.jiaojiebanListArr.count];
        int pages = [result[@"value"][@"pages"] intValue];
        
        if (self.pageNum >= pages) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            if (weakSelf.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [weakSelf.tableView.mj_footer resetNoMoreData];
            }
        }
        NSLog(@"resultresult %@",result);
        
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

- (NSMutableArray *)jiaojiebanListArr {
    
    if (!_jiaojiebanListArr) {
        _jiaojiebanListArr = [[NSMutableArray alloc]init];
        
    }
    return _jiaojiebanListArr;
}
- (WYLDatePickerView *)dataPickerview
{
    if (!_dataPickerview) {
        _dataPickerview = [[WYLDatePickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300) withDatePickerType:WYLDatePickerTypeYMD];
        _dataPickerview.delegate = self;
        _dataPickerview.title = @"请选择时间";
        _dataPickerview.isSlide = NO;
        _dataPickerview.toolBackColor = [UIColor colorWithHexString:@"#F7F7F7"];
        _dataPickerview.toolTitleColor = [UIColor colorWithHexString:@"#555555"];
        _dataPickerview.saveTitleColor = [UIColor colorWithHexString:@"#EA3425"];
        _dataPickerview.cancleTitleColor = [UIColor colorWithHexString:@"#EA3425"];
        
        [self.view addSubview:_dataPickerview];
        
    }
    return _dataPickerview;
}
- (void)datePickerViewSaveBtnClickDelegate:(NSString *)timer {
  
    if (self.currIndex == 0) {
        self.startTime = timer;
        //start
         [self.startButton setTitle:timer forState:UIControlStateNormal];
         [self.startButton setTitleColor:[UIColor colorWithHexString:@"#24252A"] forState:UIControlStateNormal];
        
    }else {
        //end
        self.endTime = timer;
         [self.endButton setTitle:timer forState:UIControlStateNormal];
         [self.endButton setTitleColor:[UIColor colorWithHexString:@"#24252A"] forState:UIControlStateNormal];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.dataPickerview.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300);
        
        [self.dataPickerview  show];
    }];
    
}
/**
 取消按钮代理方法
 */
- (void)datePickerViewCancelBtnClickDelegate {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.dataPickerview.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300);
        [self.dataPickerview  show];
    }];
}
//将时间戳转换为时间字符串
- (NSString *)timestampToTimeStr:(NSString *)timestamp {
    if (isSafeObj(timestamp)==NO) {
        return @"-/-";
    }
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:timestamp.integerValue/1000];
    NSString *timeStr=[[self dateFormatWith:@"YYYY-MM-dd"] stringFromDate:date];
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
@end
