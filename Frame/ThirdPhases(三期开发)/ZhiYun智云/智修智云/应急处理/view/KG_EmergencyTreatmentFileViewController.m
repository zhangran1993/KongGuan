//
//  KG_OperationGuideDetailViewController.m
//  Frame
//
//  Created by zhangran on 2020/9/25.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_EmergencyTreatmentFileViewController.h"
#import "KG_OperationGuideDetailCell.h"

#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
#import "KG_EmergencyTreatmentFileDetailCell.h"
@interface KG_EmergencyTreatmentFileViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *noDataView;

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic, strong)  UILabel   *titleLabel;
@property (nonatomic, strong)  UIView    *navigationView;
@property (nonatomic, strong)  UIButton  *rightButton;

@property (nonatomic ,assign) int pageNum;
@property (nonatomic ,assign) int pageSize;

@property (nonatomic,strong)  NSDictionary *currentDic;

@property (nonatomic, strong)  UILabel   *headLabel;

@end

@implementation KG_EmergencyTreatmentFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNaviTopView];
    [self queryData];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    if (isSafeArray(self.dataDic[@"handleGuideList"])) {
        
        self.dataArray = self.dataDic[@"handleGuideList"];
        [self.tableView reloadData];
    }
    
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 58)];
    headView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    
    self.headLabel = [[UILabel alloc]init];
    self.headLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.headLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.headLabel.font = [UIFont my_font:16];
    self.headLabel.text = safeString(self.dataDic[@"name"]);
    [headView addSubview:self.headLabel];
    [self.headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView.mas_left).offset(32);
        make.right.equalTo(headView.mas_right).offset(-32);
        make.height.equalTo(headView.mas_height);
        make.top.equalTo(headView.mas_top);
    }];
    
    self.tableView.tableHeaderView = headView;
    
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

-(void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
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

- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(self.dataArray.count >0) {
        return 1;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dataDic = self.dataArray[indexPath.section];
    NSString *str = [NSString stringWithFormat:@"%@",safeString(dataDic[@"content"])];
    CGRect fontRect = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 32-32, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName] context:nil];
    if(fontRect.size.height >17) {
        return 200 + fontRect.size.height;
    }
    return 200 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_EmergencyTreatmentFileDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_EmergencyTreatmentFileDetailCell "];
    if (cell == nil) {
        cell = [[KG_EmergencyTreatmentFileDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_EmergencyTreatmentFileDetailCell"];
        cell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dataDic = self.dataArray[indexPath.section];
    cell.dataDic = dataDic;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
  
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 52)];
    headView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(32, 0, SCREEN_WIDTH- 64, 52)];
    [headView addSubview:titleLabel];
    NSDictionary *dataDic = self.dataArray[section];
    
    titleLabel.text = [NSString stringWithFormat:@"0%@",safeString(dataDic[@"sequence"])];
    if ([safeString(dataDic[@"sequence"]) intValue] >9) {
        titleLabel.text = [NSString stringWithFormat:@"%@",safeString(dataDic[@"sequence"])];
    }
    
    titleLabel.textColor = [UIColor colorWithHexString:@"#005DC4"];
    titleLabel.font = [UIFont systemFontOfSize:22 weight:UIFontWeightMedium];
    titleLabel.font = [UIFont my_font:22];
    titleLabel.numberOfLines = 1;
    
    UIImageView *underImage = [[UIImageView alloc]init];
    [headView addSubview:underImage];
    underImage.image = [UIImage imageNamed:@"kg_numUnderSlider"];
    
    [underImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headView.mas_bottom).offset(-11);
        make.width.equalTo(@35);
        make.height.equalTo(@5);
        make.left.equalTo(headView.mas_left).offset(32);
    }];
    
    
    return headView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 52.f;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.001)];
    
    return footView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.001;
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
    self.titleLabel.text = @"应急操作指引详情";
    
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
    
    
    [[UITabBar appearance] setTranslucent:NO];
    
    self.tabBarController.tabBar.translucent = NO;
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


- (void)queryData {
    
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/keepInRepair/getEmergencyEventById/%@",safeString(self.dataDic[@"id"])]];
    [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        [MBProgressHUD hideHUD];
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if (code == -401||code == -402||code ==  -403) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
            
        }
        if(code  <= -1){
            
            return ;
        }
        NSDictionary *dataDic = result[@"value"];
        
        if (isSafeDictionary(dataDic)) {
            self.dataArray = dataDic[@"handleMethodList"];
        }
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
