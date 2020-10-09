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

@interface KG_EquipmentHistoryDetailViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    
}

@property (nonatomic,strong)    UITableView             *tableView;

@property (nonatomic,strong)    NSMutableArray          *dataArray;

@property (nonatomic, strong)   UILabel                 *titleLabel;

@property (nonatomic, strong)   UIView                  *navigationView;

@property (nonatomic, strong)   UIButton                *searchBtn;

@property (nonatomic, strong)   UIButton                *rightButton;

@end

@implementation KG_EquipmentHistoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    
    [self createNaviTopView];
    
    [self createUI];
    [self createTableView];
  
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
    self.titleLabel.text = safeString(self.dataDic[@"categoryName"]);
    
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
       
       return 170;
       
   }else if(indexPath.section == 4) {
       
       return 170;
       
   }else if(indexPath.section == 5) {
       
       return 170;
       
   }
    return 136;
    
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
      
        return cell;
    }else {
        KG_EquipmentHistoryFourthCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_EquipmentHistoryFourthCell"];
        if (cell == nil) {
            cell = [[KG_EquipmentHistoryFourthCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_EquipmentHistoryFourthCell"];
        }
        cell.currSection = indexPath.section;
        
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
   
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/keepInRepair/equipmentAuto/%@/%@/%@",safeString(@""),safeString(@""),safeString(@"")]];
    
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
       
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            return ;
        }
        
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
   
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/keepInRepair/equipmentManual/%@/%@/%@",safeString(@""),safeString(@""),safeString(@"")]];
    
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            return ;
        }
       
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
