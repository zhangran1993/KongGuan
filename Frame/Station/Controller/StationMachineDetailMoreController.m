//
//  StationMachineDetailMoreController.m
//  Frame
//
//  Created by zhangran on 2020/1/7.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "StationMachineDetailMoreController.h"
#import "RadarTableViewCell.h"
@interface StationMachineDetailMoreController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *radarTableView;

@property (nonatomic, strong) NSMutableArray *radarList;

@property (nonatomic, strong) UIImageView *topIconImage;

@property (nonatomic, strong) UILabel *topTitleLabel;
@end

@implementation StationMachineDetailMoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.radarList = [NSMutableArray arrayWithCapacity:0];
    [self createNaviView];
    [self loadTableView];
    [self queryData];
    
    
}

- (void)createNaviView {
    UIButton *leftButon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    leftButon.frame = CGRectMake(0,0,FrameWidth(60),FrameWidth(60));
    [leftButon setImage:[UIImage imageNamed:@"back_gray"] forState:UIControlStateNormal];
    [leftButon setContentEdgeInsets:UIEdgeInsetsMake(0, - FrameWidth(20), 0, FrameWidth(20))];
    //button.alignmentRectInsetsOverride = UIEdgeInsetsMake(0, offset, 0, -(offset));
    [leftButon addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *fixedButton = [[UIBarButtonItem alloc]initWithCustomView:leftButon];
    self.navigationItem.leftBarButtonItem = fixedButton;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FontSize(18),NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#24252A"]}] ;
    
    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.translucent = NO;
    
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]]; 
   
     
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
      [self.navigationController setNavigationBarHidden:NO];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillDisappear");
    
    [self.navigationController setNavigationBarHidden:YES];
    
    
    
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

- (void)queryData {
    
//    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
//    for (NSDictionary *dic in _machineDetail[@"tagList"]) {
//        if ([dic[@"emphasis"] boolValue]) {
//            [arr addObject:dic];
//        }
//    }
    self.radarList  = _machineDetail[@"tagList"];
    [self.radarTableView reloadData];
    self.title = [NSString stringWithFormat:@"%@-%@",safeString(_machineDetail[@"roomName"]),safeString(_machineDetail[@"name"])];
    NSString *code = safeString(_machineDetail[@"name"]);
    
    self.topIconImage.image = [UIImage imageNamed:[CommonExtension getDeviceIcon:safeString(_machineDetail[@"category"])]];
    if([safeString(_machineDetail[@"category"]) isEqualToString:@"navigation"]
       ){
        if ([safeString(_machineDetail[@"name"]) containsString:@"DME"]||
            [safeString(_machineDetail[@"alias"]) containsString:@"导航-DME"] ||
            [safeString(_machineDetail[@"machine_name"]) containsString:@"导航DME"] ) {
            self.topIconImage.image =  [UIImage imageNamed:@"导航DME"];
        }else if ([safeString(_machineDetail[@"name"]) containsString:@"DVOR"]||
                  [safeString(_machineDetail[@"alias"]) containsString:@"导航-DVOR"] ||
                  [safeString(_machineDetail[@"machine_name"]) containsString:@"导航DVOR"]) {
            self.topIconImage.image =  [UIImage imageNamed:@"导航DVOR"];
        }
    }
         
    self.topTitleLabel.text =  [NSString stringWithFormat:@"%@-%@",safeString(_machineDetail[@"roomName"]),safeString(_machineDetail[@"name"])];
}
#pragma mark - private methods 私有方法




-(void)viewDidAppear:(BOOL)animated{
    // NSLog(@"viewDidAppear");
    
    
}
-(void)viewDidDisappear:(BOOL)animated{
    
}
-(void)viewWillLayoutSubviews{
    // NSLog(@"viewWillLayoutSubviews");
    
}

- (void)loadTableView {
    self.radarTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN - Height_BottomBar)];
    self.radarTableView.delegate =self;
    self.radarTableView.dataSource =self;
    self.radarTableView.separatorStyle = NO;
    self.radarTableView.backgroundColor  = self.view.backgroundColor;
    [self.view addSubview:self.radarTableView];
    [self.radarTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50 +10)];
    self.radarTableView.tableHeaderView = headView;
    headView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    
    UIView *topView = [[UIView alloc]init];
    [headView addSubview:topView];
    topView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView.mas_left);
        make.right.equalTo(headView.mas_right);
        make.top.equalTo(headView.mas_top);
        make.height.equalTo(@10);
    }];
    
    self.topIconImage = [[UIImageView alloc]init];
    [headView addSubview:self.topIconImage];
    self.topIconImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.topIconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView.mas_left).offset(19);
        make.width.equalTo(@22);
        make.top.equalTo(headView.mas_top).offset(27);
        make.height.equalTo(@22);
    }];
    
    self.topTitleLabel = [[UILabel alloc]init];
    [headView addSubview:self.topTitleLabel];
    self.topTitleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.topTitleLabel.font = [UIFont systemFontOfSize:14];
    self.topTitleLabel.numberOfLines = 1;
    self.topTitleLabel.textAlignment = NSTextAlignmentLeft;
    [self.topTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headView.mas_right).offset(-20);
        make.centerY.equalTo(self.topIconImage.mas_centerY);
        make.left.equalTo(self.topIconImage.mas_right).offset(6);
        make.height.equalTo(headView.mas_height);
    }];
    
    
    UIView *lineView = [[UIView alloc]init];
    [headView addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headView.mas_bottom);
        make.height.equalTo(@0.5);
        make.left.equalTo(headView.mas_left).offset(16);
        make.right.equalTo(headView.mas_right).offset(-14);
    }];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //if(self.detail[indexPath.row].typeid==1){
    if ([tableView isEqual:self.radarTableView]) {
        return 50;
    }
    return 0;
}

#pragma mark - UITableviewDatasource 数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([tableView isEqual:self.radarTableView]) {
        return [self.radarList count];
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:self.radarTableView]) {
        
        RadarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RadarTableViewCell"];
        if (cell == nil) {
            cell = [[RadarTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RadarTableViewCell"];
        }
        cell.titleLabel.text = safeString(self.radarList[indexPath.row][@"name"]) ;
        cell.detailLabel.text = [NSString stringWithFormat:@"%@%@",safeString(self.radarList[indexPath.row][@"valueAlias"]),safeString(self.radarList[indexPath.row][@"unit"])] ;
        if ([safeString(self.radarList[indexPath.row][@"valueAlias"]) containsString:safeString(self.radarList[indexPath.row][@"unit"])]) {
            cell.detailLabel.text = [NSString stringWithFormat:@"%@",safeString(self.radarList[indexPath.row][@"valueAlias"])] ;
        }
        if (safeString(self.radarList[indexPath.row][@"unit"]).length == 0) {
            cell.detailLabel.text = [NSString stringWithFormat:@"%@",safeString(self.radarList[indexPath.row][@"valueAlias"])] ;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (safeString(self.radarList[indexPath.row][@"valueAlias"]).length == 0) {
            cell.detailLabel.text = @"--";
        }
        NSArray *arr = self.machineDetail[@"equipmentAlarmInfo"];
        for (NSDictionary *arDic in arr) {
            if ([safeString(arDic[@"name"] ) containsString:safeString(self.radarList[indexPath.row][@"name"])] &&[safeString(arDic[@"name"]) containsString:safeString(self.radarList[indexPath.row][@"valueAlias"])]) {
                cell.titleLabel.textColor = [UIColor colorWithHexString:@"#FB394C"];
                cell.detailLabel.textColor = [UIColor colorWithHexString:@"#FB394C"];
                cell.iconImage.backgroundColor = [UIColor colorWithHexString:@"#FB394C"];
                break;
            }else {
                cell.titleLabel.textColor = [UIColor colorWithHexString:@"#7C7E86"];
                cell.detailLabel.textColor = [UIColor colorWithHexString:@"#7C7E86"];
                cell.iconImage.backgroundColor = [UIColor colorWithHexString:@"#95A8D7"];
            }
        }
        return cell;
    }
    return nil;
}
@end
