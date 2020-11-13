//
//  KG_YiJianXunShiViewController.m
//  Frame
//
//  Created by zhangran on 2020/4/22.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_YiJianXunShiViewController.h"
#import "KG_YiJianXunShiCell.h"
#import "KG_XunShiReportDetailViewController.h"
#import "KG_OnsiteInspectionView.h"
@interface KG_YiJianXunShiViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *dataArray;
@property (nonatomic ,strong) UIButton *addBtn;

@property (nonatomic ,strong) NSDictionary *alertInfo;
@property (nonatomic, strong)  KG_OnsiteInspectionView *alertView;
@end

@implementation KG_YiJianXunShiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshZhiWeiFirstData) name:@"refreshZhiWeiFirstData" object:nil];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [self createView];
    [self queryYiJianXunShiData];
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
    self.addBtn.enabled = YES;
    [self.view bringSubviewToFront:self.addBtn];
    
}
//按钮添加方法
- (void)addMethod:(UIButton *)button {
    
    if (self.addMethod) {
        self.addMethod(@"yijianxunshi");
    }
}

- (void)refreshZhiWeiFirstData {
    [self queryYiJianXunShiData];
}
-(void)dealloc
{
    [super dealloc];
    //第一种方法.这里可以移除该控制器下的所有通知
    //移除当前所有通知
    NSLog(@"移除了所有的通知");
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = YES;
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 6)];
        _tableView.tableHeaderView = headView;
        headView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *listArray = self.dataArray[section][@"taskInfo"];
    return listArray.count;
    
   
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KG_YiJianXunShiCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_YiJianXunShiCell"];
    if (cell == nil) {
        cell = [[KG_YiJianXunShiCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_YiJianXunShiCell"];
        cell.backgroundColor = self.view.backgroundColor;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *listArray = self.dataArray[indexPath.section][@"taskInfo"];
    cell.taskButton.tag = indexPath.row;
    if (listArray.count) {
        NSDictionary *dataDic = listArray[indexPath.row];
        cell.dataDic = dataDic;
        if (indexPath.row == 0) {
            cell.leftTimeLabel.text =self.dataArray[indexPath.section][@"time"];
            cell.topLine.hidden = NO;
            cell.centerLine.hidden = YES;
            cell.bottomLine.hidden = NO;
            cell.leftTimeLabel.hidden = NO;
            cell.leftIcon.hidden = NO;
        }else {
            cell.topLine.hidden = NO;
            cell.centerLine.hidden = NO;
            cell.bottomLine.hidden = NO;
            cell.leftTimeLabel.hidden = YES;
            cell.leftIcon.hidden = YES;
        }
        if (indexPath.section == 0 &&indexPath.row ==0) {
            cell.topLine.hidden = YES;
            
        }
        if (self.dataArray.count && listArray.count) {
            if (indexPath.section == self.dataArray.count -1 && indexPath.row == listArray.count - 1) {
                cell.bottomLine.hidden = YES;
            }
        }
        
        
        NSString *timeStatus = self.dataArray[indexPath.section][@"status"];
        if ([timeStatus isEqualToString:@"abnormal"]) {
            cell.leftIcon.image = [UIImage imageNamed:@"time_redIcon"];
        }else if ([timeStatus isEqualToString:@"normalCompleted"]) {
            cell.leftIcon.image = [UIImage imageNamed:@"time_greenIcon"];
        }else if ([timeStatus isEqualToString:@"normalUncompleted"]) {
            cell.leftIcon.image = [UIImage imageNamed:@"time_grayIcon"];
        }else {
            cell.leftIcon.image = [UIImage imageNamed:@"time_grayIcon"];
        }
        
    }
    cell.taskMethod = ^(NSDictionary * _Nonnull dic) {
        BOOL islingDao = NO;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if([userDefaults objectForKey:@"role"]){
            NSArray *arr = [userDefaults objectForKey:@"role"];
            if (arr.count) {
                for (NSString *str in arr) {
                    if ([safeString(str) isEqualToString:@"领导"]) {
                        islingDao = YES;
                        break;
                    }
                }
            }
        }
        if (islingDao) {
            [self showSelContactAlertView:dic];
        }else {
            [self getTask:dic];
        }
    };
    return cell;
}
//指派任务
- (void)showSelContactAlertView:(NSDictionary *)dic {
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showAssignView"
                                                        object:self
                                                      userInfo:dic];
}

- (void)getTask:(NSDictionary *)dataDic {
    NSString *userID = [UserManager shareUserManager].userID ;
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/atcSafeguard/updateAtcPatrolRecode",WebNewHost];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
     paramDic[@"id"] = safeString(dataDic[@"id"]);
        paramDic[@"patrolName"] = safeString(userID);
       [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
    WS(weakSelf);
    [FrameBaseRequest postWithUrl:FrameRequestURL param:paramDic success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        [MBProgressHUD hideHUD];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            
            return ;
        }
//
//        if([safeString(result[@"value"]) isEqualToString:@"success"]) {
            [self.dataArray removeAllObjects];
            [self queryYiJianXunShiData];
            [FrameBaseRequest showMessage:@"领取成功"];
//        }
       
    } failure:^(NSError *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        [MBProgressHUD hideHUD];
        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSArray *listArray = self.dataArray[indexPath.section][@"taskInfo"];
    if (listArray.count) {
        NSDictionary *dataDic = listArray[indexPath.row];
        
        self.alertInfo = dataDic;
        if ([safeString(dataDic[@"status"]) isEqualToString:@"5"]) {
            
            if ([CommonExtension isLingDao]) {
                [FrameBaseRequest showMessage:@"请先指派任务"];
                return;
            }
            [FrameBaseRequest showMessage:@"请先领取任务"];
            return;
        }
        if ([safeString(self.alertInfo[@"patrolCode"]) isEqualToString:@"fieldInspection"]) {
//            normalInspection一键巡视
            _alertView = nil;
            [_alertView removeFromSuperview];
            self.alertView.hidden = NO;
        }else {
            if (self.didsel) {
                self.didsel(dataDic, @"yijianxunshi");
            }
        }
     
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *listArray = self.dataArray[indexPath.section][@"taskInfo"];
    if (listArray.count ) {
        NSDictionary *dataDic = listArray[indexPath.row];
        
        NSArray *biaoqianArr = dataDic[@"atcPatrolRoomList"];
        if (biaoqianArr.count  &&[safeString(dataDic[@"patrolCode"]) isEqualToString:@"fieldInspection"]) {
            return 134;
        }else {
            NSArray *specArr = dataDic[@"atcSpecialTagList"];
            if (specArr.count ) {
                return 134;
            }
            
            return  108;
        }
    }
    return  108;
    
       
}
//获取选择台站下当天的一键巡视任务时间轴接口：

- (void)queryYiJianXunShiData {
    
    NSDictionary *currDic = [UserManager shareUserManager].currentStationDic;
    if (currDic.count == 0) {
        return ;
    }
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcPatrolRecode/oneTouchAxis/%@",safeString(currDic[@"code"]) ]];
    [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        [MBProgressHUD hideHUD];
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:result[@"value"]];
        
        [self.tableView reloadData];
        NSLog(@"1");
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        [MBProgressHUD hideHUD];
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
            
        }else if(responses.statusCode == 502){
            
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
        
    }];
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.001)];
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.001)];
    return footView;
}


- (KG_OnsiteInspectionView *)alertView {
    
    if (!_alertView) {
        _alertView = [[KG_OnsiteInspectionView alloc]initWithCondition:self.alertInfo];
        [JSHmainWindow addSubview:_alertView];
        [_alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo([UIApplication sharedApplication].keyWindow.mas_left);
            make.right.equalTo([UIApplication sharedApplication].keyWindow.mas_right);
            make.top.equalTo([UIApplication sharedApplication].keyWindow.mas_top);
            make.bottom.equalTo([UIApplication sharedApplication].keyWindow.mas_bottom);
        }];
        
    }
    return _alertView;
    
}

@end
