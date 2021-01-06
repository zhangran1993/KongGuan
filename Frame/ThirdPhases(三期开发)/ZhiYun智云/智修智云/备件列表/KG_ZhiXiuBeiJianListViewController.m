//
//  KG_ZhiXiuBeiJianListViewController.m
//  Frame
//
//  Created by zhangran on 2020/8/5.
//  Copyright © 2020 hibaysoft. All rights reserved.
// 智修-备件列表

#import "KG_ZhiXiuBeiJianListViewController.h"
#import "KG_BeiJianListCell.h"
#import "KG_BeiJianCategoryViewController.h"
#import "KG_RunLingBeiJianViewController.h"

#import "KG_RunLingBeiJianSearchViewController.h"
#import "KG_SparePartsStatisticsListViewController.h"
#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@interface KG_ZhiXiuBeiJianListViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    
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
@end

@implementation KG_ZhiXiuBeiJianListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self createNaviTopView];
    [self createTopView];
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


- (void)createTopView {
    UIView *topView = [[UIView alloc]init];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
    topView.layer.cornerRadius = 10.f;
    topView.layer.masksToBounds = YES;
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).offset(NAVIGATIONBAR_HEIGHT);
        make.height.equalTo(@105);
    }];
    
    UIImageView *speakIcon = [[UIImageView alloc]init];
    [topView addSubview:speakIcon];
    speakIcon.image = [UIImage imageNamed:@"speaker_icon"];
    [speakIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView.mas_left).offset(16);
        make.width.equalTo(@22);
        make.height.equalTo(@18);
        make.top.equalTo(topView.mas_top).offset(20);
    }];
    
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [topView addSubview:titleLabel];
    titleLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.font = [UIFont my_font:12];
    titleLabel.text = @"这里仅展示与该告警事件有关的信息，您可切换到该台站智云查看更多信息。";
    titleLabel.numberOfLines = 2;
    [titleLabel sizeToFit];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(speakIcon.mas_centerY);
        make.left.equalTo(speakIcon.mas_right).offset(8);
        make.right.equalTo(topView.mas_right).offset(-15);
        
    }];

    UIButton *botBtn = [[UIButton alloc]init];
    [topView addSubview:botBtn];
    [botBtn setBackgroundColor:[UIColor colorWithRed:50.f/255.f green:97.f/255.f blue:206.f/255.f alpha:1]];
    [botBtn setTitle:@"本台站" forState:UIControlStateNormal];
    botBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [botBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [botBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topView.mas_right).offset(-20);
        make.top.equalTo(topView.mas_top).offset(56);
        make.height.equalTo(@28);
        make.width.equalTo(@80);
    }];
    [botBtn addTarget:self action:@selector(botMethod:) forControlEvents:UIControlEventTouchUpInside];
    botBtn.layer.cornerRadius = 4.f;
    botBtn.layer.masksToBounds = YES;
    
  
    
}


- (void)botMethod:(UIButton *)btn {
  
    //零备件
    KG_RunLingBeiJianViewController *vc = [[KG_RunLingBeiJianViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
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
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 14)];
    
    UIImageView *lineView = [[UIImageView alloc]init];
    [topView addSubview:lineView];
    lineView.image = [UIImage imageNamed:@"touying_image"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView.mas_left);
        make.right.equalTo(topView.mas_right);
        make.top.equalTo(topView.mas_top);
        make.height.equalTo(@14);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom).offset(105);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.tableView.tableHeaderView = topView;
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
    self.titleLabel.text = @"备件列表";
    
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
    
    
    self.searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.searchBtn.frame = CGRectMake(0,0,FrameWidth(40),FrameWidth(40));
    [self.searchBtn setImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateNormal];
    self.searchBtn.userInteractionEnabled = YES;
    [self.searchBtn addTarget:self action:@selector(searchMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:self.searchBtn];
    
    
    self.rightButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.rightButton.frame = CGRectMake(0,0,FrameWidth(40),FrameWidth(40));
    [self.rightButton setImage:[UIImage imageNamed:@"kg_lingbeijian_rightIcon"] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(yiduAction) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton.userInteractionEnabled = YES;
    [self.navigationView addSubview:self.rightButton];
    
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@44);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.right.equalTo(self.navigationView.mas_right).offset(-20);
    }];
    
    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@44);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.right.equalTo(self.rightButton.mas_right).offset(-40);
    }];
    
}
- (void)searchMethod:(UIButton *)button {
    
    KG_RunLingBeiJianSearchViewController *vc = [[KG_RunLingBeiJianSearchViewController alloc]init];
    vc.fromType = @"zhixiu";
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)yiduAction {
    
    KG_SparePartsStatisticsListViewController *vc = [[KG_SparePartsStatisticsListViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
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
    if (section == 0) {
        if (self.dataDic.count) {
            NSArray *dataArr = self.dataDic[@"attachmentInfo"];
            if (dataArr.count) {
                return 1;
            }
           
            return 0;
        }
        return 0;
    }else {
        if (self.otherDic.count) {
            NSArray *otherArr = self.otherDic[@"attachmentInfo"];
            if (otherArr.count) {
                return 1;
            }
           
            return 0;
        }
        return 0;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        
        NSArray *dataArr = self.dataDic[@"attachmentInfo"];
        if(dataArr.count == 0 &&self.dataDic.count >0) {
            return 45;
        }
        return dataArr.count *45;
        
      
    }else {
        NSArray *otherArr = self.otherDic[@"attachmentInfo"];
        if(otherArr.count == 0 &&self.otherDic.count >0) {
            return 45;
        }
        return otherArr.count *45;
        
    }
    
    return 0;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_BeiJianListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_BeiJianListCell"];
    if (cell == nil) {
        cell = [[KG_BeiJianListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_BeiJianListCell"];
    }
    cell.didsel = ^(NSDictionary * _Nonnull dataDic, NSDictionary * _Nonnull totalDic) {
        
        KG_BeiJianCategoryViewController *vc = [[KG_BeiJianCategoryViewController alloc]init];
        vc.dataDic = dataDic;
        vc.totalDic = totalDic;
        [self.navigationController pushViewController:vc animated:YES];
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
       
        cell.totalDic =self.dataDic ;
        cell.dataDic = self.dataDic;
    }else {
       
        cell.totalDic =self.otherDic;
        cell.dataDic =self.otherDic;
    }

    
    return cell;
    
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
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    topView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    UIView *topBgView = [[UIView alloc]init];
    topBgView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    [topView addSubview:topBgView];
    [topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_top);
        make.left.equalTo(topView.mas_left);
        make.right.equalTo(topView.mas_right);
        make.height.equalTo(@50);
    }];
    
    UIView *shuView = [[UIView alloc]init];
    [topBgView addSubview:shuView];
    shuView.layer.cornerRadius = 2.f;
    shuView.layer.masksToBounds = YES;
    shuView.backgroundColor = [UIColor colorWithRed:47/255.0 green:94/255.0 blue:209/255.0 alpha:1.0];
    [shuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView.mas_left).offset(16);
        make.width.equalTo(@3);
        make.height.equalTo(@15);
        make.centerY.equalTo(topBgView.mas_centerY);
        
    }];
    
   
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, 84, 50)];
    [topBgView addSubview:titleLabel];
    titleLabel.text = @"当前告警设备备件";
    titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    titleLabel.font = [UIFont my_font:16];
    titleLabel.numberOfLines = 1;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_top);
        make.left.equalTo(shuView.mas_right).offset(10);
        make.right.equalTo(topBgView.mas_right);
        make.height.equalTo(@50);
    }];
    
    
    
    
    UILabel *firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 50, 84, 50)];
    [topView addSubview:firstLabel];
    firstLabel.text = @"备件所属设备";
    firstLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    firstLabel.font = [UIFont systemFontOfSize:14];
    firstLabel.font = [UIFont my_font:14];
    firstLabel.numberOfLines = 1;
    firstLabel.textAlignment = NSTextAlignmentLeft;
    [firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView.mas_left).offset(16);
        make.height.equalTo(@50);
        make.width.lessThanOrEqualTo(@120);
        make.top.equalTo(topBgView.mas_bottom);
    }];
    
    UILabel *secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(140, 50, 84, 50)];
    [topView addSubview:secondLabel];
    secondLabel.text = @"备件类型";
    secondLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    secondLabel.font = [UIFont systemFontOfSize:14];
    secondLabel.font = [UIFont my_font:14];
    secondLabel.numberOfLines = 1;
    secondLabel.textAlignment = NSTextAlignmentLeft;
    [secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView.mas_left).offset(SCREEN_WIDTH/2- 30);
        make.height.equalTo(@50);
        make.width.lessThanOrEqualTo(@120);
        make.top.equalTo(topBgView.mas_bottom);
    }];
    
    
    UILabel *thirdLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 50, 84, 50)];
    [topView addSubview:thirdLabel];
    thirdLabel.text = @"备件数量";
    thirdLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    thirdLabel.font = [UIFont systemFontOfSize:14];
    thirdLabel.font = [UIFont my_font:14];
    thirdLabel.numberOfLines = 1;
    thirdLabel.textAlignment = NSTextAlignmentRight;
    [thirdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topView.mas_right).offset(-16);
        make.height.equalTo(@50);
        make.width.equalTo(@120);
        make.top.equalTo(topBgView.mas_bottom);
    }];
    
    if (section == 0) {
        titleLabel.text = @"当前告警设备备件";
    }else {
        titleLabel.text = @"其他备件";
    }
    
    return topView;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.001)];
    return footView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}


@end
