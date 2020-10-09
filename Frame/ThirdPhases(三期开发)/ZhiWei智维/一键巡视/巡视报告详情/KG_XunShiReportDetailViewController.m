//
//  KG_XunShiReportDetailViewController.m
//  Frame
//
//  Created by zhangran on 2020/4/24.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_XunShiReportDetailViewController.h"
#import "KG_XunShiReportDetailModel.h"
#import "KG_XunShiReportDataModel.h"
#import "KG_XunShiReportDataModel.h"
#import "KG_XunShiTopView.h"
#import "KG_XunShiHandleView.h"
#import "KG_XunShiResultView.h"
#import "KG_XunShiRadarView.h"
#import "KG_XunShiReportDetailCell.h"
#import "KG_XunShiResultView.h"
#import "KG_XunShiResultCell.h"
#import "KG_XunShiDetailLogCell.h"
#import "KG_RemoveTaskView.h"
#import "KG_AddressbookViewController.h"
@interface KG_XunShiReportDetailViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>



@property (nonatomic ,strong) NSArray *dataArray;
/**  标题栏 */
@property (nonatomic, strong)   UILabel      *titleLabel;
@property (nonatomic, strong)   UIView       *navigationView;
@property (strong, nonatomic)   UIImageView  *topImage1;
@property (strong, nonatomic)   KG_XunShiReportDetailModel *dataModel;
@property (strong, nonatomic)   KG_XunShiReportDataModel *listModel;
@property (strong, nonatomic)   KG_XunShiTopView *xunshiTopView;
@property (strong, nonatomic)   KG_XunShiHandleView *xunShiHandelView;

@property (strong, nonatomic)   taskDetail *radarModel;
@property (strong, nonatomic)   taskDetail *powerModel;
@property (strong, nonatomic)   taskDetail *upsModel;

@property (strong, nonatomic)   KG_XunShiRadarView *radarView;

@property (strong, nonatomic)   KG_XunShiRadarView *powerView;
@property (strong, nonatomic)   KG_XunShiRadarView *upsView;
@property (strong, nonatomic)   UIScrollView *scrollView;
@property (strong, nonatomic)   UITableView *tableView;

@property (strong, nonatomic)   KG_XunShiResultView *resultView;

@property (strong, nonatomic)   NSArray *receiveArr;

@property (strong, nonatomic)   NSArray *logArr;
@property (nonatomic, strong)   UIView       *tableHeadView;
@property (nonatomic, strong)  UIButton * moreBtn;
@property (nonatomic, copy)  NSString *descriptonStr;

@property (nonatomic, assign)  BOOL canUpdateOrSubmit;

@property (nonatomic, strong)  KG_RemoveTaskView *alertView;

@end

@implementation KG_XunShiReportDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushRemoveToAddressBook) name:@"pushRemoveToAddressBook" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveSpecialData:) name:@"saveSpecialData" object:nil];
    self.dataModel = [[KG_XunShiReportDetailModel alloc]init];
    self.listModel = [[KG_XunShiReportDataModel alloc]init];
    self.radarModel = [[taskDetail alloc]init];
    self.powerModel = [[taskDetail alloc]init];
    self.upsModel = [[taskDetail alloc]init];
    self.canUpdateOrSubmit = YES;
    [self createNaviTopView];
    [self createDataView];
    [self queryReportDetailData];
    [self getTemplateData];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
   
}
- (void)pushRemoveToAddressBook {
    
    self.alertView.hidden = YES;
    KG_AddressbookViewController *vc = [[KG_AddressbookViewController alloc]init];
    vc.sureBlockMethod = ^(NSString * _Nonnull nameID, NSString * _Nonnull nameStr) {
        self.alertView.hidden = NO;
        self.alertView.name = nameStr;
        self.alertView.nameID =nameID;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)dealloc
{
    [super dealloc];
    //第一种方法.这里可以移除该控制器下的所有通知
    //移除当前所有通知
    NSLog(@"移除了所有的通知");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    NSLog(@"StationDetailController viewWillAppear");
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillDisappear");
    self.navigationController.navigationBarHidden = NO;
    [UserManager shareUserManager].isChangeTask = NO;
}

- (void)createDataView{
    self.tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 266)];
    [self.view addSubview:self.tableView];
    [self.tableHeadView addSubview:self.xunshiTopView];
    self.tableView.tableHeaderView = self.tableHeadView;
    
    self.xunshiTopView.layer.cornerRadius = 10;
    self.xunshiTopView.layer.masksToBounds = YES;
    self.xunshiTopView.shouqiMethod = ^{
        
        UIView *tableHeaderView =self.tableView.tableHeaderView;
        
        CGRect frame = tableHeaderView.frame;
        
        [tableHeaderView removeFromSuperview];
        
        self.tableView.tableHeaderView =nil;
        
        frame.size.height =128.0+54;// 新高度
        
        tableHeaderView.frame = frame;
        
        self.tableView.tableHeaderView = tableHeaderView;
        
        [self.xunshiTopView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tableHeadView.mas_left);
            make.right.equalTo(self.tableHeadView.mas_right);
            make.top.equalTo(self.tableHeadView.mas_top);
            make.height.equalTo(@(128 +54));
        }];
    };
    
    self.xunshiTopView.zhankaiMethod = ^{
        
        UIView *tableHeaderView =self.tableView.tableHeaderView;
        
        CGRect frame = tableHeaderView.frame;
        
        [tableHeaderView removeFromSuperview];
        
        self.tableView.tableHeaderView =nil;
        
        frame.size.height =266.0;// 新高度
        
        tableHeaderView.frame = frame;
        
        self.tableView.tableHeaderView = tableHeaderView;
        
        [self.xunshiTopView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tableHeadView.mas_left);
            make.right.equalTo(self.tableHeadView.mas_right);
            make.top.equalTo(self.tableHeadView.mas_top);
            make.height.equalTo(@(266));
        }];
    };
    
    [self.xunshiTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tableHeadView.mas_left);
        make.right.equalTo(self.tableHeadView.mas_right);
        make.top.equalTo(self.tableHeadView.mas_top);
        make.height.equalTo(@266);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = YES;
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataModel.task.count + 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    return footView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.001)];
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == self.dataModel.task.count) {
        return 124;
    }else if (indexPath.section == self.dataModel.task.count + 1) {
        return 280;
    }
    
    NSInteger totalHeight = 0;
    
    taskDetail *model = self.dataModel.task[indexPath.section];
    
    NSInteger firstHeight = 44 ;
    //第一层 model.childrens 44
    //第二层 model.childrens firstobject  44
    NSArray *secondArr = model.childrens;
    NSInteger secondHeight = [secondArr count] *(44+2);
    //第三层
    NSInteger thirdHeight = 0;
    NSInteger fourthHeight = 0;
    
    for (NSDictionary *dic in secondArr) {
        NSArray *thirdArr = dic[@"childrens"];
        thirdHeight += thirdArr.count *30;
        for (NSDictionary *detailArr in thirdArr) {
            NSArray *fourthArr = detailArr[@"childrens"];
            fourthHeight += fourthArr.count *40;
            
            for (NSDictionary *fifDic in fourthArr) {
                if (isSafeDictionary(fifDic[@"atcSpecialTag"])) {
                    NSDictionary *specDic = fifDic[@"atcSpecialTag"];
                    if ([[specDic allValues] count] >0) {
                        fourthHeight += 57;
                    }
                }
            }
        }
    }
    totalHeight = firstHeight + secondHeight +thirdHeight +fourthHeight;
    NSLog(@"第一层高度：-----------%ld",(long)firstHeight);
    NSLog(@"第2层高度：-----------%ld",(long)secondHeight);
    NSLog(@"第3层高度：-----------%ld",(long)thirdHeight);
    NSLog(@"第4层高度：-----------%ld",(long)fourthHeight);
    if ([UserManager shareUserManager].isChangeTask) {
        totalHeight +=50;
    }
    return totalHeight;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section <self.dataModel.task.count ) {
        KG_XunShiReportDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_XunShiReportDetailCell"];
        if (cell == nil) {
            cell = [[KG_XunShiReportDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_XunShiReportDetailCell"];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        taskDetail *model  = self.dataModel.task[indexPath.section];
        
        cell.model = model;
        
        return cell;
    }else if (indexPath.section == self.dataModel.task.count ) {
        KG_XunShiResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_XunShiResultCell"];
        if (cell == nil) {
            cell = [[KG_XunShiResultCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_XunShiResultCell"];
        }
        
        //        if (safeString(self.dataModel.taskDescription).length) {
        cell.taskDescription = safeString(self.dataModel.taskDescription);
        if (self.descriptonStr.length) {
            cell.taskDescription = self.descriptonStr;
        }
        //        }
        cell.textStringChangeBlock = ^(NSString * _Nonnull taskDescription) {
            self.descriptonStr = taskDescription;
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }else if (indexPath.section == self.dataModel.task.count +1 ) {
        KG_XunShiDetailLogCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_XunShiDetailLogCell"];
        
        if (cell == nil) {
            cell = [[KG_XunShiDetailLogCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_XunShiDetailLogCell"];
        }
        cell.uploadReceive = ^(NSString * _Nonnull textStr) {
            [self uploadReceiveData:textStr];
        };
        if (self.receiveArr.count) {
            cell.receiveArr = self.receiveArr;
        }
        if (self.logArr.count) {
            cell.logArr = self.logArr;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

- (void)createNaviTopView {
    
    self.topImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 224)];
    [self.view addSubview:self.topImage1];
    self.topImage1.contentMode = UIViewContentModeScaleAspectFill;
    self.topImage1.image = [UIImage imageNamed:@"zhiwei_topBgImage"];
    
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
    self.titleLabel.text = @"巡视报告详情";
    
    /** 返回按钮 **/
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@44);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.left.equalTo(self.navigationView.mas_left);
    }];
    
    /** 更多按钮 **/
    self.moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.moreBtn addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
    [self.moreBtn setImage:[UIImage imageNamed:@"white_more"] forState:UIControlStateNormal];
    [self.navigationView addSubview:self.moreBtn];
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@44);
        make.centerY.equalTo(backBtn.mas_centerY);
        make.right.equalTo(self.navigationView.mas_right).offset(-13);
    }];
    
    //按钮设置点击范围扩大.实际显示区域为图片的区域
    UIImageView *leftImage = [[UIImageView alloc] init];
    leftImage.image = IMAGE(@"back_icon");
    [backBtn addSubview:leftImage];
    [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backBtn.mas_centerX);
        make.centerY.equalTo(backBtn.mas_centerY);
    }];
}

/** 标题栏 **/
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel * titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        titleLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}
- (void)back
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
- (void)moreAction {
    
    if(!self.canUpdateOrSubmit) {
        //        [FrameBaseRequest showMessage:@"任务已完成，不能执行此操作"];
        //        return;
    }
    if (_xunShiHandelView== nil) {
        
        [JSHmainWindow addSubview:self.xunShiHandelView];
        self.xunShiHandelView.didsel = ^(NSString * _Nonnull dataStr) {
            NSString *leadStr = @"";
            NSString *patrolName = safeString(self.dataModel.patrolName);
            NSArray *leadArr = [UserManager shareUserManager].leaderNameArray;
            
            for (NSDictionary *dic in leadArr) {
                if ([safeString(dic[@"id"]) isEqualToString:patrolName]) {
                    leadStr = safeString(dic[@"name"]);
                    break;
                }
            }
            NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
            if ([userdefaults objectForKey:@"name"]) {
                NSString *userName = [userdefaults objectForKey:@"name"];
                if (![safeString(self.dataDic[@"leaderName"]) isEqualToString:userName]) {
                    [FrameBaseRequest showMessage:@"您没有修改任务的权限"];
                    return;
                }
            }
            
            [self checkCanChangeTask:dataStr];
            if ([dataStr isEqualToString:@"提交任务"]) {
                NSLog(@"提交任务");
                [self uploadTask];
            }else if ([dataStr isEqualToString:@"移交任务"]) {
                NSLog(@"移交任务");
                [self removeTask];
            }else if ([dataStr isEqualToString:@"删除任务"]) {
                NSLog(@"删除任务");
                [self deleteTask];
            }else {
                [self.moreBtn removeFromSuperview];
                self.moreBtn = nil;
                /** 更多按钮 **/
                self.moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.moreBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
                self.moreBtn.titleLabel.font = FontSize(16);
                
                [self.moreBtn setTitle:@"保存" forState:UIControlStateNormal];
                [self.moreBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
                [self.navigationView addSubview:self.moreBtn];
                [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.height.equalTo(@44);
                    make.centerY.equalTo(self.titleLabel.mas_centerY);
                    make.right.equalTo(self.navigationView.mas_right).offset(-13);
                }];
                NSLog(@"修改任务");
                [UserManager shareUserManager].isChangeTask = YES;
                //                [self changeTask];
                [self.tableView reloadData];
            }
        };
        [self.xunShiHandelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.top.equalTo(self.view.mas_top);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
    }
    
    if (self.xunShiHandelView.hidden) {
        self.xunShiHandelView.hidden = NO;
    }
    
}
//任务删除接口：
//请求地址：/intelligent/atcSafeguard/remove/{id}
//   其中，id是任务的id
//请求方式：DELETE
//删除任务
- (void)deleteTask   {
    
    UIAlertController *alertContor = [UIAlertController alertControllerWithTitle:@"您确定删除吗？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertContor addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:nil]];
    [alertContor addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        
        NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcSafeguard/remove/%@",safeString(self.dataDic[@"id"])]];
        [FrameBaseRequest deleteWithUrl:FrameRequestURL param:nil success:^(id result) {
            NSInteger code = [[result objectForKey:@"errCode"] intValue];
            if(code != 0){
                
                return ;
            }
            
            NSLog(@"请求成功");
            [FrameBaseRequest showMessage:@"删除成功"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshZhiWeiData" object:self];
            [self.navigationController popViewControllerAnimated:YES];
            
        }  failure:^(NSError *error) {
            NSLog(@"请求失败 原因：%@",error);
            if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
                return;
            }
            [FrameBaseRequest showMessage:@"网络链接失败"];
            return ;
        } ];
        
        
    }]];
    
    [self presentViewController:alertContor animated:NO completion:nil];
  
}

//移交任务
- (void)removeTask {
    
    [self showAssignView];
    
}
//显示弹窗
- (void)showAssignView {
    NSDictionary *dDic = self.dataDic;
    
    self.alertView = [[KG_RemoveTaskView alloc]init];
    [JSHmainWindow addSubview:self.alertView];
    self.alertView.dataDic = dDic;
    self.alertView.confirmBlockMethod = ^(NSDictionary * _Nonnull dataDic, NSString * _Nonnull name, NSString * _Nonnull nameID) {
        
        [self assignData:dataDic name:name withNameID:nameID];
        
    };
    [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo([UIApplication sharedApplication].keyWindow.mas_left);
        make.right.equalTo([UIApplication sharedApplication].keyWindow.mas_right);
        make.top.equalTo([UIApplication sharedApplication].keyWindow.mas_top);
        make.bottom.equalTo([UIApplication sharedApplication].keyWindow.mas_bottom);
    }];
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
- (void)assignData:(NSDictionary *)dataDic name:(NSString *)name withNameID:(NSString *)nameID{
    
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcSafeguard/updateAtcPatrolRecode"]];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    paramDic[@"id"] = safeString(dataDic[@"id"]);
    paramDic[@"patrolName"] = safeString(nameID);
    [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
    [FrameBaseRequest postWithUrl:FrameRequestURL param:paramDic success:^(id result) {
        [MBProgressHUD hideHUD];
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code != 0){
            
            return ;
        }
        
        NSLog(@"请求成功");
        if ([result[@"value"] boolValue]) {
            [FrameBaseRequest showMessage:@"指派成功"];
            self.alertView.hidden = YES;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshYunxingData" object:self];
        
    }  failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSLog(@"请求失败 原因：%@",error);
        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    } ];
}


//修改任务
- (void)saveAction {
    
    [self changeTask];
}
//
//请求地址：/intelligent/atcSafeguard/updateAtcPatrolRecode
//请求方式：POST
//请求Body：
//{
//    "id": "XXX",                                       //任务Id，必填
//    "result": "{"XXX":"XXX"}",                          //存储巡查结果
//    "status": "1",                                       //任务状态，固定为1
//    "remark": "{"XXX":"XXX"}",                         //存储备注内容
//    "patrolName": "XXX",                               //任务执行负责人Id
//    "atcPatrolLabelList": ["name": "XXX"],                 //标签列表
//     "description": "XXX",                      //巡视结果，仅巡视任务支持，默认填充为空
//    "atcPatrolWorkList": ["workPersonName": "XXX"]        //执行人id列表
//}
//其中：
//result和remark采用JSONObject的数据格式，key存储父节点的id，value存内容。
//如上图片所示：
//result里面有一个key-value对，key是“环境内容”所在节点的id，value是“干净”。
//remark里面有两个key-value对，参考如下模板内容配置页面，一个key是“环境内容”所在节点的id，value是“环境内容巡查准确”；一个key是“台站环境巡视”所在节点的id，value是“台站环境巡查正确”。
- (void)changeTask {
    NSString *leadStr = @"";
    NSString *patrolName = safeString(self.dataModel.patrolName);
    NSArray *leadArr = [UserManager shareUserManager].leaderNameArray;
    
    for (NSDictionary *dic in leadArr) {
        if ([safeString(dic[@"id"]) isEqualToString:patrolName]) {
            leadStr = safeString(dic[@"name"]);
            break;
        }
    }
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    if ([userdefaults objectForKey:@"name"]) {
        NSString *userName = [userdefaults objectForKey:@"name"];
        if (![safeString(self.dataDic[@"leaderName"]) isEqualToString:userName]) {
            [FrameBaseRequest showMessage:@"您没有修改任务的权限"];
            return;
        }
    }
    
    
    
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/atcSafeguard/updateAtcPatrolRecode",WebNewHost];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    
    
    paramDic[@"id"] = safeString(self.dataDic[@"id"]);
    NSDictionary *resultDic = [UserManager shareUserManager].resultDic;
    paramDic[@"result"] = [self convertToJsonData:resultDic];
    paramDic[@"status"] = @"1";
    paramDic[@"description"] = safeString(self.descriptonStr);
    NSDictionary *remarkDic = [NSDictionary dictionary];
    if (isSafeDictionary(self.dataDic[@"remark"])) {
        if ([self.dataDic[@"remark"] count]) {
            paramDic[@"remark"] = [self convertToJsonData:self.dataDic[@"remark"]];
        }else {
            paramDic[@"remark"] =[self convertToJsonData:remarkDic] ;
        }
    }else {
        paramDic[@"remark"] = [self convertToJsonData:remarkDic];
    }
    
    
    paramDic[@"patrolName"] = safeString(self.dataDic[@"patrolName"]);
    //
    NSMutableArray *labelList = [NSMutableArray arrayWithCapacity:0];
    //    NSMutableDictionary *labelDic = [NSMutableDictionary dictionary];
    //    [labelDic setValue:@"DVOR" forKey:@"name"];
    //    [labelList addObject:labelDic];
    if (isSafeArray(self.dataDic[@"atcPatrolLabelList"])) {
        if ([self.dataDic[@"atcPatrolLabelList"] count]) {
            paramDic[@"atcPatrolLabelList"] = self.dataDic[@"atcPatrolLabelList"];
        }else {
            paramDic[@"atcPatrolLabelList"] = labelList;
        }
        
    }else {
        paramDic[@"atcPatrolLabelList"] = labelList;
        
    }
    
    
    NSMutableArray *workList = [NSMutableArray arrayWithCapacity:0];
    //    NSMutableDictionary *workDic = [NSMutableDictionary dictionary];
    //    [workDic setValue:@"1d13c2dc-fb3a-441f-976d-7a7537018245" forKey:@"workPersonName"];
    //    [workList addObject:workDic];
    if (isSafeArray(self.dataDic[@"atcPatrolWorkList"])) {
        if ([self.dataDic[@"atcPatrolWorkList"] count]) {
            paramDic[@"atcPatrolWorkList"] = self.dataDic[@"atcPatrolWorkList"];
        }else {
            paramDic[@"atcPatrolWorkList"] = workList;
        }
    }else {
        paramDic[@"atcPatrolWorkList"] = workList;
    }
    
    [FrameBaseRequest postWithUrl:FrameRequestURL param:paramDic success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            
            return ;
        }
        [FrameBaseRequest showMessage:@"保存任务成功"];
        [UserManager shareUserManager].isChangeTask = NO;
        [self getLogData];
        [self queryReportDetailData];
        [UserManager shareUserManager].resultDic = nil;
        
        /** 更多按钮 **/
        [self.moreBtn removeFromSuperview];
        self.moreBtn = nil;
        self.moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.moreBtn addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
        [self.moreBtn setImage:[UIImage imageNamed:@"white_more"] forState:UIControlStateNormal];
        [self.navigationView addSubview:self.moreBtn];
        [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@44);
            make.centerY.equalTo(self.titleLabel.mas_centerY);
            make.right.equalTo(self.navigationView.mas_right).offset(-13);
        }];
        
        
        
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
//提交任务
- (void)uploadTask{
    
    NSString *leadStr = @"";
    NSString *patrolName = safeString(self.dataModel.patrolName);
    NSArray *leadArr = [UserManager shareUserManager].leaderNameArray;
    
    for (NSDictionary *dic in leadArr) {
        if ([safeString(dic[@"id"]) isEqualToString:patrolName]) {
            leadStr = safeString(dic[@"name"]);
            break;
        }
    }
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    if ([userdefaults objectForKey:@"name"]) {
        NSString *userName = [userdefaults objectForKey:@"name"];
        if (![safeString(self.dataDic[@"leaderName"]) isEqualToString:userName]) {
            [FrameBaseRequest showMessage:@"您没有修改任务的权限"];
            return;
        }
    }
    
    
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/atcSafeguard/updateAtcPatrolRecode",WebNewHost];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    
    
    paramDic[@"id"] = safeString(self.dataDic[@"id"]);
    NSDictionary *resultDic = [UserManager shareUserManager].resultDic;
    paramDic[@"result"] = [self convertToJsonData:resultDic];
    paramDic[@"status"] = @"2";
    paramDic[@"description"] = safeString(self.descriptonStr);
    NSDictionary *remarkDic = [NSDictionary dictionary];
    if (isSafeDictionary(self.dataDic[@"remark"])) {
        if ([self.dataDic[@"remark"] count]) {
            paramDic[@"remark"] = [self convertToJsonData:self.dataDic[@"remark"]];
        }else {
            paramDic[@"remark"] =[self convertToJsonData:remarkDic] ;
        }
    }else {
        paramDic[@"remark"] = [self convertToJsonData:remarkDic];
    }
    
    
    paramDic[@"patrolName"] = safeString(self.dataDic[@"patrolName"]);
    //
    NSMutableArray *labelList = [NSMutableArray arrayWithCapacity:0];
    //    NSMutableDictionary *labelDic = [NSMutableDictionary dictionary];
    //    [labelDic setValue:@"DVOR" forKey:@"name"];
    //    [labelList addObject:labelDic];
    if (isSafeArray(self.dataDic[@"atcPatrolLabelList"])) {
        if ([self.dataDic[@"atcPatrolLabelList"] count]) {
            paramDic[@"atcPatrolLabelList"] = self.dataDic[@"atcPatrolLabelList"];
        }else {
            paramDic[@"atcPatrolLabelList"] = labelList;
        }
        
    }else {
        paramDic[@"atcPatrolLabelList"] = labelList;
        
    }
    
    
    NSMutableArray *workList = [NSMutableArray arrayWithCapacity:0];
    //    NSMutableDictionary *workDic = [NSMutableDictionary dictionary];
    //    [workDic setValue:@"1d13c2dc-fb3a-441f-976d-7a7537018245" forKey:@"workPersonName"];
    //    [workList addObject:workDic];
    if (isSafeArray(self.dataDic[@"atcPatrolWorkList"])) {
        if ([self.dataDic[@"atcPatrolWorkList"] count]) {
            paramDic[@"atcPatrolWorkList"] = self.dataDic[@"atcPatrolWorkList"];
        }else {
            paramDic[@"atcPatrolWorkList"] = workList;
        }
    }else {
        paramDic[@"atcPatrolWorkList"] = workList;
    }
    
    
    
    
    [FrameBaseRequest postWithUrl:FrameRequestURL param:paramDic success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            
            return ;
        }
        [FrameBaseRequest showMessage:@"提交任务成功"];
        [UserManager shareUserManager].isChangeTask = NO;
        [UserManager shareUserManager].resultDic = nil;
        [self.tableView reloadData];
        [self getLogData];
        [self queryReportDetailData];
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
//请求地址：/intelligent/atcSafeguard/checkUpdate/{patrolId}/{oldUpdateTime}
//其中，patrolId是任务的id；
//oldUpdateTime是任务详情接口返回的taskLastUpdateTime字段，精确到ms的时间戳
- (void)checkCanChangeTask:(NSString *)taskString {
    NSString *rId = self.dataDic[@"id"];
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcSafeguard/checkUpdate/%@/%@",rId,safeString(self.dataDic[@"lastUpdateTime"])]];
    
    [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        [MBProgressHUD hideHUD];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        NSDictionary *dic = result[@"value"];
        if ([dic[@"isUpdateEnable"] boolValue]) {
            
        }else {
            //            UIAlertController *alertContor = [UIAlertController alertControllerWithTitle:@"" message:@"是否要覆盖别人的提交?" preferredStyle:UIAlertControllerStyleAlert];
            //            [alertContor addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
            //            [alertContor addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            //
            //            }]];
            //
            //            [self presentViewController:alertContor animated:NO completion:nil];
            //
            //
            
        }
        
        NSLog(@"1");
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        [MBProgressHUD hideHUD];
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
            
        }else if(responses.statusCode == 502){
            
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
        
    }];
    
}

- (void)queryReportDetailData {
    NSString *rId = self.dataDic[@"id"];
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcSafeguard/getTourInfoById/%@",rId]];
    
    [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        [MBProgressHUD hideHUD];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        [self.dataModel mj_setKeyValues:result[@"value"]];
        [self.listModel mj_setKeyValues:result[@"value"]];
        NSMutableDictionary *remarkDic = [NSMutableDictionary dictionary];
        NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
        for (task *model in self.listModel.task) {
            for (firstData *firstData in model.childrens) {
                for (secondData *secondData in firstData.childrens) {
                    for (thirdData *thirdData in secondData.childrens) {
                        NSString *valueStr = safeString(thirdData.measureValueAlias);
                        for (fourthData *fourthData in thirdData.childrens) {
                            if ([fourthData.levelMax intValue] == 4) {
                                if (valueStr.length ) {
                                    NSLog(@"11");
                                }
                                NSString *keyStr = safeString(fourthData.parentId);
                                if (keyStr.length ) {
                                    NSMutableDictionary *dd = [NSMutableDictionary dictionary];
                                    [dd setValue:[NSString stringWithFormat:@"%@",@""] forKey:keyStr];
                                    [remarkDic addEntriesFromDictionary:dd];
                                }
                                
                                NSString *resultvalueStr = safeString(fourthData.measureValueAlias);
                                NSString *resultkeyStr = safeString(fourthData.parentId);
                                if (resultkeyStr.length ) {
                                    NSMutableDictionary *dd1 = [NSMutableDictionary dictionary];
                                    [dd1 setValue:[NSString stringWithFormat:@"%@",resultvalueStr] forKey:resultkeyStr];
                                    [resultDic addEntriesFromDictionary:dd1];
                                }
                                
                            }else {
                                for (fifthData *fifthData in fourthData.childrens) {
                                    NSDictionary *fifDic =[fifthData mj_keyValues];
                                    NSString *keyStr = safeString(fifDic[@"parentId"]);
                                    if (keyStr.length ) {
                                        NSMutableDictionary *dd = [NSMutableDictionary dictionary];
                                        [dd setValue:[NSString stringWithFormat:@"%@",@""] forKey:keyStr];
                                        [remarkDic addEntriesFromDictionary:dd];
                                    }
                                    
                                    NSString *resultvalueStr = safeString(fifDic[@"measureValueAlias"]);
                                    NSString *resultkeyStr = safeString(fifDic[@"parentId"]);
                                    if (resultkeyStr.length ) {
                                        NSMutableDictionary *dd1 = [NSMutableDictionary dictionary];
                                        [dd1 setValue:[NSString stringWithFormat:@"%@",resultvalueStr] forKey:resultkeyStr];
                                        [resultDic addEntriesFromDictionary:dd1];
                                    }
                                    
                                    
                                }
                                
                            }
                            
                            NSLog(@"1");
                        }
                    }
                }
            }
        }
        
        [UserManager shareUserManager].remarkDic = remarkDic;
        [UserManager shareUserManager].resultDic = nil;
        for (taskDetail *detailModel in self.dataModel.task) {
            if ([detailModel.engineRoomName isEqualToString:@"雷达机房"]) {
                self.radarModel = detailModel;
            }else if ([detailModel.engineRoomName isEqualToString:@"电池间"]) {
                self.powerModel = detailModel;
            }else if ([detailModel.engineRoomName isEqualToString:@"UPS机房"]) {
                self.upsModel = detailModel;
            }
        }
        
        [self getTaskFaBuTiJiaoData];
        [self getReceviceData];
        [self getLogData];
        [self refreshData];
        
        NSLog(@"1");
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        [MBProgressHUD hideHUD];
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
            
        }else if(responses.statusCode == 502){
            
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
        
    }];
    
}

//
//获取某个台站某种任务类型下的模板列表：
//请求地址：/intelligent/atcSafeguard/templateList/{stationCode}/{typeCode}/{patrolCode}
//         其中，stationCode是台站编码，
//typeCode是任务大类型编码：
//一键巡视oneTouchTour
//                    例行维护routineMaintenance
//                    特殊保障分为特殊维护specialSafeguard和特殊巡视specialTour
//patrolCode是任务小类型编码，根据任务大类型从字典中获取。

//一键巡视
- (void)getTemplateData {
    NSString *rId = self.dataDic[@"stationCode"];
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcSafeguard/templateList/%@/%@/%@",rId,@"oneTouchTour",@"normalInspection"]];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        
        NSLog(@"1");
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
            
        }else if(responses.statusCode == 502){
            
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
        
    }];
    
}
//获取任务的发布和提交详情接口：
//请求地址：/intelligent/atcSafeguard/getOperationInfo/{recodeId}
//     其中，recodeId是任务的id
//请求方式：GET
//请求返回：
//如：/intelligent/atcSafeguard/getOperationInfo/2b32230c3e084d70962c2e4440327776
//返回：
- (void)getTaskFaBuTiJiaoData {
    NSString *rId = self.dataDic[@"id"];
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcSafeguard/getOperationInfo/%@",rId]];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        self.xunshiTopView.dic = result[@"value"];
        
        
        NSLog(@"1");
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
            
        }else if(responses.statusCode == 502){
            
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
        
    }];
    
}
- (KG_XunShiTopView *)xunshiTopView {
    if (!_xunshiTopView) {
        _xunshiTopView = [[KG_XunShiTopView alloc]init];
        
    }
    return _xunshiTopView;
}

- (void)refreshData {
    
    self.xunshiTopView.model = self.dataModel;
    self.xunshiTopView.dataDic =self.dataDic;
    self.xunshiTopView.leaderString = safeString(self.dataDic[@"leaderName"]);
    //    self.radarView.detailModel = self.radarModel;
    //    self.powerView.detailModel = self.powerModel;
    //    self.upsView.detailModel = self.upsModel;
    //44 +
    //    NSInteger scrollHeight = 0;
    //    NSInteger totalHeight = 0;
    //
    //    for(taskDetail *model in self.dataModel.task){
    //
    //        NSInteger firstHeight = model.childrens.count * 44 ;
    //        //第一层 model.childrens 44
    //        //第二层 model.childrens firstobject  44
    //        NSArray *secondArr = [model.childrens firstObject][@"childrens"];
    //        NSInteger secondHeight = [secondArr count] *44;
    //        //第三层
    //        NSInteger thirdHeight = 0;
    //        NSInteger fourthHeight = 0;
    //        for (NSDictionary *dic in secondArr) {
    //            NSArray *thirdArr = dic[@"childrens"];
    //            thirdHeight += thirdArr.count *30;
    //            for (NSDictionary *detailArr in thirdArr) {
    //                NSArray *fourthArr = detailArr[@"childrens"];
    //                fourthHeight += fourthArr.count *30;
    //            }
    //        }
    //        totalHeight = firstHeight + secondHeight +thirdHeight +fourthHeight;
    //
    //        scrollHeight += totalHeight;
    //    }
    [self.tableView reloadData];
    
}

-(NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}


//展开
- (void)zhankaiMethod:(UIButton *)button {
    
    
}




//将时间戳转换为时间字符串
- (NSString *)timestampToTimeStr:(NSString *)timestamp {
    if (isSafeObj(timestamp)==NO) {
        return @"-/-";
    }
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:timestamp.integerValue/1000];
    NSString *timeStr=[[self dateFormatWith:@"YYYY.MM.dd"] stringFromDate:date];
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
- (NSString *)getTaskImage:(NSString *)status {
    NSString *ss = @"yiwancheng_icon";
    if ([status isEqualToString:@"0"]) {
        ss = @"daizhixing_icon";
    }else if ([status isEqualToString:@"1"]) {
        ss = @"jinxingzhong_icon";
    }else if ([status isEqualToString:@"2"]) {
        ss = @"yiwancheng_icon";
    }else if ([status isEqualToString:@"3"]) {
        ss = @"yuqiweiwancheng_icon";
    }else if ([status isEqualToString:@"4"]) {
        ss = @"yuqiyiwancheng_icon";
    }else if ([status isEqualToString:@"5"]) {
        ss = @"dailingqu_icon";
    }else if ([status isEqualToString:@"6"]) {
        ss = @"daizhipai_icon";
    }
    return ss;
    
}
- (KG_XunShiHandleView *)xunShiHandelView {
    if (!_xunShiHandelView) {
        _xunShiHandelView = [[KG_XunShiHandleView alloc]init];
        
    }
    return _xunShiHandelView;
}
//获得回复
- (void)getReceviceData {
    
    //    http://192.168.100.173:8089/intelligent/atcPatrolDialog/67900de54fe34afda50bde26e2b40b0a
    NSString *rId = self.dataDic[@"id"];
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcPatrolDialog/%@",rId]];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        self.receiveArr = result[@"value"];
        [self.tableView reloadData];
        
        
        NSLog(@"1");
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
            
        }else if(responses.statusCode == 502){
            
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
        
    }];
}


//获得日志
- (void)getLogData {
    
    //    http://192.168.100.173:8089/intelligent/atcPatrolDialog/67900de54fe34afda50bde26e2b40b0a
    NSString *rId = self.dataDic[@"id"];
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcSafeguard/getAtcPatrolLog/%@/%@/%@",rId,@"1",@"100"]];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        
        if (isSafeDictionary(result[@"value"])) {
            if (isSafeArray(result[@"value"][@"records"])) {
                self.logArr = result[@"value"][@"records"];
            }
            
        }
        
        for (NSDictionary *logDic in self.logArr) {
            if ([safeString(logDic[@"content"]) isEqualToString:@"提交"]) {
                self.canUpdateOrSubmit = NO;
                break;
            }
        }
        [self.tableView reloadData];
        
        
        NSLog(@"1");
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
            
        }else if(responses.statusCode == 502){
            
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
        
    }];
}

#pragma mark ----  字典转Json字符串
-(NSString *)convertToJsonData:(NSDictionary *)dict

{
    
    if (dict.count ==0) {
        return @"";
    }
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}
//提交回复
//任务的回复提交接口：
//请求地址：/intelligent/atcPatrolDialog
//请求方式：POST
- (void)uploadReceiveData:(NSString *)textStr {
    
    NSString *idStr = @"";
    NSString *nameStr = @"";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults objectForKey:@"id"]){
        idStr = [userDefaults objectForKey:@"id"];
    }
    
    if([userDefaults objectForKey:@"name"]){
        nameStr = [userDefaults objectForKey:@"name"];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"content"] =safeString(textStr);
    params[@"operatorId"] =safeString(idStr);
    params[@"operatorName"] =safeString(nameStr);
    params[@"patrolRecordId"] =safeString(self.dataDic[@"id"]);
    
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcPatrolDialog"]];
    [FrameBaseRequest postWithUrl:FrameRequestURL param:params success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code != 0){
            
            return ;
        }
        [self getReceviceData];
        
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
//请求地址：/intelligent/atcSafeguard/insertAtcSpecialTag
//请求Body：List<AtcSpecialTag>对象
//  [{
//"patrolRecordId":"XXX",                   //任务的Id
//"patrolInfoId":"XXX",                      //参数名称层级的id，即父节点的Id
//"specialTagCode":null,                     //固定值
//"specialTagName":"XXX",                  //参数名称
//"specialTagValue":"XXX",                  //参数数值
//"taskTime":"XXX",                       //任务时间
//"equipmentCode":"XXX",                  //设备编码
//"equipmentName":"XXX",                 //设备名称
//"engineRoomCode":"XXX",                //机房编码
//"engineRoomName":"XXX",                //机房名称
//"description":"XXX",                      //描述内容
//"source":"XXX"                          //任务所属大类型编码，有：
//                    //specialTour、routineMaintenance、oneTouchTour、specialSafeguard
//}]
//请求方式：POST
//请求返回：
//如：
//[{
//"patrolRecordId":"8d200d7fcaaa4d9aae9af67252d43efb",
//"patrolInfoId":"2934feb1-7350-478b-be53-2f38cea42ce6",
//"specialTagCode":null,
//"specialTagName":"1组电池容量",
//"specialTagValue":"100.0%",
//"taskTime":"2020.03.25",
//"equipmentCode":"HCJF-DMEXDC",
//"equipmentName":"DME后备电池",
//"engineRoomCode":"HCDHT-JF",
//"engineRoomName":"设备机房",
//"description":"电池正常",
//"source":"specialTour"
//}] 
- (void)saveSpecialData:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    if (dic.count) {
        NSString *str = safeString(dic[@"description"]);
        NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcSafeguard/insertAtcSpecialTag"]];
        
        NSMutableArray *paramArr = [NSMutableArray arrayWithCapacity:0];
       
        
        NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
        paramDic[@"patrolInfoId"] = safeString(dic[@"patrolRecordId"]);
        paramDic[@"patrolRecordId"] = safeString(self.dataDic[@"id"]);
        paramDic[@"specialTagCode"] = safeString(@"");
        
        paramDic[@"specialTagName"] = safeString(dic[@"specialTagName"]);
        paramDic[@"specialTagValue"] = safeString(dic[@"specialTagValue"]);
        
        
        NSString *timeStr = [self timestampToTimeStr:safeString(self.dataDic[@"createTime"])];
        paramDic[@"taskTime"] = safeString(timeStr);
        paramDic[@"equipmentCode"] = safeString(dic[@"equipmentCode"]);
        paramDic[@"equipmentName"] = safeString(dic[@"equipmentName"]);
        paramDic[@"engineRoomCode"] = safeString(dic[@"engineRoomCode"]);
        paramDic[@"engineRoomName"] = safeString(dic[@"engineRoomName"]);
        paramDic[@"description"] = safeString(str);
        paramDic[@"source"] = safeString(self.dataDic[@"typeCode"]);
        
        [paramArr addObject:paramDic];
   
        [FrameBaseRequest postWithUrl:FrameRequestURL param:paramArr success:^(id result) {
            NSInteger code = [[result objectForKey:@"errCode"] intValue];
            if(code != 0){
                
                return ;
            }
            [FrameBaseRequest showMessage:@"保存特殊标记成功"];
            NSLog(@"请求成功");
          
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
}

@end
