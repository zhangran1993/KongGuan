//
//  PatrolSpecialController
//  Frame
//
//  Created by hibayWill on 2018/3/29.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "PatrolSpecialController.h"
#import "StationItems.h"

#import "FrameBaseRequest.h"
#import <UIImageView+WebCache.h>
#import "PGDatePickManager.h"
#import "FSTextView.h"
#import "PatrolSetController.h"

#import <MJExtension.h>
#import "ValueWeatherStationMoel.h"
#import "ValueClassModel.h"
@interface PatrolSpecialController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray<StationItems *> * StationItem;




@property   int submitNum;

@property(nonatomic) UIView* bottomView;
@property(nonatomic) UITableView *tableview;
@end

@implementation PatrolSpecialController

#pragma mark - 全局常量

#pragma mark - life cycle 生命周期方法

- (void)viewDidLoad {
    [self backBtn];
    self.title =@"特殊巡查";
    [super viewDidLoad];
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, View_Width, View_Height-ZNAVViewH)];
    self.tableview.backgroundColor = [UIColor whiteColor]; //BGColor
    //[self.tableview registerClass:[UITableViewCell class]forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:self.tableview];
    
    self.tableview.delegate =self;
    self.tableview.dataSource =self;
    self.tableview.separatorStyle = NO;
    [self setupTable];
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    // NSLog(@"viewDidAppear");
}
-(void)viewDidDisappear:(BOOL)animated{
    //NSLog(@"PatrolSetController viewDidDisappear");
}
-(void)viewWillLayoutSubviews{
    // NSLog(@"viewWillLayoutSubviews");
}

#pragma mark - private methods 私有方法

- (void)setupTable{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"station_code"] = _stationCode;
    params[@"type_code"] = _type_code;
    
    NSString *  FrameRequestURL = [WebHost stringByAppendingString:@"/api/getSpecialPatrolType"];
    NSLog(@"%@    %@",FrameRequestURL,params);
    [FrameBaseRequest getWithUrl:FrameRequestURL param:params success:^(id resultNo) {
        NSMutableDictionary *result = [resultNo mutableCopy];
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        
        
        NSArray *dict = result[@"value"];
        //NSMutableArray<ValueWeatherStationMoel * > *model = [[ValueWeatherStationMoel class] mj_objectArrayWithKeyValuesArray:dict];
        //定义空的
        NSMutableArray<StationItems *> * arr = [[StationItems class] mj_objectArrayWithKeyValuesArray:@[]];
        //天气巡检
        StationItems *m = [StationItems mj_objectWithKeyValues:@{@"type":@"0",@"name":@"天气巡查",@"LabelHeight":[NSNumber numberWithInt:FrameWidth(85)]}];
        [arr addObject:m];
        for(int i = 0;i< dict.count;i++){
            if([dict[i][@"code"] isEqualToString:@"weatherInspection"]&&[dict[i][@"stationList"] count] > 0){
                NSMutableArray<StationItems *> * dicarr = [[StationItems class] mj_objectArrayWithKeyValuesArray:dict[i][@"stationList"]];
                for (StationItems * dic in dicarr) {
                    dic.specialCode = dict[i][@"code"];
                    dic.LabelHeight = FrameWidth(75);
                    [arr addObject:dic];
                }
            }
        }
        //设备故障巡检
        StationItems *m1 = [StationItems mj_objectWithKeyValues:@{@"type":@"1",@"name":@"设备故障巡检",@"LabelHeight":[NSNumber numberWithInt:FrameWidth(102)]}];
        [arr addObject:m1];
        StationItems *m11 = [StationItems mj_objectWithKeyValues:@{@"type":@"11",@"name":@"(设备故障、大修、重大改造后重新投入使用)",@"LabelHeight":[NSNumber numberWithInt:FrameWidth(75)]}];
        [arr addObject:m11];
        
        for(int i = 0;i< dict.count;i++){
            if([dict[i][@"code"] isEqualToString:@"EquipmentOverhaul"]&&[dict[i][@"stationList"] count] > 0){
                NSMutableArray<StationItems *> * dicarr = [[StationItems class] mj_objectArrayWithKeyValuesArray:dict[i][@"stationList"]];
                for (StationItems * dic in dicarr) {
                    dic.specialCode = dict[i][@"code"];
                    dic.LabelHeight = FrameWidth(75);
                    [arr addObject:dic];
                }
            }
        }
        
        StationItems *m2 = [StationItems mj_objectWithKeyValues:@{@"type":@"2",@"name":@"其他情况",@"LabelHeight":[NSNumber numberWithInt:FrameWidth(102)]}];
        [arr addObject:m2];
        
        StationItems *m21 = [StationItems mj_objectWithKeyValues:@{@"type":@"21",@"name":@"(设备新增、重大保障任务、飞行校飞)",@"LabelHeight":[NSNumber numberWithInt:FrameWidth(75)]}];
        [arr addObject:m21];
        
        for(int i = 0;i< dict.count;i++){
            if([dict[i][@"code"] isEqualToString:@"other"]&&[dict[i][@"stationList"] count] > 0){
                NSMutableArray<StationItems *> * dicarr = [[StationItems class] mj_objectArrayWithKeyValuesArray:dict[i][@"stationList"]];
                for (StationItems * dic in dicarr) {
                    dic.specialCode = dict[i][@"code"];
                    dic.LabelHeight = FrameWidth(75);
                    [arr addObject:dic];
                }
            }
        }
        self.StationItem  = [arr copy];
        NSLog(@"arrarrarrarrarr  %lu",(unsigned long)[self.StationItem count]);
        NSLog(@"ccc");
        
        [self.tableview reloadData];
        
        /*
        [arr addObject:m];
        
        
        
        
        if([dict[@"weatherStation"] count] > 0){
            for (NSDictionary *dic in dict[@"weatherStation"]) {
                StationItems *m = [StationItems mj_objectWithKeyValues:dic];
                m.LabelHeight = FrameWidth(75);
                [arr addObject:m];
            }
        }
        StationItems *m1 = [StationItems mj_objectWithKeyValues:@{@"type":@"1",@"name":@"设备故障巡检",@"LabelHeight":[NSNumber numberWithInt:FrameWidth(102)]}];
        [arr addObject:m1];
        StationItems *m11 = [StationItems mj_objectWithKeyValues:@{@"type":@"11",@"name":@"(设备故障、大修、重大改造后重新投入使用)",@"LabelHeight":[NSNumber numberWithInt:FrameWidth(75)]}];
        [arr addObject:m11];
        if([dict[@"faultStation"] count] > 0){
            for (NSDictionary *dic in dict[@"faultStation"]) {
                StationItems *m = [StationItems mj_objectWithKeyValues:dic];
                m.LabelHeight = FrameWidth(75);
                
                model.faultStation = m;
                [arr addObject:m];
            }
        }
        StationItems *m2 = [StationItems mj_objectWithKeyValues:@{@"type":@"2",@"name":@"其他情况",@"LabelHeight":[NSNumber numberWithInt:FrameWidth(102)]}];
        [arr addObject:m2];
        
        StationItems *m21 = [StationItems mj_objectWithKeyValues:@{@"type":@"21",@"name":@"(设备新增、重大保障任务、飞行校飞)",@"LabelHeight":[NSNumber numberWithInt:FrameWidth(75)]}];
        [arr addObject:m21];
        if([dict[@"anotherStation"] count] > 0){
            for (NSDictionary *dic in dict[@"anotherStation"]) {
                StationItems *m = [StationItems mj_objectWithKeyValues:dic];
                m.LabelHeight = FrameWidth(75);
                model.anotherStation = m;
                [arr addObject:m];
            }
        }
         */
        
    } failure:^(NSURLSessionDataTask *error)  {
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
            [FrameBaseRequest logout];
            UIViewController *viewCtl = self.navigationController.viewControllers[0];
            [self.navigationController popToViewController:viewCtl animated:YES];
            return;
        }else if(responses.statusCode == 502){
            
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
        
    }];
    [self.view addSubview:self.tableview];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.StationItem[indexPath.row].LabelHeight;
}

#pragma mark - UITableviewDatasource 数据源方法
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithHexString:kCellHighlightColor];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.StationItem.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StationItems *station = self.StationItem[indexPath.row];
    UITableViewCell *thiscell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 123, station.LabelHeight)];
    thiscell.selectionStyle = UITableViewCellSelectionStyleNone;//不可选择
    thiscell.backgroundColor = [UIColor whiteColor];
    
    
    
    if([station.type isEqualToString:@"0"]){//天气巡查
        
        
        UIImageView * ImgLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Patrol_weather"]];
        ImgLogo.frame = CGRectMake(FrameWidth(25), FrameWidth(25), FrameWidth(40), FrameWidth(34));
        [thiscell addSubview:ImgLogo];
        UILabel *NameLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(80),0, FrameWidth(500), FrameWidth(85))];
        NameLabel.font = FontSize(18);
        NameLabel.text = station.name;
        [thiscell addSubview:NameLabel];
        
        
    }else if([station.type isEqualToString:@"1"]){//设备故障巡检
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, FrameWidth(15))];
        bgView.backgroundColor = BGColor;
        [thiscell addSubview:bgView];
        
        
        UIImageView * ImgLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Patrol_equipment"]];
        ImgLogo.frame = CGRectMake(FrameWidth(25), FrameWidth(40), FrameWidth(40), FrameWidth(35));
        [thiscell addSubview:ImgLogo];
        UILabel *NameLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(80),FrameWidth(15), FrameWidth(500), FrameWidth(85))];
        NameLabel.font = FontSize(18);
        NameLabel.text = station.name;
        [thiscell addSubview:NameLabel];
        
        
    }else if([station.type isEqualToString:@"2"]){//其他情况
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, FrameWidth(15))];
        bgView.backgroundColor = BGColor;
        [thiscell addSubview:bgView];
        
        
        UIImageView * ImgLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Patrol_other"]];
        ImgLogo.frame = CGRectMake(FrameWidth(25), FrameWidth(40), FrameWidth(40), FrameWidth(38));
        [thiscell addSubview:ImgLogo];
        UILabel *NameLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(80),FrameWidth(15), FrameWidth(500), FrameWidth(85))];
        NameLabel.font = FontSize(18);
        NameLabel.text = station.name;
        [thiscell addSubview:NameLabel];
        
        
    }else{
        UILabel *NameLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(25),0, FrameWidth(590), station.LabelHeight-1)];
        NameLabel.font = FontSize(17);
        NameLabel.text = station.name;
        NameLabel.textColor = [UIColor grayColor];
        [thiscell addSubview:NameLabel];
        
    }
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, station.LabelHeight-0.5, WIDTH_SCREEN, 0.5)];
    lineView.backgroundColor = BGColor;
    [thiscell addSubview:lineView];
    
    return thiscell;
   
}


#pragma mark - UITableviewDelegate 代理方法

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 点击了第indexPath.row行Cell所做的操作
    [self.view endEditing:YES];
    NSLog(@"点击了第%ld行Cell所做的操作",(long)indexPath.row);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.StationItem[indexPath.row].code){
        _type_code = @"special";
        NSMutableDictionary * info = [NSMutableDictionary new];
        info[@"stationCode"] = self.StationItem[indexPath.row].code;
        info[@"specialCode"] = self.StationItem[indexPath.row].specialCode;
        info[@"stationName"] = self.StationItem[indexPath.row].alias;
        info[@"type_code"] = _type_code;
        
        [self specialPatrol:info];
    }
}

-(void)specialPatrol:(NSDictionary*)info{
    _type_code = @"special";
    NSString *  FrameRequestURL = [WebHost stringByAppendingString:[NSString stringWithFormat:@"/api/getAtcPatrolRecode/%@",_type_code]];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        PatrolSetController  *PatrolSet = [[PatrolSetController alloc] init];
        if([result[@"value"][@"status"] isEqualToString:@"0"]&&[info[@"stationCode"] isEqualToString:result[@"value"][@"station_code"] ]){
            PatrolSet.stationCode = result[@"value"][@"station_code"];
            PatrolSet.id = result[@"value"][@"id"];
            PatrolSet.patrolRecordId = result[@"value"][@"id"];
            PatrolSet.status = result[@"value"][@"status"];
        }else{
            PatrolSet.stationCode = info[@"stationCode"];
            PatrolSet.specialCode = info[@"specialCode"];
            PatrolSet.status = @"1";
            
        }
        PatrolSet.stationName = info[@"stationName"];
        PatrolSet.type_code = _type_code;//comprehensive//special
        
        [self.navigationController pushViewController:PatrolSet animated:YES];
        
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
            [FrameBaseRequest logout];
            return;
        }else if(responses.statusCode == 502){
            
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
        
    }];
    
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
@end

