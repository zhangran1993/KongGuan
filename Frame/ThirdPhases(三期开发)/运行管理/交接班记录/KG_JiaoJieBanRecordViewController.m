//
//  KG_JiaoJieBanRecordViewController.m
//  Frame
//
//  Created by zhangran on 2020/6/1.
//  Copyright © 2020 hibaysoft. All rights reserved.
//
#import "KG_JiaoJieBanRecordViewController.h"
#import "KG_JiaoJieBanRecordCell.h"
@interface KG_JiaoJieBanRecordViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *noDataView;


@property (nonatomic,strong) UIView *screenView;
@property (nonatomic,strong) UILabel *totalNumLabel;
@property (nonatomic,strong) UIButton *startButton;
@property (nonatomic,strong) UIButton *endButton;
@property (nonatomic,strong) UIButton *resetButton;



@property (nonatomic, strong)  UILabel   *titleLabel;
@property (nonatomic, strong)  UIView    *navigationView;
@property (nonatomic, strong)  UIButton  *rightButton;
@end

@implementation KG_JiaoJieBanRecordViewController
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillAppear");
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:YES];
  
}
-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillDisappear");
    [self.navigationController setNavigationBarHidden:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self createNaviTopView];
    [self createScreenView];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.screenView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [self.tableView reloadData];
    
}

- (void)createScreenView{
    self.screenView = [[UIView alloc]init];
    [self.view addSubview:self.screenView];
    [self.screenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@44);
    }];
    self.screenView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    
    
    self.totalNumLabel = [[UILabel alloc]init];
    [self.screenView addSubview:self.totalNumLabel];
    self.totalNumLabel.text = @"共100条";
    self.totalNumLabel.font = [UIFont systemFontOfSize:12];
    self.totalNumLabel.textColor = [UIColor colorWithHexString:@"#BABCC4"];
    [self.totalNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.screenView.mas_left).offset(16);
        make.top.equalTo(self.screenView.mas_top).offset(13);
        make.width.equalTo(@100);
        make.height.equalTo(@17);
    }];
    
    self.startButton = [[UIButton alloc]init];
    [self.screenView addSubview:self.startButton];
    [self.startButton setTitle:@"2020.03.02" forState:UIControlStateNormal];
    [self.startButton setImage:[UIImage imageNamed:@"start_calImage"] forState:UIControlStateNormal];
    self.startButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.startButton setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];
    self.startButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    
    [self.startButton addTarget:self action:@selector(startMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.screenView.mas_left).offset(-11);
        make.top.equalTo(self.screenView.mas_top).offset(9);
        make.height.equalTo(@24);
        make.width.equalTo(@200);
    }];
    
}
- (void)startMethod:(UIButton *)button {
    
    
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = YES;
        
    }
    return _tableView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
   
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 124;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_JiaoJieBanRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_JiaoJieBanRecordCell "];
    if (cell == nil) {
        cell = [[KG_JiaoJieBanRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_JiaoJieBanRecordCell"];
        
    }
 
    
    return cell;
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

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    
    [self.tableView reloadData];
    
    if (dataArray.count == 0) {
        [self.view addSubview:self.noDataView];
        [self.view bringSubviewToFront:self.noDataView];
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

@end
