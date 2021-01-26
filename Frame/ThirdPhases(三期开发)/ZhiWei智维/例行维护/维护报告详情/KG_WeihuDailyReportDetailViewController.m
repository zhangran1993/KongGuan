//
//  KG_XunShiReportDetailViewController.m
//  Frame
//
//  Created by zhangran on 2020/4/24.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_WeihuDailyReportDetailViewController.h"
#import "KG_XunShiReportDetailModel.h"
#import "KG_EquipResultCell.h"
#import "KG_XunShiReportDataModel.h"
#import "KG_XunShiTopView.h"
#import "KG_XunShiHandleView.h"
#import "KG_XunShiResultView.h"
#import "KG_XunShiRadarView.h"
#import "KG_XunShiReportDetailCell.h"
#import "KG_XunShiResultView.h"
#import "KG_XunShiResultCell.h"
#import "KG_XunShiDetailLogCell.h"
#import "KG_EquipCardViewController.h"
#import "KG_WeiHuDetailReportDataModel.h"
#import "KG_XunShiReportDataModel.h"
#import "KG_WeiHuContentCell.h"
#import "KG_OperationGuideViewController.h"
#import "KG_RemoveTaskView.h"
#import "KG_AddressbookViewController.h"
@interface KG_WeihuDailyReportDetailViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong)   NSArray *dataArray;
/**  标题栏 */
@property (nonatomic, strong)   UILabel                    *titleLabel;

@property (nonatomic, strong)   UIView                     *navigationView;

@property (strong, nonatomic)   UIImageView                *topImage1;

@property (strong, nonatomic)   KG_XunShiReportDetailModel *dataModel;

@property (strong, nonatomic)   KG_XunShiTopView           *xunshiTopView;

@property (strong, nonatomic)   KG_XunShiHandleView        *xunShiHandelView;

@property (strong, nonatomic)   KG_XunShiReportDataModel   *listModel;

@property (strong, nonatomic)   taskDetail                 *radarModel;

@property (strong, nonatomic)   taskDetail                 *powerModel;

@property (strong, nonatomic)   taskDetail                 *upsModel;

@property (strong, nonatomic)   KG_XunShiRadarView         *radarView;

@property (strong, nonatomic)   KG_XunShiRadarView         *powerView;

@property (strong, nonatomic)   KG_XunShiRadarView         *upsView;

@property (strong, nonatomic)   UIScrollView               *scrollView;

@property (strong, nonatomic)   UITableView                *tableView;

@property (strong, nonatomic)   KG_XunShiResultView              *resultView;

@property (strong, nonatomic)   NSArray                          *receiveArr;

@property (strong, nonatomic)   NSArray                          *logArr;

@property (nonatomic, strong)   UIView                           *tableHeadView;

@property (strong, nonatomic)   NSArray                          *equipArr;

@property (nonatomic, strong)   KG_WeiHuDetailReportDataModel    *weihuModel;

@property (strong, nonatomic)   NSDictionary                     *xunshiTopDic;

@property (nonatomic, strong)   UIButton                         *moreBtn;

@property (nonatomic, assign)   BOOL                             canUpdateOrSubmit;

@property (nonatomic, strong)   KG_RemoveTaskView                *alertView;

@end

@implementation KG_WeihuDailyReportDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushRemoveToAddressBook) name:@"pushRemoveToAddressBook" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveWeiHuSpecialData:) name:@"saveWeiHuSpecialData" object:nil];
    self.dataModel = [[KG_XunShiReportDetailModel alloc]init];
    self.listModel = [[KG_XunShiReportDataModel alloc]init];
    self.canUpdateOrSubmit = YES;
    
    self.radarModel = [[taskDetail alloc]init];
    self.powerModel = [[taskDetail alloc]init];
    self.upsModel = [[taskDetail alloc]init];
    [self createNaviTopView];
    [self createDataView];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    NSLog(@"StationDetailController viewWillAppear");
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBarHidden = YES;
    [self queryReportDetailData];
    [self getTemplateData];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillDisappear");
    self.navigationController.navigationBarHidden = NO;
   
}

-(void)dealloc
{
    [super dealloc];
    //第一种方法.这里可以移除该控制器下的所有通知
    //移除当前所有通知
    NSLog(@"移除了所有的通知");
    [[NSNotificationCenter defaultCenter] removeObserver:self];

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

        frame.size.height = 128.0 + 54;// 新高度

        tableHeaderView.frame = frame;

        self.tableView.tableHeaderView = tableHeaderView;
        self.xunshiTopView.dic = self.xunshiTopDic;
        [self.xunshiTopView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tableHeadView.mas_left);
            make.right.equalTo(self.tableHeadView.mas_right);
            make.top.equalTo(self.tableHeadView.mas_top);
            make.height.equalTo(@(128 + 54));
        }];
    };
    
    self.xunshiTopView.zhankaiMethod = ^{
        UIView *tableHeaderView = self.tableView.tableHeaderView;
        
        CGRect frame = tableHeaderView.frame;
        
        [tableHeaderView removeFromSuperview];
        
        self.tableView.tableHeaderView = nil;
        
        frame.size.height = 266.0;// 新高度
        
        tableHeaderView.frame = frame;
        
        self.tableView.tableHeaderView = tableHeaderView;
        self.xunshiTopView.dic = self.xunshiTopDic;
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
    
    return self.dataArray.count + 2;
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
    if (indexPath.section == self.dataArray.count) {
        if(self.equipArr.count == 0 ){
            
            return 100;
        }
        return SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT;
    }else if (indexPath.section == self.dataArray.count + 1) {
        return 280;
    }
    
    NSInteger totalHeight = 0;
  
    taskDetail *model = self.dataArray[indexPath.section];
    
    NSInteger firstHeight = 44 ;
    //第一层 model.childrens 44
    //第二层 model.childrens firstobject  44
    NSArray *secondArr = model.childrens;
    NSInteger secondHeight = [secondArr count] *(44 +2);
    //第三层
    NSInteger thirdHeight = 0;
    NSInteger fourthHeight = 0;
    
    for (NSDictionary *dic in secondArr) {
        NSArray *thirdArr = dic[@"childrens"];
        
        int num = 0;
        for (NSDictionary *detailArr in thirdArr) {
            if (![detailArr[@"cardDisplay"] boolValue]) {
               NSArray *fourthArr = detailArr[@"childrens"];
                thirdHeight += 40;
                if (fourthArr.count) {
                    fourthHeight += [fourthArr count] *40;
                    for (NSDictionary *fifDic in fourthArr) {
                        if (isSafeDictionary(fifDic[@"atcSpecialTag"])) {
                            NSDictionary *specDic = fifDic[@"atcSpecialTag"];
                            if ([[specDic allValues] count] >0) {
                                fourthHeight += 57;
                            }
                        }
                    }
                }
                num ++;
            }
        }
//        if (num>0 &&thirdArr.count >0) {
//            thirdHeight += 30;
//        }
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
    if (indexPath.section <self.dataArray.count ) {
        KG_WeiHuContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_WeiHuContentCell"];
        if (cell == nil) {
            cell = [[KG_WeiHuContentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_WeiHuContentCell"];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        taskDetail *model  = self.dataArray[indexPath.section];
        cell.model = model;
        return cell;
        
    }else if (indexPath.section == self.dataArray.count ) {
        KG_EquipResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_EquipResultCell"];
        if (cell == nil) {
            cell = [[KG_EquipResultCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_EquipResultCell"];
        }
        cell.moreBlockMethod = ^(NSDictionary * _Nonnull dataDic) {
            KG_OperationGuideViewController *vc  = [[KG_OperationGuideViewController alloc]init];
            vc.dataDic = dataDic;
            [self.navigationController pushViewController:vc animated:YES];
        };
        
        cell.dataDic = self.dataDic;
        cell.listArray = self.equipArr;
        cell.dataModel = self.dataModel;

        cell.moreAction = ^{
            KG_EquipCardViewController *vc = [[KG_EquipCardViewController alloc]init];
            vc.saveSuccessBlock = ^{
//                [self.moreBtn removeFromSuperview];
//                self.moreBtn = nil;
//                self.moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//                [self.moreBtn addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
//                [self.moreBtn setImage:[UIImage imageNamed:@"white_more"] forState:UIControlStateNormal];
//                [self.navigationView addSubview:self.moreBtn];
//                [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.width.height.equalTo(@44);
//                    make.centerY.equalTo(self.titleLabel.mas_centerY);
//                    make.right.equalTo(self.navigationView.mas_right).offset(-13);
//                }];
            };
            vc.dataDic = self.dataDic;
            vc.listArray = self.equipArr;
            vc.dataModel = self.dataModel;
            
            [self.navigationController pushViewController:vc animated:YES];
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
        
    }else if (indexPath.section == self.dataArray.count +1 ) {
        KG_XunShiDetailLogCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_XunShiDetailLogCell"];
        
        if (cell == nil) {
            cell = [[KG_XunShiDetailLogCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_XunShiDetailLogCell"];
        }
        if (self.receiveArr.count) {
            cell.receiveArr = self.receiveArr;
        }
        cell.uploadReceive = ^(NSString * _Nonnull textStr) {
            [self uploadReceiveData:textStr];
        };
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
    self.topImage1.image  =[UIImage imageNamed:@"zhiwei_topBgImage"];
    
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
    self.titleLabel.text = @"维护报告详情";
    NSString *ss = safeString(self.dataDic[@"patrolCode"]);
    if ([ss isEqualToString:@"monthSafeguard"] ) {
        self.titleLabel.text = [NSString stringWithFormat:@"%@%@",safeString(self.dataDic[@"stationName"]),@"月维护报告"];
    }else if([ss isEqualToString:@"daySafeguard"]){
        self.titleLabel.text = [NSString stringWithFormat:@"%@%@",safeString(self.dataDic[@"stationName"]),@"日维护报告"];
    }else if ([ss isEqualToString:@"yearSafeguard"]){
        self.titleLabel.text = [NSString stringWithFormat:@"%@%@",safeString(self.dataDic[@"stationName"]),@"年维护报告"];
    }else if ([ss isEqualToString:@"weekSafeguard"] ){
        self.titleLabel.text = [NSString stringWithFormat:@"%@%@",safeString(self.dataDic[@"stationName"]),@"周维护报告"];
    }
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
     [UserManager shareUserManager].isChangeTask = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

//修改：只有执行负责人可以修改任务内容，但是不能添加特殊标记，领导可以添加特殊标记，不能修改任务内容
//           移交：执行负责人和领导都可以移交任务 但是已经完成的任务（已经提交过一次的任务）不能再次移交
//           提交： 已经提交过一次的任务（已经完成的任务）不能再次提交
//           删除：只有领导有权限删除任务
- (void)moreAction {
    if(!self.canUpdateOrSubmit) {
//        [FrameBaseRequest showMessage:@"任务已完成，不能执行此操作"];
//        return;
    }
    [_xunShiHandelView removeFromSuperview];
    _xunShiHandelView= nil;
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
            NSLog(@"修改任务");
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
- (void)deleteTask {
    
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
        }];
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
            [FrameBaseRequest showMessage:@"移交成功"];
            self.alertView.hidden = YES;
        }
        
        [self queryReportDetailData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshZhiWeiData" object:self];
        
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
    paramDic[@"description"] = @"";
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
        [UserManager shareUserManager].resultDic = nil;
        [UserManager shareUserManager].isChangeTask = NO;
        [self getLogData];
        [self queryReportDetailData];
        [self.tableView reloadData];
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
    NSDictionary *resultDic = [NSDictionary dictionaryWithObjectsAndKeys:@"干净",@"99f29833-0c39-48f9-81b3-9246e25ee9f7",@"18s",@"233b470f-0d6f-43a6-9f35-dcaa43657e27", nil];
    paramDic[@"result"] = [self convertToJsonData:resultDic];
    paramDic[@"status"] = @"2";
    paramDic[@"description"] = @"";
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
    NSString *FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcSafeguard/getTourInfoById/%@",rId]];
    
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
                        for (fourthData *fourthData in thirdData.childrens) {
                            NSString *valueStr = safeString(fourthData.measureValueAlias);
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
        NSMutableArray *taskArr = [NSMutableArray arrayWithCapacity:0];
        [taskArr addObjectsFromArray:self.dataModel.task];
        if (taskArr.count >0) {
            [taskArr removeLastObject];
        }
        self.dataArray = taskArr;
        NSArray *arr = result[@"value"][@"task"];
        if (arr.count >0) {
            NSDictionary *infoDic = [arr lastObject];
            NSArray *darr = infoDic[@"systemAndEquipmentInfo"];
            self.equipArr = darr;
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
        self.xunshiTopDic = result[@"value"];
        
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
    NSString *timeStr=[[self dateFormatWith:@"YYYY年MM月dd日HH时mm分"] stringFromDate:date];
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
    NSString *rId = safeString(self.dataDic[@"id"]) ;
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

- (void)saveWeiHuSpecialData:(NSNotification *)notification {
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
