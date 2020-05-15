//
//  KG_LiXingWeiHuViewController.m
//  Frame
//
//  Created by zhangran on 2020/4/23.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_LiXingWeiHuViewController.h"
#import "SegmentTapView.h"
#import "KG_LiXingWeiHuCell.h"
#import "KG_NewContentViewController.h"
@interface KG_LiXingWeiHuViewController ()<SegmentTapViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *dataArray;

@property (nonatomic, strong) SegmentTapView *segment;

@property (nonatomic ,strong) UIButton *addBtn;

@property (nonatomic ,assign) int pageNum;
@property (nonatomic ,assign) int pageSize;


@property (nonatomic ,strong) NSMutableArray *paraArr;

@end

@implementation KG_LiXingWeiHuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segment.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.pageNum = 1;
    self.pageSize = 10;
    
    //初始化为日
    NSDictionary *currDic = [UserManager shareUserManager].currentStationDic;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    paraDic[@"name"] = @"stationCode";
    paraDic[@"type"] = @"eq";
    paraDic[@"content"] = safeString(currDic[@"code"]);
    [self.paraArr addObject:paraDic];
    
    NSMutableDictionary *paraDic1 = [NSMutableDictionary dictionary];
    paraDic1[@"name"] = @"patrolCode";
    paraDic1[@"type"] = @"eq";
    paraDic1[@"content"] = @"daySafeguard";
    [self.paraArr addObject:paraDic1];
    [self queryLiXingWeiHuDayData];
}

//按钮添加方法
- (void)addMethod:(UIButton *)button {
    
    if (self.addMethod) {
        self.addMethod(@"lixingweihu");
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
    KG_LiXingWeiHuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_LiXingWeiHuCell"];
    if (cell == nil) {
        cell = [[KG_LiXingWeiHuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_LiXingWeiHuCell"];
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
- (void)getTask:(NSDictionary *)dataDic {
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/atcSafeguard/updateAtcPatrolRecode",WebNewHost];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    paramDic[@"id"] = @"";
    paramDic[@"patrolName"] = @"";
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
    NSArray *listArray = self.dataArray[indexPath.section][@"taskInfo"];
    if (listArray.count) {
        NSDictionary *dataDic = listArray[indexPath.row];
        if (self.didsel) {
            self.didsel(dataDic, @"lixingweihu");
        }
    }
    
}

- (void)createView {
    self.segment = [[SegmentTapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44) withDataArray:[NSArray arrayWithObjects:@"日维护",@"周/月维护",@"季/年维护",@"巡检", nil] withFont:15];
    self.segment.delegate = self;
    [self.view addSubview:self.segment];
    
    
    self.addBtn = [[UIButton alloc]init];
    [self.view addSubview:self.addBtn];
    [self.addBtn setBackgroundImage:[UIImage imageNamed:@"add_btnIcon"] forState:UIControlStateNormal];
    [self.addBtn addTarget:self action:@selector(addMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-12.5);
        make.width.height.equalTo(@56);
    }];
    [self.view bringSubviewToFront:self.addBtn];
}

//获取选择台站下当天的例行维护任务时间轴接口：

- (void)queryLiXingWeiHuDayData {
    
    
    
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/atcPatrolRecode/app/routineMaintenance/%d/%d",WebNewHost,self.pageNum,self.pageSize];
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
        
        NSArray *biaoqianArr = dataDic[@"atcSpecialTagList"];
        if (biaoqianArr.count) {
            return 118;
        }
    }
    return  98;
}



-(void)selectedIndex:(NSInteger)index{
    NSLog(@"%ld",(long)index);
    [self.paraArr removeAllObjects];
    self.pageNum = 1;
    NSDictionary *currDic = [UserManager shareUserManager].currentStationDic;
    
    if (index == 0) {
        
        NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
        paraDic[@"name"] = @"stationCode";
        paraDic[@"type"] = @"eq";
        paraDic[@"content"] = safeString(currDic[@"code"]);
        [self.paraArr addObject:paraDic];
        
        NSMutableDictionary *paraDic1 = [NSMutableDictionary dictionary];
        paraDic1[@"name"] = @"patrolCode";
        paraDic1[@"type"] = @"eq";
        paraDic1[@"content"] = @"daySafeguard";
        [self.paraArr addObject:paraDic1];
    }else if(index == 1){
        
        
        NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
        paraDic[@"name"] = @"stationCode";
        paraDic[@"type"] = @"eq";
        paraDic[@"content"] = safeString(currDic[@"code"]);
        [self.paraArr addObject:paraDic];
        
        NSMutableDictionary *paraDic1 = [NSMutableDictionary dictionary];
        paraDic1[@"name"] = @"patrolCode";
        paraDic1[@"type"] = @"eq";
        paraDic1[@"content"] = @"weekSafeguard";
        [self.paraArr addObject:paraDic1];
        NSMutableDictionary *paraDic2 = [NSMutableDictionary dictionary];
        paraDic2[@"name"] = @"patrolCode";
        paraDic2[@"type"] = @"eq";
        paraDic2[@"content"] = @"monthSafeguard";
        [self.paraArr addObject:paraDic2];
    }else if (index == 2){
        
        
        NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
        paraDic[@"name"] = @"stationCode";
        paraDic[@"type"] = @"eq";
        paraDic[@"content"] = safeString(currDic[@"code"]);
        [self.paraArr addObject:paraDic];
        
        NSMutableDictionary *paraDic1 = [NSMutableDictionary dictionary];
        paraDic1[@"name"] = @"patrolCode";
        paraDic1[@"type"] = @"eq";
        paraDic1[@"content"] = @"quarterSafeguard";
        [self.paraArr addObject:paraDic1];
        NSMutableDictionary *paraDic2 = [NSMutableDictionary dictionary];
        paraDic2[@"name"] = @"patrolCode";
        paraDic2[@"type"] = @"eq";
        paraDic2[@"content"] = @"yearSafeguard";
        [self.paraArr addObject:paraDic2];
    }else {
        
        NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
        paraDic[@"name"] = @"stationCode";
        paraDic[@"type"] = @"eq";
        paraDic[@"content"] = safeString(currDic[@"code"]);
        [self.paraArr addObject:paraDic];
        
        NSMutableDictionary *paraDic1 = [NSMutableDictionary dictionary];
        paraDic1[@"name"] = @"patrolCode";
        paraDic1[@"type"] = @"eq";
        paraDic1[@"content"] = @"inspectionSafeguard";
        [self.paraArr addObject:paraDic1];
        
    }
    [self queryLiXingWeiHuDayData];
    
}
- (NSMutableArray *)paraArr
{
    if (!_paraArr) {
        _paraArr = [[NSMutableArray alloc] init];
    }
    return _paraArr;
}
@end
