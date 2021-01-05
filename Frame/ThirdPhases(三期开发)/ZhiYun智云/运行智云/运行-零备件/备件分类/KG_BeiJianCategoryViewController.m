//
//  KG_BeiJianCategoryViewController.m
//  Frame
//
//  Created by zhangran on 2020/7/31.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_BeiJianCategoryViewController.h"
#import "KG_BeiJianCategoryCell.h"
#import "KG_BeiJianDetailViewController.h"
@interface KG_BeiJianCategoryViewController ()<UITableViewDelegate,UITableViewDataSource>{
    

}

@property (nonatomic,strong)    UITableView             *tableView;

@property (nonatomic,strong)    NSMutableArray          *dataArray;

@property (nonatomic, strong)   UILabel                 *titleLabel;

@property (nonatomic, strong)   UIView                  *navigationView;

@property (nonatomic, strong)   UIButton                *searchBtn;

@property (nonatomic, strong)   UIButton                *rightButton;

@property (nonatomic, strong)   NSDictionary            *currentDic;

@end

@implementation KG_BeiJianCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self createNaviTopView];
    [self createUI];
    if (self.dataDic.count) {
        self.dataArray = self.dataDic[@"attachmentList"];
        [self.tableView reloadData];
    }
    
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
    self.titleLabel.text = @"备件列表";
    
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
    
      
//    self.searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//
//    self.searchBtn.frame = CGRectMake(0,0,FrameWidth(40),FrameWidth(40));
//    [self.searchBtn setImage:[UIImage imageNamed:@"yun_searchIcon"] forState:UIControlStateNormal];
//    self.searchBtn.userInteractionEnabled = NO;
//
//    [self.navigationView addSubview:self.searchBtn];
//
//
//    self.rightButton  = [UIButton buttonWithType:UIButtonTypeCustom];
//
//    self.rightButton.frame = CGRectMake(0,0,FrameWidth(40),FrameWidth(40));
//    [self.rightButton setImage:[UIImage imageNamed:@"yun_rightIcon"] forState:UIControlStateNormal];
////    [self.rightButton addTarget:self action:@selector(yiduAction) forControlEvents:UIControlEventTouchUpInside];
//    self.rightButton.userInteractionEnabled = NO;
//    [self.navigationView addSubview:self.rightButton];
//
//    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.equalTo(@44);
//        make.centerY.equalTo(self.titleLabel.mas_centerY);
//        make.right.equalTo(self.navigationView.mas_right).offset(-20);
//    }];
//
//    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.equalTo(@44);
//        make.centerY.equalTo(self.titleLabel.mas_centerY);
//        make.right.equalTo(self.rightButton.mas_right).offset(-40);
//    }];
     
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
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSDictionary *dataDic = self.dataArray[indexPath.row];
   
    return 50;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dataDic = self.dataArray[indexPath.row];
    KG_BeiJianDetailViewController *vc = [[KG_BeiJianDetailViewController alloc]init];
    vc.dataDic = dataDic;
    vc.totalDic = self.dataDic;
    if (self.totalDic.count) {
        vc.deviceStr = safeString(self.totalDic[@"equipmentName"]);
    }

    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_BeiJianCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_BeiJianCategoryCell"];
    if (cell == nil) {
        cell = [[KG_BeiJianCategoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_BeiJianCategoryCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dataDic = self.dataArray[indexPath.row];
    cell.dataDic = dataDic;
    return cell;
    
}

- (void)createUI {
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 60)];
    [self.view addSubview:topView];
    
    UIView *lineView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    [topView addSubview:lineView];
    
    
    
    
    UILabel *firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, 84, 50)];
    [topView addSubview:firstLabel];
    firstLabel.text = @"备件名称";
    firstLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    firstLabel.font = [UIFont systemFontOfSize:14];
    firstLabel.font = [UIFont my_font:14];
    firstLabel.numberOfLines = 1;
    firstLabel.textAlignment = NSTextAlignmentLeft;
    [firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView.mas_left).offset(16);
        make.height.equalTo(@50);
        make.width.lessThanOrEqualTo(@120);
        make.centerY.equalTo(topView.mas_centerY);
    }];
    
    UILabel *secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(140, 0, 84, 50)];
    [topView addSubview:secondLabel];
    secondLabel.text = @"编号";
    secondLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    secondLabel.font = [UIFont systemFontOfSize:14];
    secondLabel.font = [UIFont my_font:14];
    secondLabel.numberOfLines = 1;
    secondLabel.textAlignment = NSTextAlignmentRight;
    [secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topView.mas_left).offset(SCREEN_WIDTH/2-30);
        make.height.equalTo(@50);
        make.width.lessThanOrEqualTo(@120);
        make.centerY.equalTo(topView.mas_centerY);
    }];
    
    
    UILabel *thirdLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, 84, 50)];
    [topView addSubview:thirdLabel];
    thirdLabel.text = @"状态";
    thirdLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    thirdLabel.font = [UIFont systemFontOfSize:14];
    thirdLabel.font = [UIFont my_font:14];
    thirdLabel.numberOfLines = 1;
    thirdLabel.textAlignment = NSTextAlignmentLeft;
    [thirdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(secondLabel.mas_right).offset(40);
        make.height.equalTo(@50);
        make.width.equalTo(@120);
        make.centerY.equalTo(topView.mas_centerY);
    }];
    
    
    UILabel *fourthLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, 84, 50)];
    [topView addSubview:fourthLabel];
    fourthLabel.text = @"型号";
    fourthLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    fourthLabel.font = [UIFont systemFontOfSize:14];
    fourthLabel.font = [UIFont my_font:14];
    fourthLabel.numberOfLines = 1;
    fourthLabel.textAlignment = NSTextAlignmentRight;
    [fourthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topView.mas_right).offset(-16);
        make.height.equalTo(@50);
        make.width.equalTo(@120);
        make.centerY.equalTo(topView.mas_centerY);
    }];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 59, SCREEN_WIDTH, 1)];
    [topView addSubview:lineView1];
    lineView1.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    
    
    
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom).offset(60);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
}


@end
