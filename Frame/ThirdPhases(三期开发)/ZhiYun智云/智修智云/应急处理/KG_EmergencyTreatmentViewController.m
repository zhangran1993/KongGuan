//
//  KG_ZhiXiuBeiJianListViewController.m
//  Frame
//
//  Created by zhangran on 2020/8/5.
//  Copyright © 2020 hibaysoft. All rights reserved.
// 智修-备件列表

#import "KG_EmergencyTreatmentViewController.h"
#import "KG_BeiJianListCell.h"
#import "KG_BeiJianCategoryViewController.h"
#import "KG_RunLingBeiJianViewController.h"
#import "KG_EquipmentTroubleshootDetailCell.h"
#import "KG_WatchPdfViewController.h"

#import "KG_EmergencyTreatmentFirstCell.h"
#import "KG_EmergencyTreatmentSecondCell.h"
#import "KG_BeiJianCategoryViewController.h"
@interface KG_EmergencyTreatmentViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    
}

@property (nonatomic,strong)    UITableView             *tableView;

@property (nonatomic,strong)    NSMutableArray          *dataArray;

@property (nonatomic, strong)   UILabel                 *titleLabel;

@property (nonatomic, strong)   UIView                  *navigationView;

@property (nonatomic, strong)   UIButton                *searchBtn;

@property (nonatomic, strong)   UIButton                *rightButton;

@property (nonatomic, strong)   NSDictionary            *currentDic;

@property (nonatomic, strong)   UIView                  *noDataView;

@property (nonatomic,strong)    NSDictionary            *otherDic;

@property (nonatomic,strong)    NSDictionary            *dataDic;

@property (nonatomic, assign)   BOOL                    isZhanKai;


@property (nonatomic,strong)    NSArray                 *topArray;

@property (nonatomic, strong) UIButton        *bottomBtn;

@property (nonatomic, strong) UIView          *footView;


@end

@implementation KG_EmergencyTreatmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
   
    
    self.isZhanKai = NO;
    self.topArray = self.dataModel.emergency[@"emergencyOperation"];
    [self createNaviTopView];
    
    [self createTableView];
    [self createUI];
    
    [self queryData];
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



//查询数据 equipmentCode是告警设备的编码
- (void)queryData {
    
   
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/keepInRepair/attachmentInfo/%@",safeString(self.model.equipmentCode)]];
    
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if (code == -401||code == -402||code ==  -403) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
            
        }
        if(code  <= -1){
            
            return ;
        }
        NSDictionary *dic = result[@"value"];
      
       
        if (dic.count) {
            self.dataDic = dic[@"equipmentAttachment"];
            self.otherDic = dic[@"otherEquipmentAttachment"];
        }
        if (self.dataDic.count == 0 && self.otherDic.count == 0) {
            [self.view addSubview:self.noDataView];
            [self.view bringSubviewToFront:self.noDataView];
            return;
            
        }
       
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *error)  {
        [MBProgressHUD hideHUD];
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
            
        }else if(responses.statusCode == 502){
            
        }
        return ;
    }];
}

- (void)createTableView {
    
  
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
//    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
//    headView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
//    UIView *bgTopView = [[UIView alloc]init];
//    [headView addSubview:bgTopView];
//    bgTopView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
//    [bgTopView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(headView.mas_left);
//        make.right.equalTo(headView.mas_right);
//        make.height.equalTo(@10);
//        make.top.equalTo(headView.mas_top);
//    }];
//
//    UIImageView *iconImage = [[UIImageView alloc]init];
//    [headView addSubview:iconImage];
//    iconImage.image = [UIImage imageNamed:@"kg_icon_beijianxinxi"];
//    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(headView.mas_left).offset(16);
//        make.top.equalTo(headView.mas_top).offset(10+17);
//        make.width.equalTo(@14);
//        make.height.equalTo(@16);
//    }];
//
//    UILabel *topTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, 84, 50)];
//    [headView addSubview:topTitleLabel];
//    topTitleLabel.text = @"备件信息";
//    topTitleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
//    topTitleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
//    topTitleLabel.numberOfLines = 1;
//    topTitleLabel.backgroundColor = [UIColor clearColor];
//    topTitleLabel.textAlignment = NSTextAlignmentLeft;
//
//    [topTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(iconImage.mas_centerY);
//        make.left.equalTo(iconImage.mas_right).offset(8);
//        make.right.equalTo(headView.mas_right);
//        make.height.equalTo(@30);
//    }];
//
//    self.tableView.tableHeaderView = headView;
//
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
    topImage.image = [self createImageWithColor:[UIColor whiteColor]];
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
    self.titleLabel.text = @"应急处理";
    
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
    leftImage.image = IMAGE(@"back_black");
    [backBtn addSubview:leftImage];
    [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backBtn.mas_centerX);
        make.centerY.equalTo(backBtn.mas_centerY);
    }];
    
    
    
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
        titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
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
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = YES;
        
      
        
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
  
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    if ([tableView isEqual:self.topTableView]) {
//        if (self.isZhanKai == NO) {
//            if (self.topArray.count >3) {
//                return 3;
//            }else {
//                return self.topArray.count;
//            }
//        }else {
//            return self.topArray.count;
//        }
//        return self.topArray.count;
//    }
//    
//    if (section == 0) {
//        if (self.dataDic.count) {
//            NSArray *dataArr = self.dataDic[@"attachmentInfo"];
//            if (dataArr.count) {
//                return 1;
//            }
//           
//            return 0;
//        }
//        return 0;
//    }else {
//        if (self.otherDic.count) {
//            NSArray *otherArr = self.otherDic[@"attachmentInfo"];
//            if (otherArr.count) {
//                return 1;
//            }
//           
//            return 0;
//        }
//        return 0;
//    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (self.isZhanKai == NO) {
            if (self.topArray.count >3) {
                return 50*3+ 50 +40 +10;
            }else {
                return self.topArray.count *50 +50 +40 +10;
            }
        }else {
            
            return self.topArray.count *50 +50+40  +10;
        }
    }else if (indexPath.section == 1) {
        NSInteger topHeight = 0;
        if (self.dataDic.count) {
            NSArray *dataArr = self.dataDic[@"attachmentInfo"];
            if(dataArr.count == 0 &&self.dataDic.count >0) {
                topHeight = 45;
            }
            topHeight = dataArr.count *45;
        }
        
        NSInteger botHeight = 0;
        if (self.otherDic.count) {
            NSArray *otherArr = self.otherDic[@"attachmentInfo"];
            if(otherArr.count == 0 &&self.otherDic.count >0) {
                botHeight = 45;
            }
            botHeight =  otherArr.count *45;
        }
        
        
        return 50 + 200 + topHeight +botHeight;
    }
    return 200;
}
//    if ([tableView isEqual:self.topTableView]) {
//        return 50;
//    }
    
//    if(indexPath.section == 0){
//
//        NSArray *dataArr = self.dataDic[@"attachmentInfo"];
//        if(dataArr.count == 0 &&self.dataDic.count >0) {
//            return 45;
//        }
//        return dataArr.count *45;
//
//
//    }else {
//        NSArray *otherArr = self.otherDic[@"attachmentInfo"];
//        if(otherArr.count == 0 &&self.otherDic.count >0) {
//            return 45;
//        }
//        return otherArr.count *45;
//
//    }
//
//    return 0;

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if ([tableView isEqual:self.topTableView]) {
//
//        NSDictionary *dataDic = self.topArray[indexPath.row];
//        KG_WatchPdfViewController *vc = [[KG_WatchPdfViewController alloc]init];
//        vc.dataDic = dataDic;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {

        KG_EmergencyTreatmentFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_EmergencyTreatmentFirstCell"];
        if (cell == nil) {
            cell = [[KG_EmergencyTreatmentFirstCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_EmergencyTreatmentFirstCell"];
        }
        cell.topArray = self.topArray;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
      
        cell.zhanKaiMethod = ^(BOOL iszhankai) {
            self.isZhanKai = iszhankai;
            [self.tableView reloadData];
        };
        cell.pushToNextStep = ^(NSDictionary * _Nonnull dataDic) {
           
            KG_WatchPdfViewController *vc = [[KG_WatchPdfViewController alloc]init];
            vc.dataDic = dataDic;
            [self.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    }else if (indexPath.section == 1) {
        
        KG_EmergencyTreatmentSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_EmergencyTreatmentSecondCell"];
        if (cell == nil) {
            cell = [[KG_EmergencyTreatmentSecondCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_EmergencyTreatmentSecondCell"];
        }
        if(self.dataDic.count) {
            NSArray *topArr = self.dataDic[@"attachmentInfo"];
            cell.secondTopArray = topArr;
            cell.secondTopDic = self.dataDic;
        }
        
        if(self.otherDic.count) {
            NSArray *otherArr = self.otherDic[@"attachmentInfo"];
            cell.secondBotArray = otherArr;
            cell.secondBotDic = self.otherDic;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       
        cell.pushToNextStep = ^(NSDictionary * _Nonnull dataDic, NSDictionary * _Nonnull totalDic) {
            
            KG_BeiJianCategoryViewController *vc = [[KG_BeiJianCategoryViewController alloc]init];
            vc.dataDic = dataDic;
            vc.totalDic = totalDic;
            [self.navigationController pushViewController:vc animated:YES];
        };
        
        return cell;
    }
//    KG_BeiJianListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_BeiJianListCell"];
//    if (cell == nil) {
//        cell = [[KG_BeiJianListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_BeiJianListCell"];
//    }
//    cell.didsel = ^(NSDictionary * _Nonnull dataDic, NSDictionary * _Nonnull totalDic) {
//
//        KG_BeiJianCategoryViewController *vc = [[KG_BeiJianCategoryViewController alloc]init];
//        vc.dataDic = dataDic;
//        vc.totalDic = totalDic;
//        [self.navigationController pushViewController:vc animated:YES];
//    };
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    if (indexPath.section == 0) {
//
//        cell.totalDic =self.dataDic ;
//        cell.dataDic = self.dataDic;
//    }else {
//
//        cell.totalDic =self.otherDic;
//        cell.dataDic =self.otherDic;
//    }
//
//

    return nil;
}

- (UIView *)noDataView {
    
    if (_noDataView == nil) {
        _noDataView = [[UIView alloc]initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height)];
        _noDataView.backgroundColor = [UIColor whiteColor];
        UIImageView *iconImage = [[UIImageView alloc]init];
        iconImage.image = [UIImage imageNamed:@"station_ReportNoData@2x"];
        [_noDataView addSubview:iconImage];
        [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@302);
            make.height.equalTo(@153);
            make.centerX.equalTo(_noDataView.mas_centerX);
            make.centerY.equalTo(_noDataView.mas_centerY);
        }];
        
        UILabel *noDataLabel = [[UILabel alloc]init];
        [_noDataView addSubview:noDataLabel];
        noDataLabel.text = @"当前暂无数据";
        noDataLabel.textColor = [UIColor colorWithHexString:@"#BFC6D2"];
        noDataLabel.font = [UIFont systemFontOfSize:12];
        noDataLabel.font = [UIFont my_font:12];
        noDataLabel.textAlignment = NSTextAlignmentCenter;
        [noDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_noDataView.mas_centerX);
            make.height.equalTo(@17);
            make.width.equalTo(@200);
            make.top.equalTo(iconImage.mas_bottom).offset(27);
        }];
        
    }
    return _noDataView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if(section == 0) {
        
        UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        topView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        return topView;
    }
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.001)];
    topView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    return topView;
    
}
//    if ([tableView isEqual:self.topTableView]) {
//
//        UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.001)];
//
//
//        return topView;
//
//    }
//
    
    
  
//    UIView *topBgView = [[UIView alloc]init];
//    topBgView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
//    [topView addSubview:topBgView];
//    [topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(topView.mas_top);
//        make.left.equalTo(topView.mas_left);
//        make.right.equalTo(topView.mas_right);
//        make.height.equalTo(@50);
//    }];
//
//
//
//    UIView *shuView = [[UIView alloc]init];
//    [topBgView addSubview:shuView];
//    shuView.layer.cornerRadius = 2.f;
//    shuView.layer.masksToBounds = YES;
//    shuView.backgroundColor = [UIColor colorWithRed:47/255.0 green:94/255.0 blue:209/255.0 alpha:1.0];
//    [shuView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(topView.mas_left).offset(16);
//        make.width.equalTo(@3);
//        make.height.equalTo(@15);
//        make.centerY.equalTo(topBgView.mas_centerY);
//
//    }];
//
//
//
//    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, 84, 50)];
//    [topBgView addSubview:titleLabel];
//    titleLabel.text = @"当前告警设备备件";
//    titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
//    titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
//    titleLabel.numberOfLines = 1;
//    titleLabel.backgroundColor = [UIColor clearColor];
//    titleLabel.textAlignment = NSTextAlignmentLeft;
//
//    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(topView.mas_top);
//        make.left.equalTo(shuView.mas_right).offset(10);
//        make.right.equalTo(topBgView.mas_right);
//        make.height.equalTo(@50);
//    }];
//
//
//
//
//    UILabel *firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 50, 84, 50)];
//    [topView addSubview:firstLabel];
//    firstLabel.text = @"备件所属设备";
//    firstLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
//    firstLabel.font = [UIFont systemFontOfSize:14];
//    firstLabel.numberOfLines = 1;
//    firstLabel.textAlignment = NSTextAlignmentLeft;
//    [firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(topView.mas_left).offset(16);
//        make.height.equalTo(@50);
//        make.width.lessThanOrEqualTo(@120);
//        make.top.equalTo(topBgView.mas_bottom);
//    }];
//
//    UILabel *secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(140, 50, 84, 50)];
//    [topView addSubview:secondLabel];
//    secondLabel.text = @"备件类型";
//    secondLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
//    secondLabel.font = [UIFont systemFontOfSize:14];
//    secondLabel.numberOfLines = 1;
//    secondLabel.textAlignment = NSTextAlignmentLeft;
//    [secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(topView.mas_left).offset(SCREEN_WIDTH/2- 30);
//        make.height.equalTo(@50);
//        make.width.lessThanOrEqualTo(@120);
//        make.top.equalTo(topBgView.mas_bottom);
//    }];
//
//
//    UILabel *thirdLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 50, 84, 50)];
//    [topView addSubview:thirdLabel];
//    thirdLabel.text = @"备件数量";
//    thirdLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
//    thirdLabel.font = [UIFont systemFontOfSize:14];
//    thirdLabel.numberOfLines = 1;
//    thirdLabel.textAlignment = NSTextAlignmentRight;
//    [thirdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(topView.mas_right).offset(-16);
//        make.height.equalTo(@50);
//        make.width.equalTo(@120);
//        make.top.equalTo(topBgView.mas_bottom);
//    }];
//
//    if (section == 0) {
//        titleLabel.text = @"当前告警设备备件";
//    }else {
//        titleLabel.text = @"其他备件";
//    }
////
//    return  topView;

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.001)];
    return footView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}


@end
