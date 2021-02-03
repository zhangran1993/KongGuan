//
//  KG_MineViewController.m
//  Frame
//
//  Created by zhangran on 2020/12/9.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_MineViewController.h"

#import "KG_MineFirstCell.h"
#import "KG_MineSecondCell.h"
#import "KG_MineThirdCell.h"
#import "KG_MineFourthCell.h"


#import "KG_CenterCommonViewController.h"
#import "KG_AccountSafeViewController.h"

#import "PersonalMsgController.h"
#import "PersonalMsgListController.h"
#import "PersonalViewController.h"
#import "PersonalViewController.h"
#import "PersonalPatrolController.h"
#import "KG_DutyManageViewController.h"
#import "KG_DataCenterManagerViewController.h"
#import "PersonalAboutUsController.h"
#import "KG_PersonInfoViewController.h"
@interface KG_MineViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
}
@property (nonatomic, strong)   UITableView        *tableView;

@property (nonatomic, strong)   NSArray            *dataArray;

@property (nonatomic, strong)   UILabel            *titleLabel;

@property (nonatomic, strong)   UIView             *navigationView;

@property (nonatomic, strong)   UIButton           *rightButton;

@property (nonatomic, copy)     NSString           *staStr;

@end

@implementation KG_MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom).offset(-58- SafeAreaBottomMargin);
    }];
    [self createNaviTopView];
    [self createBottomView];
    [self stationAction];
}

-(void)viewWillAppear:(BOOL)animated{
    
    NSLog(@"StationDetailController viewWillAppear");
    if (@available(iOS 13.0, *)){
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    }else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    [self.navigationController setNavigationBarHidden:YES];
    
    if([ self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        
        if(@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
        }else{
            
        }
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    NSLog(@"StationDetailController viewWillDisappear");
    
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = YES;
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 320;
    }else if (indexPath.section == 1) {
        return 150;
    }else if (indexPath.section == 2) {
        
        return 330;
    }else if (indexPath.section == 3) {
        
        return 55;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        KG_MineFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_MineFirstCell"];
        if (cell == nil) {
            cell = [[KG_MineFirstCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_MineFirstCell"];
            cell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.pushToNextStep = ^(NSString * _Nonnull title) {
            if ([title isEqualToString:@"消息中心"]) {
                PersonalMsgController *ChooseStation = [[PersonalMsgController alloc] init];
                [self.navigationController pushViewController: ChooseStation animated:YES];
            }else if ([title isEqualToString:@"预警消息"]) {
                PersonalMsgListController  * PersonalMsg = [[PersonalMsgListController alloc] init];
                PersonalMsg.thistitle = @"预警消息";
                [self.navigationController pushViewController: PersonalMsg animated:YES];
            }else if ([title isEqualToString:@"告警消息"]) {
                PersonalMsgListController  * PersonalMsg = [[PersonalMsgListController alloc] init];
                PersonalMsg.thistitle = @"告警消息";
                [self.navigationController pushViewController: PersonalMsg animated:YES];
            }else if ([title isEqualToString:@"公告消息"]) {
                PersonalMsgListController * PersonalMsg = [[PersonalMsgListController alloc] init];
                PersonalMsg.thistitle = @"公告消息";
                [self.navigationController pushViewController: PersonalMsg animated:YES];
            }
        };
        
        cell.pushToPesonalMessPage = ^{
            KG_PersonInfoViewController *vc = [[KG_PersonInfoViewController alloc] init];
            vc.refreshData = ^{
                [self.tableView reloadData];
            };
            vc.stationStr = self.staStr;
            [self.navigationController pushViewController:vc animated:YES];
        };
        cell.staStr = self.staStr;
        return cell;
        
    }else if (indexPath.section == 1) {
        KG_MineSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_MineSecondCell"];
        if (cell == nil) {
            cell = [[KG_MineSecondCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_MineSecondCell"];
            cell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.pushToDataManager = ^{
            [self pushToDataManager];
        };
        
        return cell;
    }else if (indexPath.section == 2) {
        KG_MineThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_MineThirdCell"];
        if (cell == nil) {
            cell = [[KG_MineThirdCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_MineThirdCell"];
            cell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.didselStr = ^(NSString * _Nonnull ss) {
            
            if ([ss isEqualToString:@"台站值班"]) {
                
                KG_DutyManageViewController *vc = [[KG_DutyManageViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([ss isEqualToString:@"通用"]) {
                
                KG_CenterCommonViewController *vc = [[KG_CenterCommonViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([ss isEqualToString:@"夜间模式"]) {
                
                [FrameBaseRequest showMessage:@"夜间模式暂未开放，敬请期待"];
            }else if ([ss isEqualToString:@"夜间模式跟随系统"]) {
                [FrameBaseRequest showMessage:@"夜间模式暂未开放，敬请期待"];
                
            }else if ([ss isEqualToString:@"账号安全"]) {
                
                KG_AccountSafeViewController *vc = [[KG_AccountSafeViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([ss isEqualToString:@"关于我们"]) {
                
                PersonalAboutUsController *vc = [[PersonalAboutUsController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([ss isEqualToString:@"退出登录"]) {
                [self logout];
            }
        };
        
        return cell;
//    }else if (indexPath.section == 3) {
//        KG_MineFourthCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_MineFourthCell"];
//        if (cell == nil) {
//            cell = [[KG_MineFourthCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_MineFourthCell"];
//            cell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//
//
//        return cell;
    }
    return nil;
}


- (NSString *)CurTimeMilSec:(NSString*)pstrTime {
    NSDateFormatter *pFormatter= [[NSDateFormatter alloc]init];
    [pFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *pCurrentDate = [pFormatter dateFromString:pstrTime];
    return [NSString stringWithFormat:@"%.f",[pCurrentDate timeIntervalSince1970] * 1000];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 3) {
        [self logout];
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.001)];
    headView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    return headView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.001;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if(section == 2){
        UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.001)];
        footView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        return footView;
    }
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    footView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    return footView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(section == 2){
        return 0.001;
    }
    return 10;
}

- (void)createNaviTopView {
    
    UIImageView *topImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT +44)];
    [self.view addSubview:topImage1];
    topImage1.backgroundColor  =[UIColor clearColor];
    UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT + 44)];
    [self.view addSubview:topImage];
    topImage.backgroundColor  =[UIColor clearColor];
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
    self.titleLabel.text = @"";
    
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
    leftImage.image = IMAGE(@"backwhite");
    [backBtn addSubview:leftImage];
    [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backBtn.mas_centerX);
        make.centerY.equalTo(backBtn.mas_centerY);
    }];
    
}

- (void)backButtonClick:(UIButton *)button {
    
    //页面返回 效果修改
//    [UIView  beginAnimations:nil context:NULL];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:0.75];
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
//    [UIView commitAnimations];
//
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDelay:0.375];
//    [self.navigationController popViewControllerAnimated:NO];
//    [UIView commitAnimations];
    
    
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionPush;            //改变视图控制器出现的方式
    transition.subtype = kCATransitionFromRight;     //出现的位置
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController popViewControllerAnimated:YES];
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

//退出
-(void)logout{
    UIAlertController *alertContor = [UIAlertController alertControllerWithTitle:@"确定要退出？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertContor addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:nil]];
    [alertContor addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [FrameBaseRequest logout];
        
        //发送退出请求
        [self postLogout];
        
        //[self presentViewController:alertContor animated:NO completion:nil];
        return ;
    }]];
    [self presentViewController:alertContor animated:NO completion:nil];
    
}

-(void)postLogout{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *FrameRequestURL = [WebNewHost stringByAppendingString:@"/intelligent/api/logout"];
    
    [FrameBaseRequest getWithUrl:FrameRequestURL param:params success:^(id result) {
        NSLog(@"/api/logout ---%@---%@", params, result);
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            
            [FrameBaseRequest logout];
            
//            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:@"loginSuccess" object:nil];
            //跳转登陆页
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.slideMenuController showViewController:login];
            
            return ;
        }
        if(code == 0){
            
            [FrameBaseRequest showMessage:result[@"value"]];
            [FrameBaseRequest logout];
//            [[NSNotificationCenter defaultCenter] addObserver:self   selector:@selector(loginSuccess) name:@"loginSuccess" object:nil];
            //跳转登陆页
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.slideMenuController showViewController:login];
        }
        
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        //        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
        //            [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
        //            [FrameBaseRequest logout];
        //             [[NSNotificationCenter defaultCenter] addObserver:self   selector:@selector(loginSuccess) name:@"loginSuccess" object:nil];
        //            LoginViewController *login = [[LoginViewController alloc] init];
        //            [self.slideMenuController showViewController:login];
        //            return;
        //        }else if(responses.statusCode == 502){
        //
        //        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
    
}

//跳转到数据中心
- (void)pushToDataManager {
    
    [FrameBaseRequest showMessage:@"数据中心暂未开放，敬请期待"];
    return;
    
    KG_DataCenterManagerViewController *vc = [[KG_DataCenterManagerViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)stationAction {
    
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:@"/intelligent/api/allStationList"];
    NSLog(@"FrameRequestURL %@",FrameRequestURL);
    [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        [MBProgressHUD hideHUD];
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        NSArray *stationArr = result[@"value"];
        NSMutableString *parStr = [NSMutableString stringWithCapacity:0];
        
        for (NSDictionary *dataDic in stationArr) {
            NSString *staStr = safeString(dataDic[@"name"]);
            [parStr appendString:[NSString stringWithFormat:@"%@、",staStr]];
            
        }
        self.staStr = parStr;
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        [MBProgressHUD hideHUD];
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
        
    }];
    
}

- (void)createBottomView {
    
    UIView *botView = [[UIView alloc]init];
    [self.view addSubview:botView];
    botView.backgroundColor = [UIColor whiteColor];
    [botView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.equalTo(@(58+SafeAreaBottomMargin));
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        
    }];
    
    UIImageView *layerBgImage = [[UIImageView alloc]init];
    [botView addSubview:layerBgImage];
    layerBgImage.image = [UIImage imageNamed:@"kg_logout_sliderBgImage"];
//    layerBgImage.contentMode = UIViewContentModeScaleAspectFit;
    [layerBgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(botView.mas_left);
        make.right.equalTo(botView.mas_right);
        make.top.equalTo(botView.mas_top);
        make.height.equalTo(@58);
    }];
    
    
    UIButton *logOutBtn = [[UIButton alloc]init];
    [botView addSubview:logOutBtn];
    logOutBtn.backgroundColor = [UIColor colorWithHexString:@"#2F5ED1"];
    [logOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [logOutBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    logOutBtn.layer.cornerRadius = 4.f;
    logOutBtn.layer.masksToBounds = YES;
    logOutBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [logOutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [logOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(botView.mas_left).offset(16);
        make.right.equalTo(botView.mas_right).offset(-16);
        make.height.equalTo(@40);
        make.top.equalTo(botView.mas_top).offset(12);
    }];
    
}


@end
