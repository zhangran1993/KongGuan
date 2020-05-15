//
//  StationMachineController.m
//  Frame
//
//  Created by hibayWill on 2018/3/30.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "StationMachineController.h"
#import "StationDetailController.h"
#import "FrameBaseRequest.h"
#import <UIImageView+WebCache.h>
#import "StationMachineDetailController.h"
#import "StationMachineInfoListController.h"
#import "StationMachinePictureController.h"
#import "MachineItems.h"
#import "StationItems.h"
#import "UIColor+Extension.h"
#import <MJExtension.h>
#import "StationMachineDetailMoreController.h"
#import "KG_UpsAlertView.h"
#import "KG_MachineStationModel.h"
#import "KG_MachineDetailModel.h"
@interface StationMachineController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray<MachineItems *> * MachineList;
@property (strong, nonatomic) NSArray<MachineItems *> * MachineList1;
@property (strong, nonatomic) NSMutableArray<StationItems *> * StationItem;
@property(strong,nonatomic)UITableView *filterTabView;
@property (strong, nonatomic) KG_UpsAlertView *upsAlertView;
/** 请求管理者 */
//@property (nonatomic,weak) AFHTTPSessionManager * manager;
/** 用于加载下一页的参数(页码) */

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) NSMutableArray *rightArray;

@property (strong, nonatomic) NSMutableArray *detailArray;
@property (strong, nonatomic) KG_MachineDetailModel *detailModel;
@end

@implementation StationMachineController
- (void)viewWillAppear:(BOOL)animated
{
    if(!_station_name){
        [self backAction];
    }
    [self backBtn];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       
       NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#24252A"]}];
    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.translucent = NO;
    
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.filterTabView.delegate =self;
    self.filterTabView.dataSource =self;
    self.filterTabView.separatorStyle = NO;
    self.StationItem = [[StationItems class] mj_objectArrayWithKeyValuesArray:_mList];
    // Do any additional setup after loading the view.
    self.detailModel = [[KG_MachineDetailModel alloc]init];
//    [self getMachineList];
    [self getMachineDetailList];
    [[NSNotificationCenter defaultCenter] addObserver:self   selector:@selector(gotoMachineInfo:) name:@"Machine" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self   selector:@selector(gotoMachinePicture:) name:@"Picture" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self   selector:@selector(gotoMachineAlarmapevent:) name:@"Alarmapevent" object:nil];
    [self getRadarInfoList];
    [self getDetailRightData];
}


-(void)gotoMachineInfo:(NSNotification *)notification{
    NSLog(@"gotoMachineInfo通知过来的 - dic = %@",notification.object);
    StationMachineInfoListController  *MachineInfoList = [[StationMachineInfoListController alloc] init];
    NSDictionary *dic = notification.object;
    MachineInfoList.machineDetail = dic;
    
    [self.navigationController pushViewController:MachineInfoList animated:YES];
}


-(void)gotoMachinePicture:(NSNotification *)notification{
    NSLog(@"gotoMachinePicture通知过来的 - dic = %@",notification.object);
    StationMachinePictureController  *MachinePicture = [[StationMachinePictureController alloc] init];
    NSDictionary *dic = notification.object;
    MachinePicture.picture = dic[@"picture"];
    
    MachinePicture.thisTitle = [NSString stringWithFormat:@"%@-%@",dic[@"roomName"],dic[@"alias"]];
    [self.navigationController pushViewController:MachinePicture animated:YES];
}


-(void)gotoMachineAlarmapevent:(NSNotification *)notification{
    //NSLog(@"gotoMachineAlarmapevent通知过来的 - dic = %@",notification.object);
    self.navigationController.tabBarController.hidesBottomBarWhenPushed=NO;
    self.navigationController.tabBarController.selectedIndex = 1;
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    /*
     StationMachineInfoListController  *MachineInfoList = [[StationMachineInfoListController alloc] init];
     NSDictionary *dic = notification.object;
     MachineInfoList.machineDetail = dic;
     
     [self.navigationController pushViewController:MachineInfoList animated:YES];
     */
}

-(void)dealloc{
    //第一种方法.这里可以移除该控制器下的所有通知
    // 移除当前所有通知
    NSLog(@"移除了所有的通知");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //第二种方法.这里可以移除该控制器下名称为tongzhi的通知
    //移除名称为tongzhi的那个通知
    //NSLog(@"移除了名称为Machine的通知");
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"Machine" object:nil];
    [super dealloc];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return FrameWidth(56);
}

#pragma mark - UITableviewDatasource 数据源方法
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.filterTabView) {
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorWithHexString:kCellHighlightColor];
    }
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.filterTabView) {
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.filterTabView){
        return self.StationItem.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//不可选择
    
    StationItems *item = self.StationItem[indexPath.row];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(80), 0, FrameWidth(220), FrameWidth(54))];
    titleLabel.text = item.name;
    titleLabel.font =  FontSize(15);
    [cell addSubview:titleLabel];
    
    UIImageView *dot = [[UIImageView alloc] initWithFrame:CGRectMake(FrameWidth(55), FrameWidth(20), FrameWidth(12), FrameWidth(12))];
    dot.image = [UIImage imageNamed:@"station_dian"];
    [cell addSubview:dot];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 点击了第indexPath.row行Cell所做的操作
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"点击了第%ld行Cell所做的操作",(long)indexPath.row);
    StationItems *item = self.StationItem[indexPath.row];
    NSLog(@"点击了第行Cell所做的操作%@",item.code);
    if(item.code){
        _category = item.code;
        _machine_name = item.name;
        [self closeFrame];
//        [self getMachineList];
        [self getMachineDetailList];
    }
}

-(void)getRadarInfoList{
    NSString *  FrameRequestURL = [WebHost stringByAppendingString:[NSString stringWithFormat:@"/api/equipmentInfo/%@/%@?engine_room_code=%@",_station_code,_category,_engine_room_code]];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        
        
        
    } failure:^(NSURLSessionDataTask *error)  {
        
        
    }];
    
    
}
//获取设备详情页面右上角，台站下设备分类接口：
//请求地址：/intelligent/api/envDeviceCategory/{stationCode}
//     其中，stationCode是台站编码
//请求方式：GET
//如：http://10.33.33.147:8089/intelligent/api/envDeviceCategory/HCDHT

- (void)getDetailRightData {
//    NSString *  FrameRequestURL  =  @"http://10.33.33.147:8089/intelligent/api/envDeviceCategory/HCDHT";
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/api/envDeviceCategory/HCDHT"]];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        self.rightArray = result[@"value"];
        
        
    } failure:^(NSURLSessionDataTask *error)  {
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
}
- (void)getTemHuiData {
//    NSString *  FrameRequestURL  =  @"http://10.33.33.147:8089/intelligent/api/envRoomInfo/HCDHT/HCDHT-PDS";
    
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/api/envRoomInfo/HCDHT/HCDHT-PDS"]];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        self.dataArray = [KG_MachineStationModel mj_objectArrayWithKeyValuesArray:result[@"value"]];
        
        
        
    } failure:^(NSURLSessionDataTask *error)  {
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
}
//获取某个台站下某个机房的详情页接口：
//请求地址：/intelligent/api/envRoomInfo/{stationCode}/{engineRoomCode}
//     其中，stationCode是台站编码，engineRoomCode是机房编码
//请求方式：GET
//请求返回：
//   如：
//{

-(void)getMachineDetailList{
//    NSString *  FrameRequestURL = [NSString stringWithFormat:@"http://10.33.33.147:8089/intelligent/api/envDeviceInfo/%@/%@",_station_code,_category];
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/api/envDeviceInfo/%@/%@",_station_code,_category]];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        NSArray *equipmentDetails = result[@"value"][@"equipmentDetails"];
        if (equipmentDetails.count == 0) {
            return;
        }
        NSMutableArray * titleArr = [[NSMutableArray alloc] init];
        NSMutableArray * controllerArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < equipmentDetails.count; i++) {
            [titleArr addObject:equipmentDetails[i][@"equipment"][@"alias"]];
            
            NSDictionary * Detail = @{@"station_name":_station_name,
                                      @"machine_name":_machine_name,
                                      @"name":equipmentDetails[i][@"equipment"][@"alias"],
                                      @"alias":equipmentDetails[i][@"equipment"][@"alias"],
                                      @"code":equipmentDetails[i][@"equipment"][@"code"],
                                      @"roomName":equipmentDetails[i][@"equipment"][@"roomName"],
                                      @"picture":equipmentDetails[i][@"equipment"][@"picture"],
                                      @"status":equipmentDetails[i][@"status"],
                                      @"level":equipmentDetails[i][@"level"]?equipmentDetails[i][@"level"]:@"",
                                      @"num":equipmentDetails[i][@"num"]?equipmentDetails[i][@"num"]:@"",
                                      @"category":equipmentDetails[i][@"equipment"][@"category"],
                                      @"tagList":equipmentDetails[i][@"equipment"][@"measureTagList"],
                                      @"description":equipmentDetails[i][@"equipment"][@"description"]
            };
            //_machine_name = equipmentDetails[i][@"equipment"][@"alias"];
            StationMachineDetailController *oneVC = [[StationMachineDetailController alloc] init];
            oneVC.moreAction = ^{
                StationMachineDetailMoreController *vc = [[StationMachineDetailMoreController alloc]init];
                vc.machineDetail = Detail;
                [self.navigationController pushViewController:vc animated:YES];
            };
            
            oneVC.machineDetail = Detail;
            
            [controllerArr addObject:oneVC];
            
        }
        self.machineDetail = @{@"station_name":_station_name,
                               @"machine_name":_machine_name,
                               @"station_code":_station_code,
                               @"category":_category,
                               @"engine_room_code":_engine_room_code,
                               @"totalDetail":result[@"value"][@"totalDetail"]
        };
        
        self.title = [NSString stringWithFormat:@"%@-%@",_station_name,_machine_name];
        if(titleArr == nil || controllerArr == nil){
            [FrameBaseRequest showMessage:@"请求失败，请检查网络"];
            return ;
        }
        
        self.titleArray = titleArr;
        self.controllerArray = controllerArr;
        
        [self.detailModel mj_setKeyValues:result[@"value"]];
        
        
        
        NSLog(@"1");
    } failure:^(NSURLSessionDataTask *error)  {
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
    
}

-(void)getMachineList{
    NSString *  FrameRequestURL = [WebHost stringByAppendingString:[NSString stringWithFormat:@"/api/equipmentInfo/%@/%@?engine_room_code=%@",_station_code,_category,_engine_room_code]];
    
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
//        NSArray *equipmentDetails = result[@"value"][@"equipmentDetails"];
//        NSMutableArray * titleArr = [[NSMutableArray alloc] init];
//        NSMutableArray * controllerArr = [[NSMutableArray alloc] init];
//        for (int i = 0; i < equipmentDetails.count; i++) {
//            [titleArr addObject:equipmentDetails[i][@"equipment"][@"alias"]];
//
//            NSDictionary * Detail = @{@"station_name":_station_name,
//                                      @"machine_name":_machine_name,
//                                      @"name":equipmentDetails[i][@"equipment"][@"alias"],
//                                      @"alias":equipmentDetails[i][@"equipment"][@"alias"],
//                                      @"code":equipmentDetails[i][@"equipment"][@"code"],
//                                      @"roomName":equipmentDetails[i][@"equipment"][@"roomName"],
//                                      @"picture":equipmentDetails[i][@"equipment"][@"picture"],
//                                      @"status":equipmentDetails[i][@"status"],
//                                      @"level":equipmentDetails[i][@"level"]?equipmentDetails[i][@"level"]:@"",
//                                      @"num":equipmentDetails[i][@"num"]?equipmentDetails[i][@"num"]:@"",
//                                      @"category":equipmentDetails[i][@"equipment"][@"category"],
//                                      @"tagList":equipmentDetails[i][@"equipment"][@"tagList"],
//                                      @"description":equipmentDetails[i][@"equipment"][@"description"]
//            };
//            //_machine_name = equipmentDetails[i][@"equipment"][@"alias"];
//            StationMachineDetailController *oneVC = [[StationMachineDetailController alloc] init];
//            oneVC.moreAction = ^{
//                StationMachineDetailMoreController *vc = [[StationMachineDetailMoreController alloc]init];
//                vc.machineDetail = Detail;
//                [self.navigationController pushViewController:vc animated:YES];
//            };
//
//            oneVC.machineDetail = Detail;
//
//            [controllerArr addObject:oneVC];
//
//        }
//        self.machineDetail = @{@"station_name":_station_name,
//                               @"machine_name":_machine_name,
//                               @"station_code":_station_code,
//                               @"category":_category,
//                               @"engine_room_code":_engine_room_code,
//                               @"totalDetail":result[@"value"][@"totalDetail"]
//        };
//
//        self.title = [NSString stringWithFormat:@"%@-%@",_station_name,_machine_name];
//        if(titleArr == nil || controllerArr == nil){
//            [FrameBaseRequest showMessage:@"请求失败，请检查网络"];
//            return ;
//        }
//
//        self.titleArray = titleArr;
//        self.controllerArray = controllerArr;
//
//
    } failure:^(NSURLSessionDataTask *error)  {
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
    
    
    
    
}

-(void)getMachinetypeList{
    
    if (self.upsAlertView.isHidden) {
        self.upsAlertView.hidden = NO;
    }
    
    //    float moreheight = FrameWidth(900);
    //    if(HEIGHT_SCREEN == 812){
    //        moreheight = -FrameWidth(1100);
    //    }
    //    UIViewController *vc = [UIViewController new];
    //
    //    vc.view.frame = CGRectMake(FrameWidth(320), FrameWidth(128), FrameWidth(320),  moreheight);
    //    //_vc.view.layer.cornerRadius = 4.0;
    //    vc.view.layer.masksToBounds = YES;
    //    UIImageView * xialaImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, FrameWidth(300),  FrameWidth(20))];
    //    xialaImage.image = [UIImage imageNamed:@"station_pulldown_right"];
    //    [vc.view addSubview:xialaImage];
    //
    //    float tabelHeight = self.StationItem.count * FrameWidth(56);
    //    if(tabelHeight > FrameWidth(400)){
    //        tabelHeight = FrameWidth(400);
    //    }
    //
    //    //设置滚动
    //    self.filterTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, FrameWidth(20), FrameWidth(300) , tabelHeight)];
    //    self.filterTabView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //    [vc.view addSubview:self.filterTabView];
    //    self.filterTabView.dataSource = self;
    //    self.filterTabView.delegate = self;
    //    [self.filterTabView reloadData];
    //
    //    UIView *alphaView = [[UIView alloc]initWithFrame:CGRectMake(0, tabelHeight, FrameWidth(300),  FrameWidth(1000))];
    //    alphaView.userInteractionEnabled = YES;
    //    UITapGestureRecognizer *viewTapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeFrame)];
    //    [alphaView addGestureRecognizer:viewTapGesture];
    //    [viewTapGesture setNumberOfTapsRequired:1];
    //    [vc.view addSubview:alphaView];
    //
    //
    //    [self cb_presentPopupViewController:vc animationType:CBPopupViewAnimationSlideFromRight aligment:CBPopupViewAligmentRight overlayDismissed:nil];
    
}
-(void)closeFrame{//消失
    
    [self cb_dismissPopupViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(void)backBtn{
    UIButton *leftButon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    leftButon.frame = CGRectMake(0,0,FrameWidth(60),FrameWidth(60));
    [leftButon setImage:[UIImage imageNamed:@"back_gray"] forState:UIControlStateNormal];
    [leftButon setContentEdgeInsets:UIEdgeInsetsMake(0, - FrameWidth(20), 0, FrameWidth(20))];
    //button.alignmentRectInsetsOverride = UIEdgeInsetsMake(0, offset, 0, -(offset));
    [leftButon addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *fixedButton = [[UIBarButtonItem alloc]initWithCustomView:leftButon];
    self.navigationItem.leftBarButtonItem = fixedButton;
    
    UIButton *rightButon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightButon.frame = CGRectMake(0,0,FrameWidth(40),FrameWidth(40));
    [rightButon setImage:[UIImage imageNamed:@"ups_right"] forState:UIControlStateNormal];
    [rightButon addTarget:self action:@selector(getMachinetypeList) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightfixedButton = [[UIBarButtonItem alloc]initWithCustomView:rightButon];
    self.navigationItem.rightBarButtonItem = rightfixedButton;
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}
-(void)backAction {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"bottomapevent" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (KG_UpsAlertView *)upsAlertView {
    if (!_upsAlertView) {
        _upsAlertView = [[KG_UpsAlertView alloc]init];
        [JSHmainWindow addSubview:self.upsAlertView];
        [self.upsAlertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.left.equalTo(self.view);
            make.top.equalTo(self.view.mas_top).offset(-NAVIGATIONBAR_HEIGHT);
            
        }];
        _upsAlertView.dataArray = self.rightArray;
        _upsAlertView.didsel = ^(NSDictionary * _Nonnull selDic) {
            _category =safeString(selDic[@"categoryCode"]);
            [self getMachineDetailList];
        };
        
    }
    return _upsAlertView;
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
- (NSMutableArray *)rightArray
{
    if (!_rightArray) {
        _rightArray = [[NSMutableArray alloc] init];
    }
    return _rightArray;
}
- (NSMutableArray *)detailArray
{
    if (!_detailArray) {
        _detailArray = [[NSMutableArray alloc] init];
    }
    return _detailArray;
}


@end
