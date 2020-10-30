//
//  KG_InstrumentationViewController.m
//  Frame
//
//  Created by zhangran on 2020/9/22.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_EquipmentHistoryDetailViewController.h"

#import "KG_EquipmentHistoryFirstCell.h"
#import "KG_EquipmentHistorySecondCell.h"
#import "KG_EquipmentHistoryThirdCell.h"
#import "KG_EquipmentHistoryFourthCell.h"
#import "KG_SparePartsCell.h"
#import "KG_LastestWarnTotalCell.h"
#import "KG_EquipmentHistoryFourthCell.h"
#import "KG_EquipmentHistoryDetailModel.h"
#import "KG_EquipmentHistoryDetailMoreViewController.h"
#import "KG_FaultEventRecordViewController.h"
#import "KG_EquipmentAdjustmentRecordViewController.h"
#import "KG_WatchPdfViewController.h"
@interface KG_EquipmentHistoryDetailViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    
}

@property (nonatomic,strong)    UITableView             *tableView;

@property (nonatomic,strong)    NSMutableArray          *dataArray;

@property (nonatomic, strong)   UILabel                 *titleLabel;

@property (nonatomic, strong)   UIView                  *navigationView;

@property (nonatomic, strong)   UIButton                *searchBtn;

@property (nonatomic, strong)   UIButton                *rightButton;

@property (nonatomic, strong)   KG_EquipmentHistoryDetailModel *dataModel;

@end

@implementation KG_EquipmentHistoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    self.dataModel = [[KG_EquipmentHistoryDetailModel alloc]init];
    [self createNaviTopView];
    
    [self createUI];
    [self createTableView];
    //设备故障事件记录
    [self queryEquipmentFailureEventRecordData];
    //设备告警记录
    [self queryEquipmentAutomaticAlarmListData];
    //设备调整记录
    [self queryEquipmentAdjustmentData];
    //查询技术资料
    [self queryTechnicalInformationData];
    //查询巡视
    [self getDeviceXunshiData];
    //查询维护
    [self getDeviceWeihuData];
    //查询特殊保障
    [self getDeviceSpecialData];
    
    
    //查询备件大分类
    [self querySparePartData];
  
}

-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillAppear");
    if (@available(iOS 13.0, *)){
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    }else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    [self.navigationController setNavigationBarHidden:YES];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillDisappear");
    
}

- (void)createTableView {
       
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
  
}

- (void)createUI {
   
    
}
- (void)createNaviTopView {
    
    UIImageView *topImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT +44)];
    [self.view addSubview:topImage1];
    topImage1.backgroundColor  =[UIColor whiteColor];
    UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT + 44)];
    [self.view addSubview:topImage];
    topImage.backgroundColor  =[UIColor whiteColor];
    topImage.image = [UIImage imageNamed:@"kg_InstruTopImage"];
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
    self.titleLabel.text = safeString(self.dataDic[@"name"]);
    
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

- (void)searchAction:(UIButton *)btn {
    
}

- (void)backButtonClick:(UIButton *)button {
    
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

-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = YES;
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 13;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   if(indexPath.section == 0) {
       
       return 170;
       
   }else if(indexPath.section == 1) {
       
       return 45*5;
       
   }else if(indexPath.section == 2) {
       
       return 45*5;
       
   }else if(indexPath.section == 3) {
       if (self.dataModel.equipmentFailureList.count >2) {
           return 50 +80 +40;
       }
       return 50  +self.dataModel.equipmentFailureList.count *40;
       
   }else if(indexPath.section == 4) {
       if (self.dataModel.equipmentWarnRecordList.count >2) {
           return 50 +80 +40;
       }
       return 50 +self.dataModel.equipmentWarnRecordList.count *40;
       
   }else if(indexPath.section == 5) {
       if (self.dataModel.equipmentAdjustList.count >2) {
           return 50 +80 +40;
       }
        return 50 +self.dataModel.equipmentAdjustList.count *40;
       
   }else if(indexPath.section == 6) {
       if (self.dataModel.technicalInformationList.count >2) {
           return 50 +80 +40;
       }
        return 50 +self.dataModel.technicalInformationList.count *40;
       
   }else if(indexPath.section == 7) {
       if (self.dataModel.xunShiList.count >2) {
           return 50 +80 +40;
       }
        return 50 +self.dataModel.xunShiList.count *40;
       
   }else if(indexPath.section == 8) {
       if (self.dataModel.weiHuList.count >2) {
           return 50 +80 +40;
       }
        return 50 +self.dataModel.weiHuList.count *40;
       
   }else if(indexPath.section == 9) {
       if (self.dataModel.specialGuaranteeList.count >2) {
           return 50 +80 +40;
       }
        return 50 +self.dataModel.specialGuaranteeList.count *40;
       
   }else if(indexPath.section == 11) {
       return  313;
   }else if(indexPath.section == 12) {
      return  347 + 50;
   }
    return 50;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
 
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0) {

        KG_EquipmentHistoryFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_EquipmentHistoryFirstCell"];
        if (cell == nil) {
            cell = [[KG_EquipmentHistoryFirstCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_EquipmentHistoryFirstCell"];
        }
        cell.dataDic = self.dataDic;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
      
        return cell;
    }else if(indexPath.section == 1) {

        KG_EquipmentHistorySecondCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_EquipmentHistorySecondCell"];
        if (cell == nil) {
            cell = [[KG_EquipmentHistorySecondCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_EquipmentHistorySecondCell"];
        }
        cell.dataDic = self.dataDic;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
      
        return cell;
    }else if(indexPath.section == 2) {

        KG_EquipmentHistoryThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_EquipmentHistoryThirdCell"];
        if (cell == nil) {
            cell = [[KG_EquipmentHistoryThirdCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_EquipmentHistoryThirdCell"];
        }
        
        cell.dataDic = self.dataDic;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
      
        return cell;
    }else if(indexPath.section == 11) {

        KG_LastestWarnTotalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_LastestWarnTotalCell"];
        if (cell == nil) {
            cell = [[KG_LastestWarnTotalCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_LastestWarnTotalCell"];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
      
        return cell;
    }else if(indexPath.section == 12) {

        KG_SparePartsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_SparePartsCell"];
        if (cell == nil) {
            cell = [[KG_SparePartsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_SparePartsCell"];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.listArray = self.dataModel.sparePartsStatistics;
        return cell;
    }else {
        KG_EquipmentHistoryFourthCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_EquipmentHistoryFourthCell"];
        if (cell == nil) {
            cell = [[KG_EquipmentHistoryFourthCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_EquipmentHistoryFourthCell"];
        }
        
        cell.pushToNextStep = ^(NSString * _Nonnull titleStr, NSDictionary * _Nonnull dataDic) {
            if([titleStr isEqualToString:@"设备故障事件记录"]) {
                
                KG_FaultEventRecordViewController *vc = [[KG_FaultEventRecordViewController alloc]init];
                vc.dataDic = dataDic;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else  if([titleStr isEqualToString:@"设备告警记录"]) {
                
                KG_EquipmentAdjustmentRecordViewController *vc = [[KG_EquipmentAdjustmentRecordViewController alloc]init];
                vc.dataDic = dataDic;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else  if([titleStr isEqualToString:@"技术资料"]) {
                
                KG_WatchPdfViewController *vc = [[KG_WatchPdfViewController alloc]init];
                vc.dataDic = dataDic;
                [self.navigationController pushViewController:vc animated:YES];
                
            }
        };
     
        cell.moreMethodBlock = ^(NSString * _Nonnull titleStr) {
            KG_EquipmentHistoryDetailMoreViewController *vc = [[KG_EquipmentHistoryDetailMoreViewController alloc]init];
            if([titleStr isEqualToString:@"设备故障事件记录"]) {
                vc.listArr = self.dataModel.equipmentFailureList;
            }else if([titleStr isEqualToString:@"设备告警记录"]) {
                vc.listArr = self.dataModel.equipmentWarnRecordList;
            }else if([titleStr isEqualToString:@"设备调整记录"]) {
                vc.listArr = self.dataModel.equipmentAdjustList;
            }else if([titleStr isEqualToString:@"技术资料"]) {
                vc.listArr = self.dataModel.technicalInformationList;
            }else if([titleStr isEqualToString:@"巡视记录"]) {
                vc.listArr = self.dataModel.xunShiList;
            }else if([titleStr isEqualToString:@"维护记录"]) {
                vc.listArr = self.dataModel.weiHuList;
            }else if([titleStr isEqualToString:@"特殊保障记录"]) {
                vc.listArr = self.dataModel.specialGuaranteeList;
            }else if([titleStr isEqualToString:@"备件库存"]) {
                vc.listArr = [NSArray array];
            }
            vc.titleStr = titleStr;
            vc.code = safeString(self.dataDic[@"code"]);
            [self.navigationController pushViewController:vc animated:YES];
        };
        
        cell.currSection = indexPath.section;
        if(indexPath.section == 3) {
            cell.listArray = self.dataModel.equipmentFailureList;
        }else if(indexPath.section ==4) {
            cell.listArray = self.dataModel.equipmentWarnRecordList;
        }else if(indexPath.section ==5) {
            cell.listArray = self.dataModel.equipmentAdjustList;
        }else if(indexPath.section ==6) {
            cell.listArray = self.dataModel.technicalInformationList;
        }else if(indexPath.section ==7) {
            cell.listArray = self.dataModel.xunShiList;
        }else if(indexPath.section ==8) {
            cell.listArray = self.dataModel.weiHuList;
        }else if(indexPath.section ==9) {
            cell.listArray = self.dataModel.specialGuaranteeList;
        }else if(indexPath.section ==10) {
          cell.listArray = [NSArray array];
        }
        
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    
    return nil;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.001)];
    return topView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10;
}


//设备档案：设备告警记录，获取某个设备自动告警列表，按页返回：
//请求地址：
///intelligent/keepInRepair/equipmentAuto/{equipmentCode}/{pageNum}/{pageSize}
//     其中，equipmentCode是设备编码
//           pageNum是页码
//           pageSize是每页的数据量
//请求方式：GET
//请求返回：
- (void)queryEquipmentAutomaticAlarmListData{
   
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/keepInRepair/equipmentAuto/%@/%@/%@",safeString(self.dataDic[@"code"]),safeString(@"1"),safeString(@"20")]];
    
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
       
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            return ;
        }
        
        self.dataModel.equipmentWarnRecordList = result[@"value"][@"records"];
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *error)  {
        [MBProgressHUD hideHUD];
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录！"];
            [FrameBaseRequest logout];
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.slideMenuController showViewController:login];
            return;
            
        }else if(responses.statusCode == 502){
            
        }
//        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}

//设备档案：设备故障事件记录，按页返回：
//请求地址：
///intelligent/keepInRepair/equipmentManual/{equipmentCode}/{pageNum}/{pageSize}
//     其中，equipmentCode是设备编码
//           pageNum是页码
//           pageSize是每页的数据量
//请求方式：GET
//请求返回：
//如：http://192.168.100.173:8089/intelligent/keepInRepair/equipmentManual/HCDVOR6540/1/5
//Equipment failure event record

- (void)queryEquipmentFailureEventRecordData{
   
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/keepInRepair/equipmentManual/%@/%@/%@",safeString(self.dataDic[@"code"]),safeString(@"1"),safeString(@"20")]];
    
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            return ;
        }
        
        self.dataModel.equipmentFailureList = result[@"value"][@"records"];
        [self.tableView reloadData];
       
    } failure:^(NSURLSessionDataTask *error)  {
        [MBProgressHUD hideHUD];
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录！"];
            [FrameBaseRequest logout];
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.slideMenuController showViewController:login];
            return;
            
        }else if(responses.statusCode == 502){
            
        }
//        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}


//设备档案：设备调整记录，获取某个设备变更管理列表，按页返回：
//请求地址：
///intelligent/atcChangeManagement/equipmentCloud/{equipmentCode}/{pageNum}/{pageSize}
//     其中，equipmentCode是设备编码
//           pageNum是页码
//           pageSize是每页的数据量
//请求方式：GET


- (void)queryEquipmentAdjustmentData{
   
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcChangeManagement/equipmentCloud/%@/%@/%@",safeString(self.dataDic[@"code"]),safeString(@"1"),safeString(@"20")]];
    
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            return ;
        }
        
        self.dataModel.equipmentAdjustList = result[@"value"][@"records"];
        [self.tableView reloadData];
       
    } failure:^(NSURLSessionDataTask *error)  {
        [MBProgressHUD hideHUD];
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录！"];
            [FrameBaseRequest logout];
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.slideMenuController showViewController:login];
            return;
            
        }else if(responses.statusCode == 502){
            
        }
//        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}
//
//设备档案：按页获取设备相关的技术资料接口
//请求地址：/intelligent/atcTechnicalInfomation/equipment/{code}/{pageNum}/{pageSize}



- (void)queryTechnicalInformationData{
   
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcTechnicalInfomation/equipment/%@/%@/%@",safeString(self.dataDic[@"code"]),safeString(@"1"),safeString(@"20")]];
    
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            return ;
        }
        
        self.dataModel.technicalInformationList = result[@"value"][@"records"];
        [self.tableView reloadData];
       
    } failure:^(NSURLSessionDataTask *error)  {
        [MBProgressHUD hideHUD];
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录！"];
            [FrameBaseRequest logout];
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.slideMenuController showViewController:login];
            return;
            
        }else if(responses.statusCode == 502){
            
        }
//        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}
//
//设备档案：获取设备相关的常规/维护/特殊保障接口，按页返回：
//请求地址：/intelligent/atcPatrolRecode/equipment/{pageNum}/{pageSize}
//请求Body：
//[{
//                 "name": "equipmentCode",
//                 "type": "eq",
//                 "content": "XXX"          //设备编码，必填
//            },
//{
//                 "name": "typeCode",
//                 "type": "eq",
//                 "content": "XXX"          //任务类型编码，必填
//                                   //常规巡视取oneTouchTour
//                                   //维护巡视取routineMaintenance
//                                   //特殊保障取specialSecurity
//            }]
- (void)getDeviceXunshiData{
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcPatrolRecode/equipment/%@/%@",safeString(@"1"),safeString(@"20")]];
    NSMutableArray *paramArr = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"name"] = @"equipmentCode";
    params[@"type"] = @"eq";
    params[@"content"] = safeString(self.dataDic[@"code"]);
    
    NSMutableDictionary *params1 = [NSMutableDictionary dictionary];
    params1[@"name"] = @"typeCode";
    params1[@"type"] = @"eq";
    params1[@"content"] = safeString(@"oneTouchTour");
    
    [paramArr addObject:params];
    [paramArr addObject:params1];
    [FrameBaseRequest postWithUrl:FrameRequestURL param:paramArr success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code != 0){
            
            return ;
        }
        self.dataModel.xunShiList = result[@"value"][@"records"];
        [self.tableView reloadData];
        
        
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

//查询维护
- (void)getDeviceWeihuData{
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcPatrolRecode/equipment/%@/%@",safeString(@"1"),safeString(@"20")]];
    NSMutableArray *paramArr = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"name"] = @"equipmentCode";
    params[@"type"] = @"eq";
    params[@"content"] = safeString(self.dataDic[@"code"]);
    
    NSMutableDictionary *params1 = [NSMutableDictionary dictionary];
    params1[@"name"] = @"typeCode";
    params1[@"type"] = @"eq";
    params1[@"content"] = safeString(@"routineMaintenance");
    
    [paramArr addObject:params];
    [paramArr addObject:params1];
    [FrameBaseRequest postWithUrl:FrameRequestURL param:paramArr success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code != 0){
            
            return ;
        }
       self.dataModel.weiHuList = result[@"value"][@"records"];
        [self.tableView reloadData];
        
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

//查询特殊保障
- (void)getDeviceSpecialData{
    
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcPatrolRecode/equipment/%@/%@",safeString(@"1"),safeString(@"20")]];
    NSMutableArray *paramArr = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"name"] = @"equipmentCode";
    params[@"type"] = @"eq";
    params[@"content"] = safeString(self.dataDic[@"code"]);
    
    NSMutableDictionary *params1 = [NSMutableDictionary dictionary];
    params1[@"name"] = @"typeCode";
    params1[@"type"] = @"eq";
    params1[@"content"] = safeString(@"specialSecurity");
    
    [paramArr addObject:params];
    [paramArr addObject:params1];
    [FrameBaseRequest postWithUrl:FrameRequestURL param:paramArr success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code != 0){
            
            return ;
        }
        self.dataModel.specialGuaranteeList = result[@"value"][@"records"];
        [self.tableView reloadData];
        
        
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
//
//获取台站备件数量统计图中有备件的设备分类信息接口：
//
//请求地址：/intelligent/atcDataCenter/getEquipmentInfo/{stationCode}
//其中，stationCode是台站编码
//请求方式：GET
//请求返回：
//如：/intelligent/atcDataCenter/getEquipmentInfo/S5


- (void)querySparePartData {
    
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcDataCenter/getEquipmentInfo/%@",safeString(self.dataDic[@"stationCode"])]];
    [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        [MBProgressHUD hideHUD];
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            return ;
        }
        
        self.dataModel.sparePartsStatistics = result[@"value"];
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *error)  {
        [MBProgressHUD hideHUD];
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录！"];
            [FrameBaseRequest logout];
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.slideMenuController showViewController:login];
            return;
            
        }else if(responses.statusCode == 502){
            
        }
        //        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}
@end
