//
//  StationairConditionerController.m
//  Frame
//
//  Created by hibayWill on 2018/5/14.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//


#import "StationairConditionerController.h"
#import "AlarmListController.h"

#import "FrameBaseRequest.h"
#import <MJExtension.h>

@interface StationairConditionerController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray* airConditionerItem;
@property (strong, nonatomic) NSMutableArray*  airConditionerItem2;
@property (strong, nonatomic) UIButton *rightButton;
/** 请求管理者 */
//@property (nonatomic,weak) AFHTTPSessionManager * manager;
/** 用于加载下一页的参数(页码) */
@property(nonatomic) UITableView *tableview;
@end

@implementation StationairConditionerController

#pragma mark - 全局常量



#pragma mark - life cycle 生命周期方法

- (void)viewDidLoad {
    self.tableview.delegate =self;
    self.tableview.dataSource =self;
    self.tableview.separatorStyle = NO;
    
    
    [super viewDidLoad];
    [self backBtn];
    self.navigationItem.title = [NSString stringWithFormat:@"%@-空调控制",_engine_room_name];
    
}
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"shopdetailviewWillAppear  %@",_engine_room_code);
    
    [self setupTable];
}
#pragma mark - private methods 私有方法

- (void)setupTable{
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableview.backgroundColor = BGColor;
    NSString *  FrameRequestURL = [WebHost stringByAppendingString:[NSString stringWithFormat:@"/api/airConditionerList/%@",_engine_room_code]];
    NSLog(@"%@",FrameRequestURL);
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        NSArray * VItem = [result[@"value"] copy];
        
        self.airConditionerItem = [VItem copy];
        
   //重组数组！！！！！
        NSMutableArray *local = [[NSMutableArray alloc] init];
        for (int i = 0; i< self.airConditionerItem.count; i++) {
            NSString *name = self.airConditionerItem[i][@"airConditioner"][@"alias"];
            NSString *code = self.airConditionerItem[i][@"airConditioner"][@"code"];
            NSString *status = @"0";
            NSString *NowStatus = @"已关机";
            NSString *AirConditionNum = @"";
            
            NSArray *airTagList = [self.airConditionerItem[i][@"airTagList"] copy];
            for (int i = 0; i < airTagList.count; i++) {
                NSDictionary * item =  airTagList[i];
                if( [item[@"parameter"] isEqualToString:@"Ct"]){
                    AirConditionNum = item[@"tagValue"];
                    continue;
                }
                if( [item[@"parameter"] isEqualToString:@"StatusV"]){
                    status = item[@"tagValue"] ;
                    if([item[@"tagValue"] isEqualToString:@"0"]){
                        NowStatus = @"已关机";
                        continue;
                    }else{
                        NowStatus = @"已开机";
                        continue;
                    }
                }
            }
            
            [local addObject:@{
                               @"name":name,
                               @"code":code,
                               @"status":status,
                               @"NowStatus":NowStatus,
                               @"AirConditionNum":AirConditionNum,
                               @"airTagList":airTagList
                               }];
        }
        self.airConditionerItem2 = [local mutableCopy];//take care!!
        
        [self.tableview reloadData];
        
        
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
//        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
        
    }];
    
    
    [self.view addSubview:self.tableview];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"StationairConditionerController viewWillDisappear");
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    // NSLog(@"viewDidAppear");
}
-(void)viewDidDisappear:(BOOL)animated{
    //NSLog(@"viewDidDisappear");
}
-(void)viewWillLayoutSubviews{
    // NSLog(@"viewWillLayoutSubviews");
}

#pragma mark - 请求数据方法
/**
 *  发送请求并获取数据方法
 */


- (UITableView *)tableview{
    [_tableview setContentOffset:CGPointMake(0,0)animated:NO];
    if (_tableview ==nil)
    {
        self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN- ZNAVViewH)];
        self.tableview.delegate =self;
        self.tableview.dataSource =self;
        //[self.tableview registerClass:[UITableViewCell class]forCellReuseIdentifier:cellIdentifier];
        [self.view addSubview:self.tableview];
        
    }
    return _tableview;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self.airConditionerItem2[indexPath.row][@"cellheight"] floatValue];
    //return FrameWidth(560);
    
}

#pragma mark - UITableviewDatasource 数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.airConditionerItem2.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *thiscell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, View_Height)];
    thiscell.selectionStyle = UITableViewCellSelectionStyleNone;//不可选择
    thiscell.backgroundColor = [UIColor whiteColor];
    NSDictionary * Item = self.airConditionerItem2[indexPath.row];
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(FrameWidth(20), FrameWidth(25), FrameWidth(600), FrameWidth(535))];
    //[[UIImageView alloc] initWithFrame:CGRectMake(FrameWidth(20), FrameWidth(25), FrameWidth(600), FrameWidth(535))];;
    bgView.image = [UIImage imageNamed:@"station_AirCondition_bg"];
    [thiscell addSubview:bgView];
    
    UIImageView * icon = [[UIImageView alloc] initWithFrame:CGRectMake(FrameWidth(22), FrameWidth(30), FrameWidth(30), FrameWidth(30))];
    icon.image = [UIImage imageNamed:@"station_AirCondition"];
    [bgView addSubview:icon];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(70), FrameWidth(30), FrameWidth(300), FrameWidth(30))];
    title.text = Item[@"alias"] ;
    title.font = FontSize(14);
    title.textColor = [UIColor lightGrayColor];
    [bgView addSubview:title];
    
    
    UILabel * NowStatus =  [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(380), FrameWidth(30), FrameWidth(200), FrameWidth(30))];
    NowStatus.text = Item[@"NowStatus"];//self.airConditionerItem[indexPath.row][@"airConditioner"][@"alias"] ;
    NowStatus.font = FontSize(14);
    NowStatus.textColor = [UIColor lightGrayColor];
    NowStatus.textAlignment = NSTextAlignmentRight;
    NowStatus.tag = indexPath.row +500;
    [bgView addSubview:NowStatus];
    
    UIImageView * lineImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"station_AirCondition_line" ]];
    lineImg.frame = CGRectMake(FrameWidth(24), FrameWidth(73), FrameWidth(550), 1);
    [bgView addSubview:lineImg];
    
    UIButton * on_off = [[UIButton alloc] initWithFrame:CGRectMake(FrameWidth(40), FrameWidth(300), FrameWidth(80), FrameWidth(80))] ;
    [on_off setBackgroundImage:[UIImage imageNamed:@"station_AirCondition_on-off" ] forState:UIControlStateNormal];
    on_off.tag = indexPath.row +10;
    [on_off addTarget:self action:@selector(on_offClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [thiscell addSubview:on_off];
    
    UIButton * airConditionerbg = [[UIButton alloc] initWithFrame:CGRectMake(FrameWidth(170), FrameWidth(100), FrameWidth(250), FrameWidth(250))] ;
    [airConditionerbg setBackgroundImage:[UIImage imageNamed:@"station_AirCondition_bg2" ] forState:UIControlStateNormal];
    [bgView addSubview:airConditionerbg];
    
    UILabel * AirConditionNum = [[UILabel alloc]initWithFrame: CGRectMake(FrameWidth(35), FrameWidth(60), FrameWidth(200), FrameWidth(100))];
    AirConditionNum.textAlignment = NSTextAlignmentCenter;
    AirConditionNum.textColor = FrameColor(153, 228, 193);
    AirConditionNum.text = [NSString stringWithFormat:@"%@°",Item[@"AirConditionNum"]];//  @"150'";
    AirConditionNum.font = FontSize(50);
    AirConditionNum.tag = indexPath.row +400;
    [airConditionerbg addSubview:AirConditionNum ];
    
    UIButton * airConditionerAdd = [[UIButton alloc] initWithFrame:CGRectMake(FrameWidth(485), FrameWidth(180), FrameWidth(90), FrameWidth(90))] ;
    [airConditionerAdd setBackgroundImage:[UIImage imageNamed:@"station_AirCondition_add" ] forState:UIControlStateNormal];
    airConditionerAdd.tag = indexPath.row +100;
    [airConditionerAdd addTarget:self action:@selector(temClick:) forControlEvents:UIControlEventTouchUpInside];
    [thiscell addSubview:airConditionerAdd];
    
    UIButton * airConditionerDelete = [[UIButton alloc] initWithFrame:CGRectMake(FrameWidth(485), FrameWidth(280), FrameWidth(90), FrameWidth(90))] ;
    [airConditionerDelete setBackgroundImage:[UIImage imageNamed:@"station_AirCondition_delete" ] forState:UIControlStateNormal];
    
    airConditionerDelete.tag = indexPath.row +200;
    [airConditionerDelete addTarget:self action:@selector(temClick:) forControlEvents:UIControlEventTouchUpInside];
    [thiscell addSubview:airConditionerDelete];
    
    NSArray *airTagList = [Item[@"airTagList"] copy];//[self.airConditionerItem[indexPath.row][@"airTagList"] copy];
    allHeight = 0;
    for (int i = 0; i < airTagList.count; i++) {
        NSDictionary * item =  airTagList[i];
        if( [item[@"parameter"] isEqualToString:@"Ct"]){
            continue;
        }
        if( [item[@"parameter"] isEqualToString:@"StatusV"]){
            continue;
        }
        
        UILabel * airTagLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(25), FrameWidth(380) + FrameWidth(75) * i, FrameWidth(280), FrameWidth(75))];
        airTagLabel.textColor = [UIColor lightGrayColor];
        airTagLabel.font = FontSize(14);
        airTagLabel.text = [NSString stringWithFormat:@"%@:%@",item[@"name"],item[@"tagValue"]];
        [bgView addSubview:airTagLabel];
        
        UIImageView * lineImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"station_AirCondition_line" ]];
        lineImg.frame = CGRectMake(FrameWidth(5), 0, FrameWidth(550), 2);
        [airTagLabel addSubview:lineImg];
        
        UILabel * airTagStatus = [[UILabel alloc]initWithFrame:CGRectMake(airTagLabel.frame.origin.x +airTagLabel.frame.size.width, 0, FrameWidth(150), FrameWidth(75))];
        airTagStatus.textColor = [UIColor lightGrayColor];
        airTagStatus.font = FontSize(14);
        airTagStatus.text = @"状态:";
        [airTagLabel addSubview:airTagStatus];
        if([item[@"alarmStatus"] intValue]==1){
            //alarmStatus
            UIButton *warnBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(75), FrameWidth(25), FrameWidth(60), FrameWidth(26))];
            warnBtn.layer.cornerRadius = 2;
            [warnBtn setBackgroundColor:FrameColor(242, 108, 107)];
            
            
            [warnBtn setTitle: @"告警"   forState:UIControlStateNormal];
            warnBtn.titleLabel.font = FontBSize(13);
            //[warnBtn setBackgroundImage:[UIImage imageNamed:@"station_warn"] forState:UIControlStateNormal];
            [airTagStatus addSubview:warnBtn];
            
            UIButton *dealBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(473), FrameWidth(430) + FrameWidth(75) * i, FrameWidth(122), FrameWidth(38))];
            
            [dealBtn addTarget:self action:@selector(alarmAction) forControlEvents:UIControlEventTouchUpInside];
            [dealBtn setBackgroundImage:[UIImage imageNamed:@"station_manage"] forState:UIControlStateNormal];
            
            dealBtn.tag = indexPath.row +300;
            [dealBtn addTarget:self action:@selector(dealClick:) forControlEvents:UIControlEventTouchUpInside];
            [thiscell addSubview:warnBtn];
            
            
            
        }else if([item[@"alarmStatus"] intValue]==2){
            
            UIButton *normalBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(75), FrameWidth(25), FrameWidth(60), FrameWidth(28))];
            [normalBtn setTitle: @"--"   forState:UIControlStateNormal];
            [airTagStatus addSubview:normalBtn];
        }else if([item[@"alarmStatus"] intValue]==3){
            UIButton *normalBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(75), FrameWidth(25), FrameWidth(60), FrameWidth(28))];
            [normalBtn setBackgroundColor:FrameColor(252,201,84)];
            normalBtn.layer.cornerRadius = 2;
            normalBtn.titleLabel.font = FontBSize(13);
            [normalBtn setTitle: @"正常"   forState:UIControlStateNormal];
            normalBtn.titleLabel.textColor = [UIColor whiteColor];
            [airTagStatus addSubview:normalBtn];
            
        }else{
            
            UIButton *normalBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(75), FrameWidth(25), FrameWidth(60), FrameWidth(28))];
            [normalBtn setBackgroundColor:FrameColor(120, 203, 161)];
            normalBtn.layer.cornerRadius = 2;
            normalBtn.titleLabel.font = FontBSize(13);
            [normalBtn setTitle: @"正常"   forState:UIControlStateNormal];
            normalBtn.titleLabel.textColor = [UIColor whiteColor];
            [airTagStatus addSubview:normalBtn];
        }
        
        allHeight = airTagLabel.frame.size.height + airTagLabel.frame.origin.y;
    }
    
    if(allHeight < FrameWidth(535)){
        allHeight = FrameWidth(535);
    }
    NSDictionary *dict = @{
                           @"name":self.airConditionerItem2[indexPath.row][@"name"],
                           @"code":self.airConditionerItem2[indexPath.row][@"code"],
                           @"status":self.airConditionerItem2[indexPath.row][@"status"],
                           @"NowStatus":self.airConditionerItem2[indexPath.row][@"NowStatus"],
                           @"AirConditionNum":self.airConditionerItem2[indexPath.row][@"AirConditionNum"],
                           @"airTagList":self.airConditionerItem2[indexPath.row][@"airTagList"],
                           @"cellheight":[NSString stringWithFormat:@"%f",allHeight+bgView.frame.origin.y+10]
                           };
    self.airConditionerItem2[indexPath.row] = [dict copy];
    
    
    
    
    
    bgView.frame = CGRectMake(bgView.frame.origin.x, bgView.frame.origin.y, bgView.frame.size.width, allHeight + FrameWidth(20));
    
    
    
    return thiscell;
    
}


#pragma mark - UITableviewDelegate 代理方法

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 点击了第indexPath.row行Cell所做的操作
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"点击了第%ld行Cell所做的操作",(long)indexPath.row);
    
}

-(void)alarmAction{
    AlarmListController  *AlarmList = [[AlarmListController alloc] init];
    
    //AlarmList.engine_room_name = _room_name;
    [self.navigationController pushViewController:AlarmList animated:YES];
}

-(void)backBtn{
    UIButton *leftButon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    leftButon.frame = CGRectMake(0,0,FrameWidth(60),FrameWidth(60));
    [leftButon setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [leftButon setContentEdgeInsets:UIEdgeInsetsMake(0, - FrameWidth(20), 0, FrameWidth(20))];
    //button.alignmentRectInsetsOverride = UIEdgeInsetsMake(0, offset, 0, -(offset));
    [leftButon addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *fixedButton = [[UIBarButtonItem alloc]initWithCustomView:leftButon];
    self.navigationItem.leftBarButtonItem = fixedButton;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
   
}
-(void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)dealClick:(UIButton *)btn{
    long equipment_num = btn.tag - 10;
    int on_offExt = [self.airConditionerItem2[equipment_num][@"status"] intValue];
    if(on_offExt == 0){
        on_offExt = 1;
    }else{
        on_offExt = 0;
    }
    
    AlarmListController  *AlarmList = [[AlarmListController alloc] init];
    
    //AlarmList.engine_room_name = _room_name;
    [self.navigationController pushViewController:AlarmList animated:YES];
    
}
-(void)on_offClick:(UIButton *)btn{
    
    if(_clickNum != 0){
        return ;
    }
    _clickNum = 1;
    long equipment_num = btn.tag - 10;
    NSString * code = self.airConditionerItem2[equipment_num][@"code"];
    //self.airConditionerItem[equipment_num][@"airConditioner"][@"code"];
    
    int on_offExt = [self.airConditionerItem2[equipment_num][@"status"] intValue];
    if(on_offExt == 0){
        on_offExt = 1;
    }else{
        on_offExt = 0;
    }
    
    NSString *  FrameRequestURL = [WebHost stringByAppendingString:[NSString stringWithFormat:@"/api/airControl/%@/%d",code,on_offExt]];
    NSLog(@"%@",FrameRequestURL);
    [FrameBaseRequest postWithUrl:FrameRequestURL param:nil success:^(id result) {
        _clickNum = 0;
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        UILabel * NowStatus =  [self.view viewWithTag:btn.tag+500];
        if(on_offExt == 0){
            NowStatus.text = @"已关机";
        }else{
            NowStatus.text = @"已开机";;
        }
        [FrameBaseRequest showMessage:result[@"value"][@"msg"]];
        NSDictionary *dict = @{
                               @"name":self.airConditionerItem2[equipment_num][@"name"],
                               @"code":self.airConditionerItem2[equipment_num][@"code"],
                               @"status":[NSString stringWithFormat:@"%d",on_offExt],
                               @"NowStatus":[NSString stringWithFormat:@"%@",NowStatus.text],
                               @"AirConditionNum":self.airConditionerItem2[equipment_num][@"AirConditionNum"],
                               @"airTagList":self.airConditionerItem2[equipment_num][@"airTagList"]
                               };
        self.airConditionerItem2[equipment_num] = [dict copy];
        /*
        [self.airConditionerItem2  setObject:@{
                                      @"name":self.airConditionerItem2[equipment_num][@"name"],
                                      @"code":self.airConditionerItem2[equipment_num][@"code"],
                                      @"status":[NSString stringWithFormat:@"%d",on_offExt],
                                      @"NowStatus":[NSString stringWithFormat:@"%@",NowStatus.text],
                                      @"AirConditionNum":self.airConditionerItem2[equipment_num][@"AirConditionNum"],
                                      @"airTagList":self.airConditionerItem2[equipment_num][@"airTagList"]
                                      } atIndexedSubscript:equipment_num];
        
        */
    } failure:^(NSError *error)  {
        _clickNum = 0;
        FrameLog(@"请求失败，返回数据 : %@",error);
//        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
//            [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
//            [FrameBaseRequest logout];
//            UIViewController *viewCtl = self.navigationController.viewControllers[0];
//            [self.navigationController popToViewController:viewCtl animated:YES];
//            return;
//        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
        
    }];
}

-(void)temClick:(UIButton *)btn{
    
    if(_clickNum != 0){
        return ;
    }
    _clickNum = 1;
    long equipment_num = 0;
    int a = 0;
    if(btn.tag < 200){
        equipment_num = btn.tag - 100;
        a = 1;
    }else{
        equipment_num = btn.tag - 200;
        a = -1;
    }
    
    NSString * code = self.airConditionerItem2[equipment_num][@"code"];
    int temExt = [self.airConditionerItem2[equipment_num][@"AirConditionNum"] intValue];
    
    
    if( temExt+a < 18 || temExt+a >26  ){
        _clickNum = 0;
        [FrameBaseRequest showMessage:@"空调控制失败"];
        return;
    }
    
    
    NSString *  FrameRequestURL = [WebHost stringByAppendingString:[NSString stringWithFormat:@"/api/airControl/%@/%d",code,temExt+a]];
    NSLog(@"%@",FrameRequestURL);
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        _clickNum = 0;
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        
        UILabel * AirConditionNum = [self.view viewWithTag:equipment_num+400];
        AirConditionNum.text = [NSString stringWithFormat:@"%d",temExt+a];
        
        self.airConditionerItem2[equipment_num][@"AirConditionNum"] = [NSString stringWithFormat:@"%d",temExt+a];
        //[self.tableview reloadData];
        
    } failure:^(NSURLSessionDataTask *error)  {
        _clickNum = 0;
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


@end




