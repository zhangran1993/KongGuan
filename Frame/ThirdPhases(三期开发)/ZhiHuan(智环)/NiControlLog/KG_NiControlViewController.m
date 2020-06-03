//
//  KG_NiControlViewController.m
//  Frame
//
//  Created by zhangran on 2020/4/9.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_NiControlViewController.h"
#import "KG_NiControlCell.h"
#import "KG_NiControlSearchViewController.h"
#import "WYLDatePickerView.h"
@interface KG_NiControlViewController ()<UITableViewDelegate,UITableViewDataSource,WYLDatePickerViewDelegate>{
    
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

@property (nonatomic,strong)WYLDatePickerView *dataPickerview; //选择日期
@end

@implementation KG_NiControlViewController

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
    self.title = [NSString stringWithFormat:@"反向操作日志"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FontSize(18),NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#24252A"]}] ;
    
    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.translucent = NO;
    
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}
//搜索方法
- (void)serachMethod {
    KG_NiControlSearchViewController *vc = [[KG_NiControlSearchViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillAppear");
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
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
    paraDic[@"content"] = @"HCDHT";
    [self.paraArr addObject:paraDic];
    
    
    NSMutableDictionary *paraDic1 = [NSMutableDictionary dictionary];
    paraDic1[@"name"] = @"engineRoomCode";
    paraDic1[@"type"] = @"eq";
    paraDic1[@"content"] = @"";
    [self.paraArr addObject:paraDic1];
    
    
    NSMutableDictionary *paraDic2 = [NSMutableDictionary dictionary];
    paraDic2[@"name"] = @"equipmentGroup";
    paraDic2[@"type"] = @"eq";
    paraDic2[@"content"] = @"security";
    [self.paraArr addObject:paraDic2];
}
- (void)queryData {
    
    
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/atcBackward/log/%d/%d",WebNewHost,self.pageNum,self.pageSize];
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
          
          [FrameBaseRequest showMessage:@"网络链接失败"];
          return ;
      }];
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
    
    
    UIButton *startBtn = [[UIButton  alloc]init];
    [startBtn setTitle:@"2020.03.02" forState:UIControlStateNormal];
    [startBtn setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];
    startBtn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    [searchView addSubview:startBtn];
    [startBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    startBtn.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    startBtn.layer.cornerRadius = 2;
    startBtn.layer.masksToBounds = YES;
    [startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchView.mas_left).offset(107);
        make.width.equalTo(@96);
        make.height.equalTo(@24);
        make.top.equalTo(searchView.mas_top).offset(10);
    }];
    
    UIButton *endBtn = [[UIButton  alloc]init];
    [endBtn setTitle:@"2020.03.02" forState:UIControlStateNormal];
    [endBtn setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];
    endBtn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    [searchView addSubview:endBtn];
    [endBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [endBtn addTarget:self action:@selector(endButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [endBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(startBtn.mas_right).offset(22);
        make.width.equalTo(@96);
        make.height.equalTo(@24);
        make.top.equalTo(searchView.mas_top).offset(10);
    }];
    endBtn.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    endBtn.layer.cornerRadius = 2;
    endBtn.layer.masksToBounds = YES;
    
    UIButton *resetBtn  = [[UIButton alloc]init];
    [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    [searchView addSubview:resetBtn];
    resetBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [resetBtn setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];
    [resetBtn addTarget:self action:@selector(resetButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    return 135;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    KG_NiControlCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_NiControlCell"];
    if (cell == nil) {
        cell = [[KG_NiControlCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_NiControlCell"];
        
    }
    NSDictionary *dataDic = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dataDic = dataDic;
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
}
- (WYLDatePickerView *)dataPickerview
{
    if (!_dataPickerview) {
        WYLDatePickerView *dateView = [[WYLDatePickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300) withDatePickerType:WYLDatePickerTypeYMDHM];
        dateView.delegate = self;
        dateView.title = @"请选择时间";
        dateView.isSlide = YES;
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
    }else {
        self.endStr = timer;
        NSLog(@"%@",self.endStr);
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


@end
