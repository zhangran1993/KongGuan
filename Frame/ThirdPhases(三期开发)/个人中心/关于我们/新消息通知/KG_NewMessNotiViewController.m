//
//  KG_CenterCommonViewController.m
//  Frame
//
//  Created by zhangran on 2020/12/10.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_NewMessNotiViewController.h"

#import "KG_NewMessNotiCell.h"
@interface KG_NewMessNotiViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
}

@property (nonatomic, strong)   UITableView              *tableView;

@property (nonatomic, strong)   NSArray                  *dataArray;

@property (nonatomic, strong)   UILabel                  *titleLabel;

@property (nonatomic, strong)   UIView                   *navigationView;

@property (nonatomic, strong)   UIButton                 *rightButton;

@property (nonatomic, assign)   BOOL                     switchOn;


@property (nonatomic, assign)   NSInteger                *indexPath;


@property (nonatomic, strong)   NSDictionary             *dataDic;

@end

@implementation KG_NewMessNotiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =[UIColor colorWithHexString:@"#F6F7F9"];
    [self initData];
    // Do any additional setup after loading the view.
    [self createNaviTopView];
    
    [self createTableView];
    [self.tableView reloadData];
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

- (void)initData {
    
    self.dataArray = [NSArray arrayWithObjects:@"新消息通知",@"字体大小",@"清除缓存",nil];
    
    self.switchOn = NO;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"newMessNoti"]) {
        self.dataDic = [userDefaults objectForKey:@"newMessNoti"];
        
    }else {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
        [dic setValue:[NSNumber numberWithInt:0] forKey:@"yujing"];
        [dic setValue:[NSNumber numberWithInt:0] forKey:@"gaojing"];
        [dic setValue:[NSNumber numberWithInt:0] forKey:@"gonggao"];
        
        self.dataDic = dic;
        
    }
    
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
    self.titleLabel.text = safeString(@"新消息通知");
    
    /** 返回按钮 **/
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, (Height_NavBar -44)/2, 44, 44)];
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

- (void)createTableView {
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).offset(NAVIGATIONBAR_HEIGHT);
        make.height.equalTo(@10);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).offset(NAVIGATIONBAR_HEIGHT +10);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

-(NSArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_NewMessNotiCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_NewMessNotiCell"];
   
    if (cell == nil) {
        cell = [[KG_NewMessNotiCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_NewMessNotiCell"];
        cell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }
    cell.indexPath = indexPath.row;
    
    cell.switchOnBlock = ^(BOOL switchOn, NSInteger indexRow) {
        
      
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:self.dataDic];
        if (indexRow == 0) {
            [dic setValue:[NSNumber numberWithInt:switchOn] forKey:@"yujing"];
        }else if (indexRow == 1) {
            [dic setValue:[NSNumber numberWithInt:switchOn] forKey:@"gaojing"];
        }else if (indexRow == 2) {
            [dic setValue:[NSNumber numberWithInt:switchOn] forKey:@"gonggao"];
        }
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:dic forKey:@"newMessNoti"];
        
        
    };
    
    
    if(indexPath.row == 0) {
        
        cell.titleLabel.text = @"预警消息";
        cell.detailLabel.text = @"包含天气预警和设备参数预警";
//        [cell.swh setOn:[NSNumber numberWithBool:self.dataDic[@"yujing"]]];
        
        BOOL isON = [self.dataDic[@"yujing"] boolValue];
        [cell.swh setOn:isON];
    }else if(indexPath.row == 1) {
        cell.titleLabel.text = @"告警消息";
        cell.detailLabel.text = @"包含不同等级的告警消息";
//        [cell.swh setOn:[NSNumber numberWithBool:self.dataDic[@"gaojing"]]];
        BOOL isON =  [self.dataDic[@"gaojing"] boolValue];
        [cell.swh setOn:isON];
    }else if(indexPath.row == 2) {
        cell.titleLabel.text = @"公告消息";
        cell.detailLabel.text = @"包含任务提醒和提示消息";
//        [cell.swh setOn:[NSNumber numberWithBool:self.dataDic[@"gonggao"]]];
        BOOL isON = [self.dataDic[@"gonggao"] boolValue];
        [cell.swh setOn:isON];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//
//      if ([ss isEqualToString:@"新消息通知"]) {
//
//
//      }else if ([ss isEqualToString:@"字体大小"]) {
//
//
//      }else if ([ss isEqualToString:@"清除缓存"]) {
//
//
//      }
}
@end
