//
//  KG_LiXingWeiHuViewController.m
//  Frame
//
//  Created by zhangran on 2020/4/23.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_TeShuBaoZhangViewController.h"

#import "KG_TeShuBaoZhangCell.h"
@interface KG_TeShuBaoZhangViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *dataArray;


@property (nonatomic ,strong) UIButton *addBtn;

@property (nonatomic ,assign) int pageNum;
@property (nonatomic ,assign) int pageSize;


@property (nonatomic ,strong) NSMutableArray *paraArr;

@end

@implementation KG_TeShuBaoZhangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.pageNum = 1;
    self.pageSize = 10;
    [self createView];
    //初始化为日
    NSDictionary *currDic = [UserManager shareUserManager].currentStationDic;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    paraDic[@"name"] = @"stationCode";
    paraDic[@"type"] = @"eq";
    paraDic[@"content"] = safeString(currDic[@"code"]);
    [self.paraArr addObject:paraDic];
    
   
    [self queryLiXingWeiHuDayData];
}

//按钮添加方法
- (void)addMethod:(UIButton *)button {
    
    if (self.addMethod) {
        self.addMethod(@"teshubaozhang");
    }
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = YES;
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 6)];
        _tableView.tableHeaderView = headView;
        headView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        // 上拉加载
       _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    }
    return _tableView;
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)loadMoreData {
    
    self.pageNum ++;
     
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/atcPatrolRecode/app/routineMaintenance/%d/%d",WebNewHost,self.pageNum,self.pageSize];
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
        
        [self.tableView reloadData];
    } failure:^(NSError *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
       
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
   return self.dataArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KG_TeShuBaoZhangCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_TeShuBaoZhangCell"];
    if (cell == nil) {
        cell = [[KG_TeShuBaoZhangCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_TeShuBaoZhangCell"];
        cell.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.taskButton.tag = indexPath.row;
    NSDictionary *dataDic = self.dataArray[indexPath.row];
    
    cell.dataDic = dataDic;
    cell.taskMethod = ^(NSDictionary * _Nonnull dic) {
        [self getTask:dic];
    };
    return cell;
}
//任务移交接口：
//请求地址：/intelligent/atcSafeguard/updateAtcPatrolRecode
//请求方式：POST
//请求Body：
//{
//    "id": "XXX",                 //任务Id，必填
//    "patrolName": "XXX"         //任务执行负责人Id，必填
////任务移交时修改这个字段为新的任务执行负责人Id即可
//}
//如：
//{
//    "id": "35639b4644874a8d96d3800257f31c66",
//    "patrolName": "1d13c2dc-fb3a-441f-976d-7a7537018245"
//}
- (void)getTask:(NSDictionary *)dataDic {
    NSString *userID = [UserManager shareUserManager].userID ;
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/atcSafeguard/updateAtcPatrolRecode",WebNewHost];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
     paramDic[@"id"] = safeString(dataDic[@"id"]);
        paramDic[@"patrolName"] = safeString(userID);
       
    WS(weakSelf);
    [FrameBaseRequest postWithUrl:FrameRequestURL param:paramDic success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            
            return ;
        }
       
    } failure:^(NSError *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
    NSDictionary *dataDic = self.dataArray[indexPath.row];
    if (self.didsel) {
        self.didsel(dataDic, @"teshubaozhang");
    }
    
}

- (void)createView {
   
    self.addBtn = [[UIButton alloc]init];
    [self.view addSubview:self.addBtn];
    [self.addBtn setBackgroundImage:[UIImage imageNamed:@"add_btnIcon"] forState:UIControlStateNormal];
    [self.addBtn addTarget:self action:@selector(addMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-12.5);
        make.width.height.equalTo(@56);
    }];
    self.addBtn.enabled = NO;
    [self.view bringSubviewToFront:self.addBtn];
}

//获取选择台站特殊保障接口：

- (void)queryLiXingWeiHuDayData {
    
    
    
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/atcPatrolRecode/app/specialSecurity/%d/%d",WebNewHost,self.pageNum,self.pageSize];
    WS(weakSelf);
    [FrameBaseRequest postWithUrl:FrameRequestURL param:self.paraArr success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
          
            return ;
        }
        [self.tableView.mj_footer endRefreshing];
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:result[@"value"][@"records"]] ;
        int pages = [result[@"value"][@"total"] intValue];
        
        if (self.pageSize >= pages) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            if (weakSelf.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [weakSelf.tableView.mj_footer resetNoMoreData];
            }
        }
        
        [self.tableView reloadData];
    } failure:^(NSError *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
       
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dataDic = self.dataArray[indexPath.row];
    if (dataDic.count) {
        
        NSArray *biaoqianArr = dataDic[@"atcPatrolRoomList"];
        if (biaoqianArr.count &&[safeString(dataDic[@"patrolCode"]) isEqualToString:@"fieldInspection"]) {
            return 124;
        }else {
            return 98;
        }
    }
    return  98;
    
}




- (NSMutableArray *)paraArr
{
    if (!_paraArr) {
        _paraArr = [[NSMutableArray alloc] init];
    }
    return _paraArr;
}
@end
