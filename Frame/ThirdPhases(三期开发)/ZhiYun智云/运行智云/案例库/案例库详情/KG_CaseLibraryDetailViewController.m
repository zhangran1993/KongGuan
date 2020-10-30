//
//  KG_InstrumentationViewController.m
//  Frame
//
//  Created by zhangran on 2020/9/22.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_CaseLibraryDetailViewController.h"

#import "KG_CaseLibraryDetailFirstCell.h"
#import "KG_CaseLibraryDetailSecondCell.h"
#import "KG_CaseLibraryDetailThirdCell.h"
#import "KG_CaseLibraryDetailFourthCell.h"
#import "KG_CaseLibraryDetailFifthCell.h"
#import "KG_CaseLibraryDetailModel.h"
#import "KG_WatchPdfViewController.h"
@interface KG_CaseLibraryDetailViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    
}

@property (nonatomic,strong)    UITableView                *tableView;

@property (nonatomic,strong)    NSMutableArray             *dataArray;

@property (nonatomic, strong)   UILabel                    *titleLabel;

@property (nonatomic, strong)   UIView                     *navigationView;

@property (nonatomic, strong)   UIButton                   *searchBtn;

@property (nonatomic, strong)   UIButton                   *rightButton;

@property (nonatomic, strong)   KG_CaseLibraryDetailModel  *dataModel;

@end

@implementation KG_CaseLibraryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    
    self.dataModel = [[KG_CaseLibraryDetailModel alloc]init];
    
    [self createNaviTopView];
    
    [self createUI];
    
    [self createTableView];
    
    [self queryDetailData];
   
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
    topImage.image = [UIImage imageNamed:@"kg_anliku_bgImage"];
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
    self.titleLabel.text = safeString(@"案例库详情");
    
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
    
    return 5;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0) {
        return 170;
    }else if(indexPath.section == 1) {
        return 172;
    }else if(indexPath.section == 2) {
        return 110;
    }else if(indexPath.section == 3) {
        return 314;
    }else if(indexPath.section == 4) {
    
        return 50 +self.dataModel.referenceFileList.count *40;
    }
    
    return 170;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
 
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0) {

        KG_CaseLibraryDetailFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_CaseLibraryDetailFirstCell"];
        if (cell == nil) {
            cell = [[KG_CaseLibraryDetailFirstCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_CaseLibraryDetailFirstCell"];
        }
      
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dataModel = self.dataModel;
        return cell;
    }else if(indexPath.section == 1) {

        KG_CaseLibraryDetailSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_CaseLibraryDetailSecondCell"];
        if (cell == nil) {
            cell = [[KG_CaseLibraryDetailSecondCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_CaseLibraryDetailSecondCell"];
        }
        cell.dataModel = self.dataModel;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
      
        return cell;
    }else if(indexPath.section == 2) {

        KG_CaseLibraryDetailThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_CaseLibraryDetailThirdCell"];
        if (cell == nil) {
            cell = [[KG_CaseLibraryDetailThirdCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_CaseLibraryDetailThirdCell"];
        }
        cell.dataModel = self.dataModel;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
      
        return cell;
    }else if(indexPath.section == 3) {

        KG_CaseLibraryDetailFourthCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_CaseLibraryDetailFourthCell"];
        if (cell == nil) {
            cell = [[KG_CaseLibraryDetailFourthCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_CaseLibraryDetailFourthCell"];
        }
        cell.dataModel = self.dataModel;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
      
        return cell;
    }else if(indexPath.section == 4) {

        KG_CaseLibraryDetailFifthCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_CaseLibraryDetailFifthCell"];
        if (cell == nil) {
            cell = [[KG_CaseLibraryDetailFifthCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_CaseLibraryDetailFifthCell"];
        }
        cell.pushToNextStep = ^(NSDictionary * _Nonnull dataDic) {
            
            KG_WatchPdfViewController *vc = [[KG_WatchPdfViewController alloc]init];
            vc.dataDic = dataDic;
            [self.navigationController pushViewController:vc animated:YES];
        };
        cell.dataModel = self.dataModel;
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
//案例库4：获取某个故障案例详情:
//请求地址：/intelligent/atcFaultCase/{id}
//请求方式：GET
//请求返回:
//如：/intelligent/atcFaultCase/b0ade29813a545ac86d900e63a728115


- (void)queryDetailData{
   
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcFaultCase/%@",safeString(self.idStr)]];
    
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        [MBProgressHUD hideHUDForView:JSHmainWindow];
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        [self.dataModel mj_setKeyValues:result[@"value"]];
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *error)  {
        [MBProgressHUD hideHUDForView:JSHmainWindow];
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录！"];
            return;
        }else if(responses.statusCode == 502){
            
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}

@end
