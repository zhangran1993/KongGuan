//
//  KG_RunReportDetailViewController.m
//  Frame
//
//  Created by zhangran on 2020/6/2.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_RunReportDetailViewController.h"
#import "KG_RunReportDetailFirstCell.h"
#import "KG_RunReportDetailSecondCell.h"
#import "KG_RunReportDetailThirdCell.h"
#import "KG_RunReportDetailFourthCell.h"
#import "KG_RunReportDetailFifthCell.h"
#import "KG_RunReportDetailSixthCell.h"
#import "KG_RunReportDetailSeventhCell.h"
#import "KG_RunReportDetailEighthCell.h"
@interface KG_RunReportDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;


@property (nonatomic, strong)  UILabel   *titleLabel;
@property (nonatomic, strong)  UIView    *navigationView;
@property (nonatomic, strong)  UIButton  *rightButton;

@end

@implementation KG_RunReportDetailViewController


-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillAppear");
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:YES];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillDisappear");
    [self.navigationController setNavigationBarHidden:NO];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    [self createNaviTopView];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [self.tableView reloadData];
}

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 8;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
   
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 105;
    }else if (indexPath.section == 1) {
        return 300;
    }else if (indexPath.section == 2) {
        return 141;
    }else if (indexPath.section == 3) {
        return 260;
    }else if (indexPath.section == 4) {
        return 165;
    }else if (indexPath.section == 5) {
        return 130;
    }else if (indexPath.section == 6) {
        return 95;
    }else if (indexPath.section == 7) {
        return 160;
    }
    return 81;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        KG_RunReportDetailFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_RunReportDetailFirstCell"];
        if (cell == nil) {
            cell = [[KG_RunReportDetailFirstCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_RunReportDetailFirstCell"];
            cell.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        }
        return cell;
  
    }else if (indexPath.section == 1) {
        KG_RunReportDetailSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_RunReportDetailSecondCell"];
        if (cell == nil) {
            cell = [[KG_RunReportDetailSecondCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_RunReportDetailSecondCell"];
            cell.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        }
        return cell;
    }else if (indexPath.section == 2) {
        KG_RunReportDetailThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_RunReportDetailThirdCell"];
        if (cell == nil) {
            cell = [[KG_RunReportDetailThirdCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_RunReportDetailThirdCell"];
            cell.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        }
        return cell;
    }else if (indexPath.section == 3) {
        KG_RunReportDetailFourthCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_RunReportDetailFourthCell"];
        if (cell == nil) {
            cell = [[KG_RunReportDetailFourthCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_RunReportDetailFourthCell"];
            cell.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        }
        return cell;
    }else if (indexPath.section == 4) {
        KG_RunReportDetailFifthCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_RunReportDetailFifthCell"];
        if (cell == nil) {
            cell = [[KG_RunReportDetailFifthCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_RunReportDetailFifthCell"];
            cell.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        }
        return cell;
    }else if (indexPath.section == 5) {
        KG_RunReportDetailSixthCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_RunReportDetailSixthCell"];
        if (cell == nil) {
            cell = [[KG_RunReportDetailSixthCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_RunReportDetailSixthCell"];
            cell.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        }
        return cell;
    }else if (indexPath.section == 6) {
        KG_RunReportDetailSeventhCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_RunReportDetailSeventhCell"];
        if (cell == nil) {
            cell = [[KG_RunReportDetailSeventhCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_RunReportDetailSeventhCell"];
            cell.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        }
        return cell;
    }else if (indexPath.section == 7) {
        KG_RunReportDetailEighthCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_RunReportDetailEighthCell"];
        if (cell == nil) {
            cell = [[KG_RunReportDetailEighthCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_RunReportDetailEighthCell"];
            cell.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        }
        return cell;
    }
    return nil;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
 
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
   
    return headView;
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
    self.titleLabel.text = @"运行报告";
    
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

@end
