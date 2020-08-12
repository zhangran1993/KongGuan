//
//  KG_NiControlViewController.m
//  Frame
//
//  Created by zhangran on 2020/4/9.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_AccessCardLogViewController.h"
#import "KG_AccessCardLogCell.h"
#import "KG_NiControlSearchViewController.h"
#import "WYLDatePickerView.h"
#import "ZRDatePickerView.h"
#import "KG_AccessCardLogDataPickerView.h"
@interface KG_AccessCardLogViewController ()<UITableViewDelegate,UITableViewDataSource,AccessDatePickerViewDelegate>{
    
}
@property (nonatomic, strong) UIButton *bgBtn ;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic ,strong) NSMutableArray *paraArr;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UILabel *totolTitle;

@property (nonatomic ,assign) int pageNum;
@property (nonatomic ,assign) int pageSize;
@property (nonatomic ,assign) NSInteger btnIndex;
@property (nonatomic, copy)   NSString *startStr;
@property (nonatomic, copy)   NSString *endStr;

@property (nonatomic, strong) UIButton *accessStartBtn;
@property (nonatomic, strong) UIButton *accessEndBtn;
@property (nonatomic, strong) UIButton *accessResetBtn;
@property (nonatomic,strong)  KG_AccessCardLogDataPickerView *dataPickerview; //选择日期
@end

@implementation KG_AccessCardLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    [self initViewData];
    [self createNaviTopView];
    [self createSearchUI];
    [self setupDataSubviews];
    [self queryData];
    [self.view addSubview:self.dataPickerview];
}

- (void)createNaviTopView {
    UIButton *leftButon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    leftButon.frame = CGRectMake(0,0,FrameWidth(60),FrameWidth(60));
    [leftButon setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
    [leftButon setContentEdgeInsets:UIEdgeInsetsMake(0, - FrameWidth(20), 0, FrameWidth(20))];
    //button.alignmentRectInsetsOverride = UIEdgeInsetsMake(0, offset, 0, -(offset));
    [leftButon addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *fixedButton = [[UIBarButtonItem alloc]initWithCustomView:leftButon];
    self.navigationItem.leftBarButtonItem = fixedButton;
    UIButton *rightButon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightButon.frame = CGRectMake(0,0,24,24);
    [rightButon setImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateNormal];
    rightButon.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightButon setTitleColor:[UIColor colorWithHexString:@"#24252A"] forState:UIControlStateNormal];
    [rightButon addTarget:self action:@selector(serachMethod) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightfixedButton = [[UIBarButtonItem alloc]initWithCustomView:rightButon];
    
    self.navigationItem.rightBarButtonItems = @[rightfixedButton];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.title = [NSString stringWithFormat:@"事件日志"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FontSize(18),NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#24252A"]}] ;
    
    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.translucent = NO;
    
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}
//搜索方法
- (void)serachMethod {
//    KG_NiControlSearchViewController *vc = [[KG_NiControlSearchViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
//
}
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillAppear");
    if (@available(iOS 13.0, *)){
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    }else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    [self.navigationController setNavigationBarHidden:NO];
  
}
-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillDisappear");
    [self.navigationController setNavigationBarHidden:YES];
    
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
- (void)initViewData {
    self.btnIndex = 0;
    self.pageNum = 1;
    self.pageSize = 10;
    //初始化为日
    NSDictionary *currDic = [UserManager shareUserManager].currentStationDic;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    paraDic[@"name"] = @"stationCode";
    paraDic[@"type"] = @"eq";
    paraDic[@"content"] = safeString(self.dic[@"stationCode"]);
    [self.paraArr addObject:paraDic];
    
    
    NSMutableDictionary *paraDic1 = [NSMutableDictionary dictionary];
    paraDic1[@"name"] = @"equipmentCode";
    paraDic1[@"type"] = @"eq";
    paraDic1[@"content"] = safeString(self.dic[@"code"]);

    [self.paraArr addObject:paraDic1];
    
    NSMutableArray *contentArr = [NSMutableArray arrayWithCapacity:0];
   
     
    NSMutableDictionary *paraDic2 = [NSMutableDictionary dictionary];
    paraDic2[@"name"] = @"time";
    paraDic2[@"type"] = @"between";
    paraDic2[@"content"] = contentArr;
    [self.paraArr addObject:paraDic2];
}
- (void)queryData {
    
    
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/DoorEvent/log/%d/%d",WebNewHost,self.pageNum,self.pageSize];
      WS(weakSelf);
      [FrameBaseRequest postWithUrl:FrameRequestURL param:self.paraArr success:^(id result) {
          NSInteger code = [[result objectForKey:@"errCode"] intValue];
          if(code  <= -1){
              [FrameBaseRequest showMessage:result[@"errMsg"]];
              
              return ;
          }
          [self.tableView.mj_footer endRefreshing];
       
          [self.dataArray addObjectsFromArray:result[@"value"][@"records"]] ;
          int pages = [result[@"value"][@"pages"] intValue];
          
          if (self.pageNum >= pages) {
              [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
              
          }else {
              if (weakSelf.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                  [weakSelf.tableView.mj_footer resetNoMoreData];
              }
          }
          self.totolTitle.text = [NSString stringWithFormat:@"共%lu条",(unsigned long)self.dataArray.count];
          
          [self.tableView reloadData];
        
      } failure:^(NSError *error)  {
          FrameLog(@"请求失败，返回数据 : %@",error);
          if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
              [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
              return;
          }
          [FrameBaseRequest showMessage:@"网络链接失败"];
          return ;
      }];
}
      


- (void)loadMoreData {
    self.pageNum ++;
    //全部
    [self queryMoreData];
}
- (void)createSearchUI {
    
    UIView *searchView = [[UIView alloc]init];
    [self.view addSubview:searchView];
    searchView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.height.equalTo(@44);
    }];
    
    self.totolTitle= [[UILabel alloc]initWithFrame:CGRectMake(14, 0, 100, 40)];
   
    self.totolTitle.text = [NSString stringWithFormat:@"共%@条",@"0"];
   
    
    self.totolTitle.textColor = [UIColor colorWithHexString:@"#BABCC4"];
    self.totolTitle.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    self.totolTitle.textAlignment = NSTextAlignmentLeft;
    [searchView addSubview:self.totolTitle];
    [self.totolTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(16);
        make.width.equalTo(@100);
        make.top.equalTo(self.view.mas_top);
        make.height.equalTo(@44);
    }];
    
    
    self.accessStartBtn = [[UIButton  alloc]init];
    [self.accessStartBtn setTitle:@"开始日期" forState:UIControlStateNormal];
    [self.accessStartBtn setTitleColor:[UIColor colorWithHexString:@"#BABCC4"] forState:UIControlStateNormal];
    self.accessStartBtn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    [searchView addSubview:self.accessStartBtn];
    [self.accessStartBtn setImage:[UIImage imageNamed:@"access_startImage"] forState:UIControlStateNormal];
    self.accessStartBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [self.accessStartBtn addTarget:self action:@selector(startButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.accessStartBtn.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    self.accessStartBtn.layer.cornerRadius = 2;
    self.accessStartBtn.layer.masksToBounds = YES;
    [self.accessStartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchView.mas_left).offset(107);
        make.width.equalTo(@96);
        make.height.equalTo(@24);
        make.top.equalTo(searchView.mas_top).offset(10);
    }];
    
    self.accessEndBtn = [[UIButton  alloc]init];
    [self.accessEndBtn setTitle:@"结束日期" forState:UIControlStateNormal];
    [self.accessEndBtn setTitleColor:[UIColor colorWithHexString:@"#BABCC4"] forState:UIControlStateNormal];
    self.accessEndBtn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    [searchView addSubview:self.accessEndBtn];
    self.accessEndBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [self.accessEndBtn setImage:[UIImage imageNamed:@"access_endImage"] forState:UIControlStateNormal];
    [self.accessEndBtn addTarget:self action:@selector(endButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.accessEndBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.accessStartBtn.mas_right).offset(22);
        make.width.equalTo(@96);
        make.height.equalTo(@24);
        make.top.equalTo(searchView.mas_top).offset(10);
    }];
    self.accessEndBtn.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    self.accessEndBtn.layer.cornerRadius = 2;
    self.accessEndBtn.layer.masksToBounds = YES;
    
    self.accessResetBtn = [[UIButton alloc]init];
    [self.accessResetBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [searchView addSubview:self.accessResetBtn];
    self.accessResetBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [self.accessResetBtn setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];
    [self.accessResetBtn addTarget:self action:@selector(resetButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.accessResetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           make.right.equalTo(searchView.mas_right).offset(-16);
           make.width.equalTo(@30);
           make.height.equalTo(@20);
           make.top.equalTo(searchView.mas_top).offset(12);
       }];
}


- (void)startButtonClick:(UIButton *)button {
    self.btnIndex = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.dataPickerview.frame = CGRectMake(0,  self.view.frame.size.height-300, self.view.frame.size.width, 300);
        [self.dataPickerview  show];
    }];
}
- (void)endButtonClick:(UIButton *)button {
    self.btnIndex = 1;
    [UIView animateWithDuration:0.3 animations:^{
        self.dataPickerview.frame = CGRectMake(0,  self.view.frame.size.height-300, self.view.frame.size.width, 300);
        [self.dataPickerview  show];
    }];
}
- (void)resetButtonClick:(UIButton *)button {
    
    if([button.titleLabel.text isEqualToString:@"筛选"]){
        if (self.startStr.length >0 && self.endStr.length >0) {
            [self.accessResetBtn setTitle:@"重置" forState:UIControlStateNormal];
            [self shaixuanMethod];
        }
    }else {
        [self.accessResetBtn setTitle:@"筛选" forState:UIControlStateNormal];
        [self.accessStartBtn setTitle:@"开始日期" forState:UIControlStateNormal];
        [self.accessEndBtn setTitle:@"结束日期" forState:UIControlStateNormal];
        self.startStr = @"";
        self.endStr = @"";
        [self  resetMethod];
    }
    
}
//筛选
- (void)shaixuanMethod {
    
    [self.paraArr removeAllObjects];
    self.pageNum = 1;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    paraDic[@"name"] = @"stationCode";
    paraDic[@"type"] = @"eq";
    paraDic[@"content"] = safeString(self.dic[@"stationCode"]);
    [self.paraArr addObject:paraDic];
    
    
    NSMutableDictionary *paraDic1 = [NSMutableDictionary dictionary];
    paraDic1[@"name"] = @"equipmentCode";
    paraDic1[@"type"] = @"eq";
    paraDic1[@"content"] = safeString(self.dic[@"code"]);
    
    [self.paraArr addObject:paraDic1];
    
    NSMutableArray *contentArr = [NSMutableArray arrayWithCapacity:0];
    if (self.startStr.length >0 && self.endStr.length >0) {
        [contentArr addObject:self.startStr];
        [contentArr addObject:self.endStr];
    }
    
    NSMutableDictionary *paraDic2 = [NSMutableDictionary dictionary];
    paraDic2[@"name"] = @"time";
    paraDic2[@"type"] = @"between";
    paraDic2[@"content"] = contentArr;
    [self.paraArr addObject:paraDic2];
    
    [self.dataArray removeAllObjects];
    [self queryData];
    
}
//重置
- (void)resetMethod {
    [self.paraArr removeAllObjects];
    self.pageNum = 1;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    paraDic[@"name"] = @"stationCode";
    paraDic[@"type"] = @"eq";
    paraDic[@"content"] = safeString(self.dic[@"stationCode"]);
    [self.paraArr addObject:paraDic];
    
    
    NSMutableDictionary *paraDic1 = [NSMutableDictionary dictionary];
    paraDic1[@"name"] = @"equipmentCode";
    paraDic1[@"type"] = @"eq";
    paraDic1[@"content"] = safeString(self.dic[@"code"]);
    
    [self.paraArr addObject:paraDic1];
    
    NSMutableArray *contentArr = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary *paraDic2 = [NSMutableDictionary dictionary];
    paraDic2[@"name"] = @"time";
    paraDic2[@"type"] = @"between";
    paraDic2[@"content"] = contentArr;
    [self.paraArr addObject:paraDic2];
    [self.dataArray removeAllObjects];
    [self queryData];
}
//创建视图
-(void)setupDataSubviews
{
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.
                         view.mas_top).offset(44);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [self.tableView reloadData];

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
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}


- (NSMutableArray *)paraArr {
    if (!_paraArr) {
        _paraArr = [[NSMutableArray alloc] init];
    }
    
    return _paraArr;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.dataArray.count ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dataDic = self.dataArray[indexPath.row];
    if(safeString(dataDic[@"personName"]).length == 0){
        return 80;
    }
    return 107;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    KG_AccessCardLogCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_AccessCardLogCell"];
    if (cell == nil) {
        cell = [[KG_AccessCardLogCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_AccessCardLogCell"];
        
    }
    NSDictionary *dataDic = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dataDic = dataDic;
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
}
- (KG_AccessCardLogDataPickerView *)dataPickerview
{
    if (!_dataPickerview) {
        KG_AccessCardLogDataPickerView *dateView = [[KG_AccessCardLogDataPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300) withDatePickerType:AccessDatePickerTypeYMDHMS];
        dateView.delegate = self;
        dateView.title = @"请选择时间";
        dateView.isSlide = NO;
        dateView.toolBackColor = [UIColor colorWithHexString:@"#F7F7F7"];
        dateView.toolTitleColor = [UIColor colorWithHexString:@"#555555"];
        dateView.saveTitleColor = [UIColor colorWithHexString:@"#EA3425"];
        dateView.cancleTitleColor = [UIColor colorWithHexString:@"#EA3425"];
        _dataPickerview = dateView;
        
    }
    return _dataPickerview;
}
- (NSString *)conversionOfTime:(NSString *)time
{
    NSString *dateStr;
    //2019-03
    NSString *year = [time substringToIndex:4];
    NSString *month = [time substringFromIndex:5];
    dateStr = [NSString stringWithFormat:@"%@年%@期",year,month];
    return dateStr;
}
#pragma mark - customDelegate - Method -
//选择时间确定按钮
- (void)datePickerViewSaveBtnClickDelegate:(NSString *)timer{
    if (self.btnIndex == 0) {
        self.startStr = timer;
        NSLog(@"%@",self.startStr);
        if (self.startStr.length >10) {
            NSString *ss = [self.startStr substringToIndex:10];
            NSString *strUrl = [ss stringByReplacingOccurrencesOfString:@"-" withString:@"."];
             [self.accessStartBtn setTitle:safeString(strUrl) forState:UIControlStateNormal];
        }
        
       
        
    }else {
        self.endStr = timer;
        NSLog(@"%@",self.endStr);
        if (self.endStr.length >10) {
            NSString *ss = [self.endStr substringToIndex:10];
            NSString *strUrl = [ss stringByReplacingOccurrencesOfString:@"-" withString:@"."];
            [self.accessEndBtn setTitle:safeString(strUrl) forState:UIControlStateNormal];
        }
       
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.dataPickerview.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300);
    }];
}
//选择时间取消按钮
- (void)datePickerViewCancelBtnClickDelegate{
    [UIView animateWithDuration:0.3 animations:^{
        self.dataPickerview.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300);
    }];
}

- (void)queryMoreData {
    
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/DoorEvent/log/%d/%d",WebNewHost,self.pageNum,self.pageSize];
    WS(weakSelf);
    [FrameBaseRequest postWithUrl:FrameRequestURL param:self.paraArr success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            
            return ;
        }
        [self.tableView.mj_footer endRefreshing];
        
        [self.dataArray addObjectsFromArray:result[@"value"][@"records"]] ;
        int pages = [result[@"value"][@"pages"] intValue];
        
        if (self.pageNum >= pages) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            if (weakSelf.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [weakSelf.tableView.mj_footer resetNoMoreData];
            }
        }
        self.totolTitle.text = [NSString stringWithFormat:@"共%lu条",(unsigned long)self.dataArray.count];
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}
@end
