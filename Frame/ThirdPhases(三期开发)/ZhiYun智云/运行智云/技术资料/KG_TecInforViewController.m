//
//  KG_TecInforViewController.m
//  Frame
//
//  Created by zhangran on 2020/5/20.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_TecInforViewController.h"
#import "KG_TechInfoCell.h"
@interface KG_TecInforViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation KG_TecInforViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initViewData];
    [self createNaviTopView];
}
- (void)initViewData {
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
    [dic1 setObject:@"标准规范" forKey:@"title"];
    [dic1 setObject:@"biaozhun_icon" forKey:@"icon"];
    
    NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
    [dic2 setObject:@"操作指引" forKey:@"title"];
    [dic2 setObject:@"caozuo_icon" forKey:@"icon"];
    
    NSMutableDictionary *dic3 = [NSMutableDictionary dictionary];
    [dic3 setObject:@"地空通讯技术资料" forKey:@"title"];
    [dic3 setObject:@"dikong_icon" forKey:@"icon"];
    
    NSMutableDictionary *dic4 = [NSMutableDictionary dictionary];
    [dic4 setObject:@"导航设备资料" forKey:@"title"];
    [dic4 setObject:@"daohangshebei_icon" forKey:@"icon"];
    
    NSMutableDictionary *dic5 = [NSMutableDictionary dictionary];
    [dic5 setObject:@"平面通讯技术资料" forKey:@"title"];
    [dic5 setObject:@"pingmian_icon" forKey:@"icon"];
    
    NSMutableDictionary *dic6 = [NSMutableDictionary dictionary];
    [dic6 setObject:@"应急操作指引" forKey:@"title"];
    [dic6 setObject:@"yingji_icon" forKey:@"icon"];
    
    NSMutableDictionary *dic7 = [NSMutableDictionary dictionary];
    [dic7 setObject:@"监视设备资料" forKey:@"title"];
    [dic7 setObject:@"jianshi_icon" forKey:@"icon"];
    
    NSMutableDictionary *dic8 = [NSMutableDictionary dictionary];
    [dic8 setObject:@"设备维护规程" forKey:@"title"];
    [dic8 setObject:@"shebei_icon" forKey:@"icon"];
    
    [self.dataArray addObject:dic1];
    [self.dataArray addObject:dic2];
    [self.dataArray addObject:dic3];
    [self.dataArray addObject:dic4];
    [self.dataArray addObject:dic5];
    [self.dataArray addObject:dic6];
    [self.dataArray addObject:dic7];
    [self.dataArray addObject:dic8];
    
    [self createTableView];
}

- (void)createTableView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [self.tableView reloadData];
}


//创建导航栏视图
-  (void)createNaviTopView {
    UIButton *leftButon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    leftButon.frame = CGRectMake(0,0,FrameWidth(60),FrameWidth(60));
    [leftButon setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
    [leftButon setContentEdgeInsets:UIEdgeInsetsMake(0, - FrameWidth(20), 0, FrameWidth(20))];
    //button.alignmentRectInsetsOverride = UIEdgeInsetsMake(0, offset, 0, -(offset));
    [leftButon addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *fixedButton = [[UIBarButtonItem alloc]initWithCustomView:leftButon];
    self.navigationItem.leftBarButtonItem = fixedButton;
    
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.title = [NSString stringWithFormat:@"技术资料"];
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

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 8;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = YES;
        
        
    }
    return _tableView;
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_TechInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_TechInfoCell"];
    if (cell == nil) {
        cell = [[KG_TechInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_TechInfoCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dataDic = self.dataArray[indexPath.row];
    cell.dataDic = dataDic;
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
  
    return 50;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //    NSString *str = self.dataArray[indexPath.row];
    
}

@end
