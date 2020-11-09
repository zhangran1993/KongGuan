//
//  KG_InstrumentationViewController.m
//  Frame
//
//  Created by zhangran on 2020/9/22.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_StationFileViewController.h"

#import "KG_StationFileDetailFirstCell.h"
#import "KG_StationFileDetailSecondCell.h"
#import "KG_StationFileDetailThirdCell.h"
#import "KG_StationFileDetailFourthCell.h"
#import "KG_SparePartsCell.h"
#import "KG_LastestWarnTotalCell.h"
#import "KG_EquipmentHistoryFourthCell.h"
#import "KG_EquipmentHistoryDetailModel.h"
#import "KG_EquipmentHistoryDetailMoreViewController.h"
#import "KG_FaultEventRecordViewController.h"
#import "KG_EquipmentAdjustmentRecordViewController.h"
#import "KG_WatchPdfViewController.h"

#import "KG_StationFileEnvEventRecordCell.h"
#import "KG_StationFileWarnRecordCell.h"
#import "KG_StationFileEnvEventDetailController.h"
#import "KG_GaoJingDetailViewController.h"
#import "KG_GaoJingModel.h"

#import "KG_XunShiReportDetailViewController.h"
#import "KG_WeihuDailyReportDetailViewController.h"
#import "KG_SparepartsInventoryViewController.h"

@interface KG_StationFileViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    
}
@property (nonatomic,strong)    KG_GaoJingModel *model;

@property (nonatomic,strong)    UITableView             *tableView;

@property (nonatomic,strong)    NSMutableArray          *dataArray;

@property (nonatomic, strong)   UILabel                 *titleLabel;

@property (nonatomic, strong)   UIView                  *navigationView;

@property (nonatomic, strong)   UIButton                *searchBtn;

@property (nonatomic, strong)   UIButton                *rightButton;

@property (nonatomic, strong)   KG_EquipmentHistoryDetailModel *dataModel;

@end

@implementation KG_StationFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    self.dataModel = [[KG_EquipmentHistoryDetailModel alloc]init];
    self.model  = [[KG_GaoJingModel alloc]init];
    [self createNaviTopView];
    
    [self createUI];
    [self createTableView];
    //设备台站告警记录
    [self queryStationAlarmListData];
    //关键环境事件记录
    [self queryStationEnvEventListData];
   
    //查询技术资料
    [self queryTechnicalInformationData];
    //查询巡视
    [self getDeviceXunshiData];
    //查询维护
    [self getDeviceWeihuData];
    //查询特殊保障
    [self getDeviceSpecialData];
    
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
    
    return 11;
    
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
        
        return 45*4;
        
    }else if(indexPath.section == 3) {
        return 45*5;
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
        
    }
    return 50;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0) {
        
        KG_StationFileDetailFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_StationFileDetailFirstCell"];
        if (cell == nil) {
            cell = [[KG_StationFileDetailFirstCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_StationFileDetailFirstCell"];
        }
        cell.dataDic = self.dataDic;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if(indexPath.section == 1) {
        
        KG_StationFileDetailSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_StationFileDetailSecondCell"];
        if (cell == nil) {
            cell = [[KG_StationFileDetailSecondCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_StationFileDetailSecondCell"];
        }
        cell.dataDic = self.dataDic;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if(indexPath.section == 2) {
        
        KG_StationFileDetailThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_StationFileDetailThirdCell"];
        if (cell == nil) {
            cell = [[KG_StationFileDetailThirdCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_StationFileDetailThirdCell"];
        }
        cell.dataDic = self.dataDic;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if(indexPath.section == 3) {
        
        KG_StationFileDetailFourthCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_StationFileDetailFourthCell"];
        if (cell == nil) {
            cell = [[KG_StationFileDetailFourthCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_StationFileDetailFourthCell"];
        }
        cell.dataDic = self.dataDic;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if(indexPath.section == 4) {
        
        KG_StationFileWarnRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_StationFileWarnRecordCell"];
        if (cell == nil) {
            cell = [[KG_StationFileWarnRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_StationFileWarnRecordCell"];
        }
        
        cell.pushToNextStep = ^(NSString * _Nonnull titleStr, NSDictionary * _Nonnull dataDic) {
            if([titleStr isEqualToString:@"台站告警记录"]) {
                
                KG_GaoJingDetailViewController *vc = [[KG_GaoJingDetailViewController alloc]init];
                [self.model mj_setKeyValues:dataDic];
                vc.model = self.model;
                [self.navigationController pushViewController:vc animated:YES];
                
            }
        };
        
        cell.moreMethodBlock = ^(NSString * _Nonnull titleStr) {
            KG_EquipmentHistoryDetailMoreViewController *vc = [[KG_EquipmentHistoryDetailMoreViewController alloc]init];
            if([titleStr isEqualToString:@"台站告警记录"]) {
                vc.listArr = self.dataModel.equipmentFailureList;
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
        
        
        
    }else if(indexPath.section == 5) {
        
        KG_StationFileEnvEventRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_StationFileEnvEventRecordCell"];
        if (cell == nil) {
            cell = [[KG_StationFileEnvEventRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_StationFileEnvEventRecordCell"];
        }
        
        cell.pushToNextStep = ^(NSString * _Nonnull titleStr, NSDictionary * _Nonnull dataDic) {
            if([titleStr isEqualToString:@"台站关键环境事件记录"]) {
                
                KG_StationFileEnvEventDetailController *vc = [[KG_StationFileEnvEventDetailController alloc]init];
                vc.dataDic = dataDic;
                [self.navigationController pushViewController:vc animated:YES];
                
            }
        };
        
        cell.moreMethodBlock = ^(NSString * _Nonnull titleStr) {
            KG_EquipmentHistoryDetailMoreViewController *vc = [[KG_EquipmentHistoryDetailMoreViewController alloc]init];
            if([titleStr isEqualToString:@"台站关键环境事件记录"]) {
                vc.listArr = self.dataModel.equipmentFailureList;
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
        
    }else if(indexPath.section == 12) {
        
        KG_SparePartsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_SparePartsCell"];
        if (cell == nil) {
            cell = [[KG_SparePartsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_SparePartsCell"];
        }
        cell.dataDic = self.dataDic;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
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
                
            }else  if([titleStr isEqualToString:@"设备调整记录"]) {
                
                KG_EquipmentAdjustmentRecordViewController *vc = [[KG_EquipmentAdjustmentRecordViewController alloc]init];
                vc.dataDic = dataDic;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else  if([titleStr isEqualToString:@"技术资料"]) {
                
                KG_WatchPdfViewController *vc = [[KG_WatchPdfViewController alloc]init];
                vc.dataDic = dataDic;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else  if([titleStr isEqualToString:@"巡视记录"]) {
                
                KG_XunShiReportDetailViewController *vc = [[KG_XunShiReportDetailViewController alloc]init];
                vc.dataDic = dataDic;
                
                [self.navigationController pushViewController:vc animated:YES];
                
            }else  if([titleStr isEqualToString:@"维护记录"]) {
                
                KG_WeihuDailyReportDetailViewController *vc = [[KG_WeihuDailyReportDetailViewController alloc]init];
                vc.dataDic = dataDic;
                
                [self.navigationController pushViewController:vc animated:YES];
                
            }else  if([titleStr isEqualToString:@"特殊保障记录"]) {
                
                KG_XunShiReportDetailViewController *vc = [[KG_XunShiReportDetailViewController alloc]init];
                vc.dataDic = dataDic;
                
                [self.navigationController pushViewController:vc animated:YES];
                
            }else  if([titleStr isEqualToString:@"备件库存"]) {
                
                
                KG_SparepartsInventoryViewController *vc = [[KG_SparepartsInventoryViewController alloc]init];
                KG_GaoJingModel *model = [[KG_GaoJingModel alloc]init];
                [model mj_setKeyValues:dataDic];
                vc.model = model;
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

//
//设备档案：按页获取设备相关的技术资料接口
//请求地址：/intelligent/atcTechnicalInfomation/equipment/{code}/{pageNum}/{pageSize}



- (void)queryTechnicalInformationData{
    
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcTechnicalInfomation/station/%@/%@/%@",safeString(self.dataDic[@"code"]),safeString(@"1"),safeString(@"20")]];
    
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
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcPatrolRecode/search/oneTouchTour/%@/%@",safeString(@"1"),safeString(@"20")]];
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
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcPatrolRecode/search/routineMaintenance/%@/%@",safeString(@"1"),safeString(@"20")]];
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
    
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcPatrolRecode/search/specialSecurity/%@/%@",safeString(@"1"),safeString(@"20")]];
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

//台站档案：台站告警记录，按页返回：
//请求地址：/intelligent/keepInRepair/stationAuto/{stationCode}/{pageNum}/{pageSize}
//     其中，stationCode是台站编码
//           pageNum是页码
//           pageSize是每页的数据量
//请求方式：GET
- (void)queryStationAlarmListData{
    
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


//台站档案：关键环境事件记录，按页返回：
- (void)queryStationEnvEventListData{
    
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/keepInRepair/stationManual/%@/%@/%@",safeString(self.dataDic[@"code"]),safeString(@"1"),safeString(@"20")]];
    
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

@end
