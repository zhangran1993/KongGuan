//
//  KG_EquipCardViewController.m
//  Frame
//
//  Created by zhangran on 2020/6/16.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_EquipCardViewController.h"
#import "KG_EquipCardCell.h"
#import "KG_WeiHuCardAlertView.h"
#import "KG_OperationGuideViewController.h"
@interface KG_EquipCardViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong)  UILabel   *titleLabel;
@property (nonatomic, strong)  UIView    *navigationView;
@property (nonatomic, strong)  UIButton  *rightButton;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong)  UIView    *headView;

@property (nonatomic, strong)  UIScrollView  *scrollView;
@property (nonatomic, strong) KG_WeiHuCardAlertView *alertView;

@property (nonatomic, strong)  UIButton  *leftBtn;
@property (nonatomic, strong)  UIButton  *rightBtn;
@property (nonatomic, assign)  NSInteger selIndex;
@property (nonatomic, assign)  NSInteger selDetailIndex;

@property (nonatomic, strong)  NSDictionary * curSelDic;
@property (nonatomic, strong)  NSDictionary * curSelDetailDic;
@end

@implementation KG_EquipCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNaviTopView];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.selIndex = 0;
    self.selDetailIndex = 0;
    [self createScrollView];
    [self createView];
}

- (void)createScrollView {
    
    
}

- (void)createNaviTopView {
    
    UIImageView *topImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT +44)];
    [self.view addSubview:topImage1];
    topImage1.backgroundColor  =[UIColor whiteColor];
    UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT + 44)];
    [self.view addSubview:topImage];
    topImage.backgroundColor  =[UIColor whiteColor];
    topImage.image = [UIImage imageNamed:@"zhiyun_bgImage"];
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
    self.titleLabel.text = @"设备情况";
    
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

-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillAppear");
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:YES];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillDisappear");
    [self.navigationController setNavigationBarHidden:NO];
    
}

- (void)createView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.tableView.layer.cornerRadius = 6;
    self.tableView.layer.masksToBounds = YES;
    [self.tableView reloadData];
    
    
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 56)];
    self.tableView.tableHeaderView = self.headView;
    
    UIImageView *iconImage = [[UIImageView alloc]init];
    [self.headView addSubview:iconImage];
    iconImage.backgroundColor = [UIColor colorWithHexString:@"#BABCC4"];
    iconImage.layer.cornerRadius =2.5f;
    iconImage.layer.masksToBounds = YES;
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headView.mas_centerY);
        make.left.equalTo(self.headView.mas_left).offset(32);
        make.width.height.equalTo(@5);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [self.headView addSubview:titleLabel];
    titleLabel.text = @"系统和设备情况";
    titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    titleLabel.numberOfLines = 1;
    [titleLabel sizeToFit];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImage.mas_right).offset(4);
        make.centerY.equalTo(iconImage.mas_centerY);
        make.height.equalTo(@24);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    [self.headView addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView.mas_left);
        make.right.equalTo(self.headView.mas_right);
        make.bottom.equalTo(self.headView.mas_bottom);
        make.height.equalTo(@1);
    }];
    for (NSDictionary *dic in self.listArray) {
        
    }
   
    self.leftBtn = [[UIButton alloc]init];
    [self.headView addSubview:self.leftBtn];
    [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"equip_buttonBgImage"] forState:UIControlStateNormal];
    [self.leftBtn setTitleColor:[UIColor colorWithHexString:@"#626470"] forState:UIControlStateNormal];
    self.leftBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [self.leftBtn sizeToFit];
    [self.leftBtn addTarget:self action:@selector(showAlertView) forControlEvents:UIControlEventTouchUpInside];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right).offset(6);
        make.height.equalTo(@30);
        make.centerY.equalTo(titleLabel.mas_centerY);
    }];
    
    
    self.rightBtn = [[UIButton alloc]init];
    [self.headView addSubview:self.rightBtn];
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"equip_buttonBgImage"] forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:[UIColor colorWithHexString:@"#626470"] forState:UIControlStateNormal];
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [self.rightBtn sizeToFit];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftBtn.mas_right).offset(5);
        make.height.equalTo(@30);
        make.centerY.equalTo(titleLabel.mas_centerY);
    }];
    [self.rightBtn addTarget:self action:@selector(showAlertView) forControlEvents:UIControlEventTouchUpInside];
    if(self.listArray.count == 0){
        self.leftBtn.hidden = YES;
        self.rightBtn.hidden = YES;
    }else if(self.listArray.count > 0){
        NSDictionary *dic = self.listArray[self.selIndex];
        [self.leftBtn setTitle:safeString(dic[@"systemName"]) forState:UIControlStateNormal];
        self.leftBtn.hidden = NO;
        if (dic.count) {
            NSArray *arr = dic[@"equipmentList"];
            if (arr.count >0) {
                NSDictionary *detailDic = arr[self.selDetailIndex];
                self.rightBtn.hidden = NO;
                [self.rightBtn setTitle:safeString(detailDic[@"equipmentName"]) forState:UIControlStateNormal];
            }else {
                self.rightBtn.hidden = YES;
            }
        }
//
//    }else if(self.listArray.count == 2){
//        NSDictionary *dic = [self.listArray firstObject];
//        NSDictionary *dic1 = [self.listArray lastObject];
//        [self.leftBtn setTitle:safeString(dic[@"systemName"]) forState:UIControlStateNormal];
//
//
//
    }
    
}
//弹出
- (void)showAlertView{
    [_alertView removeFromSuperview];
    _alertView = nil;
    if (_alertView == nil) {
        [self.view addSubview:self.alertView];
        
        if (self.curSelDic.count) {
            self.alertView.curSelDic = self.curSelDic;
        }
        if (self.curSelDetailDic.count) {
            self.alertView.curSelDetailDic = self.curSelDetailDic;
        }
        self.alertView.dataArray = self.listArray;
        
        self.alertView.buttonBlockMethod = ^(NSDictionary * _Nonnull dataDic, NSDictionary * _Nonnull detailDic) {
            NSLog(@"%@----%@",dataDic,detailDic);
            if (dataDic.count) {
                self.curSelDic = dataDic;
                [self.leftBtn setTitle:safeString(dataDic[@"systemName"]) forState:UIControlStateNormal];
            }
            if (detailDic.count) {
                self.curSelDetailDic = detailDic;
                [self.rightBtn setTitle:safeString(detailDic[@"equipmentName"]) forState:UIControlStateNormal];
            }
            
            [self.tableView reloadData];
            
        };
        [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
    }else {
        self.alertView.hidden = NO;
    }
   
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
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



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_EquipCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_EquipCardCell"];
    if (cell == nil) {
        cell = [[KG_EquipCardCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_EquipCardCell"];
        cell.moreBlockMethod = ^(NSDictionary * _Nonnull dataDic) {
            
            KG_OperationGuideViewController *vc  = [[KG_OperationGuideViewController alloc]init];
            vc.dataDic = dataDic;
            [self.navigationController pushViewController:vc animated:YES];
        };
        cell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.curSelDic.count) {
        cell.curSelDic = self.curSelDic;
    }
    if (self.curSelDetailDic.count) {
        cell.curSelDetialDic = self.curSelDetailDic;
    }
    
    cell.dataModel = self.dataModel;
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
  
}

- (KG_WeiHuCardAlertView *)alertView {
    if (!_alertView) {
        _alertView = [[KG_WeiHuCardAlertView alloc]init];
        
    }
    return _alertView;
}

@end
