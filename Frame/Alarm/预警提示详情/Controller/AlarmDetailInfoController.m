//
//  AlarmDetailInfoController.m
//  Frame
//
//  Created by zhangran on 2020/1/8.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "AlarmDetailInfoController.h"
#import "AlarmDetailInfoCell.h"
@interface AlarmDetailInfoController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation AlarmDetailInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"巡检设备清单";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
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

#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 400;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AlarmDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlarmDetailInfoCell"];
    if (cell == nil) {
        cell = [[AlarmDetailInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AlarmDetailInfoCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
  
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 110;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, 50)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, WIDTH_SCREEN-40, headerView.frame.size.height-1)];
    titleLabel.text = [NSString stringWithFormat:@"%@%@",@"检查台站:",@""];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:titleLabel];
    titleLabel.textColor = [UIColor colorWithHexString:@"#222222"];
    titleLabel.numberOfLines = 1;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 1)];
    [headerView addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#E8E8E8"];
    
    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 110)];
    
    UIButton *taskBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2, 30, 150, 40)];
    [taskBtn setTitle:[NSString stringWithFormat:@"%@",@"生成巡检任务"] forState:UIControlStateNormal];
    [taskBtn setTitleColor:[UIColor colorWithRed:95.f/255.f green:175.f/255.f blue:251.f/255.f alpha:1.f] forState:UIControlStateNormal];
    taskBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [footView addSubview:taskBtn];
    [taskBtn addTarget:self action:@selector(tashCreateMethod:) forControlEvents:UIControlEventTouchUpInside];
    taskBtn.layer.borderWidth = .5f;
    taskBtn.layer.cornerRadius = 4.f;
    taskBtn.layer.masksToBounds = YES;
    taskBtn.layer.borderColor = [[UIColor colorWithRed:95.f/255.f green:175.f/255.f blue:251.f/255.f alpha:1.f] CGColor] ;
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 10)];
    [footView addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    return footView;
}
//生成巡检任务
- (void)tashCreateMethod:(UIButton *)button {
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    return _tableView;
}
/**  懒加载  */
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
