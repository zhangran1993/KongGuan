//
//  KG_NiControlSearchViewController.m
//  Frame
//
//  Created by zhangran on 2020/4/9.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_NiControlSearchViewController.h"
#import "KG_SearchCell.h"
@interface KG_NiControlSearchViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>{
    
}
@property (nonatomic, strong) UIButton *bgBtn ;

@property (nonatomic, strong) UITableView *tableView;


@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *topTitleLabel;
@end

@implementation KG_NiControlSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];

    [self createSearchUI];
    [self setupDataSubviews];
    [self createNaviTopView];
    
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
    if (@available(iOS 13.0, *)){
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    }else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    [self.navigationController setNavigationBarHidden:NO];
    
}

- (void)createSearchUI {
    
    
    UIView *searchView = [[UIView alloc]init];
    [self.view addSubview:searchView];
    searchView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).offset(NAVIGATIONBAR_HEIGHT-64 +Height_StatusBar);
        make.height.equalTo(@44);
    }];
    
    UIButton *cancelBtn = [[UIButton alloc]init];
    [searchView addSubview:cancelBtn];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#24252A"] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelBtn addTarget:self action:@selector(cancelMethod:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(searchView.mas_right).offset(-16);
        make.top.equalTo(searchView.mas_top).offset(8);
        make.height.equalTo(@28);
        make.width.equalTo(@30);
    }];
    
    UIView *searchBgView = [[UIView alloc]init];
    [searchView addSubview:searchBgView];
    searchBgView.backgroundColor = [UIColor whiteColor];
    searchBgView.layer.cornerRadius = 5.f;
    searchBgView.layer.masksToBounds = YES;
    [searchBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchView.mas_left).offset(16);
        make.top.equalTo(searchView.mas_top).offset(8);
        make.height.equalTo(@28);
        make.right.equalTo(cancelBtn.mas_left).offset(-11.5);
    }];
    
    UIImageView *iconImage = [[UIImageView alloc]init];
    [searchBgView addSubview:iconImage];
    iconImage.image = [UIImage imageNamed:@"seach_icon"];
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchBgView.mas_left).offset(6);
        make.width.height.equalTo(@18);
        make.centerY.equalTo(searchBgView.mas_centerY);
    }];
 
    self.textField = [[UITextField alloc]init];
    [searchBgView addSubview:self.textField];
    self.textField.text = @"电阻";
    self.textField.placeholder = @"请输入搜索内容";
    self.textField.font = [UIFont systemFontOfSize:14];
    self.textField.delegate = self;
    self.textField.textColor = [UIColor colorWithHexString:@"#24252A"];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImage.mas_right).offset(9);
        make.height.equalTo(@30);
        make.right.equalTo(cancelBtn.mas_left).offset(-10);
        make.top.equalTo(searchBgView.mas_top);
    }];
    
    self.topTitleLabel = [[UILabel alloc]init];
    
    self.topTitleLabel.text = @"包含“空调”的内容";
  
    self.topTitleLabel.textColor = [UIColor colorWithHexString:@"#BABCC4"];
    self.topTitleLabel.font = [UIFont systemFontOfSize:12];
    self.topTitleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.topTitleLabel];
    [self.topTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(19);
        make.width.equalTo(@200);
        make.top.equalTo(searchView.mas_bottom).offset(13);
        make.height.equalTo(@17);
    }];
  
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.textField resignFirstResponder];
}

- (void)cancelMethod:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

//创建视图
-(void)setupDataSubviews
{
    
    [self.view addSubview:self.tableView];
  
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.
                         topTitleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [self.tableView reloadData];

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
-(NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
    return  self.dataArray.count ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 87;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    KG_SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_SearchCell"];
    if (cell == nil) {
        cell = [[KG_SearchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_SearchCell"];
        
    }
    cell.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
//    NSDictionary *dataDic = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
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
  
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.title = [NSString stringWithFormat:@"历史任务"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FontSize(18),NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#24252A"]}] ;
    
    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.translucent = NO;
    
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
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

@end
