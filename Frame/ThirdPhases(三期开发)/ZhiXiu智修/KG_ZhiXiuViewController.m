//
//  KG_ZhiXiuViewController.m
//  Frame
//
//  Created by zhangran on 2020/5/14.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_ZhiXiuViewController.h"
#import "KG_HistoryTaskCell.h"
#import "SegmentTapView.h"
#import "RS_ConditionSearchView.h"
@interface KG_ZhiXiuViewController ()<SegmentTapViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) SegmentTapView *segment;
@property (nonatomic, strong) UITableView *tableView;


@property (nonatomic ,assign) int pageNum;
@property (nonatomic ,assign) int pageSize;

@property (nonatomic ,assign) BOOL isOpenSwh;

@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIButton *swh;
@end

@implementation KG_ZhiXiuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the vi
    self.isOpenSwh = NO;
    
    [self createNaviTopView];
    [self createSegmentView];
    
   
}
- (void)createSegmentView{
    NSArray *array = @[@"全部",@"未确认",@"已确认"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.segment = [[SegmentTapView alloc] initWithFrame:CGRectMake(0, 8, SCREEN_WIDTH, 44) withDataArray:array withFont:15];
    self.segment.delegate = self;
    [self.view addSubview:self.segment];
    
    
    
    UIView *swhView = [[UIView alloc]init];
    [self.view addSubview:swhView];
    swhView.backgroundColor = [UIColor colorWithHexString:@"#E6EEF7"];
    [swhView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@49);
        make.top.equalTo(self.segment.mas_bottom);
        
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [swhView addSubview:titleLabel];
    titleLabel.text = @"仅展示空管专用设备";
    titleLabel.textColor = [UIColor colorWithHexString:@"#808EAC"];
    titleLabel.font = [UIFont systemFontOfSize:14];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(swhView.mas_left).offset(15);
        make.top.equalTo(swhView.mas_top);
        make.bottom.equalTo(swhView.mas_bottom);
        make.width.equalTo(@200);
        
    }];
    
    self.swh = [[UIButton alloc]init];
    [swhView addSubview:self.swh];
    [self.swh mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(swhView.mas_right).offset(-17);
        make.centerY.equalTo(swhView.mas_centerY);
        make.width.equalTo(@44);
        make.height.equalTo(@26);
    }];
    [self.swh addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if(self.isOpenSwh){
        [self.rightButton setImage:[UIImage imageNamed:@"open_swh"] forState:UIControlStateNormal];
    }else {
         [self.rightButton setImage:[UIImage imageNamed:@"close_swh"] forState:UIControlStateNormal];
    }
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segment.mas_bottom).offset(49);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}
- (void)buttonClick:(UIButton *)button {
    
    if (self.isOpenSwh) {
        self.isOpenSwh = NO;
    }else {
        self.isOpenSwh = YES;
    }
    if(self.isOpenSwh){
        [self.rightButton setImage:[UIImage imageNamed:@"open_swh"] forState:UIControlStateNormal];
    }else {
         [self.rightButton setImage:[UIImage imageNamed:@"close_swh"] forState:UIControlStateNormal];
    }
    
}

//创建导航栏视图
-  (void)createNaviTopView {
    UIButton *leftButon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    leftButon.frame = CGRectMake(0,0,FrameWidth(60),FrameWidth(60));
    [leftButon setImage:[UIImage imageNamed:@"back_gray"] forState:UIControlStateNormal];
    [leftButon setContentEdgeInsets:UIEdgeInsetsMake(0, - FrameWidth(20), 0, FrameWidth(20))];
    //button.alignmentRectInsetsOverride = UIEdgeInsetsMake(0, offset, 0, -(offset));
    [leftButon addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *fixedButton = [[UIBarButtonItem alloc]initWithCustomView:leftButon];
    self.navigationItem.leftBarButtonItem = fixedButton;
    
   
    self.rightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.rightButton.titleLabel.font = FontSize(12);
    self.rightButton.layer.borderColor = [[UIColor colorWithHexString:@"#FFFFFF"]CGColor];
    self.rightButton.layer.borderWidth = 0.5f;
    self.rightButton.layer.cornerRadius = 12.5f;
    self.rightButton.layer.masksToBounds = YES;
    
    [self.rightButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    NSDictionary *currDic = [UserManager shareUserManager].currentStationDic;
    if (currDic.count) {
        [self.rightButton setTitle:safeString(currDic[@"alias"]) forState:UIControlStateNormal];
    }
    
    self.rightButton.frame = CGRectMake(0,0,81,22);
    [self.view addSubview:self.rightButton];
    [self.rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
   
    UIBarButtonItem *rightfixedButton = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    
    UIButton *screenButon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    screenButon.frame = CGRectMake(0,0,24,24);
    [screenButon setImage:[UIImage imageNamed:@"screen_icon"] forState:UIControlStateNormal];
    screenButon.titleLabel.font = [UIFont systemFontOfSize:16];
    [screenButon setTitleColor:[UIColor colorWithHexString:@"#24252A"] forState:UIControlStateNormal];
    [screenButon addTarget:self action:@selector(screenMethod) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightscreen = [[UIBarButtonItem alloc]initWithCustomView:screenButon];
    
    
    self.navigationItem.rightBarButtonItems = @[rightscreen,rightfixedButton];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.title = [NSString stringWithFormat:@"历史任务"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FontSize(18),NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#24252A"]}] ;
    
    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.translucent = NO;
    
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}
- (void)rightAction {
    
}
//筛选方法
- (void)screenMethod {
    NSArray *array = @[@{@"sectionName": @"内容",
                         @"sectionType": @(RS_ConditionSearchSectionTypeNormal),
                         @"allowMutiSelect": @(YES),
                         @"allowPackUp": @(YES),
                         @"itemArrM": @[@{@"itemName":@"开始时间"},
                                        @{@"itemName":@"结束时间"}]},
                       @{@"sectionName":@"起始时间",
                         @"sectionType":@(RS_ConditionSearchSectionTypeInterval),
                         @"allowMutiSelect":@(NO),
                         @"allowPackUp":@(NO),
                         @"intervalStart":@"",
                         @"intervalEnd":@"",
                         @"intervalIsInput":@(NO),
                         @"itemArrM":
                             @[@{@"itemName":@"开始时间"},
                               @{@"itemName":@"结束时间"}]}];
    
    RS_ConditionSearchView *searchView = [[RS_ConditionSearchView alloc] initWithCondition:array];
    
    //          searchView.conditionDataArr = array;
    [searchView show];
    
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
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = YES;
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 6)];
        _tableView.tableHeaderView = headView;
        headView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        // 上拉加载
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    }
    return _tableView;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dataDic = self.dataArray[indexPath.row];
    if (dataDic.count) {
        
        NSArray *biaoqianArr = dataDic[@"atcSpecialTagList"];
        if (biaoqianArr.count) {
            return 118;
        }
    }
    return  98;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_HistoryTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_HistoryTaskCell"];
    if (cell == nil) {
        cell = [[KG_HistoryTaskCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_HistoryTaskCell"];
        
    }
    cell.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *dataDic = self.dataArray[indexPath.row];
   
    cell.dataDic = dataDic;
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //    NSString *str = self.dataArray[indexPath.row];
    
}


- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}



@end
