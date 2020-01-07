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
@end

@implementation StationMachineDetailMoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.radarList = [NSMutableArray arrayWithCapacity:0];
    [self loadTableView];
    [self queryData];
    
    
}
-(void)backBtn{
    UIButton *leftButon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    leftButon.frame = CGRectMake(0,0,FrameWidth(60),FrameWidth(60));
    [leftButon setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [leftButon setContentEdgeInsets:UIEdgeInsetsMake(0, - FrameWidth(20), 0, FrameWidth(20))];
    //button.alignmentRectInsetsOverride = UIEdgeInsetsMake(0, offset, 0, -(offset));
    [leftButon addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *fixedButton = [[UIBarButtonItem alloc]initWithCustomView:leftButon];
    self.navigationItem.leftBarButtonItem = fixedButton;
    
  
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}
-(void)backAction {

    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
     [self backBtn];
      
   
}
- (void)queryData {
    self.radarList  = _machineDetail[@"tagList"];
    [self.radarTableView reloadData];
    self.title = [NSString stringWithFormat:@"%@-%@",safeString(_machineDetail[@"station_name"]),safeString(_machineDetail[@"machine_name"])];
}
#pragma mark - private methods 私有方法



-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    // NSLog(@"viewDidAppear");
    
    
}
-(void)viewDidDisappear:(BOOL)animated{
    
}
-(void)viewWillLayoutSubviews{
    // NSLog(@"viewWillLayoutSubviews");
    
}

- (void)loadTableView {
    self.radarTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN - 150 - TOOLH - ZNAVViewH)];
    self.radarTableView.delegate =self;
    self.radarTableView.dataSource =self;
    self.radarTableView.separatorStyle = NO;
    [self.view addSubview:self.radarTableView];
    [self.radarTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
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
        cell.detailLabel.text = safeString(self.radarList[indexPath.row][@"tagValue"]);
        
        return cell;
    }
    return nil;
}
@end
