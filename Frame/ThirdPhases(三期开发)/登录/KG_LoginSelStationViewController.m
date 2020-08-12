//
//  KG_LoginSelStationView.m
//  Frame
//
//  Created by zhangran on 2020/5/18.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_LoginSelStationViewController.h"
#import "KG_LoginSelStaionModel.h"
#import "KG_LoginSelStationCell.h"
#import "KG_NewLoginViewController.h"
@interface KG_LoginSelStationViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)  UILabel         *stationLabel;

@property (nonatomic,strong)  UILabel         *stationDetailLabel;

@property (nonatomic,strong)  UILabel         *selLabel;

@property (nonatomic, strong) UIView          *navigationView;

@property (nonatomic,strong)  UITableView     *tableView;

@property (nonatomic,strong)  NSMutableArray  *dataArray;

@property (nonatomic,strong)  UIButton        *selBtn;

@property (nonatomic,strong) KG_LoginSelStaionModel *model;

@end
@implementation KG_LoginSelStationViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.model = [[KG_LoginSelStaionModel alloc]init];
    [self initData];
    [self setupDataSubviews];
    [self queryStationData];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    
}

-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillAppear");
    if (@available(iOS 13.0, *)){
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    }else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    [self.navigationController setNavigationBarHidden:YES];
    self.tabBarController.tabBar.hidden = YES;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillDisappear");
    
    
}
//查询台站数据
- (void)queryStationData {
    
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcStation/app/stationSelect"]];
    [FrameBaseRequest getDataWithUrl:FrameRequestURL param:nil success:^(id result) {
        
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        self.dataArray = [KG_LoginSelStaionModel mj_objectArrayWithKeyValuesArray:result[@"value"]];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if ([userDefaults objectForKey:@"hasSelStationCode"]) {
            NSString *sCode = [userDefaults objectForKey:@"hasSelStationCode"];
            for (KG_LoginSelStaionModel *model in self.dataArray) {
                for (stationListModel *detailModel1 in model.stationList) {
                    if ([sCode isEqualToString:detailModel1.stationCode]) {
                        detailModel1.isSelected = YES;
                        self.selLabel.text = [NSString stringWithFormat:@"已选:%@", safeString(detailModel1.stationName)];
                    }else {
                        detailModel1.isSelected = NO;
                    }
                }
            }
        }
        [self.tableView reloadData];
        NSLog(@"");
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
    }];
}
//初始化数据
- (void)initData {
    
}

//创建视图
-(void)setupDataSubviews
{
    /** 导航栏 **/
    self.navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Height_NavBar)];
    self.navigationView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.navigationView];
    
    /** 返回按钮 **/
    UIButton * backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, (Height_NavBar -44)/2, 44, 44)];
    [backBtn addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@44);
        make.bottom.equalTo(self.navigationView.mas_bottom);
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
    
    
    self.stationLabel = [[UILabel alloc]init];
    [self.view addSubview:self.stationLabel];
    self.stationLabel.text = @"选择台站";
    self.stationLabel.textColor = [UIColor colorWithHexString:@"#142038"];
    self.stationLabel.font = [UIFont boldSystemFontOfSize:20];
    self.stationLabel.textAlignment = NSTextAlignmentCenter;
    [self.stationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset((SCREEN_WIDTH -200)/2);
        make.top.equalTo(backBtn.mas_bottom).offset(32);
        make.height.equalTo(@28);
        make.width.equalTo(@200);
    }];
    
    self.stationDetailLabel = [[UILabel alloc]init];
    [self.view addSubview:self.stationDetailLabel];
    self.stationDetailLabel.text = @"请选择您权限内的台站进行登录";
    self.stationDetailLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.stationDetailLabel.font = [UIFont systemFontOfSize:14];
    self.stationDetailLabel.textAlignment = NSTextAlignmentCenter;
    [self.stationDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset((SCREEN_WIDTH -200)/2);
        make.top.equalTo(self.stationLabel.mas_bottom).offset(3);
        make.height.equalTo(@20);
        make.width.equalTo(@200);
    }];
    
    self.selLabel = [[UILabel alloc]init];
    [self.view addSubview:self.selLabel];
    self.selLabel.text = @"已选：";
    self.selLabel.textColor = [UIColor colorWithHexString:@"#004EC4"];
    self.selLabel.font = [UIFont systemFontOfSize:14];
    self.selLabel.textAlignment = NSTextAlignmentCenter;
    [self.selLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset((SCREEN_WIDTH -200)/2);
        make.top.equalTo(self.stationDetailLabel.mas_bottom).offset(13);
        make.height.equalTo(@20);
        make.width.equalTo(@200);
    }];
    UIView *lineView = [[UIView alloc]init];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(34);
        make.right.equalTo(self.view.mas_right).offset(-34);
        make.height.equalTo(@0.5);
        make.top.equalTo(self.selLabel.mas_bottom).offset(20);
    }];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    
    [self.view addSubview:self.tableView];
    
    [self.selBtn = [UIButton alloc]init];
    [self.selBtn setTitle:@"选好了" forState:UIControlStateNormal];
    self.selBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    self.selBtn.layer.cornerRadius = 22;
    self.selBtn.layer.masksToBounds = YES;
    self.selBtn.layer.backgroundColor = [UIColor colorWithRed:47/255.0 green:94/255.0 blue:209/255.0 alpha:1.0].CGColor;
    [self.selBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    
    
    [self.view addSubview:self.selBtn];
    [self.selBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-24);
        make.width.equalTo(@176);
        make.height.equalTo(@44);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    [self.selBtn addTarget:self action:@selector(hasSelMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
        make.left.equalTo(self.view.mas_left).offset(34);
        make.right.equalTo(self.view.mas_right).offset(-34);
        make.bottom.equalTo(self.selBtn.mas_top).offset(-35);
    }];
    [self.tableView reloadData];
}
//选好了
- (void)hasSelMethod:(UIButton *)button {
    int num = 0;
    for (KG_LoginSelStaionModel *model in self.dataArray) {
        for (stationListModel *detailModel in model.stationList) {
            if (detailModel.isSelected) {
                num ++;
                KG_NewLoginViewController *VC= [[KG_NewLoginViewController alloc]init];
                VC.detailModel = detailModel;
                [self.navigationController pushViewController:VC animated:YES];
            }
        }
    }
    if (num == 0) {
        [MBProgressHUD show:@"请选择台站" toView:self.view];
    }
}
- (void)backButtonClick:(UIButton *)button {
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    KG_LoginSelStaionModel *model = self.dataArray[section];
    if (model.isShouQi) {
        return 0;
    }
    return model.stationList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    KG_LoginSelStaionModel *model = self.dataArray[indexPath.section];
    if (model.isShouQi) {
        return 0;
    }
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_LoginSelStationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_LoginSelStationCell "];
    if (cell == nil) {
        cell = [[KG_LoginSelStationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_LoginSelStationCell"];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    KG_LoginSelStaionModel *model = self.dataArray[indexPath.section];
    stationListModel *detailModel = model.stationList[indexPath.row];
    cell.detailModel =detailModel;
    cell.selectedMethod = ^(stationListModel * _Nonnull detailModel) {
        for (KG_LoginSelStaionModel *model in self.dataArray) {
            for (stationListModel *detailModel1 in model.stationList) {
                if ([detailModel1.stationCode isEqualToString:detailModel.stationCode]) {
                    detailModel1.isSelected = !detailModel.isSelected;
                    if (detailModel1.isSelected) {
                        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                        [userDefaults setObject:safeString(detailModel.stationName) forKey:@"hasSelStationName"];
                        [userDefaults setObject:safeString(detailModel.stationCode) forKey:@"hasSelStationCode"];
                        [userDefaults synchronize];
                    }
                }else {
                    detailModel1.isSelected = NO;
                }
            }
        }
        if (detailModel.isSelected) {
            self.selLabel.text = [NSString stringWithFormat:@"已选:%@", safeString(detailModel.stationName)];
        }else {
            self.selLabel.text = [NSString stringWithFormat:@"已选:"];
        }
        [self.tableView reloadData];
    };
    if (model.stationList.count) {
        if (indexPath.row == model.stationList.count -1) {
            cell.lineView.hidden = YES;
        }else {
            cell.lineView.hidden = NO;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_LoginSelStaionModel *model = self.dataArray[indexPath.section];
    stationListModel *detailModel = model.stationList[indexPath.row];
    for (KG_LoginSelStaionModel *model in self.dataArray) {
        for (stationListModel *detailModel1 in model.stationList) {
            if ([detailModel1.stationCode isEqualToString:detailModel.stationCode]) {
                detailModel1.isSelected = !detailModel.isSelected;
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:safeString(detailModel.stationName) forKey:@"hasSelStationName"];
                [userDefaults setObject:safeString(detailModel.stationCode) forKey:@"hasSelStationCode"];
                [userDefaults synchronize];
            }else {
                detailModel1.isSelected = NO;
            }
        }
    }
    if (detailModel.isSelected) {
        self.selLabel.text = [NSString stringWithFormat:@"已选:%@", safeString(detailModel.stationName)];
    }else {
        self.selLabel.text = [NSString stringWithFormat:@"已选:"];
    }
    [self.tableView reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    UILabel *titleLabel = [[UILabel alloc]init];
    [headView addSubview:titleLabel];
    titleLabel.text = @"导航台站";
    titleLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView.mas_left);
        make.top.equalTo(headView.mas_top);
        make.height.equalTo(headView.mas_height);
        make.width.equalTo(@200);
    }];
    KG_LoginSelStaionModel *model = self.dataArray[section];
    titleLabel.text = safeString(model.categoryName);
    
    UIButton *statusBtn = [[UIButton alloc]init];
    statusBtn.tag = section;
    [headView addSubview:statusBtn];
    [statusBtn setTitle:@"" forState:UIControlStateNormal];
    [statusBtn addTarget:self action:@selector(shouqiClick:) forControlEvents:UIControlEventTouchUpInside];
    [statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.height.equalTo(headView.mas_height);
        make.top.equalTo(headView.mas_top);
        make.right.equalTo(headView.mas_right);
    }];
    
    UIImageView * statusImageView = [[UIImageView alloc]init];
    [headView addSubview:statusImageView];
    [statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@20);
        make.height.equalTo(@20);
        make.right.equalTo(headView.mas_right).offset(-6);
        make.centerY.equalTo(titleLabel.mas_centerY);
    }];
    statusImageView.image = [UIImage imageNamed:@"right_iconImage"];
    if(model.isShouQi) {
        statusImageView.transform = CGAffineTransformMakeRotation(M_PI/2);
    }
    UIView *lineView = [[UIView alloc]init];
    [headView addSubview:lineView];
    lineView.backgroundColor =[UIColor colorWithHexString:@"#EFF0F7"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView.mas_left);
        make.right.equalTo(headView.mas_right);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(headView.mas_bottom);
    }];
    return headView;
}

- (void)shouqiClick:(UIButton *)btn {
    KG_LoginSelStaionModel *model = self.dataArray[btn.tag];
    model.isShouQi = !model.isShouQi;
    [self.tableView reloadData];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 60;
}
@end
