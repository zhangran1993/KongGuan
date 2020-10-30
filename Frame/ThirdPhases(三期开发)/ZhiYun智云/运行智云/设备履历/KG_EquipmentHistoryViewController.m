//
//  KG_InstrumentationViewController.m
//  Frame
//
//  Created by zhangran on 2020/9/22.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_EquipmentHistoryViewController.h"
#import "KG_EquipmentHistoryCell.h"
#import "KG_InstrumentationSearchViewController.h"
#import "KG_InstrumentationDetailViewController.h"
#import "KG_EquipmentHistoryDetailViewController.h"
#import "KG_StationFileViewController.h"
@interface KG_EquipmentHistoryViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    
}

@property (nonatomic,strong)    UITableView             *tableView;

@property (nonatomic,strong)    NSArray                 *dataArray;

@property (nonatomic, strong)   UILabel                 *titleLabel;

@property (nonatomic, strong)   UIView                  *navigationView;

@property (nonatomic, strong)   UIButton                *searchBtn;

@property (nonatomic, strong)   UIButton                *rightButton;

@property (nonatomic, assign)   int                     pageNum;

@property (nonatomic, assign)   int                     pageSize;

@property (nonatomic,strong)    UIView                  *noDataView;

@property (nonatomic,copy)    NSString                  *selType;


@property (nonatomic,strong) UIButton           *leftBtn;
@property (nonatomic,strong) UIImageView        *leftBotImage;

@property (nonatomic,strong) UIButton           *rightBtn;
@property (nonatomic,strong) UIImageView        *rightBotImage;

@end

@implementation KG_EquipmentHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageNum = 1;
    self.pageSize = 10;
    self.selType = @"equipFile";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNaviTopView];
    
    [self createUI];
    [self createTableView];
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
    self.titleLabel.hidden = YES;
    self.titleLabel.text = @"设备履历";
    
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
    
    
    self.rightButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.rightButton.frame = CGRectMake(0,0,FrameWidth(40),FrameWidth(40));
    [self.rightButton setImage:[UIImage imageNamed:@"screen_icon"] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(screenAction:) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton.userInteractionEnabled = YES;
    [self.navigationView addSubview:self.rightButton];
    
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@44);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.right.equalTo(self.navigationView.mas_right).offset(-20);
    }];
    
    UIView *leftView = [[UIView alloc]init];
    [self.navigationView addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.navigationView.mas_left).offset((SCREEN_WIDTH/2));
        make.width.equalTo(@100);
        make.bottom.equalTo(self.navigationView.mas_bottom);
        make.height.equalTo(@40);
    }];
    
    self.leftBtn = [[UIButton alloc]init];
    [leftView addSubview:self.leftBtn];
    [self.leftBtn setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];
    self.leftBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [self.leftBtn setTitle:@"设备档案" forState:UIControlStateNormal];
    [self.leftBtn addTarget:self action:@selector(leftBtnMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftView.mas_left);
        make.right.equalTo(leftView.mas_right);
        make.top.equalTo(leftView.mas_top);
        make.bottom.equalTo(leftView.mas_bottom);
    }];
    
    self.leftBotImage = [[UIImageView alloc]init];
    [leftView addSubview:self.leftBotImage];
    self.leftBotImage.backgroundColor = [UIColor colorWithHexString:@"#2F5ED1"];
    [self.leftBotImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(leftView.mas_centerX);
        make.width.equalTo(@20);
        make.height.equalTo(@3);
        make.bottom.equalTo(leftView.mas_bottom);
    }];
    
    
    
    UIView *rightView = [[UIView alloc]init];
    [self.navigationView addSubview:rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.navigationView.mas_left).offset((SCREEN_WIDTH/2));
        make.width.equalTo(@100);
        make.bottom.equalTo(self.navigationView.mas_bottom);
        make.height.equalTo(@40);
    }];
    self.rightBtn = [[UIButton alloc]init];
    [rightView addSubview:self.rightBtn];
    [self.rightBtn setTitleColor:[UIColor colorWithHexString:@"#24252A"] forState:UIControlStateNormal];
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    [self.rightBtn addTarget:self action:@selector(rightBtnMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightBtn setTitle:@"台站档案" forState:UIControlStateNormal];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rightView.mas_left);
        make.right.equalTo(rightView.mas_right);
        make.top.equalTo(rightView.mas_top);
        make.bottom.equalTo(rightView.mas_bottom);
    }];
    
    self.rightBotImage = [[UIImageView alloc]init];
    [rightView addSubview:self.rightBotImage];
    self.rightBotImage.backgroundColor = [UIColor colorWithHexString:@"#2F5ED1"];
    [self.rightBotImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rightView.mas_centerX);
        make.width.equalTo(@20);
        make.height.equalTo(@3);
        make.bottom.equalTo(rightView.mas_bottom);
    }];
    self.rightBotImage.hidden = YES;
    self.selType =@"equipFile";
    [self queryData];
}

//坐边按钮
- (void)leftBtnMethod:(UIButton *)btn {
    [self.leftBtn setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];
    self.leftBotImage.hidden = NO;
    self.leftBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [self.rightBtn setTitleColor:[UIColor colorWithHexString:@"#24252A"] forState:UIControlStateNormal];
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    self.rightBotImage.hidden = YES;
    self.selType =@"equipFile";
    [self queryData];

}


//右边按钮
- (void)rightBtnMethod:(UIButton *)btn {
    
    [self.leftBtn setTitleColor:[UIColor colorWithHexString:@"#24252A"] forState:UIControlStateNormal];
    self.leftBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    self.leftBotImage.hidden = YES;
    
    [self.rightBtn setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.rightBotImage.hidden = NO;
    self.selType =@"staitonFile";
    [self queryData];
}

//筛选
- (void)screenAction:(UIButton *)btn {
    
   
    
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

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = YES;
        // 上拉加载
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
    }
    return _tableView;
}

- (void)loadMoreData {
    self.pageNum ++;
    //全部
    [self queryData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    
    return self.dataArray.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
    return 136;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.selType isEqualToString:@"equipFile"]) {
        KG_EquipmentHistoryDetailViewController *vc = [[KG_EquipmentHistoryDetailViewController alloc]init];
        NSDictionary *dic = self.dataArray[indexPath.section];
        vc.idStr = safeString(dic[@"id"]);
        vc.dataDic = dic;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
       
        KG_StationFileViewController *vc = [[KG_StationFileViewController alloc]init];
        NSDictionary *dic = self.dataArray[indexPath.section];
        vc.idStr = safeString(dic[@"id"]);
        vc.dataDic = dic;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    KG_EquipmentHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_EquipmentHistoryCell"];
    if (cell == nil) {
        cell = [[KG_EquipmentHistoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_EquipmentHistoryCell"];
    }
    NSDictionary *dic = self.dataArray[indexPath.section];
    cell.selType = self.selType;
    cell.dataDic = dic;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    topView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    return  topView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.001)];
    return footView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}


- (void)queryData {
    //判断是
    if ([self.selType isEqualToString:@"equipFile"]) {
        [self queryStationEquipFileData];
    }else {
        [self queryStationFileData];
    }
}

- (UIView *)noDataView {
    
    if (_noDataView) {
        _noDataView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
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
        noDataLabel.text = @"当前暂无任务";
        noDataLabel.textColor = [UIColor colorWithHexString:@"#BFC6D2"];
        noDataLabel.font = [UIFont systemFontOfSize:12];
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
//设备档案：获取某个台站下的设备档案列表（我的台站-智云）
//请求地址：/intelligent/atcEquipment/archives/station/{code}
//     其中，code是台站编码
//请求方式：GET
//请求返回:
// 如：/intelligent/atcEquipment/archives/station/HCDHT

- (void)queryStationEquipFileData {
    
    NSDictionary *currentDic = [UserManager shareUserManager].currentStationDic;
    if (currentDic.count == 0) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if([userDefaults objectForKey:@"station"]){
            currentDic = [userDefaults objectForKey:@"station"];
        }else {
            NSArray *stationArr = [UserManager shareUserManager].stationList;
            
            if (stationArr.count >0) {
                currentDic = [stationArr firstObject][@"station"];
            }
        }
        
    }
    
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcEquipment/archives/station/%@",safeString(currentDic[@"code"])]];
    [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        [MBProgressHUD hideHUD];
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
          
            return ;
        }
       self.dataArray = result[@"value"];
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
       
        return ;
    }];
    
}



//台站档案：获取某个台站下的台站档案列表(我的台站-智云)
//请求地址：/intelligent/atcStation/archives/{stationCode}
//    其中，stationCode是台站编码
//请求方式：GET
//请求返回:
// 如：/intelligent/atcStation/archives/S5
- (void)queryStationFileData {
    
    NSDictionary *currentDic = [UserManager shareUserManager].currentStationDic;
    if (currentDic.count == 0) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if([userDefaults objectForKey:@"station"]){
            currentDic = [userDefaults objectForKey:@"station"];
        }else {
            NSArray *stationArr = [UserManager shareUserManager].stationList;
            
            if (stationArr.count >0) {
                currentDic = [stationArr firstObject][@"station"];
            }
        }
    }
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcStation/archives/%@",safeString(currentDic[@"code"])]];
    [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        [MBProgressHUD hideHUD];
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
          
            return ;
        }
        self.dataArray = result[@"value"];
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
        return ;
    }];
    
}
@end
